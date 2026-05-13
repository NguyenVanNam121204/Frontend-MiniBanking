import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/account/account_model.dart';
import '../../../models/transaction/transaction_model.dart';

part 'deposit_state.freezed.dart';

@freezed
class DepositState with _$DepositState {
  const factory DepositState({
    @Default([]) List<AccountModel> myAccounts,
    AccountModel? selectedAccount,
    @Default(0.0) double amount,
    @Default('Nạp tiền vào tài khoản') String description,
    @Default(false) bool isLoading,
    String? errorMessage,
    TransactionModel? successTransaction,
    @Default(1) int currentStep, // 1: Input, 2: Confirm, 3: Success
  }) = _DepositState;
}
