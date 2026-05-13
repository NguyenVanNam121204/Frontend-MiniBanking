import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/auth/auth_dtos.dart';
import '../../../services/auth/auth_service.dart';
import 'forgot_password_state.dart';

class ForgotPasswordViewModel extends StateNotifier<ForgotPasswordState> {
  final AuthService _authService;

  ForgotPasswordViewModel(this._authService) : super(const ForgotPasswordState());

  // Bước 1: Gửi yêu cầu quên mật khẩu (nhập email)
  Future<void> sendForgotPasswordOtp(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await _authService.forgotPassword(ForgotPasswordRequestDto(email: email));
    
    result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false, 
          emailSent: true, 
          email: email
        );
      },
      failure: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }

  // Bước 2: Xác thực mã OTP
  Future<void> verifyOtp(String otp) async {
    if (state.email == null) return;
    
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await _authService.verifyResetOtp(VerifyEmailRequestDto(
      email: state.email!,
      otp: otp,
    ));
    
    result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false, 
          otp: otp, 
          otpVerified: true
        );
      },
      failure: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }

  // Bước 3: Đặt lại mật khẩu mới
  Future<void> resetPassword(String newPassword) async {
    if (state.email == null || state.otp == null) {
      state = state.copyWith(errorMessage: 'Thiếu thông tin xác thực');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.resetPassword(ResetPasswordRequestDto(
      email: state.email!,
      otp: state.otp!,
      newPassword: newPassword,
    ));

    result.when(
      success: (_) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      },
      failure: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }

  void reset() {
    state = const ForgotPasswordState();
  }
}
