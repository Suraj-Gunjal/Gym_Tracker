import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../../pr/domain/entities/pr_detection_result.dart';
import '../../../pr/domain/usecases/pr_detection_service.dart';
import '../../../pr/presentation/providers/pr_provider.dart';
import '../../data/repositories/workout_repository_impl.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout.dart';
import '../../domain/repositories/workout_repository.dart';

/// Provider for WorkoutRepository
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return WorkoutRepositoryImpl(db);
});

/// Provider for all completed workouts
final allWorkoutsProvider = FutureProvider<List<Workout>>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getAllWorkouts();
});

/// Provider for recent workouts
final recentWorkoutsProvider = FutureProvider.family<List<Workout>, int>((
  ref,
  limit,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getRecentWorkouts(limit);
});

/// Provider for the current in-progress workout
final inProgressWorkoutProvider = FutureProvider<Workout?>((ref) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getInProgressWorkout();
});

/// Provider for a single workout by ID
final workoutByIdProvider = FutureProvider.family<Workout?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getWorkoutById(id);
});

/// Provider for last used weight for an exercise
final lastUsedWeightProvider = FutureProvider.family<double?, String>((
  ref,
  exerciseId,
) async {
  final repository = ref.watch(workoutRepositoryProvider);
  return repository.getLastUsedWeight(exerciseId);
});

/// State class for the active workout
class ActiveWorkoutState {
  final Workout? workout;
  final bool isLoading;
  final String? errorMessage;
  final PRDetectionResult? lastPRResult;

  const ActiveWorkoutState({
    this.workout,
    this.isLoading = false,
    this.errorMessage,
    this.lastPRResult,
  });

  ActiveWorkoutState copyWith({
    Workout? workout,
    bool? isLoading,
    String? errorMessage,
    PRDetectionResult? lastPRResult,
  }) {
    return ActiveWorkoutState(
      workout: workout ?? this.workout,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lastPRResult: lastPRResult,
    );
  }
}

/// State notifier for managing the active workout session
class ActiveWorkoutNotifier extends StateNotifier<ActiveWorkoutState> {
  final WorkoutRepository _workoutRepository;
  final Ref _ref;

  ActiveWorkoutNotifier(this._workoutRepository, this._ref)
    : super(const ActiveWorkoutState()) {
    _loadInProgressWorkout();
  }

  Future<void> _loadInProgressWorkout() async {
    state = state.copyWith(isLoading: true);
    try {
      final workout = await _workoutRepository.getInProgressWorkout();
      state = ActiveWorkoutState(workout: workout);
    } catch (e) {
      state = ActiveWorkoutState(errorMessage: e.toString());
    }
  }

  Future<void> startWorkout({String? name}) async {
    state = state.copyWith(isLoading: true);
    try {
      final workout = await _workoutRepository.startWorkout(name: name);
      state = ActiveWorkoutState(workout: workout);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Start a workout from a template, adding all template exercises
  Future<void> startWorkoutFromTemplate({
    required String templateName,
    required List<String> exerciseIds,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      // Create the workout
      final workout = await _workoutRepository.startWorkout(name: templateName);
      state = ActiveWorkoutState(workout: workout);

      // Add all exercises from the template
      for (final exerciseId in exerciseIds) {
        await addExercise(exerciseId);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> completeWorkout() async {
    if (state.workout == null) return;

    state = state.copyWith(isLoading: true);
    try {
      await _workoutRepository.completeWorkout(state.workout!.id);

      // Detect PRs for the completed workout
      final prRepository = _ref.read(prRepositoryProvider);
      final exerciseIds = state.workout!.exercises
          .map((e) => e.exerciseId)
          .toList();
      final existingPRs = await prRepository.getPRsForExercises(exerciseIds);

      final prResult = PRDetectionService.detectWorkoutPRs(
        workout: state.workout!,
        existingPRsByExercise: existingPRs,
      );

      // Save new PRs
      if (prResult.hasPR) {
        await prRepository.savePRs(prResult.newPRs);
      }

      state = ActiveWorkoutState(lastPRResult: prResult);

      // Invalidate related providers
      _ref.invalidate(allWorkoutsProvider);
      _ref.invalidate(recentWorkoutsProvider);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> cancelWorkout() async {
    if (state.workout == null) return;

    state = state.copyWith(isLoading: true);
    try {
      await _workoutRepository.deleteWorkout(state.workout!.id);
      state = const ActiveWorkoutState();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> addExercise(String exerciseId) async {
    if (state.workout == null) return;

    try {
      final workoutExercise = await _workoutRepository.addExerciseToWorkout(
        workoutId: state.workout!.id,
        exerciseId: exerciseId,
      );

      final updatedExercises = [...state.workout!.exercises, workoutExercise];
      final updatedWorkout = state.workout!.copyWith(
        exercises: updatedExercises,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(workout: updatedWorkout);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> removeExercise(String workoutExerciseId) async {
    if (state.workout == null) return;

    try {
      await _workoutRepository.removeExerciseFromWorkout(workoutExerciseId);

      final updatedExercises = state.workout!.exercises
          .where((e) => e.id != workoutExerciseId)
          .toList();
      final updatedWorkout = state.workout!.copyWith(
        exercises: updatedExercises,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(workout: updatedWorkout);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<PRDetectionResult> addSet({
    required String workoutExerciseId,
    required int reps,
    required double weight,
  }) async {
    if (state.workout == null) return const PRDetectionResult.empty();

    try {
      final newSet = await _workoutRepository.addSetToExercise(
        workoutExerciseId: workoutExerciseId,
        reps: reps,
        weight: weight,
      );

      // Update state
      final exerciseIndex = state.workout!.exercises.indexWhere(
        (e) => e.id == workoutExerciseId,
      );

      if (exerciseIndex != -1) {
        final exercise = state.workout!.exercises[exerciseIndex];
        final updatedSets = [...exercise.sets, newSet];
        final updatedExercise = exercise.copyWith(
          sets: updatedSets,
          updatedAt: DateTime.now(),
        );

        final updatedExercises = [...state.workout!.exercises];
        updatedExercises[exerciseIndex] = updatedExercise;

        final updatedWorkout = state.workout!.copyWith(
          exercises: updatedExercises,
          updatedAt: DateTime.now(),
        );

        // Check for PRs on this set
        final prRepository = _ref.read(prRepositoryProvider);
        final existingPRs = await prRepository.getPRsForExercise(
          exercise.exerciseId,
        );

        final prResult = PRDetectionService.detectSetPRs(
          set: newSet,
          exerciseId: exercise.exerciseId,
          workoutId: state.workout!.id,
          existingPRs: existingPRs,
        );

        // Save new PRs
        if (prResult.hasPR) {
          await prRepository.savePRs(prResult.newPRs);
        }

        state = state.copyWith(workout: updatedWorkout, lastPRResult: prResult);
        return prResult;
      }
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }

    return const PRDetectionResult.empty();
  }

  Future<void> updateSet(ExerciseSet set) async {
    if (state.workout == null) return;

    try {
      final updatedSet = set.copyWith(updatedAt: DateTime.now());
      await _workoutRepository.updateSet(updatedSet);

      // Update state
      final updatedExercises = state.workout!.exercises.map((exercise) {
        if (exercise.id == set.workoutExerciseId) {
          final updatedSets = exercise.sets.map((s) {
            return s.id == set.id ? updatedSet : s;
          }).toList();
          return exercise.copyWith(
            sets: updatedSets,
            updatedAt: DateTime.now(),
          );
        }
        return exercise;
      }).toList();

      final updatedWorkout = state.workout!.copyWith(
        exercises: updatedExercises,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(workout: updatedWorkout);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> deleteSet(String setId, String workoutExerciseId) async {
    if (state.workout == null) return;

    try {
      await _workoutRepository.deleteSet(setId);

      // Update state
      final updatedExercises = state.workout!.exercises.map((exercise) {
        if (exercise.id == workoutExerciseId) {
          final updatedSets = exercise.sets
              .where((s) => s.id != setId)
              .toList();
          return exercise.copyWith(
            sets: updatedSets,
            updatedAt: DateTime.now(),
          );
        }
        return exercise;
      }).toList();

      final updatedWorkout = state.workout!.copyWith(
        exercises: updatedExercises,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(workout: updatedWorkout);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  void clearPRResult() {
    state = state.copyWith(lastPRResult: null);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Provider for ActiveWorkoutNotifier
final activeWorkoutProvider =
    StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>((ref) {
      final repository = ref.watch(workoutRepositoryProvider);
      return ActiveWorkoutNotifier(repository, ref);
    });
