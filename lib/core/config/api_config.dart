/// API configuration for the Gym Tracker backend.
class ApiConfig {
  /// Base URL for the API.
  /// Change this to your self-hosted backend URL in production.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// API endpoints
  static const String authRegister = '/api/auth/register';
  static const String authLogin = '/api/auth/login';
  static const String authRefresh = '/api/auth/refresh';
  static const String authLogout = '/api/auth/logout';
  static const String authMe = '/api/auth/me';

  static const String exercises = '/api/exercises';
  static const String workouts = '/api/workouts';
  static const String prs = '/api/prs';

  static const String syncPush = '/api/sync/push';
  static const String syncPull = '/api/sync/pull';
  static const String syncStatus = '/api/sync/status';

  static const String health = '/health';

  /// Request timeout duration
  static const Duration timeout = Duration(seconds: 30);

  /// Token refresh threshold (refresh when less than this time remaining)
  static const Duration refreshThreshold = Duration(minutes: 2);
}
