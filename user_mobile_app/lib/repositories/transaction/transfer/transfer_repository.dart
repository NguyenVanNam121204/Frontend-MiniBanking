import '../../../models/transaction/transaction_model.dart';

abstract class ITransferRepository {
  Future<TransactionModel> transfer({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
    String? description,
    required String pin,
  });
}
