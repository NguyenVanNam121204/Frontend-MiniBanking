import 'dart:developer';
import 'package:dio/dio.dart';
import '../../../core/network/api_constants.dart';
import '../../../models/transaction/transaction_model.dart';
import 'transaction_history_repository.dart';

class TransactionHistoryRepositoryImpl implements ITransactionHistoryRepository {
  final Dio _dio;

  TransactionHistoryRepositoryImpl(this._dio);

  @override
  Future<List<TransactionModel>> getTransactionHistory(int accountId, {int page = 0, int size = 10, String? type}) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'size': size,
      };
      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await _dio.get(
        '${ApiConstants.history}/$accountId',
        queryParameters: queryParams,
      );
      
      if (response.data['success'] == true) {
        final List<dynamic> content = response.data['data']['content'];
        return content.map((json) => TransactionModel.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Lấy lịch sử giao dịch thất bại');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      log('Error getting transactions: $e');
      rethrow;
    }
  }
}
