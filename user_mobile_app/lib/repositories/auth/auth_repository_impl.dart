import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../core/results/result.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/utils/logger.dart';
import '../../models/auth/auth_dtos.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Result<AuthResponseDto, AppException>> login(LoginRequestDto request) async {
    try {
      final response = await _dio.post(ApiConstants.login, data: request.toJson());
      final data = AuthResponseDto.fromJson(response.data['data']);
      return Result.success(data);
    } on DioException catch (e) {
      AppLogger.e('Login Repo Error', e.response?.data, e.stackTrace);
      return Result.failure(ServerException(e.response?.data['message'] ?? 'Login failed'));
    } catch (e) {
      AppLogger.e('Login Repo Unexpected Error', e);
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> register(RegisterRequestDto request) async {
    try {
      await _dio.post(ApiConstants.register, data: request.toJson());
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ServerException(e.response?.data['message'] ?? 'Registration failed'));
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> verifyEmail(VerifyEmailRequestDto request) async {
    try {
      await _dio.post(ApiConstants.verifyEmail, data: request.toJson());
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ServerException(e.response?.data['message'] ?? 'Verification failed'));
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> forgotPassword(ForgotPasswordRequestDto request) async {
    try {
      await _dio.post(ApiConstants.forgotPassword, data: request.toJson());
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ServerException(e.response?.data['message'] ?? 'Request failed'));
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> resetPassword(ResetPasswordRequestDto request) async {
    try {
      await _dio.post(ApiConstants.resetPassword, data: request.toJson());
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ServerException(e.response?.data['message'] ?? 'Reset failed'));
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> resendVerification(ForgotPasswordRequestDto request) async {
    try {
      await _dio.post(ApiConstants.resendOtp, data: request.toJson());
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ServerException(e.response?.data['message'] ?? 'Resend failed'));
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<void, AppException>> verifyResetOtp(VerifyEmailRequestDto request) async {
    try {
      await _dio.post(ApiConstants.verifyResetOtp, data: request.toJson());
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ServerException(e.response?.data['message'] ?? 'OTP verification failed'));
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }

  @override
  Future<Result<AuthResponseDto, AppException>> refreshToken(String refreshToken) async {
    try {
      // Note: We don't use Authorization header here, backend expects refresh token in body or specific header
      // Based on typical implementation, it's a POST with { "refreshToken": "..." }
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final data = AuthResponseDto.fromJson(response.data['data']);
      return Result.success(data);
    } on DioException catch (e) {
      return Result.failure(ServerException(e.response?.data['message'] ?? 'Token refresh failed'));
    } catch (e) {
      return Result.failure(AppException(e.toString()));
    }
  }
}
