import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../models/user/user_model.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/results/result.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements IUserRepository {
  final Dio _dio;

  UserRepositoryImpl(this._dio);

  @override
  Future<Result<UserModel, AppException>> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      if (response.data['success'] == true) {
        return Result.success(UserModel.fromJson(response.data['data']));
      }
      return Result.failure(AppException(response.data['message']));
    } on DioException catch (e) {
      return Result.failure(AppException(e.response?.data['message'] ?? e.message ?? 'Lỗi không xác định'));
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> changePassword(String oldPassword, String newPassword) async {
    try {
      final response = await _dio.post(
        ApiConstants.changePassword,
        data: {
          'currentPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': newPassword, // Frontend usually confirms before sending, so we can send twice or add it to repo method
        },
      );
      if (response.data['success'] == true) {
        return const Result.success(null);
      }
      return Result.failure(AppException(response.data['message']));
    } on DioException catch (e) {
      return Result.failure(AppException(e.response?.data['message'] ?? e.message ?? 'Lỗi không xác định'));
    }
  }

  @override
  Future<Result<void, AppException>> setupPin(String pin) async {
    try {
      final response = await _dio.post(
        ApiConstants.setupPin,
        data: {
          'pin': pin,
          'confirmPin': pin,
        },
      );
      if (response.data['success'] == true) {
        return const Result.success(null);
      }
      return Result.failure(AppException(response.data['message']));
    } on DioException catch (e) {
      return Result.failure(AppException(e.response?.data['message'] ?? e.message ?? 'Lỗi không xác định'));
    }
  }

  @override
  Future<Result<void, AppException>> changePin(String oldPin, String newPin) async {
    try {
      final response = await _dio.post(
        ApiConstants.changePin,
        data: {
          'currentPin': oldPin,
          'newPin': newPin,
          'confirmPin': newPin,
        },
      );
      if (response.data['success'] == true) {
        return const Result.success(null);
      }
      return Result.failure(AppException(response.data['message']));
    } on DioException catch (e) {
      return Result.failure(AppException(e.response?.data['message'] ?? e.message ?? 'Lỗi không xác định'));
    }
  }

  @override
  Future<Result<bool, AppException>> verifyPin(String pin) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyPin,
        data: {'pin': pin},
      );
      if (response.data['success'] == true) {
        return Result.success(response.data['data'] == true);
      }
      return Result.failure(AppException(response.data['message']));
    } on DioException catch (e) {
      return Result.failure(AppException(e.response?.data['message'] ?? e.message ?? 'Lỗi không xác định'));
    }
  }
}
