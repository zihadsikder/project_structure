import 'dart:async';
import 'package:dio/dio.dart';
import '../models/response_data.dart';
import '../utils/logging/logger.dart';
import 'Auth_service.dart';
import 'network_interceptor.dart';

class NetworkCaller {
  static final NetworkCaller _instance = NetworkCaller._internal();
  factory NetworkCaller() => _instance;

  late final Dio _dio;
  final int timeoutDuration = 15000; // 15 seconds

  NetworkCaller._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: Duration(milliseconds: timeoutDuration),
        receiveTimeout: Duration(milliseconds: timeoutDuration),
        sendTimeout: Duration(milliseconds: timeoutDuration),
      ),
    );

    _dio.interceptors.addAll([AuthInterceptor(), LoggingInterceptor()]);
  }

  Future<ResponseData> getRequest(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: token != null ? {'Authorization': token} : null,
        ),
      );
      return _handleSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleUnexpectedError(e);
    }
  }

  Future<ResponseData> postRequest(
    String endpoint, {
    dynamic body,
    String? token,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(
          headers: token != null ? {'Authorization': token} : null,
        ),
      );
      return _handleSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleUnexpectedError(e);
    }
  }

  Future<ResponseData> putRequest(
    String endpoint, {
    dynamic body,
    String? token,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(
          headers: token != null ? {'Authorization': token} : null,
        ),
      );
      return _handleSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleUnexpectedError(e);
    }
  }

  Future<ResponseData> deleteRequest(
    String endpoint, {
    dynamic body,
    String? token,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: body,
        options: Options(
          headers: token != null ? {'Authorization': token} : null,
        ),
      );
      return _handleSuccess(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return _handleUnexpectedError(e);
    }
  }

  // Handle successful response
  ResponseData _handleSuccess(Response response) {
    return ResponseData(
      isSuccess: true,
      statusCode: response.statusCode ?? 200,
      responseData: response.data,
      errorMessage: '',
    );
  }

  // Handle Dio errors
  ResponseData _handleDioError(DioException error) {
    String errorMessage = 'Something went wrong';
    int statusCode = error.response?.statusCode ?? 500;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Connection timeout. Please check your internet.';
      statusCode = 408;
    } else if (error.type == DioExceptionType.badResponse) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        errorMessage =
            data['message'] ??
            data['error'] ??
            data['msg'] ??
            'Unexpected error occurred';
      }

      if (statusCode == 401) {
        AuthService.logoutUser();
        errorMessage = 'Session expired. Please log in again.';
      }
    } else if (error.type == DioExceptionType.connectionError) {
      errorMessage = 'No internet connection.';
    }

    return ResponseData(
      isSuccess: false,
      statusCode: statusCode,
      errorMessage: errorMessage,
      responseData: error.response?.data,
    );
  }

  // Handle unexpected errors
  ResponseData _handleUnexpectedError(dynamic error) {
    AppLoggerHelper.error('Unexpected Error: $error');
    return ResponseData(
      isSuccess: false,
      statusCode: 500,
      errorMessage: 'An unexpected error occurred. Please try again.',
      responseData: null,
    );
  }
}
