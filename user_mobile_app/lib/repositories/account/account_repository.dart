import '../../models/account/account_model.dart';

abstract class IAccountRepository {
  Future<List<AccountModel>> getMyAccounts();
  Future<AccountModel> getAccountDetails(int id);
  Future<AccountModel> createAccount(String type);
  Future<AccountModel> searchAccountByNumber(String accountNumber);
}
