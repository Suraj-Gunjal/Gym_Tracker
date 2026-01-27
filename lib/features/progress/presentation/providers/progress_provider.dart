import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../../workout/domain/entities/workout.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../../pr/presentation/providers/pr_provider.dart';
import '../../../pr/domain/entities/personal_record.dart';
import '../../../pr/domain/entities/pr_type.dart';

/// Time range for progress data
enum TimeRange { week, month, threeMonths, sixMonths, year, all }

extension TimeRangeExtension on TimeRange {
  String get displayName {
    switch (this) {
      case TimeRange.week:
        return '1 Week';
      case TimeRange.month:
        return '1 Month';
      case TimeRange.threeMonths:
        return '3 Months';
      case TimeRange.sixMonths:
        return '6 Months';
      case TimeRange.year:
        return '1 Year';
      case TimeRange.all:
        return 'All Time';
    }
  }

  DateTime get startDate {
    final now = DateTime.now();
    switch (this) {
      case TimeRange.week:
        return now.subtract(const Duration(days: 7));
      case TimeRange.month:
        return DateTime(now.year, now.month - 1, now.day);
      case TimeRange.threeMonths:
        return DateTime(now.year, now.month - 3, now.day);
      case TimeRange.sixMonths:
        return DateTime(now.year, now.month - 6, now.day);
      case TimeRange.year:
        return DateTime(now.year - 1, now.month, now.day);
      case TimeRange.all:
        return DateTime(2000);
    }
  }
}

/// Selected time range provider
final selectedTimeRangeProvider = StateProvider<TimeRange>(
  (ref) => TimeRange.month,
);

/// Data point for a progress chart
class ProgressDataPoint {
  final DateTime date;
  final double value;

  const ProgressDataPoint({required this.date, required this.value});
}

/// Progress data for an exercise
class ExerciseProgressData {
  final String exerciseId;
  final String exerciseName;
  final List<ProgressDataPoint> maxWeightProgress;
  final List<ProgressDataPoint> maxRepsProgress;
  final List<ProgressDataPoint> totalVolumeProgress;
  final PersonalRecord? currentMaxWeightPR;
  final PersonalRecord? currentMaxRepsPR;
  final PersonalRecord? currentVolumePR;

  const ExerciseProgressData({
    required this.exerciseId,
    required this.exerciseName,
    this.maxWeightProgress = const [],
    this.maxRepsProgress = const [],
    this.totalVolumeProgress = const [],
    this.currentMaxWeightPR,
    this.currentMaxRepsPR,
    this.currentVolumePR,
  });
}

/// Provider for workouts within selected time range
final workoutsInTimeRangeProvider = FutureProvider<List<Workout>>((ref) async {
  final timeRange = ref.watch(selectedTimeRangeProvider);
  final repository = ref.watch(workoutRepositoryProvider);

  return repository.getAllWorkouts(startDate: timeRange.startDate);
});

/// Overall workout statistics
class WorkoutStats {
  final int totalWorkouts;
  final int totalSets;
  final double totalVolume;
  final int totalReps;
  final Duration averageWorkoutDuration;
  final int workoutsThisWeek;
  final int workoutsThisMonth;

  const WorkoutStats({
    required this.totalWorkouts,
    required this.totalSets,
    required this.totalVolume,
    required this.totalReps,
    required this.averageWorkoutDuration,
    required this.workoutsThisWeek,
    required this.workoutsThisMonth,
  });
}

/// Provider for overall workout statistics
final workoutStatsProvider = FutureProvider<WorkoutStats>((ref) async {
  final workouts = await ref.watch(allWorkoutsProvider.future);

  if (workouts.isEmpty) {
    return const WorkoutStats(
      totalWorkouts: 0,
      totalSets: 0,
      totalVolume: 0,
      totalReps: 0,
      averageWorkoutDuration: Duration.zero,
      workoutsThisWeek: 0,
      workoutsThisMonth: 0,
    );
  }

  int totalSets = 0;
  double totalVolume = 0;
  int totalReps = 0;
  Duration totalDuration = Duration.zero;

  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  final monthAgo = DateTime(now.year, now.month - 1, now.day);
  int workoutsThisWeek = 0;
  int workoutsThisMonth = 0;

  for (final workout in workouts) {
    if (workout.completedAt == null) continue;

    // Calculate duration
    final duration = workout.completedAt!.difference(workout.startedAt);
    totalDuration += duration;

    // Count by time period
    if (workout.startedAt.isAfter(weekAgo)) {
      workoutsThisWeek++;
    }
    if (workout.startedAt.isAfter(monthAgo)) {
      workoutsThisMonth++;
    }

    // Aggregate set data
    for (final exercise in workout.exercises) {
      for (final set in exercise.sets) {
        totalSets++;
        totalReps += set.reps;
        totalVolume += set.weight * set.reps;
      }
    }
  }

  final completedWorkouts = workouts.where((w) => w.completedAt != null).length;
  final avgDuration = completedWorkouts > 0
      ? Duration(
          milliseconds: totalDuration.inMilliseconds ~/ completedWorkouts,
        )
      : Duration.zero;

  return WorkoutStats(
    totalWorkouts: completedWorkouts,
    totalSets: totalSets,
    totalVolume: totalVolume,
    totalReps: totalReps,
    averageWorkoutDuration: avgDuration,
    workoutsThisWeek: workoutsThisWeek,
    workoutsThisMonth: workoutsThisMonth,
  );
});

/// Arguments for exercise progress
class ExerciseProgressArgs {
  final String exerciseId;
  final TimeRange timeRange;

  const ExerciseProgressArgs({
    required this.exerciseId,
    required this.timeRange,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseProgressArgs &&
          runtimeType == other.runtimeType &&
          exerciseId == other.exerciseId &&
          timeRange == other.timeRange;

  @override
  int get hashCode => exerciseId.hashCode ^ timeRange.hashCode;
}

/// Provider for exercise-specific progress data
final exerciseProgressProvider =
    FutureProvider.family<ExerciseProgressData, ExerciseProgressArgs>((
      ref,
      args,
    ) async {
      final workoutRepo = ref.watch(workoutRepositoryProvider);
      final exerciseRepo = ref.watch(exerciseRepositoryProvider);
      final prRepo = ref.watch(prRepositoryProvider);

      // Get exercise details
      final exercise = await exerciseRepo.getExerciseById(args.exerciseId);
      if (exercise == null) {
        return ExerciseProgressData(
          exerciseId: args.exerciseId,
          exerciseName: 'Unknown Exercise',
        );
      }

      // Get workouts in time range
      final workouts = await workoutRepo.getAllWorkouts(
        startDate: args.timeRange.startDate,
      );

      // Get current PRs
      final maxWeightPR = await prRepo.getCurrentPR(
        args.exerciseId,
        PRType.maxWeight,
      );
      final maxRepsPR = await prRepo.getCurrentPR(
        args.exerciseId,
        PRType.maxReps,
      );
      final volumePR = await prRepo.getCurrentPR(
        args.exerciseId,
        PRType.maxVolume,
      );

      // Build progress data points
      final maxWeightProgress = <ProgressDataPoint>[];
      final maxRepsProgress = <ProgressDataPoint>[];
      final volumeProgress = <ProgressDataPoint>[];

      for (final workout in workouts) {
        if (workout.completedAt == null) continue;

        // Find exercises matching this exercise ID
        for (final workoutExercise in workout.exercises) {
          if (workoutExercise.exerciseId != args.exerciseId) continue;
          if (workoutExercise.sets.isEmpty) continue;

          // Find max weight and max reps for this workout
          double maxWeight = 0;
          int maxReps = 0;
          double totalVolume = 0;

          for (final set in workoutExercise.sets) {
            if (set.weight > maxWeight) {
              maxWeight = set.weight;
            }
            if (set.reps > maxReps) {
              maxReps = set.reps;
            }
            totalVolume += set.weight * set.reps;
          }

          final date = workout.completedAt!;
          maxWeightProgress.add(
            ProgressDataPoint(date: date, value: maxWeight),
          );
          maxRepsProgress.add(
            ProgressDataPoint(date: date, value: maxReps.toDouble()),
          );
          volumeProgress.add(ProgressDataPoint(date: date, value: totalVolume));
        }
      }

      // Sort by date
      maxWeightProgress.sort((a, b) => a.date.compareTo(b.date));
      maxRepsProgress.sort((a, b) => a.date.compareTo(b.date));
      volumeProgress.sort((a, b) => a.date.compareTo(b.date));

      return ExerciseProgressData(
        exerciseId: args.exerciseId,
        exerciseName: exercise.name,
        maxWeightProgress: maxWeightProgress,
        maxRepsProgress: maxRepsProgress,
        totalVolumeProgress: volumeProgress,
        currentMaxWeightPR: maxWeightPR,
        currentMaxRepsPR: maxRepsPR,
        currentVolumePR: volumePR,
      );
    });

/// Most used exercises provider
final mostUsedExercisesProvider = FutureProvider<List<MapEntry<String, int>>>((
  ref,
) async {
  final workouts = await ref.watch(allWorkoutsProvider.future);

  final exerciseUsage = <String, int>{};

  for (final workout in workouts) {
    for (final exercise in workout.exercises) {
      exerciseUsage[exercise.exerciseId] =
          (exerciseUsage[exercise.exerciseId] ?? 0) + 1;
    }
  }

  final sorted = exerciseUsage.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return sorted.take(10).toList();
});
