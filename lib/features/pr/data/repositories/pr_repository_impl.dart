import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/personal_record.dart' as domain;
import '../../domain/entities/pr_type.dart';
import '../../domain/repositories/pr_repository.dart';
import '../models/personal_record_mapper.dart';

/// Implementation of PRRepository using Drift database.
class PRRepositoryImpl implements PRRepository {
  final AppDatabase _db;

  PRRepositoryImpl(this._db);

  @override
  Future<List<domain.PersonalRecord>> getPRsForExercise(
    String exerciseId,
  ) async {
    final query = _db.select(_db.personalRecords)
      ..where((tbl) => tbl.exerciseId.equals(exerciseId))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.achievedAt)]);

    final results = await query.get();
    return results.map(PersonalRecordMapper.toDomain).toList();
  }

  @override
  Future<Map<String, List<domain.PersonalRecord>>> getPRsForExercises(
    List<String> exerciseIds,
  ) async {
    if (exerciseIds.isEmpty) return {};

    final query = _db.select(_db.personalRecords)
      ..where((tbl) => tbl.exerciseId.isIn(exerciseIds))
      ..where((tbl) => tbl.deleted.equals(false));

    final results = await query.get();

    final Map<String, List<domain.PersonalRecord>> grouped = {};
    for (final result in results) {
      final pr = PersonalRecordMapper.toDomain(result);
      grouped.putIfAbsent(pr.exerciseId, () => []).add(pr);
    }
    return grouped;
  }

  @override
  Future<domain.PersonalRecord?> getCurrentPR(
    String exerciseId,
    PRType prType,
  ) async {
    final query = _db.select(_db.personalRecords)
      ..where((tbl) => tbl.exerciseId.equals(exerciseId))
      ..where((tbl) => tbl.prType.equals(prType.name))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.value)])
      ..limit(1);

    final result = await query.getSingleOrNull();
    return result != null ? PersonalRecordMapper.toDomain(result) : null;
  }

  @override
  Future<List<domain.PersonalRecord>> getAllPRs({
    bool includeDeleted = false,
  }) async {
    var query = _db.select(_db.personalRecords);
    if (!includeDeleted) {
      query = query..where((tbl) => tbl.deleted.equals(false));
    }
    query = query..orderBy([(tbl) => OrderingTerm.desc(tbl.achievedAt)]);

    final results = await query.get();
    return results.map(PersonalRecordMapper.toDomain).toList();
  }

  @override
  Future<void> savePR(domain.PersonalRecord pr) async {
    await _db
        .into(_db.personalRecords)
        .insertOnConflictUpdate(PersonalRecordMapper.toCompanion(pr));
  }

  @override
  Future<void> savePRs(List<domain.PersonalRecord> prs) async {
    await _db.batch((batch) {
      for (final pr in prs) {
        batch.insert(
          _db.personalRecords,
          PersonalRecordMapper.toCompanion(pr),
          onConflict: DoUpdate((_) => PersonalRecordMapper.toCompanion(pr)),
        );
      }
    });
  }

  @override
  Future<void> deletePR(String id) async {
    final now = DateTime.now();
    await (_db.update(
      _db.personalRecords,
    )..where((tbl) => tbl.id.equals(id))).write(
      PersonalRecordsCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<List<domain.PersonalRecord>> getPRsUpdatedAfter(
    DateTime timestamp,
  ) async {
    final query = _db.select(_db.personalRecords)
      ..where((tbl) => tbl.updatedAt.isBiggerThanValue(timestamp));

    final results = await query.get();
    return results.map(PersonalRecordMapper.toDomain).toList();
  }

  @override
  Future<List<domain.PersonalRecord>> getPRHistory(
    String exerciseId,
    PRType prType,
  ) async {
    final query = _db.select(_db.personalRecords)
      ..where((tbl) => tbl.exerciseId.equals(exerciseId))
      ..where((tbl) => tbl.prType.equals(prType.name))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.achievedAt)]);

    final results = await query.get();
    return results.map(PersonalRecordMapper.toDomain).toList();
  }
}
