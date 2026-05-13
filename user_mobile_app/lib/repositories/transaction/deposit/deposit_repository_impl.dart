import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/api_constants.dart';
import '../../../models/transaction/transaction_model.dart';
import 'deposit_repository.dart';

class DepositRepositoryImpl implements IDepositRepository {
  final Dio _dio;

  DepositRepositoryImpl(this._dio);

  @override
  Future<TransactionModel> deposit({
    required String accountNumber,
    required double amount,
    String? description,
  }) async {
    try {
      final idempotencyKey = const Uuid().v4();
      final response = await _dio.post(
        ApiConstants.deposit,
        data: {
          'accountNumber': accountNumber,
          'amount': amount,
          'description': description,
        },
        options: Options(
          headers: {'Idempotency-Key': idempotencyKey},
        ),
      );

      if (response.data['success'] == true) {
        return TransactionModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Nạp tiền thất bại');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      log('Deposit Error: $e');
      rethrow;
    }
  }
}
