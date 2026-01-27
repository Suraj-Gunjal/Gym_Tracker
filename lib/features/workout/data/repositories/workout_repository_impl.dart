import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/exercise_set.dart' as domain;
import '../../domain/entities/workout.dart' as domain;
import '../../domain/entities/workout_exercise.dart' as domain;
import '../../domain/repositories/workout_repository.dart';
import '../models/workout_mapper.dart';

/// Implementation of WorkoutRepository using Drift database.
class WorkoutRepositoryImpl implements WorkoutRepository {
  final db.AppDatabase _db;
  static const _uuid = Uuid();

  WorkoutRepositoryImpl(this._db);

  @override
  Future<List<domain.Workout>> getAllWorkouts({
    DateTime? startDate,
    DateTime? endDate,
    bool includeDeleted = false,
  }) async {
    var query = _db.select(_db.workouts);

    if (!includeDeleted) {
      query = query..where((tbl) => tbl.deleted.equals(false));
    }

    if (startDate != null) {
      query = query
        ..where((tbl) => tbl.startedAt.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query = query
        ..where((tbl) => tbl.startedAt.isSmallerOrEqualValue(endDate));
    }

    query = query..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)]);

    final workouts = await query.get();

    // Load exercises and sets for each workout
    final result = <domain.Workout>[];
    for (final workout in workouts) {
      final exercises = await _getWorkoutExercises(workout.id);
      result.add(WorkoutMapper.workoutToDomain(workout, exercises: exercises));
    }

    return result;
  }

  @override
  Future<domain.Workout?> getWorkoutById(String id) async {
    final query = _db.select(_db.workouts)..where((tbl) => tbl.id.equals(id));

    final workout = await query.getSingleOrNull();
    if (workout == null) return null;

    final exercises = await _getWorkoutExercises(id);
    return WorkoutMapper.workoutToDomain(workout, exercises: exercises);
  }

  @override
  Future<domain.Workout?> getInProgressWorkout() async {
    final query = _db.select(_db.workouts)
      ..where((tbl) => tbl.completedAt.isNull())
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)])
      ..limit(1);

    final workout = await query.getSingleOrNull();
    if (workout == null) return null;

    final exercises = await _getWorkoutExercises(workout.id);
    return WorkoutMapper.workoutToDomain(workout, exercises: exercises);
  }

  @override
  Future<List<domain.Workout>> getRecentWorkouts(int limit) async {
    final query = _db.select(_db.workouts)
      ..where((tbl) => tbl.deleted.equals(false))
      ..where((tbl) => tbl.completedAt.isNotNull())
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)])
      ..limit(limit);

    final workouts = await query.get();

    final result = <domain.Workout>[];
    for (final workout in workouts) {
      final exercises = await _getWorkoutExercises(workout.id);
      result.add(WorkoutMapper.workoutToDomain(workout, exercises: exercises));
    }

    return result;
  }

  @override
  Future<void> saveWorkout(domain.Workout workout) async {
    await _db
        .into(_db.workouts)
        .insertOnConflictUpdate(WorkoutMapper.workoutToCompanion(workout));
  }

  @override
  Future<domain.Workout> startWorkout({String? name}) async {
    final now = DateTime.now();
    final workout = domain.Workout(
      id: _uuid.v4(),
      name: name,
      startedAt: now,
      updatedAt: now,
    );

    await saveWorkout(workout);
    return workout;
  }

  @override
  Future<void> completeWorkout(String workoutId) async {
    final now = DateTime.now();
    await (_db.update(
      _db.workouts,
    )..where((tbl) => tbl.id.equals(workoutId))).write(
      db.WorkoutsCompanion(completedAt: Value(now), updatedAt: Value(now)),
    );
  }

  @override
  Future<void> deleteWorkout(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.workouts)..where((tbl) => tbl.id.equals(id))).write(
      db.WorkoutsCompanion(deleted: const Value(true), updatedAt: Value(now)),
    );
  }

  @override
  Future<domain.WorkoutExercise> addExerciseToWorkout({
    required String workoutId,
    required String exerciseId,
  }) async {
    final now = DateTime.now();

    // Get current max order index
    final existingExercises =
        await (_db.select(_db.workoutExercises)
              ..where((tbl) => tbl.workoutId.equals(workoutId))
              ..where((tbl) => tbl.deleted.equals(false)))
            .get();

    final orderIndex = existingExercises.isEmpty
        ? 0
        : existingExercises
                  .map((e) => e.orderIndex)
                  .reduce((a, b) => a > b ? a : b) +
              1;

    final workoutExercise = domain.WorkoutExercise(
      id: _uuid.v4(),
      workoutId: workoutId,
      exerciseId: exerciseId,
      orderIndex: orderIndex,
      updatedAt: now,
    );

    await _db
        .into(_db.workoutExercises)
        .insert(WorkoutMapper.workoutExerciseToCompanion(workoutExercise));

    // Update workout's updatedAt
    await (_db.update(_db.workouts)..where((tbl) => tbl.id.equals(workoutId)))
        .write(db.WorkoutsCompanion(updatedAt: Value(now)));

    return workoutExercise;
  }

  @override
  Future<void> removeExerciseFromWorkout(String workoutExerciseId) async {
    final now = DateTime.now();
    await (_db.update(
      _db.workoutExercises,
    )..where((tbl) => tbl.id.equals(workoutExerciseId))).write(
      db.WorkoutExercisesCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<domain.ExerciseSet> addSetToExercise({
    required String workoutExerciseId,
    required int reps,
    required double weight,
  }) async {
    final now = DateTime.now();

    // Get current max set number
    final existingSets =
        await (_db.select(_db.exerciseSets)
              ..where((tbl) => tbl.workoutExerciseId.equals(workoutExerciseId))
              ..where((tbl) => tbl.deleted.equals(false)))
            .get();

    final setNumber = existingSets.isEmpty
        ? 1
        : existingSets.map((s) => s.setNumber).reduce((a, b) => a > b ? a : b) +
              1;

    final set = domain.ExerciseSet(
      id: _uuid.v4(),
      workoutExerciseId: workoutExerciseId,
      setNumber: setNumber,
      reps: reps,
      weight: weight,
      updatedAt: now,
    );

    await _db.into(_db.exerciseSets).insert(WorkoutMapper.setToCompanion(set));

    // Update workout exercise's updatedAt
    await (_db.update(_db.workoutExercises)
          ..where((tbl) => tbl.id.equals(workoutExerciseId)))
        .write(db.WorkoutExercisesCompanion(updatedAt: Value(now)));

    return set;
  }

  @override
  Future<void> updateSet(domain.ExerciseSet set) async {
    await _db
        .into(_db.exerciseSets)
        .insertOnConflictUpdate(WorkoutMapper.setToCompanion(set));
  }

  @override
  Future<void> deleteSet(String setId) async {
    final now = DateTime.now();
    await (_db.update(
      _db.exerciseSets,
    )..where((tbl) => tbl.id.equals(setId))).write(
      db.ExerciseSetsCompanion(
        deleted: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  @override
  Future<double?> getLastUsedWeight(String exerciseId) async {
    // Find the most recent set for this exercise
    final query = _db.selectOnly(_db.exerciseSets)
      ..join([
        innerJoin(
          _db.workoutExercises,
          _db.workoutExercises.id.equalsExp(_db.exerciseSets.workoutExerciseId),
        ),
      ])
      ..where(_db.workoutExercises.exerciseId.equals(exerciseId))
      ..where(_db.exerciseSets.deleted.equals(false))
      ..orderBy([OrderingTerm.desc(_db.exerciseSets.updatedAt)])
      ..limit(1)
      ..addColumns([_db.exerciseSets.weight]);

    final result = await query.getSingleOrNull();
    return result?.read(_db.exerciseSets.weight);
  }

  @override
  Future<List<domain.Workout>> getWorkoutsUpdatedAfter(
    DateTime timestamp,
  ) async {
    final query = _db.select(_db.workouts)
      ..where((tbl) => tbl.updatedAt.isBiggerThanValue(timestamp));

    final workouts = await query.get();
    return workouts.map((w) => WorkoutMapper.workoutToDomain(w)).toList();
  }

  @override
  Future<List<domain.WorkoutExercise>> getWorkoutExercisesUpdatedAfter(
    DateTime timestamp,
  ) async {
    final query = _db.select(_db.workoutExercises)
      ..where((tbl) => tbl.updatedAt.isBiggerThanValue(timestamp));

    final exercises = await query.get();
    return exercises
        .map((e) => WorkoutMapper.workoutExerciseToDomain(e))
        .toList();
  }

  @override
  Future<List<domain.ExerciseSet>> getSetsUpdatedAfter(
    DateTime timestamp,
  ) async {
    final query = _db.select(_db.exerciseSets)
      ..where((tbl) => tbl.updatedAt.isBiggerThanValue(timestamp));

    final sets = await query.get();
    return sets.map(WorkoutMapper.setToDomain).toList();
  }

  /// Helper method to get all exercises for a workout with their sets
  Future<List<domain.WorkoutExercise>> _getWorkoutExercises(
    String workoutId,
  ) async {
    final exerciseQuery = _db.select(_db.workoutExercises)
      ..where((tbl) => tbl.workoutId.equals(workoutId))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]);

    final exercises = await exerciseQuery.get();

    final result = <domain.WorkoutExercise>[];
    for (final exercise in exercises) {
      final sets = await _getSetsForExercise(exercise.id);
      result.add(WorkoutMapper.workoutExerciseToDomain(exercise, sets: sets));
    }

    return result;
  }

  /// Helper method to get all sets for a workout exercise
  Future<List<domain.ExerciseSet>> _getSetsForExercise(
    String workoutExerciseId,
  ) async {
    final setQuery = _db.select(_db.exerciseSets)
      ..where((tbl) => tbl.workoutExerciseId.equals(workoutExerciseId))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.setNumber)]);

    final sets = await setQuery.get();
    return sets.map(WorkoutMapper.setToDomain).toList();
  }
}
