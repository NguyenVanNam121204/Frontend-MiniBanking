import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../repositories/account/account_repository.dart';
import '../../../models/account/account_model.dart';
import 'open_account_state.dart';

class OpenAccountViewModel extends StateNotifier<OpenAccountState> {
  final IAccountRepository _accountRepository;

  OpenAccountViewModel(this._accountRepository) : super(const OpenAccountState());

  Future<void> openAccount(AccountType type) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // Backend expects type in uppercase string as part of CreateAccountRequestDto
      // But our repository handles the mapping
      final account = await _accountRepository.createAccount(type.name.toUpperCase());
      state = state.copyWith(
        isLoading: false, 
        isSuccess: true, 
        createdAccount: account
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false, 
        errorMessage: e.toString().replaceAll('Exception: ', '')
      );
    }
  }

  void reset() {
    state = const OpenAccountState();
  }
}
