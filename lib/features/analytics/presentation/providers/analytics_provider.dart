import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/volume_analytics.dart';

part 'analytics_provider.g.dart';

/// Provider for volume analytics.
@riverpod
class VolumeAnalyticsNotifier extends _$VolumeAnalyticsNotifier {
  @override
  VolumeAnalytics build() {
    return _generateMockAnalytics();
  }

  VolumeAnalytics _generateMockAnalytics() {
    final random = Random(42);
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final prevWeekStart = weekStart.subtract(const Duration(days: 7));
    final prevWeekEnd = prevWeekStart.add(const Duration(days: 6));

    final currentWeek = <MuscleGroup, WeeklyVolume>{};
    final previousWeek = <MuscleGroup, WeeklyVolume>{};
    final trends = <MuscleGroup, VolumeTrend>{};

    for (final muscle in MuscleGroup.values) {
      final sets = random.nextInt(15) + 5;
      final prevSets = random.nextInt(15) + 5;

      currentWeek[muscle] = WeeklyVolume(
        muscleGroup: muscle,
        totalSets: sets,
        totalReps: sets * (random.nextInt(6) + 8),
        totalVolume: sets * 100.0 * (random.nextDouble() + 0.5),
        workoutCount: random.nextInt(3) + 1,
        weekStart: weekStart,
        weekEnd: weekEnd,
      );

      previousWeek[muscle] = WeeklyVolume(
        muscleGroup: muscle,
        totalSets: prevSets,
        totalReps: prevSets * (random.nextInt(6) + 8),
        totalVolume: prevSets * 100.0 * (random.nextDouble() + 0.5),
        workoutCount: random.nextInt(3) + 1,
        weekStart: prevWeekStart,
        weekEnd: prevWeekEnd,
      );

      final changePercent = ((sets - prevSets) / prevSets * 100);
      trends[muscle] = VolumeTrend(
        muscleGroup: muscle,
        weeklyData: [previousWeek[muscle]!, currentWeek[muscle]!],
        averageWeeklyVolume: (sets + prevSets) / 2.0,
        volumeChangePercent: changePercent,
        isTrendingUp: sets > prevSets,
      );
    }

    final totalSets = currentWeek.values
        .map((v) => v.totalSets)
        .reduce((a, b) => a + b);
    final totalReps = currentWeek.values
        .map((v) => v.totalReps)
        .reduce((a, b) => a + b);
    final totalVolume = currentWeek.values
        .map((v) => v.totalVolume)
        .reduce((a, b) => a + b);

    final undertrained = currentWeek.entries
        .where((e) => e.value.totalSets < 8)
        .map((e) => e.key)
        .toList();

    final overtrained = currentWeek.entries
        .where((e) => e.value.totalSets > 20)
        .map((e) => e.key)
        .toList();

    return VolumeAnalytics(
      currentWeek: currentWeek,
      previousWeek: previousWeek,
      trends: trends,
      totalWeeklySets: totalSets,
      totalWeeklyReps: totalReps,
      totalWeeklyVolume: totalVolume,
      undertrainedMuscles: undertrained,
      overtrainedMuscles: overtrained,
    );
  }

  void refresh() {
    state = _generateMockAnalytics();
  }
}

/// Provider for fatigue levels.
@riverpod
class FatigueLevelsNotifier extends _$FatigueLevelsNotifier {
  @override
  Map<MuscleGroup, FatigueLevel> build() {
    return _generateMockFatigue();
  }

  Map<MuscleGroup, FatigueLevel> _generateMockFatigue() {
    final random = Random(42);
    final now = DateTime.now();
    final levels = <MuscleGroup, FatigueLevel>{};

    for (final muscle in MuscleGroup.values) {
      final fatigue = random.nextDouble() * 100;
      final daysAgo = random.nextInt(5);

      String status;
      if (fatigue > 70) {
        status = 'Needs Rest';
      } else if (fatigue > 40) {
        status = 'Recovering';
      } else {
        status = 'Recovered';
      }

      levels[muscle] = FatigueLevel(
        muscleGroup: muscle,
        fatigueScore: fatigue,
        lastTrained: now.subtract(Duration(days: daysAgo)),
        consecutiveHighVolumeDays: random.nextInt(3),
        recoveryStatus: status,
      );
    }

    return levels;
  }

  void updateFatigue(MuscleGroup muscle, double additionalFatigue) {
    final current = state[muscle];
    if (current != null) {
      state = {
        ...state,
        muscle: FatigueLevel(
          muscleGroup: muscle,
          fatigueScore: (current.fatigueScore + additionalFatigue).clamp(
            0,
            100,
          ),
          lastTrained: DateTime.now(),
          consecutiveHighVolumeDays: current.consecutiveHighVolumeDays + 1,
          recoveryStatus: 'Training',
        ),
      };
    }
  }

  void simulateRecovery() {
    state = state.map((muscle, level) {
      final newFatigue = (level.fatigueScore - 15).clamp(0.0, 100.0);
      String status;
      if (newFatigue > 70) {
        status = 'Needs Rest';
      } else if (newFatigue > 40) {
        status = 'Recovering';
      } else {
        status = 'Recovered';
      }
      return MapEntry(
        muscle,
        FatigueLevel(
          muscleGroup: muscle,
          fatigueScore: newFatigue,
          lastTrained: level.lastTrained,
          consecutiveHighVolumeDays: 0,
          recoveryStatus: status,
        ),
      );
    });
  }
}

/// Provider for workout intensity scores.
@riverpod
class IntensityScoresNotifier extends _$IntensityScoresNotifier {
  @override
  List<IntensityScore> build() {
    return _generateMockScores();
  }

  List<IntensityScore> _generateMockScores() {
    final random = Random(42);
    final now = DateTime.now();

    return List.generate(10, (index) {
      final score = random.nextDouble() * 60 + 40;
      final sets = random.nextInt(20) + 10;
      final reps = sets * (random.nextInt(6) + 8);
      final duration = random.nextInt(60) + 30;

      return IntensityScore(
        workoutId: 'workout_$index',
        score: score,
        volumeScore: score * 0.4,
        intensityScore: score * 0.35,
        densityScore: score * 0.25,
        totalSets: sets,
        totalReps: reps,
        totalWeight: reps * (random.nextDouble() * 50 + 20),
        durationMinutes: duration,
        date: now.subtract(Duration(days: index)),
      );
    });
  }

  IntensityScore calculateScore({
    required String workoutId,
    required int sets,
    required int reps,
    required double weight,
    required int duration,
  }) {
    // Volume score: based on total volume
    final volume = sets * reps * weight;
    final volumeScore = (volume / 10000).clamp(0.0, 100.0);

    // Intensity score: based on average weight
    final avgWeight = weight / (sets * reps);
    final intensityScore = (avgWeight / 2).clamp(0.0, 100.0);

    // Density score: volume per minute
    final density = volume / duration;
    final densityScore = (density / 100).clamp(0.0, 100.0);

    // Combined score
    final score =
        volumeScore * 0.4 + intensityScore * 0.35 + densityScore * 0.25;

    final newScore = IntensityScore(
      workoutId: workoutId,
      score: score,
      volumeScore: volumeScore,
      intensityScore: intensityScore,
      densityScore: densityScore,
      totalSets: sets,
      totalReps: reps,
      totalWeight: weight,
      durationMinutes: duration,
      date: DateTime.now(),
    );

    state = [newScore, ...state];
    return newScore;
  }
}

/// Provider for PR predictions.
@riverpod
class PRPredictionsNotifier extends _$PRPredictionsNotifier {
  @override
  Map<String, double> build() {
    // Exercise name -> predicted 1RM
    return {
      'Bench Press': 102.5,
      'Squat': 142.5,
      'Deadlift': 165.0,
      'Overhead Press': 62.5,
      'Barbell Row': 85.0,
    };
  }

  /// Predict 1RM using Epley formula: 1RM = weight × (1 + reps/30)
  double predict1RM(double weight, int reps) {
    if (reps <= 0) return weight;
    if (reps == 1) return weight;
    return weight * (1 + reps / 30);
  }

  /// Update prediction based on new lift data.
  void updatePrediction(String exercise, double weight, int reps) {
    final predicted = predict1RM(weight, reps);
    final current = state[exercise] ?? 0;
    if (predicted > current) {
      state = {...state, exercise: predicted};
    }
  }

  /// Get predicted weight for target reps.
  double getWeightForReps(String exercise, int targetReps) {
    final oneRM = state[exercise] ?? 0;
    if (oneRM == 0 || targetReps <= 0) return 0;
    // Reverse Epley: weight = 1RM / (1 + reps/30)
    return oneRM / (1 + targetReps / 30);
  }
}
