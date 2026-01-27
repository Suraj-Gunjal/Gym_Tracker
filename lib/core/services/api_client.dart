import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'secure_storage_service.dart';

/// HTTP client with automatic token refresh and error handling.
class ApiClient {
  final SecureStorageService _storage;
  final http.Client _httpClient;

  ApiClient({SecureStorageService? storage, http.Client? httpClient})
    : _storage = storage ?? SecureStorageService(),
      _httpClient = httpClient ?? http.Client();

  /// Make a GET request
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, String>? queryParams,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint, queryParams);
    final headers = await _buildHeaders(requiresAuth);

    try {
      final response = await _httpClient
          .get(uri, headers: headers)
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Make a POST request
  Future<ApiResponse> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requiresAuth);

    try {
      final response = await _httpClient
          .post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Make a PUT request
  Future<ApiResponse> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requiresAuth);

    try {
      final response = await _httpClient
          .put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Make a PATCH request
  Future<ApiResponse> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requiresAuth);

    try {
      final response = await _httpClient
          .patch(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  /// Make a DELETE request
  Future<ApiResponse> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final uri = _buildUri(endpoint);
    final headers = await _buildHeaders(requiresAuth);

    try {
      final response = await _httpClient
          .delete(uri, headers: headers)
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Uri _buildUri(String endpoint, [Map<String, String>? queryParams]) {
    final baseUri = Uri.parse(ApiConfig.baseUrl);
    return Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port,
      path: endpoint,
      queryParameters: queryParams?.isNotEmpty == true ? queryParams : null,
    );
  }

  Future<Map<String, String>> _buildHeaders(bool requiresAuth) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add device ID
    final deviceId = await _storage.getDeviceId();
    if (deviceId != null) {
      headers['X-Device-Id'] = deviceId;
    }

    // Add auth token
    if (requiresAuth) {
      final token = await _storage.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  ApiResponse _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    dynamic data;

    try {
      if (response.body.isNotEmpty) {
        data = jsonDecode(response.body);
      }
    } catch (_) {
      data = response.body;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return ApiResponse.success(data, statusCode);
    }

    // Extract error message
    String? errorMessage;
    String? errorCode;
    if (data is Map<String, dynamic>) {
      errorMessage = data['error'] as String?;
      errorCode = data['code'] as String?;
    }

    return ApiResponse.error(
      errorMessage ?? 'Request failed',
      statusCode,
      errorCode,
    );
  }

  ApiResponse _handleError(dynamic error) {
    debugPrint('API Error: $error');

    if (error is SocketException) {
      return ApiResponse.error('No internet connection', 0, 'NETWORK_ERROR');
    }

    if (error.toString().contains('TimeoutException')) {
      return ApiResponse.error('Request timed out', 0, 'TIMEOUT');
    }

    return ApiResponse.error(
      'An unexpected error occurred',
      0,
      'UNKNOWN_ERROR',
    );
  }

  void dispose() {
    _httpClient.close();
  }
}

/// Represents an API response
class ApiResponse {
  final bool isSuccess;
  final dynamic data;
  final String? error;
  final String? errorCode;
  final int statusCode;

  const ApiResponse._({
    required this.isSuccess,
    this.data,
    this.error,
    this.errorCode,
    required this.statusCode,
  });

  factory ApiResponse.success(dynamic data, int statusCode) {
    return ApiResponse._(isSuccess: true, data: data, statusCode: statusCode);
  }

  factory ApiResponse.error(String message, int statusCode, [String? code]) {
    return ApiResponse._(
      isSuccess: false,
      error: message,
      errorCode: code,
      statusCode: statusCode,
    );
  }

  /// Check if the error is due to authentication
  bool get isAuthError => statusCode == 401;

  /// Check if the error is a network error
  bool get isNetworkError => statusCode == 0;

  /// Get data as a typed map
  Map<String, dynamic>? get dataAsMap {
    if (data is Map<String, dynamic>) {
      return data as Map<String, dynamic>;
    }
    return null;
  }

  /// Get data as a list
  List<dynamic>? get dataAsList {
    if (data is List) {
      return data as List<dynamic>;
    }
    return null;
  }
}
