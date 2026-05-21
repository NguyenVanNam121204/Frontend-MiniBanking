import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../app/providers.dart';
import '../../core/app/app_colors.dart';
import '../../models/notification/app_notification_model.dart';
import '../../viewmodels/notification/notification_state.dart';
import '../../viewmodels/notification/notification_view_model.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationViewModelProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NotificationState>(notificationViewModelProvider, (
      previous,
      next,
    ) {
      final oldError = previous?.errorMessage;
      final newError = next.errorMessage;
      if (newError != null && newError.isNotEmpty && newError != oldError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newError,
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.redAccent.shade200,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(notificationViewModelProvider.notifier).clearError();
      }
    });

    final state = ref.watch(notificationViewModelProvider);
    final viewModel = ref.read(notificationViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thông báo',
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (state.unreadCount > 0)
            IconButton(
              icon: const Icon(
                LucideIcons.checkSquare,
                color: AppColors.accent,
                size: 20,
              ),
              tooltip: 'Đọc tất cả',
              onPressed: viewModel.markAllAsRead,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        color: AppColors.accent,
        child: _buildBody(context, state, viewModel),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationState state,
    NotificationViewModel viewModel,
  ) {
    if (state.isLoading && state.notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (state.notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.02),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.bellOff,
                      color: AppColors.slate500,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có thông báo nào',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thông báo giao dịch và bảo mật sẽ hiển thị tại đây.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.slate400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final todayList = _getNotificationsByGroup(
      state.notifications,
      NotificationGroup.today,
    );
    final yesterdayList = _getNotificationsByGroup(
      state.notifications,
      NotificationGroup.yesterday,
    );
    final olderList = _getNotificationsByGroup(
      state.notifications,
      NotificationGroup.older,
    );

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        if (todayList.isNotEmpty) ...[
          _buildSectionHeader('Hôm nay'),
          ...todayList.map(
            (n) => _buildNotificationItem(context, n, viewModel),
          ),
        ],
        if (yesterdayList.isNotEmpty) ...[
          _buildSectionHeader('Hôm qua'),
          ...yesterdayList.map(
            (n) => _buildNotificationItem(context, n, viewModel),
          ),
        ],
        if (olderList.isNotEmpty) ...[
          _buildSectionHeader('Trước đó'),
          ...olderList.map(
            (n) => _buildNotificationItem(context, n, viewModel),
          ),
        ],
        if (state.isRefreshing)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.slate400,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    AppNotificationModel notification,
    NotificationViewModel viewModel,
  ) {
    final timeStr = DateFormat('HH:mm').format(notification.createdAt);
    final dateStr = DateFormat('dd/MM').format(notification.createdAt);

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.error.withValues(alpha: 0.1),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(LucideIcons.trash2, color: AppColors.error),
      ),
      onDismissed: (_) {
        viewModel.deleteNotification(notification);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã xóa thông báo',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Colors.grey[900],
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: InkWell(
        onTap: () async {
          await viewModel.markAsRead(notification);
          if (!context.mounted) {
            return;
          }
          _showDetailsModal(context, notification.copyWith(isRead: true));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.02),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.03),
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getTypeColor(
                    notification.type,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(notification.type),
                  color: _getTypeColor(notification.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$timeStr, $dateStr',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.slate500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.body,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: notification.isRead
                            ? AppColors.slate400
                            : AppColors.slate300,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!notification.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsModal(
    BuildContext context,
    AppNotificationModel notification,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.bgDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(top: BorderSide(color: Colors.white12, width: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getTypeColor(
                      notification.type,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getTypeIcon(notification.type),
                    color: _getTypeColor(notification.type),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy - HH:mm',
                        ).format(notification.createdAt),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.slate400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Text(
                notification.body,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.6,
                ),
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
                    fontSize: 15,
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

  List<AppNotificationModel> _getNotificationsByGroup(
    List<AppNotificationModel> notifications,
    NotificationGroup group,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return notifications.where((notification) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      switch (group) {
        case NotificationGroup.today:
          return notificationDate == today;
        case NotificationGroup.yesterday:
          return notificationDate == yesterday;
        case NotificationGroup.older:
          return notificationDate.isBefore(yesterday);
      }
    }).toList();
  }

  IconData _getTypeIcon(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.transaction:
        return LucideIcons.arrowLeftRight;
      case AppNotificationType.security:
        return LucideIcons.shieldAlert;
      case AppNotificationType.system:
        return LucideIcons.bellRing;
    }
  }

  Color _getTypeColor(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.transaction:
        return AppColors.accent;
      case AppNotificationType.security:
        return AppColors.error;
      case AppNotificationType.system:
        return Colors.amberAccent;
    }
  }
}

enum NotificationGroup { today, yesterday, older }
