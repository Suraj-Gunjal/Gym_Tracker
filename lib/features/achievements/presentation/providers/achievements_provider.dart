import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/achievement.dart';

part 'achievements_provider.g.dart';

/// Provider for all achievements
@riverpod
class AchievementsNotifier extends _$AchievementsNotifier {
  @override
  List<Achievement> build() {
    return _getPredefinedAchievements();
  }

  List<Achievement> _getPredefinedAchievements() {
    return const [
      // Workout Count Achievements
      Achievement(
        id: 'first-workout',
        name: 'First Steps',
        description: 'Complete your first workout',
        iconName: 'emoji_events',
        color: '#22C55E',
        category: AchievementCategory.workout,
        tier: AchievementTier.bronze,
        requirementValue: 1,
        requirementType: AchievementRequirementType.workoutCount,
        xpReward: 50,
        sortOrder: 1,
      ),
      Achievement(
        id: 'workout-10',
        name: 'Getting Started',
        description: 'Complete 10 workouts',
        iconName: 'fitness_center',
        color: '#22C55E',
        category: AchievementCategory.workout,
        tier: AchievementTier.bronze,
        requirementValue: 10,
        requirementType: AchievementRequirementType.workoutCount,
        xpReward: 100,
        sortOrder: 2,
      ),
      Achievement(
        id: 'workout-50',
        name: 'Dedicated',
        description: 'Complete 50 workouts',
        iconName: 'fitness_center',
        color: '#3B82F6',
        category: AchievementCategory.workout,
        tier: AchievementTier.silver,
        requirementValue: 50,
        requirementType: AchievementRequirementType.workoutCount,
        xpReward: 250,
        sortOrder: 3,
      ),
      Achievement(
        id: 'workout-100',
        name: 'Century Club',
        description: 'Complete 100 workouts',
        iconName: 'military_tech',
        color: '#F59E0B',
        category: AchievementCategory.workout,
        tier: AchievementTier.gold,
        requirementValue: 100,
        requirementType: AchievementRequirementType.workoutCount,
        xpReward: 500,
        sortOrder: 4,
      ),
      Achievement(
        id: 'workout-500',
        name: 'Iron Warrior',
        description: 'Complete 500 workouts',
        iconName: 'workspace_premium',
        color: '#8B5CF6',
        category: AchievementCategory.workout,
        tier: AchievementTier.platinum,
        requirementValue: 500,
        requirementType: AchievementRequirementType.workoutCount,
        xpReward: 1000,
        sortOrder: 5,
      ),

      // Streak Achievements
      Achievement(
        id: 'streak-3',
        name: 'On Fire',
        description: 'Maintain a 3-day workout streak',
        iconName: 'local_fire_department',
        color: '#EF4444',
        category: AchievementCategory.consistency,
        tier: AchievementTier.bronze,
        requirementValue: 3,
        requirementType: AchievementRequirementType.streakDays,
        xpReward: 75,
        sortOrder: 10,
      ),
      Achievement(
        id: 'streak-7',
        name: 'Week Warrior',
        description: 'Maintain a 7-day workout streak',
        iconName: 'local_fire_department',
        color: '#F59E0B',
        category: AchievementCategory.consistency,
        tier: AchievementTier.silver,
        requirementValue: 7,
        requirementType: AchievementRequirementType.streakDays,
        xpReward: 200,
        sortOrder: 11,
      ),
      Achievement(
        id: 'streak-30',
        name: 'Monthly Beast',
        description: 'Maintain a 30-day workout streak',
        iconName: 'whatshot',
        color: '#EF4444',
        category: AchievementCategory.consistency,
        tier: AchievementTier.gold,
        requirementValue: 30,
        requirementType: AchievementRequirementType.streakDays,
        xpReward: 750,
        sortOrder: 12,
      ),
      Achievement(
        id: 'streak-100',
        name: 'Unstoppable',
        description: 'Maintain a 100-day workout streak',
        iconName: 'bolt',
        color: '#8B5CF6',
        category: AchievementCategory.consistency,
        tier: AchievementTier.diamond,
        requirementValue: 100,
        requirementType: AchievementRequirementType.streakDays,
        xpReward: 2500,
        sortOrder: 13,
      ),

      // PR Achievements
      Achievement(
        id: 'first-pr',
        name: 'Personal Best',
        description: 'Hit your first personal record',
        iconName: 'emoji_events',
        color: '#FFD700',
        category: AchievementCategory.strength,
        tier: AchievementTier.bronze,
        requirementValue: 1,
        requirementType: AchievementRequirementType.prCount,
        xpReward: 100,
        sortOrder: 20,
      ),
      Achievement(
        id: 'pr-10',
        name: 'Record Breaker',
        description: 'Hit 10 personal records',
        iconName: 'trending_up',
        color: '#F59E0B',
        category: AchievementCategory.strength,
        tier: AchievementTier.silver,
        requirementValue: 10,
        requirementType: AchievementRequirementType.prCount,
        xpReward: 300,
        sortOrder: 21,
      ),
      Achievement(
        id: 'pr-50',
        name: 'PR Machine',
        description: 'Hit 50 personal records',
        iconName: 'military_tech',
        color: '#FFD700',
        category: AchievementCategory.strength,
        tier: AchievementTier.gold,
        requirementValue: 50,
        requirementType: AchievementRequirementType.prCount,
        xpReward: 750,
        sortOrder: 22,
      ),

      // Volume Achievements
      Achievement(
        id: 'weight-1000',
        name: 'Tonnage',
        description: 'Lift a total of 1,000 kg',
        iconName: 'fitness_center',
        color: '#6366F1',
        category: AchievementCategory.progress,
        tier: AchievementTier.bronze,
        requirementValue: 1000,
        requirementType: AchievementRequirementType.weightLifted,
        xpReward: 100,
        sortOrder: 30,
      ),
      Achievement(
        id: 'weight-10000',
        name: 'Heavy Lifter',
        description: 'Lift a total of 10,000 kg',
        iconName: 'fitness_center',
        color: '#6366F1',
        category: AchievementCategory.progress,
        tier: AchievementTier.silver,
        requirementValue: 10000,
        requirementType: AchievementRequirementType.weightLifted,
        xpReward: 300,
        sortOrder: 31,
      ),
      Achievement(
        id: 'weight-100000',
        name: 'Iron Giant',
        description: 'Lift a total of 100,000 kg',
        iconName: 'fitness_center',
        color: '#F59E0B',
        category: AchievementCategory.progress,
        tier: AchievementTier.gold,
        requirementValue: 100000,
        requirementType: AchievementRequirementType.weightLifted,
        xpReward: 750,
        sortOrder: 32,
      ),
      Achievement(
        id: 'weight-1000000',
        name: 'Mountain Mover',
        description: 'Lift a total of 1,000,000 kg',
        iconName: 'landscape',
        color: '#8B5CF6',
        category: AchievementCategory.progress,
        tier: AchievementTier.diamond,
        requirementValue: 1000000,
        requirementType: AchievementRequirementType.weightLifted,
        xpReward: 5000,
        sortOrder: 33,
      ),

      // Special Achievements
      Achievement(
        id: 'early-bird',
        name: 'Early Bird',
        description: 'Complete a workout before 7 AM',
        iconName: 'wb_sunny',
        color: '#F59E0B',
        category: AchievementCategory.special,
        tier: AchievementTier.bronze,
        requirementValue: 1,
        requirementType: AchievementRequirementType.earlyBirdWorkouts,
        xpReward: 100,
        sortOrder: 40,
      ),
      Achievement(
        id: 'night-owl',
        name: 'Night Owl',
        description: 'Complete a workout after 9 PM',
        iconName: 'nightlight_round',
        color: '#6366F1',
        category: AchievementCategory.special,
        tier: AchievementTier.bronze,
        requirementValue: 1,
        requirementType: AchievementRequirementType.nightOwlWorkouts,
        xpReward: 100,
        sortOrder: 41,
      ),
      Achievement(
        id: 'weekend-warrior',
        name: 'Weekend Warrior',
        description: 'Complete 10 weekend workouts',
        iconName: 'weekend',
        color: '#22C55E',
        category: AchievementCategory.special,
        tier: AchievementTier.silver,
        requirementValue: 10,
        requirementType: AchievementRequirementType.weekendWarrior,
        xpReward: 200,
        sortOrder: 42,
      ),
    ];
  }
}

/// Provider for user achievement progress
@riverpod
class UserAchievementsNotifier extends _$UserAchievementsNotifier {
  final _uuid = const Uuid();

  @override
  List<UserAchievement> build() {
    final achievements = ref.watch(achievementsNotifierProvider);
    // Initialize with sample progress
    return achievements.map((a) {
      int progress = 0;
      bool unlocked = false;

      // Sample progress for demonstration
      switch (a.requirementType) {
        case AchievementRequirementType.workoutCount:
          progress = 25;
          unlocked = progress >= a.requirementValue;
          break;
        case AchievementRequirementType.streakDays:
          progress = 5;
          unlocked = progress >= a.requirementValue;
          break;
        case AchievementRequirementType.prCount:
          progress = 8;
          unlocked = progress >= a.requirementValue;
          break;
        case AchievementRequirementType.weightLifted:
          progress = 15000;
          unlocked = progress >= a.requirementValue;
          break;
        default:
          progress = 0;
      }

      return UserAchievement(
        id: _uuid.v4(),
        achievementId: a.id,
        achievement: a,
        currentProgress: progress,
        isUnlocked: unlocked,
        unlockedAt: unlocked
            ? DateTime.now().subtract(const Duration(days: 5))
            : null,
        isSeen: unlocked,
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  void updateProgress(String achievementId, int newProgress) {
    state = [
      for (final ua in state)
        if (ua.achievementId == achievementId)
          ua.copyWith(
            currentProgress: newProgress,
            isUnlocked:
                ua.achievement != null &&
                newProgress >= ua.achievement!.requirementValue,
            unlockedAt:
                ua.achievement != null &&
                    newProgress >= ua.achievement!.requirementValue &&
                    !ua.isUnlocked
                ? DateTime.now()
                : ua.unlockedAt,
            updatedAt: DateTime.now(),
          )
        else
          ua,
    ];
  }

  void markAsSeen(String achievementId) {
    state = [
      for (final ua in state)
        if (ua.achievementId == achievementId)
          ua.copyWith(isSeen: true, updatedAt: DateTime.now())
        else
          ua,
    ];
  }
}

/// Provider for user stats
@riverpod
class UserStatsNotifier extends _$UserStatsNotifier {
  @override
  UserStats build() {
    // Sample stats for demonstration
    return UserStats(
      id: 'user-stats',
      totalWorkouts: 25,
      totalExercises: 312,
      totalSets: 945,
      totalReps: 8420,
      totalWeightLifted: 15750.5,
      totalMinutes: 1875,
      currentStreak: 5,
      longestStreak: 12,
      totalPRs: 8,
      totalXP: 2750,
      level: 3,
      lastWorkoutAt: DateTime.now().subtract(const Duration(hours: 18)),
      updatedAt: DateTime.now(),
    );
  }

  void addWorkoutStats({
    int exercises = 0,
    int sets = 0,
    int reps = 0,
    double weightLifted = 0,
    int minutes = 0,
    int prs = 0,
    int xp = 0,
  }) {
    final now = DateTime.now();
    final lastWorkout = state.lastWorkoutAt;

    // Calculate streak
    int newStreak = state.currentStreak;
    if (lastWorkout == null) {
      newStreak = 1;
    } else {
      final daysSince = now.difference(lastWorkout).inDays;
      if (daysSince <= 1) {
        newStreak = state.currentStreak + 1;
      } else {
        newStreak = 1;
      }
    }

    state = state.copyWith(
      totalWorkouts: state.totalWorkouts + 1,
      totalExercises: state.totalExercises + exercises,
      totalSets: state.totalSets + sets,
      totalReps: state.totalReps + reps,
      totalWeightLifted: state.totalWeightLifted + weightLifted,
      totalMinutes: state.totalMinutes + minutes,
      currentStreak: newStreak,
      longestStreak: newStreak > state.longestStreak
          ? newStreak
          : state.longestStreak,
      totalPRs: state.totalPRs + prs,
      totalXP: state.totalXP + xp,
      level: ((state.totalXP + xp) / 1000).floor() + 1,
      lastWorkoutAt: now,
      updatedAt: now,
    );
  }
}

/// Unlocked achievements
@riverpod
List<UserAchievement> unlockedAchievements(Ref ref) {
  final userAchievements = ref.watch(userAchievementsNotifierProvider);
  return userAchievements.where((ua) => ua.isUnlocked).toList()..sort(
    (a, b) => (b.unlockedAt ?? DateTime(1970)).compareTo(
      a.unlockedAt ?? DateTime(1970),
    ),
  );
}

/// In-progress achievements
@riverpod
List<UserAchievement> inProgressAchievements(Ref ref) {
  final userAchievements = ref.watch(userAchievementsNotifierProvider);
  return userAchievements
      .where((ua) => !ua.isUnlocked && ua.currentProgress > 0)
      .toList()
    ..sort((a, b) => b.progressPercent.compareTo(a.progressPercent));
}

/// Achievements by category
@riverpod
Map<AchievementCategory, List<UserAchievement>> achievementsByCategory(
  Ref ref,
) {
  final userAchievements = ref.watch(userAchievementsNotifierProvider);
  final map = <AchievementCategory, List<UserAchievement>>{};

  for (final category in AchievementCategory.values) {
    map[category] = userAchievements
        .where((ua) => ua.achievement?.category == category)
        .toList();
  }

  return map;
}

/// New (unseen) achievements count
@riverpod
int newAchievementsCount(Ref ref) {
  final userAchievements = ref.watch(userAchievementsNotifierProvider);
  return userAchievements.where((ua) => ua.isNew).length;
}
