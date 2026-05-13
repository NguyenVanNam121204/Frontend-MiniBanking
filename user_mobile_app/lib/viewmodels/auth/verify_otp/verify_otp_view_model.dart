import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/auth/auth_dtos.dart';
import '../../../services/auth/auth_service.dart';
import 'verify_otp_state.dart';

class VerifyOtpViewModel extends StateNotifier<VerifyOtpState> {
  final AuthService _authService;

  VerifyOtpViewModel(this._authService) : super(const VerifyOtpState());

  Future<void> verifyOtp(String email, String otp) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.verifyEmail(VerifyEmailRequestDto(
      email: email,
      otp: otp,
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

  Future<void> resendOtp(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.resendVerification(email);

    result.when(
      success: (_) {
        state = state.copyWith(isLoading: false);
      },
      failure: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }

  Future<void> resetPassword(String email, String otp, String newPassword) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.resetPassword(ResetPasswordRequestDto(
      email: email,
      otp: otp,
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
}
