import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/auth/auth_dtos.dart';
import '../../../services/auth/auth_service.dart';
import 'login_state.dart';

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthService _authService;

  LoginViewModel(this._authService) : super(const LoginState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.login(LoginRequestDto(
      username: username, 
      password: password
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
