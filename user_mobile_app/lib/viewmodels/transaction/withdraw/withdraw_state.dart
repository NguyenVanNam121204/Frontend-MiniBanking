import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/account/account_model.dart';
import '../../../models/transaction/transaction_model.dart';

part 'withdraw_state.freezed.dart';

@freezed
class WithdrawState with _$WithdrawState {
  const factory WithdrawState({
    @Default([]) List<AccountModel> myAccounts,
    AccountModel? selectedAccount,
    @Default(0.0) double amount,
    @Default('Rút tiền từ tài khoản') String description,
    @Default('') String pin,
    @Default(false) bool isLoading,
    String? errorMessage,
    TransactionModel? successTransaction,
    @Default(1) int currentStep, // 1: Input, 2: Confirm, 3: PIN, 4: Success
    @Default(0) int wrongPinAttempts,
    @Default(false) bool isLocked,
  }) = _WithdrawState;
}
