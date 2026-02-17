import 'package:drift/drift.dart';

/// Drift table for rest timer settings.
///
/// Stores user preferences for rest timer.
class RestTimerSettings extends Table {
  /// UUID primary key (single row per user)
  TextColumn get id => text()();

  /// Default rest time in seconds
  IntColumn get defaultRestSeconds =>
      integer().withDefault(const Constant(90))();

  /// Rest time for compound exercises (seconds)
  IntColumn get compoundRestSeconds =>
      integer().withDefault(const Constant(180))();

  /// Rest time for isolation exercises (seconds)
  IntColumn get isolationRestSeconds =>
      integer().withDefault(const Constant(60))();

  /// Whether to auto-start timer after logging a set
  BoolColumn get autoStartTimer =>
      boolean().withDefault(const Constant(true))();

  /// Whether to vibrate when timer completes
  BoolColumn get vibrateOnComplete =>
      boolean().withDefault(const Constant(true))();

  /// Whether to play sound when timer completes
  BoolColumn get soundOnComplete =>
      boolean().withDefault(const Constant(true))();

  /// Sound file name to play
  TextColumn get soundName => text().withDefault(const Constant('bell'))();

  /// Whether to show timer as notification
  BoolColumn get showNotification =>
      boolean().withDefault(const Constant(true))();

  /// Last modification timestamp
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for exercise-specific rest times.
class ExerciseRestTimes extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Reference to the exercise
  TextColumn get exerciseId => text()();

  /// Custom rest time in seconds
  IntColumn get restSeconds => integer()();

  /// Last modification timestamp
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
