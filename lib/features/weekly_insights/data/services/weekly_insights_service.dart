import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/repositories/exercise_repository.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../../recovery/presentation/screens/muscle_heatmap_screen.dart';
import '../../../workout/domain/repositories/workout_repository.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../../workout/domain/entities/workout.dart';
import '../../domain/models/weekly_insight.dart';

/// Service for generating AI weekly insights.
class WeeklyInsightsService {
  final WorkoutRepository _workoutRepository;
  final ExerciseRepository _exerciseRepository;

  WeeklyInsightsService(this._workoutRepository, this._exerciseRepository);

  /// Generate insights for the current week.
  Future<WeeklyInsight> generateCurrentWeekInsights() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return generateInsightsForWeek(weekStart, weekEnd);
  }

  /// Generate insights for a specific week.
  Future<WeeklyInsight> generateInsightsForWeek(
    DateTime weekStart,
    DateTime weekEnd,
  ) async {
    // Get all exercises for lookup
    final allExercises = await _exerciseRepository.getAllExercises();
    final exerciseMap = {for (var e in allExercises) e.id: e};

    // Get workouts for this week
    final allWorkouts = await _workoutRepository.getAllWorkouts();
    final thisWeekWorkouts = allWorkouts.where((w) {
      return w.startedAt.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          w.startedAt.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();

    // Get last week's workouts for comparison
    final lastWeekStart = weekStart.subtract(const Duration(days: 7));
    final lastWeekEnd = weekStart.subtract(const Duration(days: 1));
    final lastWeekWorkouts = allWorkouts.where((w) {
      return w.startedAt.isAfter(
            lastWeekStart.subtract(const Duration(days: 1)),
          ) &&
          w.startedAt.isBefore(lastWeekEnd.add(const Duration(days: 1)));
    }).toList();

    // Calculate stats
    final stats = _calculateStats(thisWeekWorkouts, exerciseMap);
    final lastWeekStats = _calculateStats(lastWeekWorkouts, exerciseMap);

    // Generate achievements
    final achievements = _generateAchievements(
      thisWeekWorkouts,
      stats,
      lastWeekStats,
    );

    // Find areas to improve
    final areasToImprove = _findAreasToImprove(stats, lastWeekStats);

    // Generate recommendations
    final recommendations = _generateRecommendations(stats, areasToImprove);

    // Calculate overall score
    final overallScore = _calculateOverallScore(stats, lastWeekStats);

    // Determine trend
    final trend = _determineTrend(stats, lastWeekStats);

    // Generate summary message
    final summaryMessage = _generateSummaryMessage(stats, achievements, trend);

    return WeeklyInsight(
      weekStart: weekStart,
      weekEnd: weekEnd,
      stats: stats,
      achievements: achievements,
      areasToImprove: areasToImprove,
      recommendations: recommendations,
      summaryMessage: summaryMessage,
      overallScore: overallScore,
      trend: trend,
    );
  }

  /// Get insights for multiple weeks.
  Future<List<WeeklyInsight>> getInsightsHistory(int weeks) async {
    final insights = <WeeklyInsight>[];
    final now = DateTime.now();

    for (int i = 0; i < weeks; i++) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (i * 7)));
      final weekEnd = weekStart.add(const Duration(days: 6));
      final insight = await generateInsightsForWeek(weekStart, weekEnd);
      insights.add(insight);
    }

    return insights;
  }

  /// Calculate stats from workouts.
  WeeklyStats _calculateStats(
    List<Workout> workouts,
    Map<String, Exercise> exerciseMap,
  ) {
    if (workouts.isEmpty) {
      return const WeeklyStats(
        workoutCount: 0,
        totalSets: 0,
        totalReps: 0,
        totalVolume: 0,
        totalDuration: Duration.zero,
        exerciseVariety: 0,
        prsSet: 0,
        avgIntensity: 0,
        muscleGroupsWorked: {},
      );
    }

    int totalSets = 0;
    int totalReps = 0;
    double totalVolume = 0;
    Duration totalDuration = Duration.zero;
    final exerciseIds = <String>{};
    final muscleGroups = <String, int>{};

    for (final workout in workouts) {
      totalDuration += workout.duration ?? Duration.zero;

      for (final workoutExercise in workout.exercises) {
        exerciseIds.add(workoutExercise.exerciseId);

        // Get the actual exercise to determine muscle group
        final exercise = exerciseMap[workoutExercise.exerciseId];
        final muscle = exercise != null
            ? _getMuscleGroupLabel(exercise.muscleGroup.name)
            : 'Other';
        muscleGroups[muscle] =
            (muscleGroups[muscle] ?? 0) + workoutExercise.sets.length;

        for (final set in workoutExercise.sets) {
          totalSets++;
          totalReps += set.reps;
          totalVolume += set.weight * set.reps;
        }
      }
    }

    // Estimate average intensity (simplified)
    final avgIntensity = totalSets > 0
        ? (totalVolume / totalSets / 100).clamp(0.0, 1.0)
        : 0.0;

    return WeeklyStats(
      workoutCount: workouts.length,
      totalSets: totalSets,
      totalReps: totalReps,
      totalVolume: totalVolume,
      totalDuration: totalDuration,
      exerciseVariety: exerciseIds.length,
      prsSet: 0, // PRs counted separately via PR repository
      avgIntensity: avgIntensity,
      muscleGroupsWorked: muscleGroups,
    );
  }

  /// Get display label for a muscle group.
  String _getMuscleGroupLabel(String muscleGroupName) {
    // Map muscle group enum names to display labels
    switch (muscleGroupName.toLowerCase()) {
      case 'chest':
        return MuscleGroup.chest.label;
      case 'back':
        return MuscleGroup.back.label;
      case 'shoulders':
        return MuscleGroup.shoulders.label;
      case 'biceps':
        return MuscleGroup.biceps.label;
      case 'triceps':
        return MuscleGroup.triceps.label;
      case 'quadriceps':
      case 'quads':
        return MuscleGroup.quads.label;
      case 'hamstrings':
        return MuscleGroup.hamstrings.label;
      case 'glutes':
        return MuscleGroup.glutes.label;
      case 'calves':
        return MuscleGroup.calves.label;
      case 'abs':
      case 'core':
        return MuscleGroup.core.label;
      case 'forearms':
        return MuscleGroup.forearms.label;
      case 'traps':
        return MuscleGroup.traps.label;
      default:
        return 'Other';
    }
  }

  /// Generate achievements for the week.
  List<Achievement> _generateAchievements(
    List<Workout> workouts,
    WeeklyStats stats,
    WeeklyStats lastWeekStats,
  ) {
    final achievements = <Achievement>[];

    // Consistency achievement
    if (stats.workoutCount >= 4) {
      achievements.add(
        Achievement(
          title: 'Consistency King',
          description: 'Hit ${stats.workoutCount} workouts this week!',
          type: AchievementType.consistency,
          value: '${stats.workoutCount}',
        ),
      );
    } else if (stats.workoutCount >= 3) {
      achievements.add(
        Achievement(
          title: 'Solid Week',
          description: 'Completed ${stats.workoutCount} workouts',
          type: AchievementType.consistency,
          value: '${stats.workoutCount}',
        ),
      );
    }

    // Volume improvement
    if (lastWeekStats.totalVolume > 0) {
      final volumeIncrease =
          ((stats.totalVolume - lastWeekStats.totalVolume) /
              lastWeekStats.totalVolume) *
          100;
      if (volumeIncrease >= 10) {
        achievements.add(
          Achievement(
            title: 'Volume Up!',
            description:
                'Lifted ${volumeIncrease.toStringAsFixed(0)}% more than last week',
            type: AchievementType.volume,
            value: '+${volumeIncrease.toStringAsFixed(0)}%',
          ),
        );
      }
    }

    // Big volume week
    if (stats.totalVolume >= 50000) {
      achievements.add(
        Achievement(
          title: 'Heavy Lifter',
          description: 'Moved ${stats.volumeFormatted} total volume!',
          type: AchievementType.milestone,
          value: stats.volumeFormatted,
        ),
      );
    }

    // Exercise variety
    if (stats.exerciseVariety >= 10) {
      achievements.add(
        Achievement(
          title: 'Variety Master',
          description: 'Used ${stats.exerciseVariety} different exercises',
          type: AchievementType.variety,
          value: '${stats.exerciseVariety}',
        ),
      );
    }

    // Training duration
    if (stats.totalDuration.inHours >= 5) {
      achievements.add(
        Achievement(
          title: 'Dedicated',
          description: 'Spent ${stats.durationFormatted} training',
          type: AchievementType.milestone,
          value: stats.durationFormatted,
        ),
      );
    }

    return achievements;
  }

  /// Find areas that need improvement.
  List<ImprovementArea> _findAreasToImprove(
    WeeklyStats stats,
    WeeklyStats lastWeekStats,
  ) {
    final areas = <ImprovementArea>[];

    // Low workout frequency
    if (stats.workoutCount < 3) {
      areas.add(
        ImprovementArea(
          title: 'Workout Frequency',
          description:
              'Only ${stats.workoutCount} workout${stats.workoutCount == 1 ? '' : 's'} this week. '
              'Aim for at least 3-4 sessions.',
          type: ImprovementType.frequency,
          priority: 0.9,
        ),
      );
    }

    // Volume decline
    if (lastWeekStats.totalVolume > 0) {
      final volumeDecline =
          ((lastWeekStats.totalVolume - stats.totalVolume) /
              lastWeekStats.totalVolume) *
          100;
      if (volumeDecline >= 20) {
        areas.add(
          ImprovementArea(
            title: 'Volume Drop',
            description:
                'Volume decreased by ${volumeDecline.toStringAsFixed(0)}% from last week. '
                'Consider adding more sets.',
            type: ImprovementType.progression,
            priority: 0.7,
          ),
        );
      }
    }

    // Muscle imbalance
    final muscleGroups = stats.muscleGroupsWorked;
    if (muscleGroups.isNotEmpty) {
      final maxSets = muscleGroups.values.reduce((a, b) => a > b ? a : b);

      // Check for push/pull imbalance
      final pushMuscles = ['Chest', 'Shoulders', 'Triceps'];
      final pullMuscles = ['Back', 'Biceps'];

      final pushSets = pushMuscles
          .map((m) => muscleGroups[m] ?? 0)
          .fold(0, (a, b) => a + b);
      final pullSets = pullMuscles
          .map((m) => muscleGroups[m] ?? 0)
          .fold(0, (a, b) => a + b);

      if (pushSets > 0 && pullSets > 0) {
        final ratio = pushSets / pullSets;
        if (ratio > 1.5) {
          areas.add(
            const ImprovementArea(
              title: 'Push/Pull Balance',
              description:
                  'More push than pull work. Add more back and bicep exercises.',
              type: ImprovementType.balance,
              priority: 0.6,
            ),
          );
        } else if (ratio < 0.67) {
          areas.add(
            const ImprovementArea(
              title: 'Push/Pull Balance',
              description:
                  'More pull than push work. Add more chest and shoulder exercises.',
              type: ImprovementType.balance,
              priority: 0.6,
            ),
          );
        }
      }

      // Check for neglected muscle groups
      final neglected = muscleGroups.entries
          .where((e) => e.value < maxSets * 0.3 && e.value > 0)
          .map((e) => e.key)
          .toList();

      if (neglected.isNotEmpty && neglected.length <= 2) {
        areas.add(
          ImprovementArea(
            title: 'Train More: ${neglected.join(", ")}',
            description: 'These muscle groups got less attention this week.',
            type: ImprovementType.balance,
            priority: 0.5,
          ),
        );
      }
    }

    // Low variety
    if (stats.exerciseVariety < 5 && stats.workoutCount >= 2) {
      areas.add(
        ImprovementArea(
          title: 'Exercise Variety',
          description:
              'Only ${stats.exerciseVariety} exercises used. '
              'Try mixing in some new movements.',
          type: ImprovementType.variety,
          priority: 0.4,
        ),
      );
    }

    // Sort by priority
    areas.sort((a, b) => b.priority.compareTo(a.priority));

    return areas.take(3).toList();
  }

  /// Generate personalized recommendations.
  List<String> _generateRecommendations(
    WeeklyStats stats,
    List<ImprovementArea> areasToImprove,
  ) {
    final recommendations = <String>[];

    // Based on workout frequency
    if (stats.workoutCount == 0) {
      recommendations.add(
        'Start with just 2-3 light sessions this week to build momentum.',
      );
    } else if (stats.workoutCount < 3) {
      recommendations.add(
        'Try to fit in ${3 - stats.workoutCount} more workout${stats.workoutCount == 2 ? '' : 's'} to hit your weekly goal.',
      );
    } else if (stats.workoutCount >= 5) {
      recommendations.add(
        "Great frequency! Make sure you're getting enough rest between sessions.",
      );
    }

    // Based on improvement areas
    for (final area in areasToImprove) {
      switch (area.type) {
        case ImprovementType.balance:
          recommendations.add(
            'Consider a dedicated pull day or add 2-3 rowing movements.',
          );
          break;
        case ImprovementType.frequency:
          recommendations.add(
            'Schedule your workouts in advance to stay consistent.',
          );
          break;
        case ImprovementType.variety:
          recommendations.add(
            'Try a new exercise variation for each muscle group.',
          );
          break;
        case ImprovementType.progression:
          recommendations.add(
            'Focus on adding 1 rep or 2.5kg to your main lifts.',
          );
          break;
        case ImprovementType.intensity:
          recommendations.add('Push closer to failure on your last sets.');
          break;
        case ImprovementType.recovery:
          recommendations.add(
            'Prioritize 7-8 hours of sleep for better recovery.',
          );
          break;
      }
    }

    // General recommendations based on stats
    if (stats.totalSets > 100) {
      recommendations.add(
        'High volume week! Consider a lighter deload next week.',
      );
    }

    return recommendations.take(4).toList();
  }

  /// Calculate overall score.
  double _calculateOverallScore(WeeklyStats stats, WeeklyStats lastWeekStats) {
    double score = 0.0;

    // Workout frequency (max 0.4)
    if (stats.workoutCount >= 4) {
      score += 0.4;
    } else if (stats.workoutCount >= 3) {
      score += 0.3;
    } else if (stats.workoutCount >= 2) {
      score += 0.2;
    } else if (stats.workoutCount >= 1) {
      score += 0.1;
    }

    // Volume compared to last week (max 0.3)
    if (lastWeekStats.totalVolume > 0) {
      final volumeRatio = stats.totalVolume / lastWeekStats.totalVolume;
      if (volumeRatio >= 1.1) {
        score += 0.3;
      } else if (volumeRatio >= 1.0) {
        score += 0.25;
      } else if (volumeRatio >= 0.9) {
        score += 0.2;
      } else if (volumeRatio >= 0.8) {
        score += 0.1;
      }
    } else if (stats.totalVolume > 0) {
      score += 0.25; // No baseline, but did something
    }

    // Exercise variety (max 0.15)
    if (stats.exerciseVariety >= 10) {
      score += 0.15;
    } else if (stats.exerciseVariety >= 6) {
      score += 0.1;
    } else if (stats.exerciseVariety >= 3) {
      score += 0.05;
    }

    // Muscle balance (max 0.15)
    final muscleGroupsCount = stats.muscleGroupsWorked.length;
    if (muscleGroupsCount >= 6) {
      score += 0.15;
    } else if (muscleGroupsCount >= 4) {
      score += 0.1;
    } else if (muscleGroupsCount >= 2) {
      score += 0.05;
    }

    return score.clamp(0.0, 1.0);
  }

  /// Determine trend direction.
  TrendDirection _determineTrend(WeeklyStats stats, WeeklyStats lastWeekStats) {
    if (lastWeekStats.totalVolume == 0 && stats.totalVolume == 0) {
      return TrendDirection.stable;
    }

    if (lastWeekStats.totalVolume == 0) {
      return TrendDirection.improving;
    }

    final volumeChange =
        (stats.totalVolume - lastWeekStats.totalVolume) /
        lastWeekStats.totalVolume;
    final workoutChange =
        (stats.workoutCount - lastWeekStats.workoutCount) /
        (lastWeekStats.workoutCount == 0 ? 1 : lastWeekStats.workoutCount);

    final combinedChange = (volumeChange + workoutChange) / 2;

    if (combinedChange >= 0.1) return TrendDirection.improving;
    if (combinedChange <= -0.1) return TrendDirection.declining;
    return TrendDirection.stable;
  }

  /// Generate a summary message.
  String _generateSummaryMessage(
    WeeklyStats stats,
    List<Achievement> achievements,
    TrendDirection trend,
  ) {
    if (stats.workoutCount == 0) {
      return "Rest week? No workouts logged. Let's get after it next week! 💪";
    }

    if (achievements.isNotEmpty) {
      if (trend == TrendDirection.improving) {
        return "Crushing it! You hit ${achievements.length} achievement${achievements.length > 1 ? 's' : ''} and your training is trending up! 🚀";
      }
      return "Great week! ${achievements.first.title}. Keep the momentum going! 💪";
    }

    if (trend == TrendDirection.declining) {
      return "Lighter week - that's okay! Recovery matters. Come back stronger! 🌱";
    }

    if (stats.workoutCount >= 4) {
      return "Solid consistency with ${stats.workoutCount} workouts! That's how progress is made. 📈";
    }

    return "Good start! ${stats.workoutCount} workout${stats.workoutCount > 1 ? 's' : ''} completed. Keep building the habit! 👊";
  }
}

/// Provider for weekly insights service.
final weeklyInsightsServiceProvider = Provider<WeeklyInsightsService>((ref) {
  final workoutRepo = ref.watch(workoutRepositoryProvider);
  final exerciseRepo = ref.watch(exerciseRepositoryProvider);
  return WeeklyInsightsService(workoutRepo, exerciseRepo);
});
