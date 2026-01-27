import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/exercise_set.dart' as domain;
import '../../domain/entities/workout.dart' as domain;
import '../../domain/entities/workout_exercise.dart' as domain;

/// Mapper to convert between Workout domain entities and Drift data classes.
class WorkoutMapper {
  /// Convert Drift Workout data to domain entity
  static domain.Workout workoutToDomain(
    db.Workout data, {
    List<domain.WorkoutExercise> exercises = const [],
  }) {
    return domain.Workout(
      id: data.id,
      name: data.name,
      startedAt: data.startedAt,
      completedAt: data.completedAt,
      notes: data.notes,
      exercises: exercises,
      updatedAt: data.updatedAt,
      deleted: data.deleted,
    );
  }

  /// Convert Workout domain entity to Drift companion
  static db.WorkoutsCompanion workoutToCompanion(domain.Workout entity) {
    return db.WorkoutsCompanion.insert(
      id: entity.id,
      name: Value(entity.name),
      startedAt: entity.startedAt,
      completedAt: Value(entity.completedAt),
      notes: Value(entity.notes),
      updatedAt: entity.updatedAt,
      deleted: Value(entity.deleted),
    );
  }

  /// Convert Drift WorkoutExercise data to domain entity
  static domain.WorkoutExercise workoutExerciseToDomain(
    db.WorkoutExercise data, {
    List<domain.ExerciseSet> sets = const [],
  }) {
    return domain.WorkoutExercise(
      id: data.id,
      workoutId: data.workoutId,
      exerciseId: data.exerciseId,
      orderIndex: data.orderIndex,
      notes: data.notes,
      sets: sets,
      updatedAt: data.updatedAt,
      deleted: data.deleted,
    );
  }

  /// Convert WorkoutExercise domain entity to Drift companion
  static db.WorkoutExercisesCompanion workoutExerciseToCompanion(
    domain.WorkoutExercise entity,
  ) {
    return db.WorkoutExercisesCompanion.insert(
      id: entity.id,
      workoutId: entity.workoutId,
      exerciseId: entity.exerciseId,
      orderIndex: entity.orderIndex,
      notes: Value(entity.notes),
      updatedAt: entity.updatedAt,
      deleted: Value(entity.deleted),
    );
  }

  /// Convert Drift ExerciseSet data to domain entity
  static domain.ExerciseSet setToDomain(db.ExerciseSet data) {
    return domain.ExerciseSet(
      id: data.id,
      workoutExerciseId: data.workoutExerciseId,
      setNumber: data.setNumber,
      reps: data.reps,
      weight: data.weight,
      notes: data.notes,
      completed: data.completed,
      updatedAt: data.updatedAt,
      deleted: data.deleted,
    );
  }

  /// Convert ExerciseSet domain entity to Drift companion
  static db.ExerciseSetsCompanion setToCompanion(domain.ExerciseSet entity) {
    return db.ExerciseSetsCompanion.insert(
      id: entity.id,
      workoutExerciseId: entity.workoutExerciseId,
      setNumber: entity.setNumber,
      reps: entity.reps,
      weight: entity.weight,
      notes: Value(entity.notes),
      completed: Value(entity.completed),
      updatedAt: entity.updatedAt,
      deleted: Value(entity.deleted),
    );
  }
}
