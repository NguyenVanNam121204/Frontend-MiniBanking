import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../network/api_constants.dart';
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
        final refreshToken = await storageService.getRefreshToken();
        
        if (refreshToken != null) {
          try {
            // Use a separate Dio instance to avoid circular dependency and interceptor loops
            final refreshDio = Dio(BaseOptions(
              baseUrl: e.requestOptions.baseUrl,
              contentType: 'application/json',
            ));
            
            final response = await refreshDio.post(
              ApiConstants.refreshToken,
              data: {'refreshToken': refreshToken},
            );
            
            if (response.statusCode == 200 && response.data['success'] == true) {
              final newAccessToken = response.data['data']['accessToken'];
              final newRefreshToken = response.data['data']['refreshToken'];
              
              // Save new tokens
              await storageService.saveTokens(
                accessToken: newAccessToken,
                refreshToken: newRefreshToken,
              );
              
              // Retry the original request with new token
              final options = e.requestOptions;
              options.headers['Authorization'] = 'Bearer $newAccessToken';
              
              final clonedRequest = await dio.request(
                options.path,
                options: Options(
                  method: options.method,
                  headers: options.headers,
                ),
                data: options.data,
                queryParameters: options.queryParameters,
              );
              
              return handler.resolve(clonedRequest);
            }
          } catch (refreshError) {
            // Refresh token failed or expired
            await storageService.clearTokens();
            await storageService.clearUsername();
            // Optional: Broadcast logout event or navigate to login
          }
        }
      }
      return handler.next(e);
    },
  ));

  return dio;
}
