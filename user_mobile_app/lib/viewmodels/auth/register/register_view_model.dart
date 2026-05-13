import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/auth/auth_dtos.dart';
import '../../../services/auth/auth_service.dart';
import 'register_state.dart';

class RegisterViewModel extends StateNotifier<RegisterState> {
  final AuthService _authService;

  RegisterViewModel(this._authService) : super(const RegisterState());

  Future<void> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.register(RegisterRequestDto(
      username: username,
      email: email,
      password: password,
    ));

    result.when(
      success: (data) {
        state = state.copyWith(isLoading: false, isSuccess: true);
      },
      failure: (error) {
        state = state.copyWith(isLoading: false, errorMessage: error.message);
      },
    );
  }
}
