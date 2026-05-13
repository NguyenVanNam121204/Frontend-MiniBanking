import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../repositories/transaction/history/transaction_history_repository.dart';
import '../../../services/account/account_service.dart';
import 'transaction_history_state.dart';

class TransactionHistoryViewModel extends StateNotifier<TransactionHistoryState> {
  final ITransactionHistoryRepository _repository;
  final AccountService _accountService;

  TransactionHistoryViewModel(this._repository, this._accountService) : super(const TransactionHistoryState()) {
    init();
  }

  Future<void> init() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final accounts = await _accountService.getMyAccounts();
      if (accounts.isNotEmpty) {
        state = state.copyWith(
          accounts: accounts,
          selectedAccount: accounts.first,
        );
        await fetchTransactions();
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectAccount(int accountId) {
    final account = state.accounts.firstWhere((a) => a.id == accountId);
    state = state.copyWith(selectedAccount: account, currentPage: 0, transactions: [], hasMore: true);
    fetchTransactions();
  }

  void setFilter(String? type) {
    state = state.copyWith(filterType: type, currentPage: 0, transactions: [], hasMore: true);
    fetchTransactions();
  }

  Future<void> fetchTransactions({bool isLoadMore = false}) async {
    if (state.selectedAccount == null) return;
    if (isLoadMore && (!state.hasMore || state.isLoadingMore)) return;

    if (isLoadMore) {
      state = state.copyWith(isLoadingMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    try {
      final page = isLoadMore ? state.currentPage + 1 : 0;
      final newTransactions = await _repository.getTransactionHistory(
        state.selectedAccount!.id,
        page: page,
        size: 20,
        type: state.filterType,
      );

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        transactions: isLoadMore ? [...state.transactions, ...newTransactions] : newTransactions,
        currentPage: page,
        hasMore: newTransactions.length == 20,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() => fetchTransactions();
}
