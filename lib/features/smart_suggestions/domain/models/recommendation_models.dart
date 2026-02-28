import '../../../exercise/domain/entities/exercise.dart';
import '../../../recovery/presentation/screens/muscle_heatmap_screen.dart';

/// Training goal types.
enum TrainingGoal {
  strength('Strength', 'Heavy weight, low reps (3-6)', 3, 6, 0.85),
  hypertrophy(
    'Hypertrophy',
    'Moderate weight, medium reps (8-12)',
    8,
    12,
    0.70,
  ),
  endurance('Endurance', 'Light weight, high reps (15-20)', 15, 20, 0.50),
  power('Power', 'Explosive, moderate reps (3-5)', 3, 5, 0.75);

  final String displayName;
  final String description;
  final int minReps;
  final int maxReps;
  final double intensityMultiplier; // % of 1RM

  const TrainingGoal(
    this.displayName,
    this.description,
    this.minReps,
    this.maxReps,
    this.intensityMultiplier,
  );
}

/// A recommendation for progressive overload.
class ProgressiveOverloadSuggestion {
  final Exercise exercise;
  final double currentWeight;
  final double suggestedWeight;
  final int currentReps;
  final int suggestedReps;
  final String reason;
  final OverloadType type;
  final double confidence; // 0-1 how confident the suggestion is

  const ProgressiveOverloadSuggestion({
    required this.exercise,
    required this.currentWeight,
    required this.suggestedWeight,
    required this.currentReps,
    required this.suggestedReps,
    required this.reason,
    required this.type,
    required this.confidence,
  });

  double get weightIncrease => suggestedWeight - currentWeight;
  int get repsIncrease => suggestedReps - currentReps;
  bool get hasWeightIncrease => weightIncrease > 0;
  bool get hasRepsIncrease => repsIncrease > 0;
}

/// Type of progressive overload.
enum OverloadType {
  weight('Add Weight', '🏋️'),
  reps('Add Reps', '🔢'),
  sets('Add Sets', '📈'),
  frequency('Increase Frequency', '📅'),
  maintain('Maintain', '✅');

  final String label;
  final String emoji;
  const OverloadType(this.label, this.emoji);
}

/// Exercise recommendation based on muscle recovery.
class ExerciseRecommendation {
  final Exercise exercise;
  final double recoveryScore; // 0-1, 1 = fully recovered
  final RecoveryStatus recoveryStatus;
  final String reason;
  final int suggestedSets;
  final int suggestedReps;
  final double suggestedWeight;
  final bool isPriority;

  const ExerciseRecommendation({
    required this.exercise,
    required this.recoveryScore,
    required this.recoveryStatus,
    required this.reason,
    required this.suggestedSets,
    required this.suggestedReps,
    required this.suggestedWeight,
    this.isPriority = false,
  });
}

/// Muscle recovery data for planning.
class MuscleRecoveryData {
  final MuscleGroup muscle;
  final double recoveryScore; // 0-1
  final DateTime? lastWorked;
  final int hoursSinceLastWorkout;
  final int totalSetsLast7Days;
  final double volumeLast7Days;

  const MuscleRecoveryData({
    required this.muscle,
    required this.recoveryScore,
    this.lastWorked,
    required this.hoursSinceLastWorkout,
    required this.totalSetsLast7Days,
    required this.volumeLast7Days,
  });

  RecoveryStatus get status => RecoveryStatus.fromValue(recoveryScore);
  bool get isFullyRecovered => recoveryScore >= 0.8;
  bool get needsRest => recoveryScore < 0.3;
}

/// Generated workout suggestion.
class WorkoutSuggestion {
  final String name;
  final String description;
  final TrainingGoal goal;
  final List<ExerciseRecommendation> exercises;
  final Duration estimatedDuration;
  final List<MuscleGroup> targetMuscles;
  final double overallReadiness; // 0-1

  const WorkoutSuggestion({
    required this.name,
    required this.description,
    required this.goal,
    required this.exercises,
    required this.estimatedDuration,
    required this.targetMuscles,
    required this.overallReadiness,
  });

  int get totalSets => exercises.fold(0, (sum, e) => sum + e.suggestedSets);
  int get exerciseCount => exercises.length;
}

/// Weekly training analysis.
class WeeklyAnalysis {
  final int totalWorkouts;
  final int totalSets;
  final double totalVolume;
  final Map<MuscleGroup, int> muscleFrequency;
  final Map<MuscleGroup, double> muscleVolume;
  final List<MuscleGroup> neglectedMuscles;
  final List<MuscleGroup> overtrainedMuscles;
  final double balanceScore; // 0-1

  const WeeklyAnalysis({
    required this.totalWorkouts,
    required this.totalSets,
    required this.totalVolume,
    required this.muscleFrequency,
    required this.muscleVolume,
    required this.neglectedMuscles,
    required this.overtrainedMuscles,
    required this.balanceScore,
  });
}

/// Exercise performance history for an exercise.
class ExercisePerformance {
  final Exercise exercise;
  final List<PerformanceDataPoint> history;
  final double currentMax1RM;
  final double averageVolume;
  final int timesPerformed;
  final DateTime? lastPerformed;
  final TrendDirection trend;

  const ExercisePerformance({
    required this.exercise,
    required this.history,
    required this.currentMax1RM,
    required this.averageVolume,
    required this.timesPerformed,
    this.lastPerformed,
    required this.trend,
  });
}

/// A single data point of exercise performance.
class PerformanceDataPoint {
  final DateTime date;
  final double maxWeight;
  final int totalReps;
  final int totalSets;
  final double volume;
  final double estimated1RM;

  const PerformanceDataPoint({
    required this.date,
    required this.maxWeight,
    required this.totalReps,
    required this.totalSets,
    required this.volume,
    required this.estimated1RM,
  });
}

/// Trend direction for progress.
enum TrendDirection {
  improving('Improving', '📈', true),
  plateau('Plateau', '➡️', false),
  declining('Declining', '📉', false),
  newExercise('New', '🆕', false);

  final String label;
  final String emoji;
  final bool isPositive;
  const TrendDirection(this.label, this.emoji, this.isPositive);
}

/// Calculate estimated 1RM using Epley formula.
double calculate1RM(double weight, int reps) {
  if (reps == 1) return weight;
  if (reps <= 0 || weight <= 0) return 0;
  // Epley formula: 1RM = weight × (1 + reps/30)
  return weight * (1 + reps / 30);
}

/// Calculate weight for target reps from 1RM.
double calculateWeightForReps(
  double oneRM,
  int targetReps, {
  double rpeAdjustment = 0.0,
}) {
  if (targetReps == 1) return oneRM;
  // Reverse Epley: weight = 1RM / (1 + reps/30)
  final baseWeight = oneRM / (1 + targetReps / 30);
  // Apply RPE adjustment (negative = easier, positive = harder)
  return baseWeight * (1 + rpeAdjustment);
}
