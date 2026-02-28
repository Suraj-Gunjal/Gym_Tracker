/// A weekly insight/summary with AI-generated analysis.
class WeeklyInsight {
  final DateTime weekStart;
  final DateTime weekEnd;
  final WeeklyStats stats;
  final List<Achievement> achievements;
  final List<ImprovementArea> areasToImprove;
  final List<String> recommendations;
  final String summaryMessage;
  final double overallScore; // 0.0 to 1.0
  final TrendDirection trend;

  const WeeklyInsight({
    required this.weekStart,
    required this.weekEnd,
    required this.stats,
    required this.achievements,
    required this.areasToImprove,
    required this.recommendations,
    required this.summaryMessage,
    required this.overallScore,
    required this.trend,
  });

  String get dateRangeText {
    final startStr = '${weekStart.day}/${weekStart.month}';
    final endStr = '${weekEnd.day}/${weekEnd.month}';
    return '$startStr - $endStr';
  }

  String get scoreEmoji {
    if (overallScore >= 0.9) return '🔥';
    if (overallScore >= 0.75) return '💪';
    if (overallScore >= 0.5) return '👍';
    if (overallScore >= 0.25) return '🌱';
    return '😴';
  }

  String get scoreLabelText {
    if (overallScore >= 0.9) return 'Outstanding!';
    if (overallScore >= 0.75) return 'Great Work!';
    if (overallScore >= 0.5) return 'Solid Week';
    if (overallScore >= 0.25) return 'Getting Started';
    return 'Light Week';
  }
}

/// Stats for the week.
class WeeklyStats {
  final int workoutCount;
  final int totalSets;
  final int totalReps;
  final double totalVolume; // kg
  final Duration totalDuration;
  final int exerciseVariety;
  final int prsSet;
  final double avgIntensity; // 0.0 to 1.0
  final Map<String, int> muscleGroupsWorked; // muscle -> sets

  const WeeklyStats({
    required this.workoutCount,
    required this.totalSets,
    required this.totalReps,
    required this.totalVolume,
    required this.totalDuration,
    required this.exerciseVariety,
    required this.prsSet,
    required this.avgIntensity,
    required this.muscleGroupsWorked,
  });

  String get volumeFormatted {
    if (totalVolume >= 1000) {
      return '${(totalVolume / 1000).toStringAsFixed(1)}k kg';
    }
    return '${totalVolume.toStringAsFixed(0)} kg';
  }

  String get durationFormatted {
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

/// An achievement unlocked this week.
class Achievement {
  final String title;
  final String description;
  final AchievementType type;
  final String? value;

  const Achievement({
    required this.title,
    required this.description,
    required this.type,
    this.value,
  });

  String get emoji {
    switch (type) {
      case AchievementType.pr:
        return '🏆';
      case AchievementType.consistency:
        return '📅';
      case AchievementType.volume:
        return '📈';
      case AchievementType.variety:
        return '🎯';
      case AchievementType.streak:
        return '🔥';
      case AchievementType.milestone:
        return '⭐';
    }
  }
}

/// Types of achievements.
enum AchievementType {
  pr, // New personal record
  consistency, // Workout consistency
  volume, // Volume milestone
  variety, // Exercise variety
  streak, // Workout streak
  milestone, // General milestone
}

/// An area that could be improved.
class ImprovementArea {
  final String title;
  final String description;
  final ImprovementType type;
  final double priority; // 0.0 to 1.0

  const ImprovementArea({
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
  });

  String get emoji {
    switch (type) {
      case ImprovementType.recovery:
        return '😴';
      case ImprovementType.balance:
        return '⚖️';
      case ImprovementType.frequency:
        return '📅';
      case ImprovementType.intensity:
        return '💪';
      case ImprovementType.variety:
        return '🔄';
      case ImprovementType.progression:
        return '📈';
    }
  }
}

/// Types of improvement areas.
enum ImprovementType {
  recovery, // Need more rest
  balance, // Muscle imbalance
  frequency, // Workout frequency
  intensity, // Training intensity
  variety, // Exercise variety
  progression, // Progressive overload
}

/// Trend direction compared to previous weeks.
enum TrendDirection {
  improving,
  stable,
  declining;

  String get label {
    switch (this) {
      case TrendDirection.improving:
        return 'Improving';
      case TrendDirection.stable:
        return 'Stable';
      case TrendDirection.declining:
        return 'Declining';
    }
  }

  String get emoji {
    switch (this) {
      case TrendDirection.improving:
        return '📈';
      case TrendDirection.stable:
        return '➡️';
      case TrendDirection.declining:
        return '📉';
    }
  }
}

/// Comparison between two weeks.
class WeekComparison {
  final WeeklyStats thisWeek;
  final WeeklyStats lastWeek;

  const WeekComparison({required this.thisWeek, required this.lastWeek});

  double get volumeChange =>
      _percentChange(lastWeek.totalVolume, thisWeek.totalVolume);
  double get workoutChange => _percentChange(
    lastWeek.workoutCount.toDouble(),
    thisWeek.workoutCount.toDouble(),
  );
  double get setsChange => _percentChange(
    lastWeek.totalSets.toDouble(),
    thisWeek.totalSets.toDouble(),
  );
  double get intensityChange =>
      _percentChange(lastWeek.avgIntensity, thisWeek.avgIntensity);

  double _percentChange(double old, double current) {
    if (old == 0) return current > 0 ? 100 : 0;
    return ((current - old) / old) * 100;
  }
}
