import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_state.freezed.dart';

@freezed
class SecurityState with _$SecurityState {
  const factory SecurityState({
    @Default(false) bool isLoading,
    String? successMessage,
    String? errorMessage,
  }) = _SecurityState;
}
