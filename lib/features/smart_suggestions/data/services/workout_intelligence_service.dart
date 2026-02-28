import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/entities/muscle_group.dart' as exercise_mg;
import '../../../workout/domain/entities/workout.dart';
import '../../../recovery/presentation/screens/muscle_heatmap_screen.dart';
import '../../domain/models/recommendation_models.dart';

/// Service that analyzes workout history and generates intelligent recommendations.
class WorkoutIntelligenceService {
  /// Analyze muscle recovery based on workout history.
  List<MuscleRecoveryData> analyzeMuscleRecovery(
    List<Workout> workouts,
    List<Exercise> exercises,
  ) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Track muscle data
    final muscleData = <MuscleGroup, _MuscleTracker>{};
    for (final muscle in MuscleGroup.values) {
      muscleData[muscle] = _MuscleTracker();
    }

    // Process recent workouts
    final recentWorkouts = workouts
        .where(
          (w) => w.completedAt != null && w.completedAt!.isAfter(sevenDaysAgo),
        )
        .toList();

    for (final workout in recentWorkouts) {
      for (final we in workout.exercises.where((e) => !e.deleted)) {
        final exercise = exercises.firstWhere(
          (e) => e.id == we.exerciseId,
          orElse: () => Exercise(
            id: we.exerciseId,
            name: 'Unknown',
            muscleGroup: exercise_mg.MuscleGroup.chest,
            updatedAt: now,
          ),
        );

        // Get muscle activation for this exercise
        final activations = _getMuscleActivations(exercise.name);
        final workoutDate = workout.completedAt ?? workout.startedAt;
        final setCount = we.sets.where((s) => s.completed).length;
        final volume = we.totalVolume;

        for (final entry in activations.entries) {
          final tracker = muscleData[entry.key]!;
          tracker.addWorkout(
            date: workoutDate,
            sets: (setCount * entry.value).round(),
            volume: volume * entry.value,
            intensity: entry.value,
          );
        }
      }
    }

    // Calculate recovery scores
    return muscleData.entries.map((entry) {
      final tracker = entry.value;
      final hoursSince = tracker.lastWorked != null
          ? now.difference(tracker.lastWorked!).inHours
          : 999;

      return MuscleRecoveryData(
        muscle: entry.key,
        recoveryScore: tracker.calculateRecovery(hoursSince),
        lastWorked: tracker.lastWorked,
        hoursSinceLastWorkout: hoursSince,
        totalSetsLast7Days: tracker.totalSets,
        volumeLast7Days: tracker.totalVolume,
      );
    }).toList()..sort((a, b) => b.recoveryScore.compareTo(a.recoveryScore));
  }

  /// Generate progressive overload suggestions for exercises.
  List<ProgressiveOverloadSuggestion> generateOverloadSuggestions(
    List<Workout> workouts,
    List<Exercise> exercises,
    TrainingGoal goal,
  ) {
    final suggestions = <ProgressiveOverloadSuggestion>[];
    final now = DateTime.now();
    final fourWeeksAgo = now.subtract(const Duration(days: 28));

    // Group workouts by exercise
    final exerciseHistory = <String, List<_ExerciseSession>>{};

    for (final workout in workouts.where(
      (w) => w.completedAt != null && w.completedAt!.isAfter(fourWeeksAgo),
    )) {
      for (final we in workout.exercises.where((e) => !e.deleted)) {
        exerciseHistory.putIfAbsent(we.exerciseId, () => []);

        if (we.sets.isNotEmpty) {
          exerciseHistory[we.exerciseId]!.add(
            _ExerciseSession(
              date: workout.completedAt ?? workout.startedAt,
              maxWeight: we.maxWeight,
              totalReps: we.totalReps,
              totalSets: we.sets.where((s) => s.completed).length,
              volume: we.totalVolume,
            ),
          );
        }
      }
    }

    // Analyze each exercise
    for (final entry in exerciseHistory.entries) {
      final exercise = exercises.firstWhere(
        (e) => e.id == entry.key,
        orElse: () => Exercise(
          id: entry.key,
          name: 'Unknown Exercise',
          muscleGroup: exercise_mg.MuscleGroup.chest,
          updatedAt: now,
        ),
      );

      final sessions = entry.value..sort((a, b) => a.date.compareTo(b.date));
      if (sessions.length < 2) continue;

      final suggestion = _analyzeProgression(exercise, sessions, goal);
      if (suggestion != null) {
        suggestions.add(suggestion);
      }
    }

    // Sort by confidence
    suggestions.sort((a, b) => b.confidence.compareTo(a.confidence));
    return suggestions;
  }

  /// Generate a workout suggestion based on recovery and goals.
  WorkoutSuggestion generateWorkoutSuggestion(
    List<MuscleRecoveryData> muscleRecovery,
    List<Exercise> exercises,
    List<ProgressiveOverloadSuggestion> overloadSuggestions,
    TrainingGoal goal, {
    int maxExercises = 6,
    List<MuscleGroup>? preferredMuscles,
  }) {
    // Find recovered muscles to train
    final trainableMuscles = muscleRecovery
        .where((m) => m.isFullyRecovered)
        .map((m) => m.muscle)
        .toList();

    // If preferred muscles specified, prioritize those
    List<MuscleGroup> targetMuscles;
    if (preferredMuscles != null && preferredMuscles.isNotEmpty) {
      targetMuscles = preferredMuscles
          .where((m) => trainableMuscles.contains(m))
          .toList();
      if (targetMuscles.isEmpty) {
        targetMuscles = trainableMuscles.take(3).toList();
      }
    } else {
      // Auto-select based on category balance
      targetMuscles = _selectBalancedMuscles(muscleRecovery, 3);
    }

    // Find exercises for target muscles
    final recommendations = <ExerciseRecommendation>[];

    for (final muscle in targetMuscles) {
      final muscleExercises = exercises.where((e) {
        final activations = _getMuscleActivations(e.name);
        return activations.containsKey(muscle) && activations[muscle]! >= 0.6;
      }).toList();

      for (final exercise in muscleExercises.take(2)) {
        final overload = overloadSuggestions.firstWhere(
          (s) => s.exercise.id == exercise.id,
          orElse: () => ProgressiveOverloadSuggestion(
            exercise: exercise,
            currentWeight: 0,
            suggestedWeight: 0,
            currentReps: goal.maxReps,
            suggestedReps: goal.maxReps,
            reason: 'Start with comfortable weight',
            type: OverloadType.maintain,
            confidence: 0.5,
          ),
        );

        final recoveryData = muscleRecovery.firstWhere(
          (m) => m.muscle == muscle,
          orElse: () => MuscleRecoveryData(
            muscle: muscle,
            recoveryScore: 1.0,
            hoursSinceLastWorkout: 72,
            totalSetsLast7Days: 0,
            volumeLast7Days: 0,
          ),
        );

        recommendations.add(
          ExerciseRecommendation(
            exercise: exercise,
            recoveryScore: recoveryData.recoveryScore,
            recoveryStatus: recoveryData.status,
            reason: overload.reason,
            suggestedSets: 3,
            suggestedReps: (goal.minReps + goal.maxReps) ~/ 2,
            suggestedWeight: overload.suggestedWeight > 0
                ? overload.suggestedWeight
                : overload.currentWeight,
            isPriority: overload.type == OverloadType.weight,
          ),
        );
      }
    }

    // Limit exercises
    final finalExercises = recommendations.take(maxExercises).toList();

    // Calculate overall readiness
    final avgRecovery = targetMuscles.isEmpty
        ? 1.0
        : muscleRecovery
                  .where((m) => targetMuscles.contains(m.muscle))
                  .map((m) => m.recoveryScore)
                  .fold(0.0, (a, b) => a + b) /
              targetMuscles.length;

    // Determine workout name
    final workoutName = _generateWorkoutName(targetMuscles);

    return WorkoutSuggestion(
      name: workoutName,
      description: 'AI-suggested workout based on your recovery and progress',
      goal: goal,
      exercises: finalExercises,
      estimatedDuration: Duration(minutes: 5 + (finalExercises.length * 10)),
      targetMuscles: targetMuscles,
      overallReadiness: avgRecovery,
    );
  }

  /// Analyze weekly training balance.
  WeeklyAnalysis analyzeWeeklyTraining(
    List<Workout> workouts,
    List<Exercise> exercises,
  ) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    final weekWorkouts = workouts
        .where((w) => w.completedAt != null && w.completedAt!.isAfter(weekAgo))
        .toList();

    final muscleFreq = <MuscleGroup, int>{};
    final muscleVol = <MuscleGroup, double>{};

    for (final muscle in MuscleGroup.values) {
      muscleFreq[muscle] = 0;
      muscleVol[muscle] = 0.0;
    }

    int totalSets = 0;
    double totalVolume = 0;

    for (final workout in weekWorkouts) {
      for (final we in workout.exercises.where((e) => !e.deleted)) {
        final exercise = exercises.firstWhere(
          (e) => e.id == we.exerciseId,
          orElse: () => Exercise(
            id: we.exerciseId,
            name: 'Unknown',
            muscleGroup: exercise_mg.MuscleGroup.chest,
            updatedAt: now,
          ),
        );

        final activations = _getMuscleActivations(exercise.name);
        final sets = we.sets.where((s) => s.completed).length;
        final volume = we.totalVolume;

        totalSets += sets;
        totalVolume += volume;

        for (final entry in activations.entries) {
          muscleFreq[entry.key] = (muscleFreq[entry.key] ?? 0) + 1;
          muscleVol[entry.key] =
              (muscleVol[entry.key] ?? 0) + (volume * entry.value);
        }
      }
    }

    // Find neglected and overtrained muscles
    final avgFreq = muscleFreq.values.isEmpty
        ? 0
        : muscleFreq.values.reduce((a, b) => a + b) / muscleFreq.length;

    final neglected = muscleFreq.entries
        .where((e) => e.value < avgFreq * 0.5)
        .map((e) => e.key)
        .toList();

    final overtrained = muscleFreq.entries
        .where((e) => e.value > avgFreq * 2)
        .map((e) => e.key)
        .toList();

    // Calculate balance score
    final variance = _calculateVariance(muscleFreq.values.toList());
    final balanceScore = (1 - (variance / 10)).clamp(0.0, 1.0);

    return WeeklyAnalysis(
      totalWorkouts: weekWorkouts.length,
      totalSets: totalSets,
      totalVolume: totalVolume,
      muscleFrequency: muscleFreq,
      muscleVolume: muscleVol,
      neglectedMuscles: neglected,
      overtrainedMuscles: overtrained,
      balanceScore: balanceScore,
    );
  }

  // === Private Helpers ===

  Map<MuscleGroup, double> _getMuscleActivations(String exerciseName) {
    final normalizedName = exerciseName.toLowerCase().trim();

    // Check exact match first
    if (ExerciseMuscleMapping.exerciseToMuscles.containsKey(normalizedName)) {
      return ExerciseMuscleMapping.exerciseToMuscles[normalizedName]!;
    }

    // Check partial matches
    for (final entry in ExerciseMuscleMapping.exerciseToMuscles.entries) {
      if (normalizedName.contains(entry.key) ||
          entry.key.contains(normalizedName)) {
        return entry.value;
      }
    }

    // Default: assume compound movement
    return {MuscleGroup.chest: 0.5};
  }

  List<MuscleGroup> _selectBalancedMuscles(
    List<MuscleRecoveryData> recovery,
    int count,
  ) {
    // Group by category
    final byCategory = <MuscleCategory, List<MuscleRecoveryData>>{};
    for (final data in recovery) {
      byCategory.putIfAbsent(data.muscle.category, () => []).add(data);
    }

    // Select one from each category that's most recovered
    final selected = <MuscleGroup>[];
    for (final category in MuscleCategory.values) {
      final categoryMuscles = byCategory[category] ?? [];
      final recovered = categoryMuscles
          .where((m) => m.isFullyRecovered)
          .toList();
      if (recovered.isNotEmpty) {
        selected.add(recovered.first.muscle);
      }
    }

    return selected.take(count).toList();
  }

  ProgressiveOverloadSuggestion? _analyzeProgression(
    Exercise exercise,
    List<_ExerciseSession> sessions,
    TrainingGoal goal,
  ) {
    if (sessions.length < 2) return null;

    final recent = sessions.last;
    final previous = sessions[sessions.length - 2];

    // Calculate trend
    final weightTrend = recent.maxWeight - previous.maxWeight;
    final repsTrend = recent.totalReps - previous.totalReps;

    // Estimate 1RM
    final avgRepsPerSet = recent.totalSets > 0
        ? recent.totalReps / recent.totalSets
        : goal.maxReps;
    // Calculate 1RM for potential future use
    final _ = calculate1RM(recent.maxWeight, avgRepsPerSet.round());

    // Determine progression type
    OverloadType type;
    double suggestedWeight;
    int suggestedReps;
    String reason;
    double confidence;

    if (weightTrend > 0) {
      // Already progressing weight - maintain
      type = OverloadType.maintain;
      suggestedWeight = recent.maxWeight;
      suggestedReps = avgRepsPerSet.round();
      reason = 'Great progress! Keep this weight';
      confidence = 0.9;
    } else if (repsTrend >= 2) {
      // Rep increase - suggest weight increase
      type = OverloadType.weight;
      suggestedWeight =
          recent.maxWeight + _getWeightIncrement(recent.maxWeight);
      suggestedReps = goal.minReps;
      reason = 'Strong rep gains! Add weight';
      confidence = 0.85;
    } else if (recent.totalSets >= 3 && avgRepsPerSet >= goal.maxReps) {
      // Hitting top of rep range - increase weight
      type = OverloadType.weight;
      suggestedWeight =
          recent.maxWeight + _getWeightIncrement(recent.maxWeight);
      suggestedReps = goal.minReps;
      reason = 'Hit rep target - time to add weight!';
      confidence = 0.8;
    } else if (avgRepsPerSet < goal.maxReps) {
      // Not at top of rep range - add reps
      type = OverloadType.reps;
      suggestedWeight = recent.maxWeight;
      suggestedReps = (avgRepsPerSet + 1).round().clamp(
        goal.minReps,
        goal.maxReps,
      );
      reason = 'Build up reps before adding weight';
      confidence = 0.75;
    } else {
      // Maintain current performance
      type = OverloadType.maintain;
      suggestedWeight = recent.maxWeight;
      suggestedReps = avgRepsPerSet.round();
      reason = 'Maintain current performance';
      confidence = 0.6;
    }

    return ProgressiveOverloadSuggestion(
      exercise: exercise,
      currentWeight: recent.maxWeight,
      suggestedWeight: suggestedWeight,
      currentReps: avgRepsPerSet.round(),
      suggestedReps: suggestedReps,
      reason: reason,
      type: type,
      confidence: confidence,
    );
  }

  double _getWeightIncrement(double currentWeight) {
    // Smaller increments for lighter weights
    if (currentWeight < 20) return 1.0;
    if (currentWeight < 50) return 2.5;
    return 5.0;
  }

  String _generateWorkoutName(List<MuscleGroup> muscles) {
    if (muscles.isEmpty) return 'Full Body';

    final categories = muscles.map((m) => m.category).toSet();

    if (categories.length == 1) {
      return '${categories.first.label} Day';
    }

    if (categories.contains(MuscleCategory.push) &&
        categories.contains(MuscleCategory.pull)) {
      return 'Upper Body';
    }

    if (categories.contains(MuscleCategory.legs)) {
      return 'Lower Body';
    }

    return 'Mixed Workout';
  }

  double _calculateVariance(List<int> values) {
    if (values.isEmpty) return 0;
    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDiffs = values.map((v) => (v - mean) * (v - mean));
    return squaredDiffs.reduce((a, b) => a + b) / values.length;
  }
}

/// Internal helper for tracking muscle work.
class _MuscleTracker {
  DateTime? lastWorked;
  int totalSets = 0;
  double totalVolume = 0;
  double maxIntensity = 0;

  void addWorkout({
    required DateTime date,
    required int sets,
    required double volume,
    required double intensity,
  }) {
    if (lastWorked == null || date.isAfter(lastWorked!)) {
      lastWorked = date;
    }
    totalSets += sets;
    totalVolume += volume;
    if (intensity > maxIntensity) {
      maxIntensity = intensity;
    }
  }

  double calculateRecovery(int hoursSince) {
    if (lastWorked == null) return 1.0;

    // Base recovery: 48-72 hours for full recovery
    // High volume/intensity = longer recovery needed
    final baseHours = 48.0;
    final intensityFactor = 1 + (maxIntensity * 0.5); // 1.0 - 1.5
    final volumeFactor = 1 + (totalSets / 30).clamp(0, 0.5); // 1.0 - 1.5

    final recoveryNeeded = baseHours * intensityFactor * volumeFactor;
    return (hoursSince / recoveryNeeded).clamp(0.0, 1.0);
  }
}

/// Internal helper for exercise session data.
class _ExerciseSession {
  final DateTime date;
  final double maxWeight;
  final int totalReps;
  final int totalSets;
  final double volume;

  _ExerciseSession({
    required this.date,
    required this.maxWeight,
    required this.totalReps,
    required this.totalSets,
    required this.volume,
  });
}
