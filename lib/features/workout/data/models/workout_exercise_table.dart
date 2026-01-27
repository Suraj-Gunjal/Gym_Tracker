import 'package:drift/drift.dart';

/// Drift table for workout exercises.
///
/// Links workouts to exercises.
class WorkoutExercises extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Reference to parent workout
  TextColumn get workoutId => text()();

  /// Reference to exercise definition
  TextColumn get exerciseId => text()();

  /// Order within the workout
  IntColumn get orderIndex => integer()();

  /// Optional notes
  TextColumn get notes => text().nullable()();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag (for sync)
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
