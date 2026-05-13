import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../../core/network/api_constants.dart';
import '../../../models/transaction/transaction_model.dart';
import 'transfer_repository.dart';

class TransferRepositoryImpl implements ITransferRepository {
  final Dio _dio;

  TransferRepositoryImpl(this._dio);

  @override
  Future<TransactionModel> transfer({
    required String fromAccountNumber,
    required String toAccountNumber,
    required double amount,
    String? description,
    required String pin,
  }) async {
    try {
      final idempotencyKey = const Uuid().v4();
      final response = await _dio.post(
        ApiConstants.transfer,
        data: {
          'fromAccountNumber': fromAccountNumber,
          'toAccountNumber': toAccountNumber,
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
      throw Exception(response.data['message'] ?? 'Chuyển tiền thất bại');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      log('Transfer Error: $e');
      rethrow;
    }
  }
}
