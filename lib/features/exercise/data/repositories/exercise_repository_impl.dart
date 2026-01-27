import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/exercise.dart' as domain;
import '../../domain/entities/muscle_group.dart';
import '../../domain/repositories/exercise_repository.dart';
import '../models/exercise_mapper.dart';

/// Implementation of ExerciseRepository using Drift database.
class ExerciseRepositoryImpl implements ExerciseRepository {
  final db.AppDatabase _db;

  ExerciseRepositoryImpl(this._db);

  @override
  Future<List<domain.Exercise>> getAllExercises({
    MuscleGroup? muscleGroup,
    bool includeDeleted = false,
  }) async {
    var query = _db.select(_db.exercises);

    if (!includeDeleted) {
      query = query..where((tbl) => tbl.deleted.equals(false));
    }

    if (muscleGroup != null) {
      query = query..where((tbl) => tbl.muscleGroup.equals(muscleGroup.name));
    }

    query = query..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);

    final results = await query.get();
    return results.map(ExerciseMapper.toDomain).toList();
  }

  @override
  Future<domain.Exercise?> getExerciseById(String id) async {
    final query = _db.select(_db.exercises)..where((tbl) => tbl.id.equals(id));

    final result = await query.getSingleOrNull();
    return result != null ? ExerciseMapper.toDomain(result) : null;
  }

  @override
  Future<List<domain.Exercise>> getExercisesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final query = _db.select(_db.exercises)..where((tbl) => tbl.id.isIn(ids));

    final results = await query.get();
    return results.map(ExerciseMapper.toDomain).toList();
  }

  @override
  Future<List<domain.Exercise>> searchExercises(String query) async {
    final searchQuery = _db.select(_db.exercises)
      ..where((tbl) => tbl.name.lower().contains(query.toLowerCase()))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);

    final results = await searchQuery.get();
    return results.map(ExerciseMapper.toDomain).toList();
  }

  @override
  Future<void> saveExercise(domain.Exercise exercise) async {
    await _db
        .into(_db.exercises)
        .insertOnConflictUpdate(ExerciseMapper.toCompanion(exercise));
  }

  @override
  Future<void> deleteExercise(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.exercises)..where((tbl) => tbl.id.equals(id))).write(
      db.ExercisesCompanion(deleted: const Value(true), updatedAt: Value(now)),
    );
  }

  @override
  Future<List<domain.Exercise>> getPredefinedExercises() async {
    final query = _db.select(_db.exercises)
      ..where((tbl) => tbl.isPredefined.equals(true))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);

    final results = await query.get();
    return results.map(ExerciseMapper.toDomain).toList();
  }

  @override
  Future<List<domain.Exercise>> getCustomExercises() async {
    final query = _db.select(_db.exercises)
      ..where((tbl) => tbl.isPredefined.equals(false))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]);

    final results = await query.get();
    return results.map(ExerciseMapper.toDomain).toList();
  }

  @override
  Future<List<domain.Exercise>> getExercisesUpdatedAfter(
    DateTime timestamp,
  ) async {
    final query = _db.select(_db.exercises)
      ..where((tbl) => tbl.updatedAt.isBiggerThanValue(timestamp));

    final results = await query.get();
    return results.map(ExerciseMapper.toDomain).toList();
  }

  @override
  Future<void> seedPredefinedExercises() async {
    // Check if already seeded
    final existing = await getPredefinedExercises();
    if (existing.isNotEmpty) return;

    final now = DateTime.now();
    final exercises = _getPredefinedExerciseList(now);

    await _db.batch((batch) {
      for (final exercise in exercises) {
        batch.insert(_db.exercises, ExerciseMapper.toCompanion(exercise));
      }
    });
  }

  /// Returns a list of predefined exercises
  List<domain.Exercise> _getPredefinedExerciseList(DateTime now) {
    return [
      // Chest
      domain.Exercise(
        id: 'pre_bench_press',
        name: 'Bench Press',
        muscleGroup: MuscleGroup.chest,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_incline_bench',
        name: 'Incline Bench Press',
        muscleGroup: MuscleGroup.chest,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_decline_bench',
        name: 'Decline Bench Press',
        muscleGroup: MuscleGroup.chest,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_dumbbell_fly',
        name: 'Dumbbell Fly',
        muscleGroup: MuscleGroup.chest,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_cable_crossover',
        name: 'Cable Crossover',
        muscleGroup: MuscleGroup.chest,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_push_up',
        name: 'Push Up',
        muscleGroup: MuscleGroup.chest,
        isPredefined: true,
        updatedAt: now,
      ),

      // Back
      domain.Exercise(
        id: 'pre_deadlift',
        name: 'Deadlift',
        muscleGroup: MuscleGroup.back,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_barbell_row',
        name: 'Barbell Row',
        muscleGroup: MuscleGroup.back,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_pull_up',
        name: 'Pull Up',
        muscleGroup: MuscleGroup.back,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_lat_pulldown',
        name: 'Lat Pulldown',
        muscleGroup: MuscleGroup.lats,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_seated_row',
        name: 'Seated Cable Row',
        muscleGroup: MuscleGroup.back,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_tbar_row',
        name: 'T-Bar Row',
        muscleGroup: MuscleGroup.back,
        isPredefined: true,
        updatedAt: now,
      ),

      // Shoulders
      domain.Exercise(
        id: 'pre_overhead_press',
        name: 'Overhead Press',
        muscleGroup: MuscleGroup.shoulders,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_lateral_raise',
        name: 'Lateral Raise',
        muscleGroup: MuscleGroup.shoulders,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_front_raise',
        name: 'Front Raise',
        muscleGroup: MuscleGroup.shoulders,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_rear_delt_fly',
        name: 'Rear Delt Fly',
        muscleGroup: MuscleGroup.shoulders,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_face_pull',
        name: 'Face Pull',
        muscleGroup: MuscleGroup.shoulders,
        isPredefined: true,
        updatedAt: now,
      ),

      // Biceps
      domain.Exercise(
        id: 'pre_barbell_curl',
        name: 'Barbell Curl',
        muscleGroup: MuscleGroup.biceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_dumbbell_curl',
        name: 'Dumbbell Curl',
        muscleGroup: MuscleGroup.biceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_hammer_curl',
        name: 'Hammer Curl',
        muscleGroup: MuscleGroup.biceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_preacher_curl',
        name: 'Preacher Curl',
        muscleGroup: MuscleGroup.biceps,
        isPredefined: true,
        updatedAt: now,
      ),

      // Triceps
      domain.Exercise(
        id: 'pre_tricep_pushdown',
        name: 'Tricep Pushdown',
        muscleGroup: MuscleGroup.triceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_skull_crusher',
        name: 'Skull Crusher',
        muscleGroup: MuscleGroup.triceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_tricep_dip',
        name: 'Tricep Dip',
        muscleGroup: MuscleGroup.triceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_overhead_extension',
        name: 'Overhead Tricep Extension',
        muscleGroup: MuscleGroup.triceps,
        isPredefined: true,
        updatedAt: now,
      ),

      // Legs - Quadriceps
      domain.Exercise(
        id: 'pre_squat',
        name: 'Squat',
        muscleGroup: MuscleGroup.quadriceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_front_squat',
        name: 'Front Squat',
        muscleGroup: MuscleGroup.quadriceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_leg_press',
        name: 'Leg Press',
        muscleGroup: MuscleGroup.quadriceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_leg_extension',
        name: 'Leg Extension',
        muscleGroup: MuscleGroup.quadriceps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_lunge',
        name: 'Lunge',
        muscleGroup: MuscleGroup.quadriceps,
        isPredefined: true,
        updatedAt: now,
      ),

      // Legs - Hamstrings
      domain.Exercise(
        id: 'pre_romanian_deadlift',
        name: 'Romanian Deadlift',
        muscleGroup: MuscleGroup.hamstrings,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_leg_curl',
        name: 'Leg Curl',
        muscleGroup: MuscleGroup.hamstrings,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_good_morning',
        name: 'Good Morning',
        muscleGroup: MuscleGroup.hamstrings,
        isPredefined: true,
        updatedAt: now,
      ),

      // Legs - Glutes
      domain.Exercise(
        id: 'pre_hip_thrust',
        name: 'Hip Thrust',
        muscleGroup: MuscleGroup.glutes,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_glute_bridge',
        name: 'Glute Bridge',
        muscleGroup: MuscleGroup.glutes,
        isPredefined: true,
        updatedAt: now,
      ),

      // Calves
      domain.Exercise(
        id: 'pre_calf_raise',
        name: 'Standing Calf Raise',
        muscleGroup: MuscleGroup.calves,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_seated_calf_raise',
        name: 'Seated Calf Raise',
        muscleGroup: MuscleGroup.calves,
        isPredefined: true,
        updatedAt: now,
      ),

      // Abs
      domain.Exercise(
        id: 'pre_crunch',
        name: 'Crunch',
        muscleGroup: MuscleGroup.abs,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_plank',
        name: 'Plank',
        muscleGroup: MuscleGroup.abs,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_leg_raise',
        name: 'Hanging Leg Raise',
        muscleGroup: MuscleGroup.abs,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_cable_crunch',
        name: 'Cable Crunch',
        muscleGroup: MuscleGroup.abs,
        isPredefined: true,
        updatedAt: now,
      ),

      // Traps
      domain.Exercise(
        id: 'pre_shrug',
        name: 'Barbell Shrug',
        muscleGroup: MuscleGroup.traps,
        isPredefined: true,
        updatedAt: now,
      ),
      domain.Exercise(
        id: 'pre_dumbbell_shrug',
        name: 'Dumbbell Shrug',
        muscleGroup: MuscleGroup.traps,
        isPredefined: true,
        updatedAt: now,
      ),
    ];
  }
}
