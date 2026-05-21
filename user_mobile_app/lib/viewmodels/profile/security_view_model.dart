import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/user/user_repository.dart';
import 'security_state.dart';

class SecurityViewModel extends StateNotifier<SecurityState> {
  final IUserRepository _userRepository;

  SecurityViewModel(this._userRepository) : super(const SecurityState());

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    if (oldPassword == newPassword) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Mật khẩu mới không được trùng với mật khẩu hiện tại",
      );
      return false;
    }

    final result = await _userRepository.changePassword(
      oldPassword,
      newPassword,
    );

    return result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: "Đổi mật khẩu thành công",
        );
        return true;
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapErrorMessage(error.message),
        );
        return false;
      },
    );
  }

  Future<bool> setupPin(String pin) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _userRepository.setupPin(pin);

    return result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: "Thiết lập mã PIN thành công",
        );
        return true;
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapErrorMessage(error.message),
        );
        return false;
      },
    );
  }

  Future<bool> verifyPin(String pin) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );
    final result = await _userRepository.verifyPin(pin);

    return result.when(
      success: (isValid) {
        state = state.copyWith(isLoading: false);
        return isValid;
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapErrorMessage(error.message),
        );
        return false;
      },
    );
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      successMessage: null,
    );

    if (oldPin == newPin) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Mã PIN mới không được trùng với mã PIN hiện tại",
      );
      return false;
    }

    final result = await _userRepository.changePin(oldPin, newPin);

    return result.when(
      success: (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: "Đổi mã PIN thành công",
        );
        return true;
      },
      failure: (error) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _mapErrorMessage(error.message),
        );
        return false;
      },
    );
  }

  String _mapErrorMessage(String message) {
    if (message.contains("Invalid password") ||
        message.contains("không đúng") ||
        message.contains("Wrong password")) {
      if (message.contains("PIN")) return "Mã PIN hiện tại không chính xác.";
      return "Mật khẩu hiện tại không chính xác.";
    }
    if (message.contains("Input validation failed")) {
      return "Thông tin nhập vào không hợp lệ. Vui lòng kiểm tra lại.";
    }
    if (message.contains("Invalid PIN")) {
      return "Mã PIN hiện tại không chính xác.";
    }
    if (message.contains("already exists")) {
      return "Thông tin đã tồn tại trên hệ thống.";
    }
    if (message.contains("not found")) {
      return "Không tìm thấy thông tin người dùng.";
    }
    return message; // Return original if no match
  }

  void clearMessages() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}
