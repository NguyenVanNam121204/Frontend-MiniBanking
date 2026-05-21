import '../../models/notification/app_notification_model.dart';

class NotificationState {
  final List<AppNotificationModel> notifications;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  int get unreadCount => notifications.where((item) => !item.isRead).length;

  NotificationState copyWith({
    List<AppNotificationModel>? notifications,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
