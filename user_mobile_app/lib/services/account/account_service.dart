import '../../models/account/account_model.dart';
import '../../repositories/account/account_repository.dart';

class AccountService {
  final IAccountRepository _repository;

  AccountService(this._repository);

  Future<List<AccountModel>> getMyAccounts() => _repository.getMyAccounts();
  Future<AccountModel> getAccountDetails(int id) => _repository.getAccountDetails(id);
  Future<AccountModel> createAccount(AccountType type) => 
      _repository.createAccount(type.name.toUpperCase());
  Future<AccountModel> searchAccount(String accountNumber) => 
      _repository.searchAccountByNumber(accountNumber);
}
