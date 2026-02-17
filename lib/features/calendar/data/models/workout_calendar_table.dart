import 'package:drift/drift.dart';

/// Table for caching calendar data and workout summaries.
class WorkoutCalendarCache extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// User ID for multi-user support.
  TextColumn get userId => text().nullable()();

  /// Date of the workout (stored as date only).
  DateTimeColumn get date => dateTime()();

  /// Number of workouts on this day.
  IntColumn get workoutCount => integer().withDefault(const Constant(0))();

  /// Total duration in minutes.
  IntColumn get totalDurationMinutes =>
      integer().withDefault(const Constant(0))();

  /// Total sets completed.
  IntColumn get totalSets => integer().withDefault(const Constant(0))();

  /// Total volume (weight × reps).
  RealColumn get totalVolume => real().withDefault(const Constant(0.0))();

  /// Number of PRs achieved.
  IntColumn get prsAchieved => integer().withDefault(const Constant(0))();

  /// Intensity level (1-10 based on RPE or volume).
  IntColumn get intensityLevel => integer().withDefault(const Constant(5))();

  /// Primary muscle groups worked (comma-separated).
  TextColumn get muscleGroups => text().withDefault(const Constant(''))();

  /// Cache timestamps.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'workout_calendar_cache';
}

/// Table for workout streaks tracking.
class WorkoutStreaks extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// User ID.
  TextColumn get userId => text().nullable()();

  /// Current streak count.
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();

  /// Longest streak ever achieved.
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();

  /// Last workout date.
  DateTimeColumn get lastWorkoutDate => dateTime().nullable()();

  /// Streak start date.
  DateTimeColumn get streakStartDate => dateTime().nullable()();

  /// Weekly goal (workouts per week).
  IntColumn get weeklyGoal => integer().withDefault(const Constant(3))();

  /// Workouts this week.
  IntColumn get workoutsThisWeek => integer().withDefault(const Constant(0))();

  /// Week start date (for resetting weekly count).
  DateTimeColumn get weekStartDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'workout_streaks';
}
