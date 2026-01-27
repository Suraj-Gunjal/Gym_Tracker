import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/exercise.dart' as domain;
import '../../domain/entities/muscle_group.dart';

/// Mapper to convert between Exercise domain entity and Drift data class.
class ExerciseMapper {
  /// Convert Drift data class to domain entity
  static domain.Exercise toDomain(db.Exercise data) {
    return domain.Exercise(
      id: data.id,
      name: data.name,
      muscleGroup: MuscleGroup.values.firstWhere(
        (e) => e.name == data.muscleGroup,
        orElse: () => MuscleGroup.other,
      ),
      description: data.description,
      isPredefined: data.isPredefined,
      updatedAt: data.updatedAt,
      deleted: data.deleted,
    );
  }

  /// Convert domain entity to Drift companion for insert/update
  static db.ExercisesCompanion toCompanion(domain.Exercise entity) {
    return db.ExercisesCompanion.insert(
      id: entity.id,
      name: entity.name,
      muscleGroup: entity.muscleGroup.name,
      description: Value(entity.description),
      isPredefined: Value(entity.isPredefined),
      updatedAt: entity.updatedAt,
      deleted: Value(entity.deleted),
    );
  }
}
