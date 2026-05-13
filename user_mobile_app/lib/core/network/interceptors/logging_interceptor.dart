import 'package:dio/dio.dart';
import '../../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.i('--> ${options.method} ${options.uri}');
    AppLogger.d('Headers: ${options.headers}');
    AppLogger.d('Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i('<-- ${response.statusCode} ${response.requestOptions.uri}');
    AppLogger.d('Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      err.error,
      err.stackTrace,
    );
    super.onError(err, handler);
  }
}
