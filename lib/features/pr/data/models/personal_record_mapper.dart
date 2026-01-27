import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/personal_record.dart' as domain;
import '../../domain/entities/pr_type.dart';

/// Mapper to convert between PersonalRecord domain entity and Drift data class.
class PersonalRecordMapper {
  /// Convert Drift data class to domain entity
  static domain.PersonalRecord toDomain(db.PersonalRecord data) {
    return domain.PersonalRecord(
      id: data.id,
      exerciseId: data.exerciseId,
      prType: PRType.values.firstWhere(
        (e) => e.name == data.prType,
        orElse: () => PRType.maxWeight,
      ),
      value: data.value,
      atWeight: data.atWeight,
      workoutId: data.workoutId,
      setId: data.setId,
      achievedAt: data.achievedAt,
      previousValue: data.previousValue,
      updatedAt: data.updatedAt,
      deleted: data.deleted,
    );
  }

  /// Convert domain entity to Drift companion for insert/update
  static db.PersonalRecordsCompanion toCompanion(domain.PersonalRecord entity) {
    return db.PersonalRecordsCompanion.insert(
      id: entity.id,
      exerciseId: entity.exerciseId,
      prType: entity.prType.name,
      value: entity.value,
      atWeight: Value(entity.atWeight),
      workoutId: entity.workoutId,
      setId: Value(entity.setId),
      achievedAt: entity.achievedAt,
      previousValue: Value(entity.previousValue),
      updatedAt: entity.updatedAt,
      deleted: Value(entity.deleted),
    );
  }
}
