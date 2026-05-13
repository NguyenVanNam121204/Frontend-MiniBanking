import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/account/account_service.dart';
import '../../../repositories/transaction/deposit/deposit_repository.dart';
import 'deposit_state.dart';
import '../../../models/account/account_model.dart';

class DepositViewModel extends StateNotifier<DepositState> {
  final AccountService _accountService;
  final IDepositRepository _transactionRepository;

  DepositViewModel(this._accountService, this._transactionRepository) : super(const DepositState()) {
    init();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      final accounts = await _accountService.getMyAccounts();
      state = state.copyWith(
        myAccounts: accounts,
        selectedAccount: accounts.isNotEmpty ? accounts.first : null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectAccount(AccountModel account) {
    state = state.copyWith(selectedAccount: account);
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount, errorMessage: null);
  }

  void setDescription(String description) {
    state = state.copyWith(description: description);
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1, errorMessage: null);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1, errorMessage: null);
    }
  }

  Future<void> performDeposit() async {
    if (state.selectedAccount == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final transaction = await _transactionRepository.deposit(
        accountNumber: state.selectedAccount!.accountNumber,
        amount: state.amount,
        description: state.description,
      );

      state = state.copyWith(
        isLoading: false,
        successTransaction: transaction,
        currentStep: 3, // Success screen
      );
    } catch (e) {
      String errorMsg = e.toString();
      errorMsg = errorMsg
          .replaceFirst(RegExp(r'^Exception: '), '')
          .replaceFirst(RegExp(r'^error: '), '')
          .replaceFirst(RegExp(r'^DioException.*: '), '');
          
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMsg.trim(),
      );
    }
  }

  void reset() {
    state = const DepositState();
    init();
  }
}
