import 'package:uuid/uuid.dart';

import '../../../workout/domain/entities/entities.dart';
import '../entities/entities.dart';

/// Service for detecting Personal Records (PRs).
///
/// Compares current performance against historical PRs
/// to detect new achievements in:
/// - Max weight lifted
/// - Max reps at same weight
/// - Max volume in a single workout for an exercise
class PRDetectionService {
  static const _uuid = Uuid();

  /// Detect PRs for a single set.
  ///
  /// Checks against existing PRs to see if this set establishes
  /// a new max weight or max reps record.
  ///
  /// [set] - The set just completed
  /// [exerciseId] - The exercise this set belongs to
  /// [workoutId] - The workout this set is part of
  /// [existingPRs] - Current PRs for this exercise
  static PRDetectionResult detectSetPRs({
    required ExerciseSet set,
    required String exerciseId,
    required String workoutId,
    required List<PersonalRecord> existingPRs,
  }) {
    final newPRs = <PersonalRecord>[];
    final now = DateTime.now();

    // Check for max weight PR
    final maxWeightPR = _detectMaxWeightPR(
      weight: set.weight,
      exerciseId: exerciseId,
      workoutId: workoutId,
      setId: set.id,
      existingPRs: existingPRs,
      now: now,
    );
    if (maxWeightPR != null) {
      newPRs.add(maxWeightPR);
    }

    // Check for max reps PR at this weight
    final maxRepsPR = _detectMaxRepsPR(
      reps: set.reps,
      weight: set.weight,
      exerciseId: exerciseId,
      workoutId: workoutId,
      setId: set.id,
      existingPRs: existingPRs,
      now: now,
    );
    if (maxRepsPR != null) {
      newPRs.add(maxRepsPR);
    }

    return PRDetectionResult(newPRs: newPRs);
  }

  /// Detect volume PR for an exercise within a workout.
  ///
  /// Call this after all sets for an exercise are complete.
  ///
  /// [workoutExercise] - The completed workout exercise with all sets
  /// [existingPRs] - Current PRs for this exercise
  static PRDetectionResult detectVolumePR({
    required WorkoutExercise workoutExercise,
    required List<PersonalRecord> existingPRs,
  }) {
    final totalVolume = workoutExercise.totalVolume;
    if (totalVolume <= 0) {
      return const PRDetectionResult.empty();
    }

    final now = DateTime.now();

    // Find existing max volume PR
    final existingMaxVolume = existingPRs
        .where((pr) => pr.prType == PRType.maxVolume && !pr.deleted)
        .fold<double>(0, (max, pr) => pr.value > max ? pr.value : max);

    // Check if new volume beats existing
    if (totalVolume > existingMaxVolume) {
      final newPR = PersonalRecord(
        id: _uuid.v4(),
        exerciseId: workoutExercise.exerciseId,
        prType: PRType.maxVolume,
        value: totalVolume,
        workoutId: workoutExercise.workoutId,
        achievedAt: now,
        previousValue: existingMaxVolume > 0 ? existingMaxVolume : null,
        updatedAt: now,
      );
      return PRDetectionResult(newPRs: [newPR]);
    }

    return const PRDetectionResult.empty();
  }

  /// Detect all PRs for a completed workout.
  ///
  /// Combines set-level PRs and volume PRs for all exercises.
  ///
  /// [workout] - The completed workout with all exercises and sets
  /// [existingPRsByExercise] - Map of exerciseId to existing PRs
  static PRDetectionResult detectWorkoutPRs({
    required Workout workout,
    required Map<String, List<PersonalRecord>> existingPRsByExercise,
  }) {
    final allNewPRs = <PersonalRecord>[];

    for (final workoutExercise in workout.exercises) {
      if (workoutExercise.deleted) continue;

      final existingPRs =
          existingPRsByExercise[workoutExercise.exerciseId] ?? [];

      // Check each set for weight/reps PRs
      for (final set in workoutExercise.sets) {
        if (set.deleted || !set.completed) continue;

        final setResult = detectSetPRs(
          set: set,
          exerciseId: workoutExercise.exerciseId,
          workoutId: workout.id,
          existingPRs: existingPRs,
        );
        allNewPRs.addAll(setResult.newPRs);
      }

      // Check for volume PR
      final volumeResult = detectVolumePR(
        workoutExercise: workoutExercise,
        existingPRs: existingPRs,
      );
      allNewPRs.addAll(volumeResult.newPRs);
    }

    return PRDetectionResult(newPRs: allNewPRs);
  }

  /// Detect max weight PR
  static PersonalRecord? _detectMaxWeightPR({
    required double weight,
    required String exerciseId,
    required String workoutId,
    required String setId,
    required List<PersonalRecord> existingPRs,
    required DateTime now,
  }) {
    if (weight <= 0) return null;

    // Find existing max weight PR
    final existingMaxWeight = existingPRs
        .where((pr) => pr.prType == PRType.maxWeight && !pr.deleted)
        .fold<double>(0, (max, pr) => pr.value > max ? pr.value : max);

    // Check if new weight beats existing
    if (weight > existingMaxWeight) {
      return PersonalRecord(
        id: _uuid.v4(),
        exerciseId: exerciseId,
        prType: PRType.maxWeight,
        value: weight,
        workoutId: workoutId,
        setId: setId,
        achievedAt: now,
        previousValue: existingMaxWeight > 0 ? existingMaxWeight : null,
        updatedAt: now,
      );
    }

    return null;
  }

  /// Detect max reps PR at a specific weight
  static PersonalRecord? _detectMaxRepsPR({
    required int reps,
    required double weight,
    required String exerciseId,
    required String workoutId,
    required String setId,
    required List<PersonalRecord> existingPRs,
    required DateTime now,
  }) {
    if (reps <= 0 || weight <= 0) return null;

    // Find existing max reps PR at same weight (with small tolerance)
    const weightTolerance = 0.5; // 0.5 kg tolerance
    final existingMaxReps = existingPRs
        .where(
          (pr) =>
              pr.prType == PRType.maxReps &&
              !pr.deleted &&
              pr.atWeight != null &&
              (pr.atWeight! - weight).abs() <= weightTolerance,
        )
        .fold<int>(
          0,
          (max, pr) => pr.value.toInt() > max ? pr.value.toInt() : max,
        );

    // Check if new reps beats existing at this weight
    if (reps > existingMaxReps) {
      return PersonalRecord(
        id: _uuid.v4(),
        exerciseId: exerciseId,
        prType: PRType.maxReps,
        value: reps.toDouble(),
        atWeight: weight,
        workoutId: workoutId,
        setId: setId,
        achievedAt: now,
        previousValue: existingMaxReps > 0 ? existingMaxReps.toDouble() : null,
        updatedAt: now,
      );
    }

    return null;
  }
}
