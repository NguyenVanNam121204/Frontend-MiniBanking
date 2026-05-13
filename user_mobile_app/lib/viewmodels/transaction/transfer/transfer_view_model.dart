import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/account/account_service.dart';
import '../../../repositories/transaction/transfer/transfer_repository.dart';
import 'transfer_state.dart';
import '../../../models/account/account_model.dart';

class TransferViewModel extends StateNotifier<TransferState> {
  final AccountService _accountService;
  final ITransferRepository _transferRepository;

  TransferViewModel(this._accountService, this._transferRepository) : super(const TransferState()) {
    init();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true);
    try {
      final accounts = await _accountService.getMyAccounts();
      state = state.copyWith(
        myAccounts: accounts,
        selectedSourceAccount: accounts.isNotEmpty ? accounts.first : null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectSourceAccount(AccountModel account) {
    state = state.copyWith(selectedSourceAccount: account);
  }

  Future<void> searchRecipient(String accountNumber) async {
    if (accountNumber.isEmpty) {
      state = state.copyWith(recipientAccount: null, errorMessage: null);
      return;
    }
    
    if (accountNumber.length < 5) {
      state = state.copyWith(recipientAccount: null);
      return;
    }
    
    state = state.copyWith(isSearchingRecipient: true, errorMessage: null);
    try {
      final account = await _accountService.searchAccount(accountNumber);
      state = state.copyWith(
        recipientAccount: account,
        isSearchingRecipient: false,
        errorMessage: null,
      );
    } catch (e) {
      String errorMsg = e.toString();
      // Aggressively remove technical prefixes
      errorMsg = errorMsg
          .replaceFirst(RegExp(r'^Exception: '), '')
          .replaceFirst(RegExp(r'^error: '), '')
          .replaceFirst(RegExp(r'^DioException.*: '), '');
      
      state = state.copyWith(
        recipientAccount: null,
        isSearchingRecipient: false,
        errorMessage: errorMsg.trim(),
      );
    }
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
  }

  void setDescription(String desc) {
    state = state.copyWith(description: desc);
  }

  void setPin(String pin) {
    if (state.isLocked) return;
    state = state.copyWith(pin: pin, errorMessage: null);
    if (pin.length == 6) {
      performTransfer();
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
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> performTransfer() async {
    if (state.selectedSourceAccount == null || state.recipientAccount == null) return;
    
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await _transferRepository.transfer(
        fromAccountNumber: state.selectedSourceAccount!.accountNumber,
        toAccountNumber: state.recipientAccount!.accountNumber,
        amount: state.amount,
        description: state.description,
        pin: state.pin,
      );
      
      state = state.copyWith(
        isLoading: false,
        successTransaction: result,
        currentStep: 4, // Success step
        wrongPinAttempts: 0, // Reset on success
      );
    } catch (e) {
      String errorMsg = e.toString();
      // Aggressively remove technical prefixes
      errorMsg = errorMsg
          .replaceFirst(RegExp(r'^Exception: '), '')
          .replaceFirst(RegExp(r'^error: '), '')
          .replaceFirst(RegExp(r'^DioException.*: '), '');
      
      int attempts = state.wrongPinAttempts + 1;
      bool locked = attempts >= 5;
      
      if (errorMsg.contains('PIN không chính xác')) {
        if (locked) {
          errorMsg = "Bạn đã nhập sai mã PIN 5 lần. Để bảo mật, tài khoản tạm thời bị khóa tính năng chuyển tiền.";
        } else {
          errorMsg = "Mã PIN không chính xác. Bạn còn ${5 - attempts} lần thử lại.";
        }
      }

      state = state.copyWith(
        isLoading: false, 
        errorMessage: errorMsg,
        wrongPinAttempts: attempts,
        isLocked: locked,
        pin: '', // Clear pin for retry
      );
    }
  }

  void reset() {
    state = const TransferState();
    init();
  }
}
