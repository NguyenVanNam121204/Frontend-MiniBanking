import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/api_constants.dart';
import '../../../models/transaction/transaction_model.dart';
import 'withdraw_repository.dart';

class WithdrawRepositoryImpl implements IWithdrawRepository {
  final Dio _dio;

  WithdrawRepositoryImpl(this._dio);

  @override
  Future<TransactionModel> withdraw({
    required String accountNumber,
    required double amount,
    String? description,
    required String pin,
  }) async {
    try {
      final idempotencyKey = const Uuid().v4();
      final response = await _dio.post(
        ApiConstants.withdraw,
        data: {
          'accountNumber': accountNumber,
          'amount': amount,
          'description': description,
          'pin': pin,
        },
        options: Options(
          headers: {'Idempotency-Key': idempotencyKey},
        ),
      );

      if (response.data['success'] == true) {
        return TransactionModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Rút tiền thất bại');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      log('Withdraw Error: $e');
      rethrow;
    }
  }
}
