import 'package:shared_preferences/shared_preferences.dart';

/// Service for securely storing sensitive data like tokens.
/// Uses SharedPreferences for simplicity (cross-platform).
/// For production, consider flutter_secure_storage for mobile.
class SecureStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _deviceIdKey = 'device_id';
  static const String _userIdKey = 'user_id';
  static const String _lastSyncKey = 'last_sync_at';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Access Token
  Future<String?> getAccessToken() async {
    final prefs = await _preferences;
    return prefs.getString(_accessTokenKey);
  }

  Future<void> setAccessToken(String token) async {
    final prefs = await _preferences;
    await prefs.setString(_accessTokenKey, token);
  }

  Future<void> deleteAccessToken() async {
    final prefs = await _preferences;
    await prefs.remove(_accessTokenKey);
  }

  // Refresh Token
  Future<String?> getRefreshToken() async {
    final prefs = await _preferences;
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    final prefs = await _preferences;
    await prefs.setString(_refreshTokenKey, token);
  }

  Future<void> deleteRefreshToken() async {
    final prefs = await _preferences;
    await prefs.remove(_refreshTokenKey);
  }

  // Device ID
  Future<String?> getDeviceId() async {
    final prefs = await _preferences;
    return prefs.getString(_deviceIdKey);
  }

  Future<void> setDeviceId(String deviceId) async {
    final prefs = await _preferences;
    await prefs.setString(_deviceIdKey, deviceId);
  }

  // User ID
  Future<String?> getUserId() async {
    final prefs = await _preferences;
    return prefs.getString(_userIdKey);
  }

  Future<void> setUserId(String userId) async {
    final prefs = await _preferences;
    await prefs.setString(_userIdKey, userId);
  }

  // Last Sync
  Future<DateTime?> getLastSyncAt() async {
    final prefs = await _preferences;
    final timestamp = prefs.getString(_lastSyncKey);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  Future<void> setLastSyncAt(DateTime dateTime) async {
    final prefs = await _preferences;
    await prefs.setString(_lastSyncKey, dateTime.toIso8601String());
  }

  // Clear all auth data
  Future<void> clearAll() async {
    final prefs = await _preferences;
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    // Keep device ID for re-login on same device
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
