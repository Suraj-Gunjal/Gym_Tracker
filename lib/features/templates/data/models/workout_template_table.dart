import 'package:drift/drift.dart';

/// Drift table for workout templates.
///
/// Templates allow users to save and reuse workout routines.
class WorkoutTemplates extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Template name (e.g., "Push Day", "Full Body")
  TextColumn get name => text()();

  /// Optional description
  TextColumn get description => text().nullable()();

  /// Color for visual identification (hex string)
  TextColumn get color => text().withDefault(const Constant('#6366F1'))();

  /// Icon name for visual identification
  TextColumn get iconName => text().withDefault(const Constant('fitness_center'))();

  /// Estimated duration in minutes
  IntColumn get estimatedMinutes => integer().nullable()();

  /// Number of times this template was used
  IntColumn get usageCount => integer().withDefault(const Constant(0))();

  /// Last time this template was used
  DateTimeColumn get lastUsedAt => dateTime().nullable()();

  /// Sort order for custom ordering
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Whether this is a system/predefined template
  BoolColumn get isPredefined => boolean().withDefault(const Constant(false))();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime()();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag (for sync)
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for template exercises.
///
/// Links exercises to templates with order and default sets.
class TemplateExercises extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Reference to the template
  TextColumn get templateId => text().references(WorkoutTemplates, #id)();

  /// Reference to the exercise
  TextColumn get exerciseId => text()();

  /// Order of this exercise in the template
  IntColumn get sortOrder => integer()();

  /// Default number of sets
  IntColumn get defaultSets => integer().withDefault(const Constant(3))();

  /// Default reps (target)
  IntColumn get defaultReps => integer().nullable()();

  /// Default weight
  RealColumn get defaultWeight => real().nullable()();

  /// Default rest time in seconds
  IntColumn get defaultRestSeconds => integer().withDefault(const Constant(90))();

  /// Notes for this exercise in the template
  TextColumn get notes => text().nullable()();

  /// Superset group (exercises with same group are supersetted)
  IntColumn get supersetGroup => integer().nullable()();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag (for sync)
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
