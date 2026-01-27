import 'package:uuid/uuid.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../models/auth_models.dart';

/// Result wrapper for auth operations
class AuthResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const AuthResult._({this.data, this.error, required this.isSuccess});

  factory AuthResult.success(T data) =>
      AuthResult._(data: data, isSuccess: true);

  factory AuthResult.failure(String error) =>
      AuthResult._(error: error, isSuccess: false);
}

/// Repository for remote authentication operations
class RemoteAuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storage;
  final Uuid _uuid;

  RemoteAuthRepository({ApiClient? apiClient, SecureStorageService? storage})
    : _apiClient = apiClient ?? ApiClient(),
      _storage = storage ?? SecureStorageService(),
      _uuid = const Uuid();

  /// Register a new user
  Future<AuthResult<AuthResponse>> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final deviceId = await _getOrCreateDeviceId();

    final response = await _apiClient.post(
      ApiConfig.authRegister,
      body: {
        'email': email,
        'password': password,
        if (displayName != null) 'displayName': displayName,
        'deviceId': deviceId,
        'deviceName': await _getDeviceName(),
      },
      requiresAuth: false,
    );

    if (response.isSuccess && response.dataAsMap != null) {
      final authResponse = AuthResponse.fromJson(response.dataAsMap!);
      await _saveAuthData(authResponse);
      return AuthResult.success(authResponse);
    }

    return AuthResult.failure(response.error ?? 'Registration failed');
  }

  /// Login an existing user
  Future<AuthResult<AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    final deviceId = await _getOrCreateDeviceId();

    final response = await _apiClient.post(
      ApiConfig.authLogin,
      body: {
        'email': email,
        'password': password,
        'deviceId': deviceId,
        'deviceName': await _getDeviceName(),
      },
      requiresAuth: false,
    );

    if (response.isSuccess && response.dataAsMap != null) {
      final authResponse = AuthResponse.fromJson(response.dataAsMap!);
      await _saveAuthData(authResponse);
      return AuthResult.success(authResponse);
    }

    return AuthResult.failure(response.error ?? 'Login failed');
  }

  /// Refresh the access token
  Future<AuthResult<TokenRefreshResponse>> refreshToken() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) {
      return AuthResult.failure('No refresh token available');
    }

    final response = await _apiClient.post(
      ApiConfig.authRefresh,
      body: {'refreshToken': refreshToken},
      requiresAuth: false,
    );

    if (response.isSuccess && response.dataAsMap != null) {
      final tokenResponse = TokenRefreshResponse.fromJson(response.dataAsMap!);
      await _storage.setAccessToken(tokenResponse.accessToken);
      await _storage.setRefreshToken(tokenResponse.refreshToken);
      return AuthResult.success(tokenResponse);
    }

    // If refresh fails, clear auth data
    if (response.isAuthError) {
      await _storage.clearAll();
    }

    return AuthResult.failure(response.error ?? 'Token refresh failed');
  }

  /// Logout the current user
  Future<AuthResult<void>> logout() async {
    final response = await _apiClient.post(ApiConfig.authLogout);

    // Clear local data regardless of server response
    await _storage.clearAll();

    if (response.isSuccess) {
      return AuthResult.success(null);
    }

    // Still return success since local data is cleared
    return AuthResult.success(null);
  }

  /// Get the current user profile
  Future<AuthResult<AuthUser>> getCurrentUser() async {
    final response = await _apiClient.get(ApiConfig.authMe);

    if (response.isSuccess && response.dataAsMap != null) {
      return AuthResult.success(AuthUser.fromJson(response.dataAsMap!));
    }

    return AuthResult.failure(response.error ?? 'Failed to get user');
  }

  /// Update user profile
  Future<AuthResult<AuthUser>> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    final response = await _apiClient.patch(
      ApiConfig.authMe,
      body: {
        if (displayName != null) 'displayName': displayName,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      },
    );

    if (response.isSuccess && response.dataAsMap != null) {
      return AuthResult.success(AuthUser.fromJson(response.dataAsMap!));
    }

    return AuthResult.failure(response.error ?? 'Failed to update profile');
  }

  /// Delete user account
  Future<AuthResult<void>> deleteAccount() async {
    final response = await _apiClient.delete(ApiConfig.authMe);

    if (response.isSuccess) {
      await _storage.clearAll();
      return AuthResult.success(null);
    }

    return AuthResult.failure(response.error ?? 'Failed to delete account');
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await _storage.isLoggedIn();
  }

  /// Check server health
  Future<bool> checkServerHealth() async {
    final response = await _apiClient.get(
      ApiConfig.health,
      requiresAuth: false,
    );
    return response.isSuccess;
  }

  // Private helpers

  Future<String> _getOrCreateDeviceId() async {
    var deviceId = await _storage.getDeviceId();
    if (deviceId == null) {
      deviceId = _uuid.v4();
      await _storage.setDeviceId(deviceId);
    }
    return deviceId;
  }

  Future<String> _getDeviceName() async {
    // In a real app, get actual device name
    return 'Flutter App';
  }

  Future<void> _saveAuthData(AuthResponse response) async {
    await _storage.setAccessToken(response.accessToken);
    await _storage.setRefreshToken(response.refreshToken);
    await _storage.setUserId(response.user.id);
    if (response.deviceId != null) {
      await _storage.setDeviceId(response.deviceId!);
    }
  }
}
