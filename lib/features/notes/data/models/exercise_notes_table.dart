import 'package:drift/drift.dart';

/// Table for storing exercise notes and custom tips.
class ExerciseNotes extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// Reference to the exercise.
  TextColumn get exerciseId => text()();

  /// User ID for personalized notes.
  TextColumn get userId => text().nullable()();

  /// User's personal notes about the exercise.
  TextColumn get personalNotes => text().withDefault(const Constant(''))();

  /// Cue words for form (e.g., "squeeze at top", "control descent").
  TextColumn get formCues =>
      text().withDefault(const Constant(''))(); // JSON array

  /// Common mistakes to avoid.
  TextColumn get commonMistakes =>
      text().withDefault(const Constant(''))(); // JSON array

  /// Equipment variations (e.g., "barbell", "dumbbell", "cable").
  TextColumn get variations =>
      text().withDefault(const Constant(''))(); // JSON array

  /// Video URL for form demonstration.
  TextColumn get videoUrl => text().nullable()();

  /// GIF URL for quick reference.
  TextColumn get gifUrl => text().nullable()();

  /// Target muscle focus tips.
  TextColumn get muscleFocusTips => text().withDefault(const Constant(''))();

  /// Breathing pattern instructions.
  TextColumn get breathingPattern => text().nullable()();

  /// Tempo recommendation (e.g., "3-1-2" = 3s eccentric, 1s pause, 2s concentric).
  TextColumn get tempoRecommendation => text().nullable()();

  /// Is this a favorite exercise?
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  /// Last used date.
  DateTimeColumn get lastUsedAt => dateTime().nullable()();

  /// Total times performed.
  IntColumn get timesPerformed => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'exercise_notes';
}

/// Table for workout challenges.
class WorkoutChallenges extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// Challenge name.
  TextColumn get name => text()();

  /// Challenge description.
  TextColumn get description => text()();

  /// Challenge type: 'volume', 'frequency', 'streak', 'strength', 'time'.
  TextColumn get challengeType => text()();

  /// Target value to achieve.
  RealColumn get targetValue => real()();

  /// Current progress value.
  RealColumn get currentValue => real().withDefault(const Constant(0.0))();

  /// Unit of measurement (e.g., 'kg', 'reps', 'days', 'workouts').
  TextColumn get unit => text()();

  /// Challenge duration in days.
  IntColumn get durationDays => integer()();

  /// Start date.
  DateTimeColumn get startDate => dateTime()();

  /// End date.
  DateTimeColumn get endDate => dateTime()();

  /// XP reward for completion.
  IntColumn get xpReward => integer().withDefault(const Constant(100))();

  /// Badge/Achievement ID to unlock.
  TextColumn get badgeId => text().nullable()();

  /// Is challenge active?
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Is challenge completed?
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  /// Challenge difficulty: 1-5.
  IntColumn get difficulty => integer().withDefault(const Constant(3))();

  /// Icon name for display.
  TextColumn get iconName =>
      text().withDefault(const Constant('fitness_center'))();

  /// Color for display (hex).
  TextColumn get color => text().withDefault(const Constant('#6366F1'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'workout_challenges';
}

/// Table for challenge leaderboard entries.
class ChallengeLeaderboard extends Table {
  /// Unique identifier.
  TextColumn get id => text()();

  /// Challenge ID.
  TextColumn get challengeId => text()();

  /// User ID.
  TextColumn get userId => text()();

  /// User display name.
  TextColumn get displayName => text()();

  /// User avatar URL.
  TextColumn get avatarUrl => text().nullable()();

  /// Score/progress value.
  RealColumn get score => real()();

  /// Rank position.
  IntColumn get rank => integer()();

  /// Completed at timestamp.
  DateTimeColumn get completedAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'challenge_leaderboard';
}
