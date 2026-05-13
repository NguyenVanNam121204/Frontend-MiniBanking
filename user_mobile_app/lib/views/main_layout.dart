import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app/app_colors.dart';
import 'home/home_screen.dart';
import 'transaction/history/transaction_history_screen.dart';
import 'profile/profile_screen.dart';
import '../app/providers.dart';

class MainLayout extends ConsumerWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);

    final screens = [
      const HomeScreen(),
      const TransactionHistoryScreen(isTab: true),
      const Scaffold(body: Center(child: Text("Notifications", style: TextStyle(color: Colors.white)))),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bgDark,
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(navigationIndexProvider.notifier).state = index,
          backgroundColor: AppColors.bgDark,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.slate400,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
              icon: Icon(LucideIcons.bell, size: 24),
              activeIcon: Icon(LucideIcons.bell, size: 24),
              label: 'Thông báo',
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
}
