import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout.dart';
import '../../domain/entities/workout_exercise.dart';

/// Abstract repository for Workout operations.
abstract class WorkoutRepository {
  /// Get all workouts (with optional date range filter)
  Future<List<Workout>> getAllWorkouts({
    DateTime? startDate,
    DateTime? endDate,
    bool includeDeleted = false,
  });

  /// Get a single workout by ID with all exercises and sets
  Future<Workout?> getWorkoutById(String id);

  /// Get the current in-progress workout (if any)
  Future<Workout?> getInProgressWorkout();

  /// Get recent workouts (last N workouts)
  Future<List<Workout>> getRecentWorkouts(int limit);

  /// Save a workout (insert or update)
  Future<void> saveWorkout(Workout workout);

  /// Start a new workout
  Future<Workout> startWorkout({String? name});

  /// Complete a workout
  Future<void> completeWorkout(String workoutId);

  /// Soft delete a workout
  Future<void> deleteWorkout(String id);

  /// Add an exercise to a workout
  Future<WorkoutExercise> addExerciseToWorkout({
    required String workoutId,
    required String exerciseId,
  });

  /// Remove an exercise from a workout
  Future<void> removeExerciseFromWorkout(String workoutExerciseId);

  /// Add a set to a workout exercise
  Future<ExerciseSet> addSetToExercise({
    required String workoutExerciseId,
    required int reps,
    required double weight,
  });

  /// Update a set
  Future<void> updateSet(ExerciseSet set);

  /// Delete a set
  Future<void> deleteSet(String setId);

  /// Get last used weight for an exercise
  Future<double?> getLastUsedWeight(String exerciseId);

  /// Get workouts updated after a timestamp (for sync)
  Future<List<Workout>> getWorkoutsUpdatedAfter(DateTime timestamp);

  /// Get workout exercises updated after a timestamp (for sync)
  Future<List<WorkoutExercise>> getWorkoutExercisesUpdatedAfter(
    DateTime timestamp,
  );

  /// Get sets updated after a timestamp (for sync)
  Future<List<ExerciseSet>> getSetsUpdatedAfter(DateTime timestamp);
}
