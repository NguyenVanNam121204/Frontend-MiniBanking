import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notification/app_notification_model.dart';
import '../../repositories/notification/notification_repository.dart';
import 'notification_state.dart';

class NotificationViewModel extends StateNotifier<NotificationState> {
  final INotificationRepository _notificationRepository;

  NotificationViewModel(this._notificationRepository)
    : super(const NotificationState()) {
    loadNotifications();
  }

  Future<void> loadNotifications({bool silent = false}) async {
    state = state.copyWith(
      isLoading: !silent,
      isRefreshing: silent,
      clearErrorMessage: true,
    );

    final result = await _notificationRepository.getNotifications();
    result.when(
      success: (notifications) {
        state = state.copyWith(
          notifications: notifications,
          isLoading: false,
          isRefreshing: false,
          clearErrorMessage: true,
        );
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          errorMessage: error.message,
        );
      },
    );
  }

  Future<void> refresh() async {
    await loadNotifications(silent: true);
  }

  void applyRealtimeNotification(AppNotificationModel notification) {
    final existingIndex = state.notifications.indexWhere(
      (item) => item.id == notification.id,
    );
    final updated = [...state.notifications];

    if (existingIndex >= 0) {
      updated[existingIndex] = notification;
    } else {
      updated.insert(0, notification);
    }

    state = state.copyWith(
      notifications: updated,
      isLoading: false,
      isRefreshing: false,
      clearErrorMessage: true,
    );
  }

  Future<void> markAsRead(AppNotificationModel notification) async {
    if (notification.isRead) {
      return;
    }

    _updateNotification(notification.copyWith(isRead: true));
    final result = await _notificationRepository.markAsRead(notification.id);
    result.when(
      success: (_) {},
      failure: (error) {
        _updateNotification(notification);
        state = state.copyWith(errorMessage: error.message);
      },
    );
  }

  Future<void> markAllAsRead() async {
    final previous = state.notifications;
    state = state.copyWith(
      notifications: previous
          .map((item) => item.copyWith(isRead: true))
          .toList(),
      clearErrorMessage: true,
    );

    final result = await _notificationRepository.markAllAsRead();
    result.when(
      success: (_) {},
      failure: (error) {
        state = state.copyWith(
          notifications: previous,
          errorMessage: error.message,
        );
      },
    );
  }

  Future<void> deleteNotification(AppNotificationModel notification) async {
    final previous = state.notifications;
    state = state.copyWith(
      notifications: previous
          .where((item) => item.id != notification.id)
          .toList(),
      clearErrorMessage: true,
    );

    final result = await _notificationRepository.deleteNotification(
      notification.id,
    );
    result.when(
      success: (_) {},
      failure: (error) {
        state = state.copyWith(
          notifications: previous,
          errorMessage: error.message,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }

  void _updateNotification(AppNotificationModel notification) {
    final updated = state.notifications
        .map((item) => item.id == notification.id ? notification : item)
        .toList();
    state = state.copyWith(notifications: updated, clearErrorMessage: true);
  }
}
