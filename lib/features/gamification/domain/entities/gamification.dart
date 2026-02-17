/// Gamification entities for XP, leveling, and missions.

/// User level tiers.
enum LevelTier {
  beginner(1, 10, 'Beginner', '🌱', 0xFF22C55E),
  intermediate(11, 25, 'Intermediate', '💪', 0xFF3B82F6),
  advanced(26, 50, 'Advanced', '🔥', 0xFFF59E0B),
  elite(51, 75, 'Elite', '⚡', 0xFF8B5CF6),
  master(76, 99, 'Master', '👑', 0xFFEF4444),
  legend(100, 999, 'Legend', '🏆', 0xFFD4AF37);

  final int minLevel;
  final int maxLevel;
  final String title;
  final String emoji;
  final int colorValue;

  const LevelTier(
    this.minLevel,
    this.maxLevel,
    this.title,
    this.emoji,
    this.colorValue,
  );

  static LevelTier fromLevel(int level) {
    for (final tier in LevelTier.values) {
      if (level >= tier.minLevel && level <= tier.maxLevel) {
        return tier;
      }
    }
    return LevelTier.legend;
  }
}

/// XP gain sources.
enum XPSource {
  workoutCompleted('Workout Completed', 100),
  prBroken('PR Broken', 250),
  streakMaintained('Streak Maintained', 50),
  challengeCompleted('Challenge Completed', 200),
  achievementUnlocked('Achievement Unlocked', 150),
  missionCompleted('Mission Completed', 75),
  firstWorkoutOfDay('First Workout', 25),
  consistencyBonus('Consistency Bonus', 100);

  final String label;
  final int baseXP;

  const XPSource(this.label, this.baseXP);
}

/// XP transaction record.
class XPTransaction {
  final String id;
  final XPSource source;
  final int amount;
  final DateTime earnedAt;
  final String? description;

  const XPTransaction({
    required this.id,
    required this.source,
    required this.amount,
    required this.earnedAt,
    this.description,
  });
}

/// User profile with XP and level.
class GamificationProfile {
  final String oderId;
  final int currentXP;
  final int totalXP;
  final int level;
  final int xpToNextLevel;
  final int xpForCurrentLevel;
  final int currentStreak;
  final int longestStreak;
  final List<XPTransaction> recentXP;
  final DateTime? lastWorkoutDate;

  const GamificationProfile({
    required this.oderId,
    required this.currentXP,
    required this.totalXP,
    required this.level,
    required this.xpToNextLevel,
    required this.xpForCurrentLevel,
    required this.currentStreak,
    required this.longestStreak,
    required this.recentXP,
    this.lastWorkoutDate,
  });

  LevelTier get tier => LevelTier.fromLevel(level);
  double get levelProgress =>
      xpToNextLevel > 0 ? currentXP / xpToNextLevel : 1.0;
  int get xpRemaining => xpToNextLevel - currentXP;

  /// Calculate XP needed for a specific level.
  static int xpForLevel(int level) {
    // Exponential growth: 100 * level^1.5
    return (100 * level * (level * 0.5 + 0.5)).round();
  }
}

/// Mission types.
enum MissionType {
  daily('Daily', 1, '📅'),
  weekly('Weekly', 7, '📆'),
  monthly('Monthly', 30, '🗓️'),
  special('Special', 0, '⭐');

  final String label;
  final int durationDays;
  final String emoji;

  const MissionType(this.label, this.durationDays, this.emoji);
}

/// Mission difficulty.
enum MissionDifficulty {
  easy('Easy', 1.0, 0xFF22C55E),
  medium('Medium', 1.5, 0xFFF59E0B),
  hard('Hard', 2.0, 0xFFEF4444),
  legendary('Legendary', 3.0, 0xFF8B5CF6);

  final String label;
  final double xpMultiplier;
  final int colorValue;

  const MissionDifficulty(this.label, this.xpMultiplier, this.colorValue);
}

/// A mission/quest.
class Mission {
  final String id;
  final String title;
  final String description;
  final MissionType type;
  final MissionDifficulty difficulty;
  final int targetValue;
  final int currentValue;
  final int xpReward;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCompleted;
  final String? iconName;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.targetValue,
    required this.currentValue,
    required this.xpReward,
    required this.startDate,
    this.endDate,
    this.isCompleted = false,
    this.iconName,
  });

  double get progress =>
      targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;
  bool get canComplete => currentValue >= targetValue && !isCompleted;
  int get remaining => (targetValue - currentValue).clamp(0, targetValue);

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    MissionType? type,
    MissionDifficulty? difficulty,
    int? targetValue,
    int? currentValue,
    int? xpReward,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
    String? iconName,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      xpReward: xpReward ?? this.xpReward,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
      iconName: iconName ?? this.iconName,
    );
  }
}

/// Streak data.
class StreakData {
  final int currentStreak;
  final int longestStreak;
  final List<DateTime> streakDates;
  final DateTime? lastActivityDate;
  final bool isAtRisk; // Haven't worked out today

  const StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.streakDates,
    this.lastActivityDate,
    this.isAtRisk = false,
  });

  /// Get streak milestone rewards.
  int get nextMilestone {
    const milestones = [7, 14, 30, 60, 90, 180, 365];
    for (final m in milestones) {
      if (currentStreak < m) return m;
    }
    return (currentStreak / 100).ceil() * 100;
  }

  int get daysToNextMilestone => nextMilestone - currentStreak;
}

/// Leaderboard entry.
class LeaderboardEntry {
  final String oderId;
  final String userName;
  final String? avatarUrl;
  final int rank;
  final int score;
  final int level;
  final LevelTier tier;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.oderId,
    required this.userName,
    this.avatarUrl,
    required this.rank,
    required this.score,
    required this.level,
    required this.tier,
    this.isCurrentUser = false,
  });
}

/// Leaderboard types.
enum LeaderboardType {
  xp('XP Earned', 'Total XP this week'),
  workouts('Workouts', 'Workouts completed'),
  volume('Volume', 'Total weight lifted'),
  streak('Streak', 'Current streak days');

  final String label;
  final String description;

  const LeaderboardType(this.label, this.description);
}
