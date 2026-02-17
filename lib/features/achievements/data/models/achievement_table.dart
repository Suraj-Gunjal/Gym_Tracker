import 'package:drift/drift.dart';

/// Drift table for achievements/badges.
///
/// Stores available achievements and user progress.
class Achievements extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Achievement name
  TextColumn get name => text()();

  /// Description of how to earn it
  TextColumn get description => text()();

  /// Icon name
  TextColumn get iconName => text()();

  /// Color (hex string)
  TextColumn get color => text()();

  /// Category (workout, strength, consistency, etc.)
  TextColumn get category => text()();

  /// Tier (bronze, silver, gold, platinum)
  TextColumn get tier => text()();

  /// Requirement value (e.g., 100 for "100 workouts")
  IntColumn get requirementValue => integer()();

  /// Requirement type (workout_count, pr_count, streak_days, etc.)
  TextColumn get requirementType => text()();

  /// XP points awarded
  IntColumn get xpReward => integer().withDefault(const Constant(100))();

  /// Sort order
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Whether this is a system achievement
  BoolColumn get isPredefined => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for user achievement progress.
class UserAchievements extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Reference to achievement
  TextColumn get achievementId => text().references(Achievements, #id)();

  /// Current progress value
  IntColumn get currentProgress => integer().withDefault(const Constant(0))();

  /// Whether the achievement is unlocked
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();

  /// When the achievement was unlocked
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  /// Whether the user has seen/acknowledged this achievement
  BoolColumn get isSeen => boolean().withDefault(const Constant(false))();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for user stats (for achievements and gamification).
class UserStats extends Table {
  /// UUID primary key (single row per user)
  TextColumn get id => text()();

  /// Total workouts completed
  IntColumn get totalWorkouts => integer().withDefault(const Constant(0))();

  /// Total exercises performed
  IntColumn get totalExercises => integer().withDefault(const Constant(0))();

  /// Total sets completed
  IntColumn get totalSets => integer().withDefault(const Constant(0))();

  /// Total reps performed
  IntColumn get totalReps => integer().withDefault(const Constant(0))();

  /// Total weight lifted (kg)
  RealColumn get totalWeightLifted => real().withDefault(const Constant(0.0))();

  /// Total workout duration (minutes)
  IntColumn get totalMinutes => integer().withDefault(const Constant(0))();

  /// Current workout streak (consecutive days)
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();

  /// Longest workout streak
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();

  /// Total PRs achieved
  IntColumn get totalPRs => integer().withDefault(const Constant(0))();

  /// Total XP earned
  IntColumn get totalXP => integer().withDefault(const Constant(0))();

  /// Current level
  IntColumn get level => integer().withDefault(const Constant(1))();

  /// Last workout date (for streak calculation)
  DateTimeColumn get lastWorkoutAt => dateTime().nullable()();

  /// Last modification timestamp
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
