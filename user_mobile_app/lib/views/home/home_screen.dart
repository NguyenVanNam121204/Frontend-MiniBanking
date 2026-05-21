import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/providers.dart';
import '../../core/app/app_colors.dart';
import '../../models/account/account_model.dart';
import '../../models/transaction/transaction_model.dart';
import '../../viewmodels/home/home_state.dart';
import '../../viewmodels/home/home_view_model.dart';
import '../../viewmodels/notification/notification_state.dart';
import '../account/open_account_screen.dart';
import '../notification/notification_screen.dart';
import '../transaction/deposit/deposit_screen.dart';
import '../transaction/transfer/transfer_screen.dart';
import '../transaction/withdraw/withdraw_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bellAnimationController;
  late final Animation<double> _bellRotation;
  int _lastUnreadCount = 0;

  @override
  void initState() {
    super.initState();
    _bellAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _bellRotation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: -0.12), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.12), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.12, end: -0.09), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -0.09, end: 0.09), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.09, end: 0), weight: 1),
        ]).animate(
          CurvedAnimation(
            parent: _bellAnimationController,
            curve: Curves.easeInOut,
          ),
        );

    Future.microtask(() {
      ref.read(homeViewModelProvider.notifier).fetchData();
      ref.read(notificationViewModelProvider.notifier).loadNotifications();
    });
  }

  @override
  void dispose() {
    _bellAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final homeViewModel = ref.read(homeViewModelProvider.notifier);
    final notificationState = ref.watch(notificationViewModelProvider);

    ref.listen<NotificationState>(notificationViewModelProvider, (
      previous,
      next,
    ) {
      final previousUnread = previous?.unreadCount ?? _lastUnreadCount;
      final nextUnread = next.unreadCount;
      if (nextUnread > previousUnread) {
        _bellAnimationController.forward(from: 0);
      }
      _lastUnreadCount = nextUnread;
    });

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: RefreshIndicator(
        onRefresh: () async {
          await homeViewModel.fetchData();
          await ref.read(notificationViewModelProvider.notifier).refresh();
        },
        color: AppColors.accent,
        backgroundColor: AppColors.slate800,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context, homeState, notificationState),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            _buildBalanceCard(context, homeState, homeViewModel),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    _buildQuickActions(context),
                    const SizedBox(height: 32),
                    _buildAccountSectionHeader(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildAccountsList(homeState),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            _buildTransactionSectionHeader(context, ref),
            _buildTransactionsList(homeState),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Chào buổi sáng 👋';
    } else if (hour >= 12 && hour < 18) {
      return 'Chào buổi chiều 👋';
    } else {
      return 'Chào buổi tối 👋';
    }
  }

  Widget _buildAppBar(
    BuildContext context,
    HomeState state,
    NotificationState notificationState,
  ) {
    return SliverAppBar(
      expandedHeight: 80,
      backgroundColor: AppColors.bgDark,
      elevation: 0,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getGreeting(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.slate400,
                    ),
                  ),
                  Text(
                    state.userName.isNotEmpty ? state.userName : 'Người dùng',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildNotificationButton(context, notificationState),
                  const SizedBox(width: 12),
                  _buildProfileButton(context, state.userName),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(
    BuildContext context,
    NotificationState notificationState,
  ) {
    return AnimatedBuilder(
      animation: _bellRotation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _bellRotation.value,
          alignment: Alignment.topCenter,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _buildIconButton(LucideIcons.bell, () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
                if (!mounted) {
                  return;
                }
                await ref
                    .read(notificationViewModelProvider.notifier)
                    .refresh();
                await ref.read(homeViewModelProvider.notifier).fetchData();
              }),
              if (notificationState.unreadCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.bgDark, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        notificationState.unreadCount > 99
                            ? '99+'
                            : notificationState.unreadCount.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String userName) {
    final String displayName = userName.trim().isNotEmpty
        ? userName.trim()
        : 'User';
    final String initial = displayName.characters.first.toUpperCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          ref.read(navigationIndexProvider.notifier).state = 3;
        },
        child: Container(
          width: 48,
          height: 48,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bgDark, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    HomeState state,
    HomeViewModel viewModel,
  ) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: PageView(
          controller: PageController(viewportFraction: 0.92),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildBalanceCardItem(
              context,
              state,
              viewModel,
              'Tổng số dư tài khoản',
              state.personalBalance,
              [AppColors.primary, AppColors.secondary],
              LucideIcons.user,
            ),
            if (state.businessBalance > 0 ||
                state.accounts.any((a) => a.type == AccountType.business))
              _buildBalanceCardItem(
                context,
                state,
                viewModel,
                'Số dư doanh nghiệp',
                state.businessBalance,
                const [Color(0xFF6366F1), Color(0xFFA855F7)],
                LucideIcons.briefcase,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCardItem(
    BuildContext context,
    HomeState state,
    HomeViewModel viewModel,
    String title,
    double amount,
    List<Color> gradientColors,
    IconData icon,
  ) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(
                  state.isBalanceVisible ? LucideIcons.eye : LucideIcons.eyeOff,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 20,
                ),
                onPressed: viewModel.toggleBalanceVisibility,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            state.isBalanceVisible ? currencyFormat.format(amount) : '••••••••',
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _buildSmallQuickAction(LucideIcons.plus, 'Nạp tiền', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DepositScreen(),
                  ),
                );
              }),
              const SizedBox(width: 12),
              _buildSmallQuickAction(LucideIcons.send, 'Chuyển tiền', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransferScreen(),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallQuickAction(
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuickActionItem(
          LucideIcons.plusCircle,
          'Nạp tiền',
          Colors.greenAccent,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DepositScreen()),
            );
          },
        ),
        _buildQuickActionItem(
          LucideIcons.minusCircle,
          'Rút tiền',
          Colors.redAccent,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WithdrawScreen()),
            );
          },
        ),
        _buildQuickActionItem(
          LucideIcons.arrowLeftRight,
          'Chuyển tiền',
          AppColors.accent,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TransferScreen()),
            );
          },
        ),
        _buildQuickActionItem(
          LucideIcons.moreHorizontal,
          'Thêm',
          Colors.purple,
          () {},
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.slate400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tài khoản của bạn',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OpenAccountScreen(),
              ),
            );
          },
          child: Text(
            'Thêm mới',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountsList(HomeState state) {
    if (state.isLoading && state.accounts.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      );
    }

    if (state.accounts.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            'Bạn chưa có tài khoản nào',
            style: GoogleFonts.inter(color: AppColors.slate400),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildAccountItem(state.accounts[index]),
          childCount: state.accounts.length,
        ),
      ),
    );
  }

  Widget _buildAccountItem(AccountModel account) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getAccountColor(account.type).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _getAccountIcon(account.type),
              color: _getAccountColor(account.type),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getAccountTitle(account.type),
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  account.accountNumber,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.slate400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            currencyFormat.format(account.balance),
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSectionHeader(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Giao dịch gần đây',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(navigationIndexProvider.notifier).state = 1;
              },
              child: Text(
                'Xem tất cả',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(HomeState state) {
    if (state.isLoading && state.recentTransactions.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox());
    }

    if (state.recentTransactions.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              'Chưa có giao dịch nào',
              style: GoogleFonts.inter(color: AppColors.slate400),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) =>
              _buildTransactionItem(context, state.recentTransactions[index]),
          childCount: state.recentTransactions.length,
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    TransactionModel transaction,
  ) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final isNegative =
        transaction.type == TransactionType.withdraw ||
        transaction.type == TransactionType.transfer;

    return InkWell(
      onTap: () => _showTransactionDetails(context, transaction),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getTransactionColor(
                  transaction.type,
                ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTransactionIcon(transaction.type),
                color: _getTransactionColor(transaction.type),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description ??
                        _getTransactionTitle(transaction.type),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM, HH:mm').format(transaction.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.slate400,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isNegative ? '-' : '+'}${currencyFormat.format(transaction.amount)}',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isNegative ? Colors.redAccent : Colors.greenAccent,
                  ),
                ),
                const SizedBox(height: 4),
                _buildStatusBadge(transaction.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, TransactionModel tx) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    final isNegative =
        tx.type == TransactionType.withdraw ||
        tx.type == TransactionType.transfer;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.bgDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getTransactionColor(tx.type).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getTransactionIcon(tx.type),
                color: _getTransactionColor(tx.type),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getTransactionTitle(tx.type),
              style: GoogleFonts.outfit(
                color: AppColors.slate400,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${isNegative ? '-' : '+'}${currencyFormat.format(tx.amount)}',
              style: GoogleFonts.outfit(
                color: isNegative ? Colors.redAccent : Colors.greenAccent,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Trạng thái',
                    _getStatusLabel(tx.status),
                    color: _getStatusColor(tx.status),
                  ),
                  _buildDetailRow('Mã giao dịch', '#${tx.id}'),
                  _buildDetailRow(
                    'Thời gian',
                    DateFormat('dd/MM/yyyy HH:mm').format(tx.createdAt),
                  ),
                  _buildDetailRow(
                    'Từ tài khoản',
                    tx.fromAccountNumber ?? 'N/A',
                  ),
                  _buildDetailRow('Đến tài khoản', tx.toAccountNumber ?? 'N/A'),
                  const Divider(color: Colors.white10, height: 32),
                  _buildDetailRow(
                    'Nội dung',
                    tx.description?.isEmpty ?? true
                        ? 'Giao dịch ngân hàng'
                        : tx.description!,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Đóng',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: AppColors.slate400, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                color: color ?? Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(TransactionStatus status) {
    final color = _getStatusColor(status);
    final label = _getStatusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getStatusLabel(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Thành công';
      case TransactionStatus.pending:
        return 'Chờ duyệt';
      case TransactionStatus.failed:
        return 'Thất bại';
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Colors.greenAccent;
      case TransactionStatus.pending:
        return Colors.orangeAccent;
      case TransactionStatus.failed:
        return Colors.redAccent;
    }
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return LucideIcons.arrowDownLeft;
      case TransactionType.withdraw:
        return LucideIcons.arrowUpRight;
      case TransactionType.transfer:
        return LucideIcons.arrowRightLeft;
    }
  }

  Color _getTransactionColor(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return Colors.greenAccent;
      case TransactionType.withdraw:
        return Colors.redAccent;
      case TransactionType.transfer:
        return Colors.blueAccent;
    }
  }

  String _getTransactionTitle(TransactionType type) {
    switch (type) {
      case TransactionType.deposit:
        return 'Nạp tiền';
      case TransactionType.withdraw:
        return 'Rút tiền';
      case TransactionType.transfer:
        return 'Chuyển khoản';
    }
  }

  IconData _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.savings:
        return LucideIcons.piggyBank;
      case AccountType.checking:
        return LucideIcons.creditCard;
      case AccountType.business:
        return LucideIcons.briefcase;
    }
  }

  Color _getAccountColor(AccountType type) {
    switch (type) {
      case AccountType.savings:
        return Colors.orangeAccent;
      case AccountType.checking:
        return AppColors.accent;
      case AccountType.business:
        return Colors.purpleAccent;
    }
  }

  String _getAccountTitle(AccountType type) {
    switch (type) {
      case AccountType.savings:
        return 'Tài khoản Tiết kiệm';
      case AccountType.checking:
        return 'Tài khoản Thanh toán';
      case AccountType.business:
        return 'Tài khoản Doanh nghiệp';
    }
  }
}
