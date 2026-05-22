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
    this._transactionRepository,
  ) : super(const HomeState()) {
    _init();
  }

  Future<void> _init() async {
    final userName = await _storageService.getUsername() ?? '';
    if (!mounted) {
      return;
    }
    state = state.copyWith(userName: userName);
    await fetchData();
  }

  Future<void> fetchData({bool silent = false}) async {
    if (!mounted) {
      return;
    }
    state = state.copyWith(isLoading: !silent, errorMessage: null);
    try {
      // 1. Get Accounts
      final accounts = await _accountService.getMyAccounts();
      if (!mounted) {
        return;
      }

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

      // 2. Get recent history across all accounts, then dedupe by transaction id.
      if (accounts.isNotEmpty) {
        try {
          final transactionGroups = await Future.wait(
            accounts.map(
              (account) => _transactionRepository.getTransactionHistory(
                account.id,
                size: 5,
              ),
            ),
          );
          if (!mounted) {
            return;
          }

          final transactionById = {
            for (final transaction in transactionGroups.expand(
              (items) => items,
            ))
              transaction.id: transaction,
          };
          final transactions = transactionById.values.toList()
            ..sort((a, b) {
              final aTime = a.completedAt ?? a.createdAt;
              final bTime = b.completedAt ?? b.createdAt;
              return bTime.compareTo(aTime);
            });

          state = state.copyWith(
            recentTransactions: transactions.take(5).toList(),
          );
        } catch (e) {
          log('Error fetching transactions: $e');
          // Don't set global error if only transactions fail
        }
      } else {
        state = state.copyWith(recentTransactions: []);
      }

      if (!mounted) {
        return;
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      if (!mounted) {
        return;
      }
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
