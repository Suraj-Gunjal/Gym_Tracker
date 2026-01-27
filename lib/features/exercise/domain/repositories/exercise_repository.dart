import '../../domain/entities/exercise.dart';
import '../../domain/entities/muscle_group.dart';

/// Abstract repository for Exercise operations.
abstract class ExerciseRepository {
  /// Get all exercises (optionally filtered by muscle group)
  Future<List<Exercise>> getAllExercises({
    MuscleGroup? muscleGroup,
    bool includeDeleted = false,
  });

  /// Get a single exercise by ID
  Future<Exercise?> getExerciseById(String id);

  /// Get exercises by IDs
  Future<List<Exercise>> getExercisesByIds(List<String> ids);

  /// Search exercises by name
  Future<List<Exercise>> searchExercises(String query);

  /// Save an exercise (insert or update)
  Future<void> saveExercise(Exercise exercise);

  /// Soft delete an exercise
  Future<void> deleteExercise(String id);

  /// Get predefined exercises
  Future<List<Exercise>> getPredefinedExercises();

  /// Get custom exercises
  Future<List<Exercise>> getCustomExercises();

  /// Get exercises updated after a timestamp (for sync)
  Future<List<Exercise>> getExercisesUpdatedAfter(DateTime timestamp);

  /// Seed predefined exercises (called on first launch)
  Future<void> seedPredefinedExercises();
}
