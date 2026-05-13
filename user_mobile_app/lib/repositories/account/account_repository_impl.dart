import 'dart:developer';
import 'package:dio/dio.dart';
import '../../core/network/api_constants.dart';
import '../../models/account/account_model.dart';
import 'account_repository.dart';

class AccountRepositoryImpl implements IAccountRepository {
  final Dio _dio;

  AccountRepositoryImpl(this._dio);

  @override
  Future<List<AccountModel>> getMyAccounts() async {
    try {
      final response = await _dio.get(ApiConstants.accounts);
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AccountModel.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'Lấy danh sách tài khoản thất bại');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      log('Error getting accounts: $e');
      rethrow;
    }
  }

  @override
  Future<AccountModel> getAccountDetails(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.accounts}/$id');
      if (response.data['success'] == true) {
        return AccountModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Lấy chi tiết tài khoản thất bại');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      log('Error getting account details: $e');
      rethrow;
    }
  }

  @override
  Future<AccountModel> createAccount(String type) async {
    try {
      final response = await _dio.post(
        ApiConstants.accounts,
        data: {'type': type},
      );
      if (response.data['success'] == true) {
        return AccountModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Tạo tài khoản thất bại');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      log('Error creating account: $e');
      rethrow;
    }
  }

  @override
  Future<AccountModel> searchAccountByNumber(String accountNumber) async {
    try {
      final response = await _dio.get(ApiConstants.searchAccount(accountNumber));
      if (response.data['success'] == true) {
        return AccountModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'Không tìm thấy tài khoản');
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message;
      throw Exception(message);
    } catch (e) {
      log('Error searching account: $e');
      rethrow;
    }
  }
}
