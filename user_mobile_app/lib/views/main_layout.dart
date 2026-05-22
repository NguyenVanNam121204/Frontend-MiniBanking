import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../app/providers.dart';
import '../core/app/app_colors.dart';
import '../core/network/dio_client.dart';
import '../models/notification/app_notification_model.dart';
import '../services/realtime_event_service.dart';
import '../widgets/security/pin_setup_prompt_card.dart';
import 'auth/login/login_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'profile/security/setup_pin_screen.dart';
import 'qr_pay/qr_pay_screen.dart';
import 'transaction/history/transaction_history_screen.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  StreamSubscription<RealtimeEvent>? _realtimeSubscription;
  Timer? _fallbackRefreshTimer;
  final List<Timer> _realtimeRefreshTimers = [];
  bool _isFallbackRefreshing = false;

  @override
  void initState() {
    super.initState();
    authSessionExpiredNotifier.addListener(_handleSessionExpired);
    Future.microtask(() async {
      final realtimeService = ref.read(realtimeEventServiceProvider);
      _realtimeSubscription = realtimeService.events.listen(
        _handleRealtimeEvent,
      );
      await realtimeService.startUserStream();
      if (!mounted) {
        return;
      }
      _startFallbackRefresh();
    });
  }

  @override
  void dispose() {
    authSessionExpiredNotifier.removeListener(_handleSessionExpired);
    for (final timer in _realtimeRefreshTimers) {
      timer.cancel();
    }
    _realtimeRefreshTimers.clear();
    _fallbackRefreshTimer?.cancel();
    _realtimeSubscription?.cancel();
    ref.read(realtimeEventServiceProvider).stop();
    super.dispose();
  }

  void _handleSessionExpired() {
    if (!mounted) {
      return;
    }

    ref.read(realtimeEventServiceProvider).stop();
    ref.read(navigationIndexProvider.notifier).state = 0;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final profileState = ref.watch(profileViewModelProvider);

    final screens = [
      const HomeScreen(),
      const TransactionHistoryScreen(isTab: true),
      const QrPayScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bgDark,
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            final hasPin = profileState.user?.hasPin ?? true;
            if (index == 2 && !hasPin) {
              showPinSetupPromptSheet(
                context: context,
                onSetup: () => _openSetupPinScreen(context),
              );
              return;
            }
            ref.read(navigationIndexProvider.notifier).state = index;
          },
          backgroundColor: AppColors.bgDark,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.slate400,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home, size: 24),
              activeIcon: Icon(LucideIcons.home, size: 24),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.arrowLeftRight, size: 24),
              activeIcon: Icon(LucideIcons.arrowLeftRight, size: 24),
              label: 'Giao dịch',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.qrCode, size: 24),
              activeIcon: Icon(LucideIcons.qrCode, size: 24),
              label: 'QR Pay',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user, size: 24),
              activeIcon: Icon(LucideIcons.user, size: 24),
              label: 'Cá nhân',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSetupPinScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SetupPinScreen()),
    );
    if (!mounted) {
      return;
    }
    await ref.read(profileViewModelProvider.notifier).refresh();
  }

  Future<void> _handleRealtimeEvent(RealtimeEvent event) async {
    switch (event.eventType) {
      case 'CONNECTED':
        await _refreshRealtimeState(includeBalance: true);
        break;
      case 'USER_NOTIFICATION_CREATED':
        final notification = _applyRealtimeNotification(event);
        if (notification?.type == AppNotificationType.transaction) {
          _scheduleRealtimeRefreshes(includeBalance: true);
        }
        break;
      case 'ACCOUNT_BALANCE_UPDATED':
        _scheduleRealtimeRefreshes(includeBalance: true);
        break;
      default:
        break;
    }
  }

  AppNotificationModel? _applyRealtimeNotification(RealtimeEvent event) {
    try {
      final notification = AppNotificationModel.fromJson(event.data);
      ref
          .read(notificationViewModelProvider.notifier)
          .applyRealtimeNotification(notification);
      return notification;
    } catch (_) {
      ref.read(notificationViewModelProvider.notifier).refresh();
      return null;
    }
  }

  void _scheduleRealtimeRefreshes({required bool includeBalance}) {
    unawaited(_refreshRealtimeState(includeBalance: includeBalance));

    for (final delay in const [
      Duration(milliseconds: 700),
      Duration(seconds: 2),
    ]) {
      late final Timer timer;
      timer = Timer(delay, () {
        _realtimeRefreshTimers.remove(timer);
        if (!mounted) {
          return;
        }
        unawaited(_refreshRealtimeState(includeBalance: includeBalance));
      });
      _realtimeRefreshTimers.add(timer);
    }
  }

  Future<void> _refreshRealtimeState({required bool includeBalance}) async {
    if (!mounted) {
      return;
    }

    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final notificationViewModel = ref.read(
      notificationViewModelProvider.notifier,
    );

    await Future.wait([
      if (includeBalance) homeViewModel.fetchData(silent: true),
      notificationViewModel.refresh(),
    ]);
  }

  void _startFallbackRefresh() {
    _fallbackRefreshTimer?.cancel();
    _fallbackRefreshTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || _isFallbackRefreshing) {
        return;
      }
      _isFallbackRefreshing = true;
      _refreshRealtimeState(includeBalance: true).whenComplete(() {
        if (!mounted) {
          return;
        }
        _isFallbackRefreshing = false;
      });
    });
  }
}
