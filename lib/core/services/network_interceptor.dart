import 'package:dio/dio.dart';
import '../utils/logging/logger.dart';
import 'Auth_service.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLoggerHelper.info('--- 🚀 API REQUEST ---');
    AppLoggerHelper.info('URL: [${options.method}] ${options.uri}');
    if (options.headers.isNotEmpty) {
      AppLoggerHelper.verbose('Headers: ${options.headers}');
    }
    if (options.data != null) {
      AppLoggerHelper.verbose('Body: ${options.data}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLoggerHelper.info('--- ✅ API RESPONSE ---');
    AppLoggerHelper.info(
      'URL: [${response.requestOptions.method}] ${response.requestOptions.uri}',
    );
    AppLoggerHelper.info(
      'Status: ${response.statusCode} - ${response.statusMessage}',
    );
    if (response.data != null) {
      AppLoggerHelper.debug('Response Data: ${response.data}');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLoggerHelper.error('--- ❌ API ERROR ---');
    AppLoggerHelper.error(
      'URL: [${err.requestOptions.method}] ${err.requestOptions.uri}',
    );
    AppLoggerHelper.error('Status: ${err.response?.statusCode}');
    AppLoggerHelper.error('Message: ${err.message}');
    if (err.response?.data != null) {
      AppLoggerHelper.error('Error Data: ${err.response?.data}');
    }
    return super.onError(err, handler);
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Only add default token if Authorization header is not already set manually
    if (!options.headers.containsKey('Authorization')) {
      final token = AuthService.token;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    return super.onRequest(options, handler);
  }
}
