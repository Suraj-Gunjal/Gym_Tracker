import 'package:drift/drift.dart';

/// Drift table for workouts.
///
/// Stores workout session data.
class Workouts extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Optional workout name
  TextColumn get name => text().nullable()();

  /// When the workout was started
  DateTimeColumn get startedAt => dateTime()();

  /// When the workout was completed (null if in progress)
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Optional notes
  TextColumn get notes => text().nullable()();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag (for sync)
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
