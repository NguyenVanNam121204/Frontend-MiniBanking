import '../../core/exceptions/app_exception.dart';
import '../../core/results/result.dart';
import '../../models/auth/auth_dtos.dart';

abstract class IAuthRepository {
  Future<Result<AuthResponseDto, AppException>> login(LoginRequestDto request);
  Future<Result<void, AppException>> register(RegisterRequestDto request);
  Future<Result<void, AppException>> verifyEmail(VerifyEmailRequestDto request);
  Future<Result<void, AppException>> forgotPassword(ForgotPasswordRequestDto request);
  Future<Result<void, AppException>> resetPassword(ResetPasswordRequestDto request);
  Future<Result<void, AppException>> resendVerification(ForgotPasswordRequestDto request);
  Future<Result<void, AppException>> verifyResetOtp(VerifyEmailRequestDto request);
  Future<Result<AuthResponseDto, AppException>> refreshToken(String refreshToken);
}
