/// Achievement tier levels
enum AchievementTier {
  bronze('Bronze', '🥉', 100),
  silver('Silver', '🥈', 250),
  gold('Gold', '🥇', 500),
  platinum('Platinum', '💎', 1000),
  diamond('Diamond', '💠', 2500);

  final String displayName;
  final String emoji;
  final int baseXP;

  const AchievementTier(this.displayName, this.emoji, this.baseXP);
}

/// Achievement categories
enum AchievementCategory {
  workout('Workout', '🏋️'),
  strength('Strength', '💪'),
  consistency('Consistency', '🔥'),
  progress('Progress', '📈'),
  social('Social', '👥'),
  special('Special', '⭐');

  final String displayName;
  final String emoji;

  const AchievementCategory(this.displayName, this.emoji);
}

/// Requirement types for achievements
enum AchievementRequirementType {
  workoutCount,
  exerciseCount,
  setCount,
  repCount,
  weightLifted,
  prCount,
  streakDays,
  consecutiveWeeks,
  uniqueExercises,
  muscleGroupsHit,
  minutesWorkedOut,
  earlyBirdWorkouts, // Before 7am
  nightOwlWorkouts, // After 9pm
  weekendWarrior, // Weekend workouts
  perfectWeek, // 7 consecutive days
}

/// Domain entity representing an achievement.
class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String color;
  final AchievementCategory category;
  final AchievementTier tier;
  final int requirementValue;
  final AchievementRequirementType requirementType;
  final int xpReward;
  final int sortOrder;
  final bool isPredefined;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.color,
    required this.category,
    required this.tier,
    required this.requirementValue,
    required this.requirementType,
    this.xpReward = 100,
    this.sortOrder = 0,
    this.isPredefined = true,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Achievement &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Domain entity for user's progress on an achievement.
class UserAchievement {
  final String id;
  final String achievementId;
  final Achievement? achievement; // Populated when fetching
  final int currentProgress;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final bool isSeen;
  final DateTime updatedAt;

  const UserAchievement({
    required this.id,
    required this.achievementId,
    this.achievement,
    this.currentProgress = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.isSeen = false,
    required this.updatedAt,
  });

  /// Progress percentage (0.0 to 1.0)
  double get progressPercent {
    if (achievement == null) return 0.0;
    return (currentProgress / achievement!.requirementValue).clamp(0.0, 1.0);
  }

  /// Whether this is a newly unlocked achievement (unlocked but not seen)
  bool get isNew => isUnlocked && !isSeen;

  UserAchievement copyWith({
    String? id,
    String? achievementId,
    Achievement? achievement,
    int? currentProgress,
    bool? isUnlocked,
    DateTime? unlockedAt,
    bool? isSeen,
    DateTime? updatedAt,
  }) {
    return UserAchievement(
      id: id ?? this.id,
      achievementId: achievementId ?? this.achievementId,
      achievement: achievement ?? this.achievement,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isSeen: isSeen ?? this.isSeen,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Domain entity for user statistics.
class UserStats {
  final String id;
  final int totalWorkouts;
  final int totalExercises;
  final int totalSets;
  final int totalReps;
  final double totalWeightLifted;
  final int totalMinutes;
  final int currentStreak;
  final int longestStreak;
  final int totalPRs;
  final int totalXP;
  final int level;
  final DateTime? lastWorkoutAt;
  final DateTime updatedAt;

  const UserStats({
    required this.id,
    this.totalWorkouts = 0,
    this.totalExercises = 0,
    this.totalSets = 0,
    this.totalReps = 0,
    this.totalWeightLifted = 0.0,
    this.totalMinutes = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalPRs = 0,
    this.totalXP = 0,
    this.level = 1,
    this.lastWorkoutAt,
    required this.updatedAt,
  });

  /// XP required for next level
  int get xpForNextLevel => level * 1000;

  /// XP progress in current level
  int get xpInCurrentLevel => totalXP % 1000;

  /// Progress to next level (0.0 to 1.0)
  double get levelProgress => xpInCurrentLevel / xpForNextLevel;

  /// Title based on level
  String get title {
    if (level < 5) return 'Beginner';
    if (level < 10) return 'Novice';
    if (level < 20) return 'Intermediate';
    if (level < 35) return 'Advanced';
    if (level < 50) return 'Expert';
    if (level < 75) return 'Master';
    if (level < 100) return 'Legend';
    return 'Immortal';
  }

  UserStats copyWith({
    String? id,
    int? totalWorkouts,
    int? totalExercises,
    int? totalSets,
    int? totalReps,
    double? totalWeightLifted,
    int? totalMinutes,
    int? currentStreak,
    int? longestStreak,
    int? totalPRs,
    int? totalXP,
    int? level,
    DateTime? lastWorkoutAt,
    DateTime? updatedAt,
  }) {
    return UserStats(
      id: id ?? this.id,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalExercises: totalExercises ?? this.totalExercises,
      totalSets: totalSets ?? this.totalSets,
      totalReps: totalReps ?? this.totalReps,
      totalWeightLifted: totalWeightLifted ?? this.totalWeightLifted,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalPRs: totalPRs ?? this.totalPRs,
      totalXP: totalXP ?? this.totalXP,
      level: level ?? this.level,
      lastWorkoutAt: lastWorkoutAt ?? this.lastWorkoutAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
