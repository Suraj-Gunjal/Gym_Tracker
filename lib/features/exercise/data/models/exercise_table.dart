import 'package:drift/drift.dart';

/// Drift table for exercises.
///
/// Stores exercise definitions (predefined + custom).
class Exercises extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Exercise name
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Muscle group (stored as enum name string)
  TextColumn get muscleGroup => text()();

  /// Optional description
  TextColumn get description => text().nullable()();

  /// Whether this is a predefined exercise
  BoolColumn get isPredefined => boolean().withDefault(const Constant(false))();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag (for sync)
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
