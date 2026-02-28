import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/achievement.dart';

/// Repository for achievements using Drift database.
class AchievementRepository {
  final db.AppDatabase _db;
  static const _uuid = Uuid();

  AchievementRepository(this._db);

  /// Get all achievements.
  Future<List<Achievement>> getAllAchievements() async {
    final query = _db.select(_db.achievements)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]);
    final rows = await query.get();
    return rows.map(_mapToEntity).toList();
  }

  /// Get user achievement progress for all achievements.
  Future<List<UserAchievement>> getUserAchievements() async {
    final achievements = await getAllAchievements();
    final userAchievements = <UserAchievement>[];

    for (final achievement in achievements) {
      final query = _db.select(_db.userAchievements)
        ..where((tbl) => tbl.achievementId.equals(achievement.id));
      final row = await query.getSingleOrNull();

      if (row != null) {
        userAchievements.add(
          UserAchievement(
            id: row.id,
            achievementId: row.achievementId,
            achievement: achievement,
            currentProgress: row.currentProgress,
            isUnlocked: row.isUnlocked,
            unlockedAt: row.unlockedAt,
            isSeen: row.isSeen,
            updatedAt: row.updatedAt,
          ),
        );
      } else {
        // Create default progress entry
        final id = _uuid.v4();
        final now = DateTime.now();
        userAchievements.add(
          UserAchievement(
            id: id,
            achievementId: achievement.id,
            achievement: achievement,
            currentProgress: 0,
            isUnlocked: false,
            isSeen: false,
            updatedAt: now,
          ),
        );
      }
    }

    return userAchievements;
  }

  /// Get user stats.
  Future<UserStats?> getUserStats() async {
    final query = _db.select(_db.userStats)..limit(1);
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    return _mapStatsToEntity(row);
  }

  /// Get or create user stats.
  Future<UserStats> getOrCreateUserStats() async {
    var stats = await getUserStats();
    if (stats != null) return stats;

    // Create initial stats
    final id = 'user-stats';
    final now = DateTime.now();

    await _db
        .into(_db.userStats)
        .insert(
          db.UserStatsCompanion(
            id: Value(id),
            totalWorkouts: const Value(0),
            totalExercises: const Value(0),
            totalSets: const Value(0),
            totalReps: const Value(0),
            totalWeightLifted: const Value(0.0),
            totalMinutes: const Value(0),
            currentStreak: const Value(0),
            longestStreak: const Value(0),
            totalPRs: const Value(0),
            totalXP: const Value(0),
            level: const Value(1),
            updatedAt: Value(now),
          ),
        );

    return UserStats(
      id: id,
      totalWorkouts: 0,
      totalExercises: 0,
      totalSets: 0,
      totalReps: 0,
      totalWeightLifted: 0,
      totalMinutes: 0,
      currentStreak: 0,
      longestStreak: 0,
      totalPRs: 0,
      totalXP: 0,
      level: 1,
      updatedAt: now,
    );
  }

  /// Calculate and update user stats from workouts.
  Future<UserStats> calculateStatsFromWorkouts() async {
    // Get all completed workouts
    final workoutQuery = _db.select(_db.workouts)
      ..where((tbl) => tbl.completedAt.isNotNull())
      ..where((tbl) => tbl.deleted.equals(false));
    final workouts = await workoutQuery.get();

    int totalWorkouts = workouts.length;
    int totalExercises = 0;
    int totalSets = 0;
    int totalReps = 0;
    double totalWeightLifted = 0;
    int totalMinutes = 0;

    for (final workout in workouts) {
      // Calculate duration
      if (workout.completedAt != null) {
        totalMinutes += workout.completedAt!
            .difference(workout.startedAt)
            .inMinutes;
      }

      // Get exercises for this workout
      final exerciseQuery = _db.select(_db.workoutExercises)
        ..where((tbl) => tbl.workoutId.equals(workout.id))
        ..where((tbl) => tbl.deleted.equals(false));
      final exercises = await exerciseQuery.get();
      totalExercises += exercises.length;

      for (final exercise in exercises) {
        // Get sets for this exercise
        final setsQuery = _db.select(_db.exerciseSets)
          ..where((tbl) => tbl.workoutExerciseId.equals(exercise.id))
          ..where((tbl) => tbl.completed.equals(true))
          ..where((tbl) => tbl.deleted.equals(false));
        final sets = await setsQuery.get();

        for (final set in sets) {
          totalSets++;
          totalReps += set.reps;
          totalWeightLifted += set.weight * set.reps;
        }
      }
    }

    // Calculate streak
    int currentStreak = 0;
    int longestStreak = 0;

    if (workouts.isNotEmpty) {
      // Sort by completion date
      workouts.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

      // Get unique dates
      final workoutDates =
          workouts
              .map(
                (w) => DateTime(
                  w.completedAt!.year,
                  w.completedAt!.month,
                  w.completedAt!.day,
                ),
              )
              .toSet()
              .toList()
            ..sort((a, b) => b.compareTo(a));

      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      final yesterday = today.subtract(const Duration(days: 1));

      // Check if streak is active
      if (workoutDates.isNotEmpty) {
        final mostRecent = workoutDates.first;
        if (mostRecent == today || mostRecent == yesterday) {
          currentStreak = 1;
          for (int i = 1; i < workoutDates.length; i++) {
            if (workoutDates[i - 1].difference(workoutDates[i]).inDays == 1) {
              currentStreak++;
            } else {
              break;
            }
          }
        }

        // Calculate longest streak
        int tempStreak = 1;
        longestStreak = 1;
        for (int i = 1; i < workoutDates.length; i++) {
          if (workoutDates[i - 1].difference(workoutDates[i]).inDays == 1) {
            tempStreak++;
            if (tempStreak > longestStreak) {
              longestStreak = tempStreak;
            }
          } else {
            tempStreak = 1;
          }
        }
      }
    }

    // Get PR count
    final prQuery = _db.select(_db.personalRecords)
      ..where((tbl) => tbl.deleted.equals(false));
    final prs = await prQuery.get();
    final totalPRs = prs.length;

    // Calculate XP and level
    final totalXP =
        (totalWorkouts * 50) + (totalPRs * 100) + (currentStreak * 10);
    final level = (totalXP / 1000).floor() + 1;

    final now = DateTime.now();
    final id = 'user-stats';

    // Update or create
    await _db
        .into(_db.userStats)
        .insertOnConflictUpdate(
          db.UserStatsCompanion(
            id: Value(id),
            totalWorkouts: Value(totalWorkouts),
            totalExercises: Value(totalExercises),
            totalSets: Value(totalSets),
            totalReps: Value(totalReps),
            totalWeightLifted: Value(totalWeightLifted),
            totalMinutes: Value(totalMinutes),
            currentStreak: Value(currentStreak),
            longestStreak: Value(
              longestStreak > currentStreak ? longestStreak : currentStreak,
            ),
            totalPRs: Value(totalPRs),
            totalXP: Value(totalXP),
            level: Value(level),
            lastWorkoutAt: Value(
              workouts.isNotEmpty ? workouts.first.completedAt : null,
            ),
            updatedAt: Value(now),
          ),
        );

    return UserStats(
      id: id,
      totalWorkouts: totalWorkouts,
      totalExercises: totalExercises,
      totalSets: totalSets,
      totalReps: totalReps,
      totalWeightLifted: totalWeightLifted,
      totalMinutes: totalMinutes,
      currentStreak: currentStreak,
      longestStreak: longestStreak > currentStreak
          ? longestStreak
          : currentStreak,
      totalPRs: totalPRs,
      totalXP: totalXP,
      level: level,
      lastWorkoutAt: workouts.isNotEmpty ? workouts.first.completedAt : null,
      updatedAt: now,
    );
  }

  /// Update achievement progress based on stats.
  Future<void> updateAchievementProgress(UserStats stats) async {
    final achievements = await getAllAchievements();
    final now = DateTime.now();

    for (final achievement in achievements) {
      int progress = 0;

      switch (achievement.requirementType) {
        case AchievementRequirementType.workoutCount:
          progress = stats.totalWorkouts;
          break;
        case AchievementRequirementType.exerciseCount:
          progress = stats.totalExercises;
          break;
        case AchievementRequirementType.setCount:
          progress = stats.totalSets;
          break;
        case AchievementRequirementType.repCount:
          progress = stats.totalReps;
          break;
        case AchievementRequirementType.weightLifted:
          progress = stats.totalWeightLifted.round();
          break;
        case AchievementRequirementType.prCount:
          progress = stats.totalPRs;
          break;
        case AchievementRequirementType.streakDays:
          progress = stats.currentStreak;
          break;
        case AchievementRequirementType.minutesWorkedOut:
          progress = stats.totalMinutes;
          break;
        default:
          continue;
      }

      final isUnlocked = progress >= achievement.requirementValue;

      // Check if entry exists
      final query = _db.select(_db.userAchievements)
        ..where((tbl) => tbl.achievementId.equals(achievement.id));
      final existing = await query.getSingleOrNull();

      if (existing != null) {
        // Update existing
        final wasUnlocked = existing.isUnlocked;
        await (_db.update(
          _db.userAchievements,
        )..where((tbl) => tbl.achievementId.equals(achievement.id))).write(
          db.UserAchievementsCompanion(
            currentProgress: Value(progress),
            isUnlocked: Value(isUnlocked),
            unlockedAt: isUnlocked && !wasUnlocked
                ? Value(now)
                : const Value.absent(),
            isSeen: isUnlocked && !wasUnlocked
                ? const Value(false)
                : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
      } else {
        // Create new entry
        await _db
            .into(_db.userAchievements)
            .insert(
              db.UserAchievementsCompanion(
                id: Value(_uuid.v4()),
                achievementId: Value(achievement.id),
                currentProgress: Value(progress),
                isUnlocked: Value(isUnlocked),
                unlockedAt: isUnlocked ? Value(now) : const Value.absent(),
                isSeen: const Value(false),
                updatedAt: Value(now),
              ),
            );
      }
    }
  }

  /// Mark achievement as seen.
  Future<void> markAsSeen(String achievementId) async {
    await (_db.update(
      _db.userAchievements,
    )..where((tbl) => tbl.achievementId.equals(achievementId))).write(
      db.UserAchievementsCompanion(
        isSeen: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Seed predefined achievements if they don't exist.
  Future<void> seedPredefinedAchievements() async {
    final existing = await getAllAchievements();
    if (existing.isNotEmpty) return;

    final predefined = _getPredefinedAchievements();
    for (final achievement in predefined) {
      await _db
          .into(_db.achievements)
          .insert(
            db.AchievementsCompanion(
              id: Value(achievement.id),
              name: Value(achievement.name),
              description: Value(achievement.description),
              iconName: Value(achievement.iconName),
              color: Value(achievement.color),
              category: Value(achievement.category.name),
              tier: Value(achievement.tier.name),
              requirementValue: Value(achievement.requirementValue),
              requirementType: Value(achievement.requirementType.name),
              xpReward: Value(achievement.xpReward),
              sortOrder: Value(achievement.sortOrder),
              isPredefined: const Value(true),
            ),
          );
    }
  }

  /// Map database row to domain entity.
  Achievement _mapToEntity(db.Achievement row) {
    return Achievement(
      id: row.id,
      name: row.name,
      description: row.description,
      iconName: row.iconName,
      color: row.color,
      category: _parseCategory(row.category),
      tier: _parseTier(row.tier),
      requirementValue: row.requirementValue,
      requirementType: _parseRequirementType(row.requirementType),
      xpReward: row.xpReward,
      sortOrder: row.sortOrder,
      isPredefined: row.isPredefined,
    );
  }

  /// Map user stats row to entity.
  UserStats _mapStatsToEntity(db.UserStat row) {
    return UserStats(
      id: row.id,
      totalWorkouts: row.totalWorkouts,
      totalExercises: row.totalExercises,
      totalSets: row.totalSets,
      totalReps: row.totalReps,
      totalWeightLifted: row.totalWeightLifted,
      totalMinutes: row.totalMinutes,
      currentStreak: row.currentStreak,
      longestStreak: row.longestStreak,
      totalPRs: row.totalPRs,
      totalXP: row.totalXP,
      level: row.level,
      lastWorkoutAt: row.lastWorkoutAt,
      updatedAt: row.updatedAt,
    );
  }

  AchievementCategory _parseCategory(String value) {
    return AchievementCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AchievementCategory.workout,
    );
  }

  AchievementTier _parseTier(String value) {
    return AchievementTier.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AchievementTier.bronze,
    );
  }

  AchievementRequirementType _parseRequirementType(String value) {
    return AchievementRequirementType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AchievementRequirementType.workoutCount,
    );
  }

  List<Achievement> _getPredefinedAchievements() {
    return const [
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
        sortOrder: 30,
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
        sortOrder: 31,
      ),
    ];
  }
}
