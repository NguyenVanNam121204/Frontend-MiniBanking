import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/storage_service.dart';
import 'interceptors/logging_interceptor.dart';

Dio createDio(StorageService storageService) {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.get('BASE_URL', fallback: 'http://localhost:8080/api'),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );

  dio.interceptors.add(LoggingInterceptor());

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storageService.getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) async {
      if (e.response?.statusCode == 401) {
        // Handle Token Refresh logic here
        // For brevity in setup, we'll just forward for now
      }
      return handler.next(e);
    },
  ));

  return dio;
}
