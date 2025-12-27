import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/response_data.dart';
import '../utils/logging/logger.dart';
import 'Auth_service.dart';

class NetworkCaller {
  final int timeoutDuration = 12;

  Future<ResponseData> getRequest(String endpoint, {String? token}) async {
    AppLoggerHelper.info('GET → $endpoint');
    try {
      final response = await http
          .get(
        Uri.parse(endpoint),
        headers: _buildHeaders(token),
      )
          .timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e, stack) {
      AppLoggerHelper.error('GET Error: $e\nStack: $stack');
      return _handleError(e);
    }
  }

  Future<ResponseData> postRequest(String endpoint,
      {Map<String, dynamic>? body, String? token}) async {
    AppLoggerHelper.info('POST → $endpoint');
    if (body != null) {
      AppLoggerHelper.info('Body: ${jsonEncode(body)}');
    }

    try {
      final response = await http
          .post(
        Uri.parse(endpoint),
        headers: _buildHeaders(token),
        body: body != null ? jsonEncode(body) : null,
      )
          .timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e, stack) {
      AppLoggerHelper.error('POST Error: $e\nStack: $stack');
      return _handleError(e);
    }
  }

  Future<ResponseData> putRequest(String endpoint,
      {Map<String, dynamic>? body, String? token}) async {
    AppLoggerHelper.info('PUT → $endpoint');
    if (body != null) {
      AppLoggerHelper.info('Body: ${jsonEncode(body)}');
    }

    try {
      final response = await http
          .put(
        Uri.parse(endpoint),
        headers: _buildHeaders(token),
        body: body != null ? jsonEncode(body) : null,
      )
          .timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e, stack) {
      AppLoggerHelper.error('PUT Error: $e\nStack: $stack');
      return _handleError(e);
    }
  }

  Future<ResponseData> deleteRequest(String endpoint, {String? token}) async {
    AppLoggerHelper.info('DELETE → $endpoint');

    try {
      final response = await http
          .delete(
        Uri.parse(endpoint),
        headers: _buildHeaders(token),
      )
          .timeout(Duration(seconds: timeoutDuration));
      return _handleResponse(response);
    } catch (e, stack) {
      AppLoggerHelper.error('DELETE Error: $e\nStack: $stack');
      return _handleError(e);
    }
  }

  // Headers make function
  Map<String, String> _buildHeaders(String? token) {
    final authToken = token ?? AuthService.token?.toString();
    return {
      'Authorization': authToken ?? '',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Response hgandelling
  ResponseData _handleResponse(http.Response response) {
    AppLoggerHelper.info('Status: ${response.statusCode} | Body: ${response.body.substring(0, response.body.length.clamp(0, 500))}...');

    try {
      final dynamic decoded = jsonDecode(response.body);

      // Error message extract
      String? errorMessage;
      if (decoded is Map<String, dynamic>) {
        errorMessage = decoded['message'] as String? ??
            decoded['error'] as String? ??
            decoded['msg'] as String?;
      }

      switch (response.statusCode) {
        case 200:
        case 201:
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decoded,
            errorMessage: '',
          );

        case 204:
          return ResponseData(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: null,
            errorMessage: '',
          );

        case 400: // Bad Request (validation error)
          return ResponseData(
            isSuccess: false,
            statusCode: 400,
            errorMessage: errorMessage ?? 'Invalid request. Please check your input.',
            responseData: decoded,
          );

        case 401: // Unauthorized
          AuthService.logoutUser(); // auto update
          return ResponseData(
            isSuccess: false,
            statusCode: 401,
            errorMessage: errorMessage ?? 'Session expired. Please log in again.',
            responseData: null,
          );

        case 403: // Forbidden
          return ResponseData(
            isSuccess: false,
            statusCode: 403,
            errorMessage: errorMessage ?? 'You do not have permission to perform this action.',
            responseData: null,
          );

        case 404:
          return ResponseData(
            isSuccess: false,
            statusCode: 404,
            errorMessage: errorMessage ?? 'Resource not found.',
            responseData: null,
          );

        case 500:
        case 502:
        case 503:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessage ?? 'Server error. Please try again later.',
            responseData: null,
          );

        default:
          return ResponseData(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessage ?? 'Unexpected error occurred.',
            responseData: decoded,
          );
      }
    } catch (e) {
      AppLoggerHelper.error('Response parsing failed: $e');
      return ResponseData(
        isSuccess: false,
        statusCode: response.statusCode,
        errorMessage: 'Failed to understand server response.',
        responseData: null,
      );
    }
  }

  // Client-side errors
  ResponseData _handleError(dynamic error) {
    if (error is TimeoutException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 408,
        errorMessage: 'Request timed out. Check your internet and try again.',
        responseData: null,
      );
    } else if (error is http.ClientException) {
      return ResponseData(
        isSuccess: false,
        statusCode: 503,
        errorMessage: 'Network issue. Please check your connection.',
        responseData: null,
      );
    } else {
      return ResponseData(
        isSuccess: false,
        statusCode: 500,
        errorMessage: 'Something went wrong. Please try again.',
        responseData: null,
      );
    }
  }
}