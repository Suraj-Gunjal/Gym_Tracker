import 'package:drift/drift.dart';

/// Drift table for personal records.
///
/// Stores PR achievements for exercises.
class PersonalRecords extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Reference to exercise
  TextColumn get exerciseId => text()();

  /// PR type (maxWeight, maxReps, maxVolume)
  TextColumn get prType => text()();

  /// The record value
  RealColumn get value => real()();

  /// For max reps: weight at which reps were performed
  RealColumn get atWeight => real().nullable()();

  /// Reference to workout where PR was achieved
  TextColumn get workoutId => text()();

  /// Reference to specific set (optional)
  TextColumn get setId => text().nullable()();

  /// When the PR was achieved
  DateTimeColumn get achievedAt => dateTime()();

  /// Previous record value (for comparison)
  RealColumn get previousValue => real().nullable()();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag (for sync)
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
