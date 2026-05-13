import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/transaction/transaction_model.dart';
import '../../../models/account/account_model.dart';

part 'transaction_history_state.freezed.dart';

@freezed
class TransactionHistoryState with _$TransactionHistoryState {
  const factory TransactionHistoryState({
    @Default([]) List<TransactionModel> transactions,
    @Default([]) List<AccountModel> accounts,
    AccountModel? selectedAccount,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(0) int currentPage,
    @Default(true) bool hasMore,
    String? errorMessage,
    String? filterType, // 'ALL', 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
  }) = _TransactionHistoryState;
}
