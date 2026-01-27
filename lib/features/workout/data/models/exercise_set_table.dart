import 'package:drift/drift.dart';

/// Drift table for exercise sets.
///
/// Stores individual sets within workout exercises.
class ExerciseSets extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Reference to parent workout exercise
  TextColumn get workoutExerciseId => text()();

  /// Set number within the exercise (1, 2, 3...)
  IntColumn get setNumber => integer()();

  /// Number of reps performed
  IntColumn get reps => integer()();

  /// Weight used (in kg)
  RealColumn get weight => real()();

  /// Optional notes
  TextColumn get notes => text().nullable()();

  /// Whether this set was completed
  BoolColumn get completed => boolean().withDefault(const Constant(true))();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag (for sync)
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
