import '../../models/user/user_model.dart';
import '../../core/exceptions/app_exception.dart';
import '../../core/results/result.dart';

abstract class IUserRepository {
  Future<Result<UserModel, AppException>> getProfile();
  Future<Result<void, AppException>> changePassword(String oldPassword, String newPassword);
  Future<Result<void, AppException>> setupPin(String pin);
  Future<Result<void, AppException>> changePin(String oldPin, String newPin);
  Future<Result<bool, AppException>> verifyPin(String pin);
}
