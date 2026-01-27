/// Application-wide configuration.
class AppConfig {
  AppConfig._();

  /// App name
  static const String appName = 'Gym Tracker';

  /// App version
  static const String version = '1.0.0';

  /// Build number
  static const int buildNumber = 1;

  /// Environment (from compile-time variable)
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Whether we're in development mode
  static bool get isDevelopment => environment == 'development';

  /// Whether we're in production mode
  static bool get isProduction => environment == 'production';

  /// Default weight unit
  static const String defaultWeightUnit = 'kg';

  /// Supported weight units
  static const List<String> weightUnits = ['kg', 'lbs'];

  /// Conversion factor from kg to lbs
  static const double kgToLbs = 2.20462;

  /// PR celebration duration
  static const Duration prCelebrationDuration = Duration(seconds: 3);

  /// Auto-save interval for active workouts
  static const Duration autoSaveInterval = Duration(seconds: 30);

  /// Sync retry attempts
  static const int syncRetryAttempts = 3;

  /// Sync retry delay
  static const Duration syncRetryDelay = Duration(seconds: 5);
}
