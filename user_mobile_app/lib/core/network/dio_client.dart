import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import '../network/api_constants.dart';
import '../../services/storage_service.dart';
import 'interceptors/logging_interceptor.dart';

Future<String?>? _refreshTokenFuture;
final ValueNotifier<int> authSessionExpiredNotifier = ValueNotifier<int>(0);

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

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storageService.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        final isRefreshRequest =
            e.requestOptions.path == ApiConstants.refreshToken;
        if (e.response?.statusCode == 401 && !isRefreshRequest) {
          try {
            _refreshTokenFuture ??= _refreshAccessToken(
              e.requestOptions.baseUrl,
              storageService,
            );
            final newAccessToken = await _refreshTokenFuture;

            if (newAccessToken != null) {
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
          } finally {
            _refreshTokenFuture = null;
          }
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
}

Future<String?> _refreshAccessToken(
  String baseUrl,
  StorageService storageService,
) async {
  final refreshToken = await storageService.getRefreshToken();
  if (refreshToken == null) {
    await storageService.clearAll();
    authSessionExpiredNotifier.value++;
    return null;
  }

  try {
    final refreshDio = Dio(
      BaseOptions(baseUrl: baseUrl, contentType: 'application/json'),
    );

    final response = await refreshDio.post(
      ApiConstants.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final newAccessToken = response.data['data']['accessToken'] as String;
      final newRefreshToken = response.data['data']['refreshToken'] as String;

      await storageService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      return newAccessToken;
    }
  } catch (_) {
    await storageService.clearAll();
    authSessionExpiredNotifier.value++;
  }

  return null;
}
