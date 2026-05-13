import 'package:freezed_annotation/freezed_annotation.dart';
import '../../models/user/user_model.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    UserModel? user,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ProfileState;
}
