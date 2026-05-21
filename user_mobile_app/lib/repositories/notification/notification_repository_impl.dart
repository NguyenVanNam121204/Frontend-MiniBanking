import 'package:dio/dio.dart';

import '../../core/exceptions/app_exception.dart';
import '../../core/network/api_constants.dart';
import '../../core/results/result.dart';
import '../../models/notification/app_notification_model.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final Dio _dio;

  NotificationRepositoryImpl(this._dio);

  @override
  Future<Result<List<AppNotificationModel>, AppException>> getNotifications({
    int page = 0,
    int size = 50,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.notifications,
        queryParameters: {
          'page': page,
          'size': size,
        },
      );

      if (response.data['success'] == true) {
        final content = (response.data['data']?['content'] as List<dynamic>? ?? [])
            .map((item) => AppNotificationModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return Result.success(content);
      }

      return Result.failure(AppException(response.data['message'] ?? 'Khong tai duoc thong bao'));
    } on DioException catch (e) {
      return Result.failure(
        AppException(e.response?.data['message'] ?? e.message ?? 'Khong tai duoc thong bao'),
      );
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> markAsRead(int notificationId) async {
    try {
      final response = await _dio.patch(ApiConstants.markNotificationAsRead(notificationId));
      if (response.data['success'] == true) {
        return const Result.success(null);
      }
      return Result.failure(AppException(response.data['message'] ?? 'Khong cap nhat duoc thong bao'));
    } on DioException catch (e) {
      return Result.failure(
        AppException(e.response?.data['message'] ?? e.message ?? 'Khong cap nhat duoc thong bao'),
      );
    }
  }

  @override
  Future<Result<void, AppException>> markAllAsRead() async {
    try {
      final response = await _dio.patch(ApiConstants.markAllNotificationsAsRead);
      if (response.data['success'] == true) {
        return const Result.success(null);
      }
      return Result.failure(AppException(response.data['message'] ?? 'Khong cap nhat duoc thong bao'));
    } on DioException catch (e) {
      return Result.failure(
        AppException(e.response?.data['message'] ?? e.message ?? 'Khong cap nhat duoc thong bao'),
      );
    }
  }

  @override
  Future<Result<void, AppException>> deleteNotification(int notificationId) async {
    try {
      final response = await _dio.delete(ApiConstants.deleteNotification(notificationId));
      if (response.data['success'] == true) {
        return const Result.success(null);
      }
      return Result.failure(AppException(response.data['message'] ?? 'Khong xoa duoc thong bao'));
    } on DioException catch (e) {
      return Result.failure(
        AppException(e.response?.data['message'] ?? e.message ?? 'Khong xoa duoc thong bao'),
      );
    }
  }
}
