import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/account/account_service.dart';
import '../../../repositories/transaction/withdraw/withdraw_repository.dart';
import 'withdraw_state.dart';
import '../../../models/account/account_model.dart';

class WithdrawViewModel extends StateNotifier<WithdrawState> {
  final AccountService _accountService;
  final IWithdrawRepository _transactionRepository;

  WithdrawViewModel(this._accountService, this._transactionRepository) : super(const WithdrawState()) {
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

  void setPin(String pin) {
    if (state.isLocked) return;
    
    state = state.copyWith(pin: pin, errorMessage: null);
    if (pin.length == 6) {
      performWithdraw();
    }
  }

  void updatePin(String digit) {
    if (state.pin.length < 6) {
      setPin(state.pin + digit);
    }
  }

  void deleteLastPin() {
    if (state.pin.isNotEmpty) {
      setPin(state.pin.substring(0, state.pin.length - 1));
    }
  }

  void nextStep() {
    if (state.currentStep < 4) {
      state = state.copyWith(currentStep: state.currentStep + 1, errorMessage: null);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1, errorMessage: null, pin: '');
    }
  }

  Future<void> performWithdraw() async {
    if (state.selectedAccount == null) return;

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final transaction = await _transactionRepository.withdraw(
        accountNumber: state.selectedAccount!.accountNumber,
        amount: state.amount,
        description: state.description,
        pin: state.pin,
      );

      state = state.copyWith(
        isLoading: false,
        successTransaction: transaction,
        currentStep: 4, // Success screen
        wrongPinAttempts: 0,
      );
    } catch (e) {
      String errorMsg = e.toString();
      errorMsg = errorMsg
          .replaceFirst(RegExp(r'^Exception: '), '')
          .replaceFirst(RegExp(r'^error: '), '')
          .replaceFirst(RegExp(r'^DioException.*: '), '');
      
      int attempts = state.wrongPinAttempts + 1;
      bool locked = attempts >= 5;
      
      if (errorMsg.contains('PIN không chính xác')) {
        if (locked) {
          errorMsg = "Bạn đã nhập sai mã PIN 5 lần. Để bảo mật, tài khoản tạm thời bị khóa tính năng rút tiền.";
        } else {
          errorMsg = "Mã PIN không chính xác. Bạn còn ${5 - attempts} lần thử lại.";
        }
      }

      state = state.copyWith(
        isLoading: false, 
        errorMessage: errorMsg.trim(),
        wrongPinAttempts: attempts,
        isLocked: locked,
        pin: '', // Clear pin for retry
      );
    }
  }

  void reset() {
    state = const WithdrawState();
    init();
  }
}
