import 'package:drift/drift.dart';

/// Drift table for body measurements.
///
/// Tracks user's body stats over time.
class BodyMeasurements extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// Date of the measurement
  DateTimeColumn get measuredAt => dateTime()();

  /// Body weight in kg
  RealColumn get weightKg => real().nullable()();

  /// Body fat percentage
  RealColumn get bodyFatPercent => real().nullable()();

  /// Muscle mass in kg
  RealColumn get muscleMassKg => real().nullable()();

  // Body part measurements in cm
  RealColumn get neckCm => real().nullable()();
  RealColumn get shouldersCm => real().nullable()();
  RealColumn get chestCm => real().nullable()();
  RealColumn get leftBicepCm => real().nullable()();
  RealColumn get rightBicepCm => real().nullable()();
  RealColumn get leftForearmCm => real().nullable()();
  RealColumn get rightForearmCm => real().nullable()();
  RealColumn get waistCm => real().nullable()();
  RealColumn get hipsCm => real().nullable()();
  RealColumn get leftThighCm => real().nullable()();
  RealColumn get rightThighCm => real().nullable()();
  RealColumn get leftCalfCm => real().nullable()();
  RealColumn get rightCalfCm => real().nullable()();

  /// Optional notes
  TextColumn get notes => text().nullable()();

  /// Optional photo path
  TextColumn get photoPath => text().nullable()();

  /// Last modification timestamp (for sync)
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag (for sync)
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
