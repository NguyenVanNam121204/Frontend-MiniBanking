import '../../core/exceptions/app_exception.dart';
import '../../core/results/result.dart';
import '../../models/auth/auth_dtos.dart';
import '../../repositories/auth/auth_repository.dart';
import '../storage_service.dart';

class AuthService {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthService(this._authRepository, this._storageService);

  Future<Result<AuthResponseDto, AppException>> login(LoginRequestDto request) async {
    final result = await _authRepository.login(request);
    
    return result.when(
      success: (data) async {
        await _storageService.saveTokens(
          accessToken: data.accessToken, 
          refreshToken: data.refreshToken
        );
        await _storageService.saveUsername(data.user.username);
        return Result.success(data);
      },
      failure: (error) => Result.failure(error),
    );
  }

  Future<Result<void, AppException>> register(RegisterRequestDto request) async {
    return _authRepository.register(request);
  }

  Future<Result<void, AppException>> verifyEmail(VerifyEmailRequestDto request) async {
    return _authRepository.verifyEmail(request);
  }

  Future<Result<void, AppException>> forgotPassword(ForgotPasswordRequestDto request) async {
    return _authRepository.forgotPassword(request);
  }

  Future<Result<void, AppException>> resetPassword(ResetPasswordRequestDto request) async {
    return _authRepository.resetPassword(request);
  }

  Future<Result<void, AppException>> resendVerification(String email) async {
    return _authRepository.resendVerification(ForgotPasswordRequestDto(email: email));
  }
  Future<Result<void, AppException>> verifyResetOtp(VerifyEmailRequestDto request) async {
    return _authRepository.verifyResetOtp(request);
  }
}
