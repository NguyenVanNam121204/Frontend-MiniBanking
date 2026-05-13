import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/account/account_model.dart';
import '../../../services/account/account_service.dart';
import '../../../services/storage_service.dart';
import '../../../repositories/transaction/history/transaction_history_repository.dart';
import 'home_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  final AccountService _accountService;
  final StorageService _storageService;
  final ITransactionHistoryRepository _transactionRepository;

  HomeViewModel(
    this._accountService, 
    this._storageService,
    this._transactionRepository
  ) : super(const HomeState()) {
    _init();
  }

  Future<void> _init() async {
    final userName = await _storageService.getUsername() ?? '';
    state = state.copyWith(userName: userName);
    fetchData();
  }

  Future<void> fetchData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      // 1. Get Accounts
      final accounts = await _accountService.getMyAccounts();
      
      double personalSum = 0;
      double businessSum = 0;
      
      for (var acc in accounts) {
        if (acc.type == AccountType.business) {
          businessSum += acc.balance;
        } else {
          personalSum += acc.balance;
        }
      }
      
      state = state.copyWith(
        accounts: List.from(accounts),
        personalBalance: personalSum,
        businessBalance: businessSum,
        totalBalance: personalSum + businessSum,
      );

      // 2. Get history for the first account if it exists
      if (accounts.isNotEmpty) {
        try {
          final transactions = await _transactionRepository.getTransactionHistory(
            accounts.first.id, 
            size: 5
          );
          state = state.copyWith(recentTransactions: transactions);
        } catch (e) {
          log('Error fetching transactions: $e');
          // Don't set global error if only transactions fail
        }
      }
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  // Keep fetchAccounts for RefreshIndicator compatibility
  Future<void> fetchAccounts() => fetchData();

  void toggleBalanceVisibility() {
    state = state.copyWith(isBalanceVisible: !state.isBalanceVisible);
  }
}
