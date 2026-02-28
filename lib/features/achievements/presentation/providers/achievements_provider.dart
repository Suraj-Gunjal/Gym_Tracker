import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/achievement_repository_impl.dart';
import '../../domain/entities/achievement.dart';

part 'achievements_provider.g.dart';

/// Provider for achievement repository
@riverpod
AchievementRepository achievementRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return AchievementRepository(db);
}

/// Provider for all achievements
@riverpod
class AchievementsNotifier extends _$AchievementsNotifier {
  @override
  Future<List<Achievement>> build() async {
    final repository = ref.watch(achievementRepositoryProvider);
    // Seed predefined achievements if needed
    await repository.seedPredefinedAchievements();
    return repository.getAllAchievements();
  }
}

/// Provider for user achievement progress
@riverpod
class UserAchievementsNotifier extends _$UserAchievementsNotifier {
  @override
  Future<List<UserAchievement>> build() async {
    final repository = ref.watch(achievementRepositoryProvider);
    // Calculate and update stats from workouts first
    final stats = await repository.calculateStatsFromWorkouts();
    // Update achievement progress based on stats
    await repository.updateAchievementProgress(stats);
    // Return user achievements with progress
    return repository.getUserAchievements();
  }

  Future<void> updateProgress(String achievementId, int newProgress) async {
    final repository = ref.read(achievementRepositoryProvider);
    final stats = await repository.calculateStatsFromWorkouts();
    await repository.updateAchievementProgress(stats);
    ref.invalidateSelf();
  }

  Future<void> markAsSeen(String achievementId) async {
    final repository = ref.read(achievementRepositoryProvider);
    await repository.markAsSeen(achievementId);
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Provider for user stats
@riverpod
class UserStatsNotifier extends _$UserStatsNotifier {
  @override
  Future<UserStats> build() async {
    final repository = ref.watch(achievementRepositoryProvider);
    // Calculate real stats from workout data
    return repository.calculateStatsFromWorkouts();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Unlocked achievements
@riverpod
List<UserAchievement> unlockedAchievements(Ref ref) {
  final userAchievementsAsync = ref.watch(userAchievementsNotifierProvider);
  return userAchievementsAsync.when(
    data: (userAchievements) =>
        userAchievements.where((ua) => ua.isUnlocked).toList()..sort(
          (a, b) => (b.unlockedAt ?? DateTime(1970)).compareTo(
            a.unlockedAt ?? DateTime(1970),
          ),
        ),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// In-progress achievements
@riverpod
List<UserAchievement> inProgressAchievements(Ref ref) {
  final userAchievementsAsync = ref.watch(userAchievementsNotifierProvider);
  return userAchievementsAsync.when(
    data: (userAchievements) =>
        userAchievements
            .where((ua) => !ua.isUnlocked && ua.currentProgress > 0)
            .toList()
          ..sort((a, b) => b.progressPercent.compareTo(a.progressPercent)),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Achievements by category
@riverpod
Map<AchievementCategory, List<UserAchievement>> achievementsByCategory(
  Ref ref,
) {
  final userAchievementsAsync = ref.watch(userAchievementsNotifierProvider);
  return userAchievementsAsync.when(
    data: (userAchievements) {
      final map = <AchievementCategory, List<UserAchievement>>{};

      for (final category in AchievementCategory.values) {
        map[category] = userAchievements
            .where((ua) => ua.achievement?.category == category)
            .toList();
      }

      return map;
    },
    loading: () => {},
    error: (_, __) => {},
  );
}

/// New (unseen) achievements count
@riverpod
int newAchievementsCount(Ref ref) {
  final userAchievementsAsync = ref.watch(userAchievementsNotifierProvider);
  return userAchievementsAsync.when(
    data: (userAchievements) => userAchievements.where((ua) => ua.isNew).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}
