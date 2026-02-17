/// Volume analytics data structures.

/// Muscle group for volume tracking.
enum MuscleGroup {
  chest('Chest', '🫁', [0xFFEF4444]),
  back('Back', '🔙', [0xFF3B82F6]),
  shoulders('Shoulders', '💪', [0xFFF97316]),
  biceps('Biceps', '💪', [0xFF22C55E]),
  triceps('Triceps', '💪', [0xFF8B5CF6]),
  quads('Quads', '🦵', [0xFFEC4899]),
  hamstrings('Hamstrings', '🦵', [0xFF14B8A6]),
  glutes('Glutes', '🍑', [0xFFF59E0B]),
  calves('Calves', '🦵', [0xFF06B6D4]),
  abs('Abs', '🧱', [0xFF64748B]),
  forearms('Forearms', '💪', [0xFFA855F7]);

  final String label;
  final String emoji;
  final List<int> colorValues;

  const MuscleGroup(this.label, this.emoji, this.colorValues);

  int get primaryColor => colorValues[0];
}

/// Volume entry for a single workout.
class VolumeEntry {
  final String id;
  final MuscleGroup muscleGroup;
  final int sets;
  final int totalReps;
  final double totalWeight; // Total weight moved (sets × reps × weight)
  final DateTime date;

  const VolumeEntry({
    required this.id,
    required this.muscleGroup,
    required this.sets,
    required this.totalReps,
    required this.totalWeight,
    required this.date,
  });

  double get averageWeight => totalReps > 0 ? totalWeight / totalReps : 0;
}

/// Weekly volume summary per muscle group.
class WeeklyVolume {
  final MuscleGroup muscleGroup;
  final int totalSets;
  final int totalReps;
  final double totalVolume;
  final int workoutCount;
  final DateTime weekStart;
  final DateTime weekEnd;

  const WeeklyVolume({
    required this.muscleGroup,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    required this.workoutCount,
    required this.weekStart,
    required this.weekEnd,
  });

  /// Get volume classification.
  String get volumeStatus {
    // Based on general recommendations
    if (totalSets < 6) return 'Low';
    if (totalSets < 12) return 'Moderate';
    if (totalSets < 20) return 'Optimal';
    return 'High';
  }

  /// Check if within recommended range (10-20 sets/week for most).
  bool get isOptimal => totalSets >= 10 && totalSets <= 20;
}

/// Volume trends over time.
class VolumeTrend {
  final MuscleGroup muscleGroup;
  final List<WeeklyVolume> weeklyData;
  final double averageWeeklyVolume;
  final double volumeChangePercent;
  final bool isTrendingUp;

  const VolumeTrend({
    required this.muscleGroup,
    required this.weeklyData,
    required this.averageWeeklyVolume,
    required this.volumeChangePercent,
    required this.isTrendingUp,
  });
}

/// Overall volume analytics.
class VolumeAnalytics {
  final Map<MuscleGroup, WeeklyVolume> currentWeek;
  final Map<MuscleGroup, WeeklyVolume> previousWeek;
  final Map<MuscleGroup, VolumeTrend> trends;
  final int totalWeeklySets;
  final int totalWeeklyReps;
  final double totalWeeklyVolume;
  final List<MuscleGroup> undertrainedMuscles;
  final List<MuscleGroup> overtrainedMuscles;

  const VolumeAnalytics({
    required this.currentWeek,
    required this.previousWeek,
    required this.trends,
    required this.totalWeeklySets,
    required this.totalWeeklyReps,
    required this.totalWeeklyVolume,
    required this.undertrainedMuscles,
    required this.overtrainedMuscles,
  });

  /// Get balance score (0-100).
  int get balanceScore {
    if (currentWeek.isEmpty) return 0;
    final average = totalWeeklySets / MuscleGroup.values.length;
    final variance =
        currentWeek.values
            .map((v) {
              final diff = v.totalSets - average;
              return diff * diff;
            })
            .reduce((a, b) => a + b) /
        currentWeek.length;
    // Lower variance = higher score
    return (100 - variance.clamp(0, 100)).round();
  }

  /// Get recommendations.
  List<String> get recommendations {
    final recs = <String>[];

    if (undertrainedMuscles.isNotEmpty) {
      recs.add(
        'Consider adding more sets for ${undertrainedMuscles.map((m) => m.label).join(", ")}',
      );
    }

    if (overtrainedMuscles.isNotEmpty) {
      recs.add(
        'You might be overtraining ${overtrainedMuscles.map((m) => m.label).join(", ")}',
      );
    }

    if (balanceScore < 50) {
      recs.add(
        'Your training is unbalanced. Try to train all muscle groups more evenly.',
      );
    }

    return recs;
  }
}

/// Fatigue indicator.
class FatigueLevel {
  final MuscleGroup muscleGroup;
  final double fatigueScore; // 0-100
  final DateTime lastTrained;
  final int consecutiveHighVolumeDays;
  final String recoveryStatus;

  const FatigueLevel({
    required this.muscleGroup,
    required this.fatigueScore,
    required this.lastTrained,
    required this.consecutiveHighVolumeDays,
    required this.recoveryStatus,
  });

  bool get needsRest => fatigueScore > 70;
  bool get isRecovered => fatigueScore < 30;

  String get statusEmoji {
    if (fatigueScore > 80) return '🔴';
    if (fatigueScore > 60) return '🟠';
    if (fatigueScore > 40) return '🟡';
    return '🟢';
  }
}

/// Workout intensity score.
class IntensityScore {
  final String workoutId;
  final double score; // 0-100
  final double volumeScore;
  final double intensityScore;
  final double densityScore; // Volume / Time
  final int totalSets;
  final int totalReps;
  final double totalWeight;
  final int durationMinutes;
  final DateTime date;

  const IntensityScore({
    required this.workoutId,
    required this.score,
    required this.volumeScore,
    required this.intensityScore,
    required this.densityScore,
    required this.totalSets,
    required this.totalReps,
    required this.totalWeight,
    required this.durationMinutes,
    required this.date,
  });

  String get difficultyLabel {
    if (score >= 90) return 'Extreme';
    if (score >= 75) return 'Very Hard';
    if (score >= 60) return 'Hard';
    if (score >= 40) return 'Moderate';
    if (score >= 20) return 'Easy';
    return 'Light';
  }

  String get difficultyEmoji {
    if (score >= 90) return '🔥🔥🔥';
    if (score >= 75) return '🔥🔥';
    if (score >= 60) return '🔥';
    if (score >= 40) return '💪';
    if (score >= 20) return '👍';
    return '😊';
  }
}
