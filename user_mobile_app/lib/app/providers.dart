import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../core/di/injection.dart';
import '../repositories/auth/auth_repository.dart';
import '../services/auth/auth_service.dart';
import '../services/storage_service.dart';

// ViewModels
import '../viewmodels/auth/login/login_view_model.dart';
import '../viewmodels/auth/login/login_state.dart';
import '../viewmodels/auth/register/register_view_model.dart';
import '../viewmodels/auth/register/register_state.dart';
import '../viewmodels/auth/verify_otp/verify_otp_view_model.dart';
import '../viewmodels/auth/forgot_password/forgot_password_view_model.dart';
import '../viewmodels/auth/forgot_password/forgot_password_state.dart';
import '../viewmodels/auth/verify_otp/verify_otp_state.dart';

// -- Infrastructure Providers --

final dioProvider = Provider<Dio>((ref) {
  return getIt<Dio>();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return getIt<StorageService>();
});

// -- Repository Providers --

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return getIt<AuthRepository>();
});

// -- Service Providers --

final authServiceProvider = Provider<AuthService>((ref) {
  return getIt<AuthService>();
});

// -- ViewModel Providers --

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel(ref.watch(authServiceProvider));
});

final registerViewModelProvider = StateNotifierProvider<RegisterViewModel, RegisterState>((ref) {
  return RegisterViewModel(ref.watch(authServiceProvider));
});

final verifyOtpViewModelProvider = StateNotifierProvider<VerifyOtpViewModel, VerifyOtpState>((ref) {
  return VerifyOtpViewModel(ref.watch(authServiceProvider));
});

final forgotPasswordViewModelProvider = StateNotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>((ref) {
  return ForgotPasswordViewModel(ref.watch(authServiceProvider));
});
