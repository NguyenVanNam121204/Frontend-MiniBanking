import '../../core/exceptions/app_exception.dart';
import '../../core/results/result.dart';
import '../../models/notification/app_notification_model.dart';

abstract class INotificationRepository {
  Future<Result<List<AppNotificationModel>, AppException>> getNotifications({int page = 0, int size = 50});
  Future<Result<void, AppException>> markAsRead(int notificationId);
  Future<Result<void, AppException>> markAllAsRead();
  Future<Result<void, AppException>> deleteNotification(int notificationId);
}
