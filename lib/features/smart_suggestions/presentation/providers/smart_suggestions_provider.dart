import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../data/services/workout_intelligence_service.dart';
import '../../domain/models/recommendation_models.dart';

/// Provider for the workout intelligence service.
final workoutIntelligenceProvider = Provider<WorkoutIntelligenceService>((ref) {
  return WorkoutIntelligenceService();
});

/// Provider for muscle recovery data.
final muscleRecoveryProvider = FutureProvider<List<MuscleRecoveryData>>((
  ref,
) async {
  final workouts = await ref.watch(allWorkoutsProvider.future);
  final exercises = await ref.watch(allExercisesProvider.future);
  final service = ref.watch(workoutIntelligenceProvider);

  return service.analyzeMuscleRecovery(workouts, exercises);
});

/// Provider for progressive overload suggestions.
final overloadSuggestionsProvider =
    FutureProvider.family<List<ProgressiveOverloadSuggestion>, TrainingGoal>((
      ref,
      goal,
    ) async {
      final workouts = await ref.watch(allWorkoutsProvider.future);
      final exercises = await ref.watch(allExercisesProvider.future);
      final service = ref.watch(workoutIntelligenceProvider);

      return service.generateOverloadSuggestions(workouts, exercises, goal);
    });

/// Provider for workout suggestions.
final workoutSuggestionProvider =
    FutureProvider.family<WorkoutSuggestion, TrainingGoal>((ref, goal) async {
      final muscleRecovery = await ref.watch(muscleRecoveryProvider.future);
      final exercises = await ref.watch(allExercisesProvider.future);
      final overloadSuggestions = await ref.watch(
        overloadSuggestionsProvider(goal).future,
      );
      final service = ref.watch(workoutIntelligenceProvider);

      return service.generateWorkoutSuggestion(
        muscleRecovery,
        exercises,
        overloadSuggestions,
        goal,
      );
    });

/// Provider for weekly training analysis.
final weeklyAnalysisProvider = FutureProvider<WeeklyAnalysis>((ref) async {
  final workouts = await ref.watch(allWorkoutsProvider.future);
  final exercises = await ref.watch(allExercisesProvider.future);
  final service = ref.watch(workoutIntelligenceProvider);

  return service.analyzeWeeklyTraining(workouts, exercises);
});

/// State for the smart suggestions screen.
class SmartSuggestionsState {
  final TrainingGoal selectedGoal;
  final bool isLoading;
  final String? error;

  const SmartSuggestionsState({
    this.selectedGoal = TrainingGoal.hypertrophy,
    this.isLoading = false,
    this.error,
  });

  SmartSuggestionsState copyWith({
    TrainingGoal? selectedGoal,
    bool? isLoading,
    String? error,
  }) {
    return SmartSuggestionsState(
      selectedGoal: selectedGoal ?? this.selectedGoal,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for smart suggestions screen state.
class SmartSuggestionsNotifier extends StateNotifier<SmartSuggestionsState> {
  SmartSuggestionsNotifier() : super(const SmartSuggestionsState());

  void setGoal(TrainingGoal goal) {
    state = state.copyWith(selectedGoal: goal);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }
}

/// Provider for screen state.
final smartSuggestionsStateProvider =
    StateNotifierProvider<SmartSuggestionsNotifier, SmartSuggestionsState>((
      ref,
    ) {
      return SmartSuggestionsNotifier();
    });
