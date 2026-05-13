import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default(false) bool isLoading,
    @Default(false) bool emailSent,
    @Default(false) bool otpVerified,
    @Default(false) bool isSuccess,
    String? errorMessage,
    String? email,
    String? otp,
    int? remainingAttempts,
  }) = _ForgotPasswordState;
}
