import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/user/user_repository.dart';
import 'profile_state.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  final IUserRepository _userRepository;

  ProfileViewModel(this._userRepository) : super(const ProfileState()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _userRepository.getProfile();
    
    result.when(
      success: (user) {
        state = state.copyWith(user: user, isLoading: false);
      },
      failure: (error) {
        state = state.copyWith(errorMessage: error.message, isLoading: false);
      },
    );
  }

  Future<void> refresh() async {
    await loadProfile();
  }
}
