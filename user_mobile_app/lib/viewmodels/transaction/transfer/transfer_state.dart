import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/account/account_model.dart';
import '../../../models/transaction/transaction_model.dart';

part 'transfer_state.freezed.dart';

@freezed
class TransferState with _$TransferState {
  const factory TransferState({
    @Default([]) List<AccountModel> myAccounts,
    AccountModel? selectedSourceAccount,
    AccountModel? recipientAccount,
    @Default(0.0) double amount,
    @Default('Chuyển tiền') String description,
    @Default('') String pin,
    @Default(false) bool isLoading,
    @Default(false) bool isSearchingRecipient,
    String? errorMessage,
    TransactionModel? successTransaction,
    @Default(1) int currentStep, // 1: Input Info, 2: Confirm, 3: PIN, 4: Success
    @Default(0) int wrongPinAttempts,
    @Default(false) bool isLocked,
  }) = _TransferState;
}
