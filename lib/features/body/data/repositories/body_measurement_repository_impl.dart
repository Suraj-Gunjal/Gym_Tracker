import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/body_measurement.dart';

/// Repository for body measurements using Drift database.
class BodyMeasurementRepository {
  final db.AppDatabase _db;
  static const _uuid = Uuid();

  BodyMeasurementRepository(this._db);

  /// Get all body measurements ordered by date (newest first).
  Future<List<BodyMeasurement>> getAllMeasurements({
    bool includeDeleted = false,
  }) async {
    var query = _db.select(_db.bodyMeasurements);

    if (!includeDeleted) {
      query = query..where((tbl) => tbl.deleted.equals(false));
    }

    query = query..orderBy([(tbl) => OrderingTerm.desc(tbl.measuredAt)]);

    final rows = await query.get();
    return rows.map(_mapToEntity).toList();
  }

  /// Get a single measurement by ID.
  Future<BodyMeasurement?> getMeasurementById(String id) async {
    final query = _db.select(_db.bodyMeasurements)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _mapToEntity(row) : null;
  }

  /// Get the most recent measurement.
  Future<BodyMeasurement?> getLatestMeasurement() async {
    final query = _db.select(_db.bodyMeasurements)
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.measuredAt)])
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row != null ? _mapToEntity(row) : null;
  }

  /// Get measurements within a date range.
  Future<List<BodyMeasurement>> getMeasurementsInRange(
    DateTime start,
    DateTime end,
  ) async {
    final query = _db.select(_db.bodyMeasurements)
      ..where((tbl) => tbl.deleted.equals(false))
      ..where((tbl) => tbl.measuredAt.isBiggerOrEqualValue(start))
      ..where((tbl) => tbl.measuredAt.isSmallerOrEqualValue(end))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.measuredAt)]);

    final rows = await query.get();
    return rows.map(_mapToEntity).toList();
  }

  /// Save a new measurement.
  Future<BodyMeasurement> saveMeasurement(BodyMeasurement measurement) async {
    final id = measurement.id.isEmpty ? _uuid.v4() : measurement.id;
    final now = DateTime.now();

    final companion = db.BodyMeasurementsCompanion(
      id: Value(id),
      measuredAt: Value(measurement.measuredAt),
      weightKg: Value(measurement.weightKg),
      bodyFatPercent: Value(measurement.bodyFatPercent),
      muscleMassKg: Value(measurement.muscleMassKg),
      neckCm: Value(measurement.neckCm),
      shouldersCm: Value(measurement.shouldersCm),
      chestCm: Value(measurement.chestCm),
      leftBicepCm: Value(measurement.leftBicepCm),
      rightBicepCm: Value(measurement.rightBicepCm),
      leftForearmCm: Value(measurement.leftForearmCm),
      rightForearmCm: Value(measurement.rightForearmCm),
      waistCm: Value(measurement.waistCm),
      hipsCm: Value(measurement.hipsCm),
      leftThighCm: Value(measurement.leftThighCm),
      rightThighCm: Value(measurement.rightThighCm),
      leftCalfCm: Value(measurement.leftCalfCm),
      rightCalfCm: Value(measurement.rightCalfCm),
      notes: Value(measurement.notes),
      photoPath: Value(measurement.photoPath),
      updatedAt: Value(now),
      deleted: Value(measurement.deleted),
    );

    await _db.into(_db.bodyMeasurements).insertOnConflictUpdate(companion);

    return measurement.copyWith(id: id, updatedAt: now);
  }

  /// Delete a measurement (soft delete).
  Future<void> deleteMeasurement(String id) async {
    final now = DateTime.now();
    await (_db.update(
      _db.bodyMeasurements,
    )..where((tbl) => tbl.id.equals(id))).write(
      db.BodyMeasurementsCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  /// Map database row to domain entity.
  BodyMeasurement _mapToEntity(db.BodyMeasurement row) {
    return BodyMeasurement(
      id: row.id,
      measuredAt: row.measuredAt,
      weightKg: row.weightKg,
      bodyFatPercent: row.bodyFatPercent,
      muscleMassKg: row.muscleMassKg,
      neckCm: row.neckCm,
      shouldersCm: row.shouldersCm,
      chestCm: row.chestCm,
      leftBicepCm: row.leftBicepCm,
      rightBicepCm: row.rightBicepCm,
      leftForearmCm: row.leftForearmCm,
      rightForearmCm: row.rightForearmCm,
      waistCm: row.waistCm,
      hipsCm: row.hipsCm,
      leftThighCm: row.leftThighCm,
      rightThighCm: row.rightThighCm,
      leftCalfCm: row.leftCalfCm,
      rightCalfCm: row.rightCalfCm,
      notes: row.notes,
      photoPath: row.photoPath,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }
}
