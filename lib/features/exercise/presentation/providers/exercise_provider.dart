import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/exercise_repository_impl.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/muscle_group.dart';
import '../../domain/repositories/exercise_repository.dart';

/// Provider for ExerciseRepository
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ExerciseRepositoryImpl(db);
});

/// Provider for all exercises
final allExercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getAllExercises();
});

/// Provider for exercises filtered by muscle group
final exercisesByMuscleGroupProvider =
    FutureProvider.family<List<Exercise>, MuscleGroup?>((
      ref,
      muscleGroup,
    ) async {
      final repository = ref.watch(exerciseRepositoryProvider);
      return repository.getAllExercises(muscleGroup: muscleGroup);
    });

/// Provider for exercise search
final exerciseSearchProvider = FutureProvider.family<List<Exercise>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) {
    return ref.watch(allExercisesProvider).value ?? [];
  }
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.searchExercises(query);
});

/// Provider for a single exercise by ID
final exerciseByIdProvider = FutureProvider.family<Exercise?, String>((
  ref,
  id,
) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getExerciseById(id);
});

/// Provider for predefined exercises only
final predefinedExercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getPredefinedExercises();
});

/// Provider for custom (user-created) exercises only
final customExercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repository = ref.watch(exerciseRepositoryProvider);
  return repository.getCustomExercises();
});

/// State notifier for managing exercise CRUD operations
class ExerciseNotifier extends StateNotifier<AsyncValue<List<Exercise>>> {
  final ExerciseRepository _repository;
  final Ref _ref;

  ExerciseNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    state = const AsyncValue.loading();
    try {
      final exercises = await _repository.getAllExercises();
      state = AsyncValue.data(exercises);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await _loadExercises();
    // Invalidate dependent providers
    _ref.invalidate(allExercisesProvider);
    _ref.invalidate(predefinedExercisesProvider);
    _ref.invalidate(customExercisesProvider);
  }

  Future<void> addExercise(Exercise exercise) async {
    try {
      await _repository.saveExercise(exercise);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateExercise(Exercise exercise) async {
    try {
      await _repository.saveExercise(exercise);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await _repository.deleteExercise(id);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> seedPredefinedExercises() async {
    try {
      await _repository.seedPredefinedExercises();
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for ExerciseNotifier
final exerciseNotifierProvider =
    StateNotifierProvider<ExerciseNotifier, AsyncValue<List<Exercise>>>((ref) {
      final repository = ref.watch(exerciseRepositoryProvider);
      return ExerciseNotifier(repository, ref);
    });
