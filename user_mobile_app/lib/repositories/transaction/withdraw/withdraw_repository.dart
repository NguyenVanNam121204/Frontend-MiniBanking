import '../../../models/transaction/transaction_model.dart';

abstract class IWithdrawRepository {
  Future<TransactionModel> withdraw({
    required String accountNumber,
    required double amount,
    String? description,
    required String pin,
  });
}
