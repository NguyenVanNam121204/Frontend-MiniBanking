import '../../../models/transaction/transaction_model.dart';

abstract class ITransactionHistoryRepository {
  Future<List<TransactionModel>> getTransactionHistory(int accountId, {int page = 0, int size = 10, String? type});
}
