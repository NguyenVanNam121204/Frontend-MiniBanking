import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/account/account_model.dart';
import '../../../models/transaction/transaction_model.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default([]) List<AccountModel> accounts,
    @Default([]) List<TransactionModel> recentTransactions,
    @Default(0.0) double totalBalance, // Keeping for backward compatibility or global view
    @Default(0.0) double personalBalance,
    @Default(0.0) double businessBalance,
    @Default('') String userName,
    @Default(false) bool isLoading,
    @Default(true) bool isBalanceVisible,
    String? errorMessage,
  }) = _HomeState;
}
