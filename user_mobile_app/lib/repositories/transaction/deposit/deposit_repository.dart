import '../../../models/transaction/transaction_model.dart';

abstract class IDepositRepository {
  Future<TransactionModel> deposit({
    required String accountNumber,
    required double amount,
    String? description,
  });
}
