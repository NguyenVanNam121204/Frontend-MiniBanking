import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/account/account_model.dart';

part 'open_account_state.freezed.dart';

@freezed
class OpenAccountState with _$OpenAccountState {
  const factory OpenAccountState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorMessage,
    AccountModel? createdAccount,
  }) = _OpenAccountState;
}
