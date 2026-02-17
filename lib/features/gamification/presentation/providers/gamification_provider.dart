import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/gamification.dart';

part 'gamification_provider.g.dart';

/// Provider for user's gamification profile.
@riverpod
class GamificationProfileNotifier extends _$GamificationProfileNotifier {
  @override
  GamificationProfile build() {
    return GamificationProfile(
      oderId: 'user_1',
      currentXP: 850,
      totalXP: 12850,
      level: 23,
      xpToNextLevel: 1200,
      xpForCurrentLevel: 1100,
      currentStreak: 15,
      longestStreak: 32,
      recentXP: _generateRecentXP(),
      lastWorkoutDate: DateTime.now().subtract(const Duration(hours: 20)),
    );
  }

  List<XPTransaction> _generateRecentXP() {
    final random = Random(42);
    final now = DateTime.now();
    final sources = XPSource.values;

    return List.generate(10, (i) {
      final source = sources[random.nextInt(sources.length)];
      return XPTransaction(
        id: 'xp_$i',
        source: source,
        amount: source.baseXP + random.nextInt(50),
        earnedAt: now.subtract(Duration(hours: random.nextInt(72))),
        description: source.label,
      );
    });
  }

  void addXP(XPSource source, {String? description, int? bonusXP}) {
    final amount = source.baseXP + (bonusXP ?? 0);
    final newCurrentXP = state.currentXP + amount;
    final newTotalXP = state.totalXP + amount;

    // Check for level up
    int newLevel = state.level;
    int newXPToNext = state.xpToNextLevel;
    int currentXP = newCurrentXP;

    while (currentXP >= newXPToNext) {
      currentXP -= newXPToNext;
      newLevel++;
      newXPToNext = GamificationProfile.xpForLevel(newLevel + 1);
    }

    final transaction = XPTransaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      source: source,
      amount: amount,
      earnedAt: DateTime.now(),
      description: description,
    );

    state = GamificationProfile(
      oderId: state.oderId,
      currentXP: currentXP,
      totalXP: newTotalXP,
      level: newLevel,
      xpToNextLevel: newXPToNext,
      xpForCurrentLevel: GamificationProfile.xpForLevel(newLevel),
      currentStreak: state.currentStreak,
      longestStreak: state.longestStreak,
      recentXP: [transaction, ...state.recentXP.take(19)],
      lastWorkoutDate: state.lastWorkoutDate,
    );
  }

  void updateStreak(int streak) {
    state = GamificationProfile(
      oderId: state.oderId,
      currentXP: state.currentXP,
      totalXP: state.totalXP,
      level: state.level,
      xpToNextLevel: state.xpToNextLevel,
      xpForCurrentLevel: state.xpForCurrentLevel,
      currentStreak: streak,
      longestStreak: streak > state.longestStreak
          ? streak
          : state.longestStreak,
      recentXP: state.recentXP,
      lastWorkoutDate: DateTime.now(),
    );
  }
}

/// Provider for missions.
@riverpod
class MissionsNotifier extends _$MissionsNotifier {
  @override
  List<Mission> build() {
    return _generateMissions();
  }

  List<Mission> _generateMissions() {
    final now = DateTime.now();
    return [
      // Daily missions
      Mission(
        id: 'd1',
        title: 'Early Bird',
        description: 'Complete a workout before 9 AM',
        type: MissionType.daily,
        difficulty: MissionDifficulty.easy,
        targetValue: 1,
        currentValue: 0,
        xpReward: 50,
        startDate: now,
        endDate: DateTime(now.year, now.month, now.day, 23, 59),
        iconName: 'wb_sunny',
      ),
      Mission(
        id: 'd2',
        title: 'Push It',
        description: 'Complete 100 push exercises',
        type: MissionType.daily,
        difficulty: MissionDifficulty.medium,
        targetValue: 100,
        currentValue: 45,
        xpReward: 75,
        startDate: now,
        endDate: DateTime(now.year, now.month, now.day, 23, 59),
        iconName: 'fitness_center',
      ),
      Mission(
        id: 'd3',
        title: 'Hydration Hero',
        description: 'Log 3L of water',
        type: MissionType.daily,
        difficulty: MissionDifficulty.easy,
        targetValue: 3000,
        currentValue: 2100,
        xpReward: 40,
        startDate: now,
        endDate: DateTime(now.year, now.month, now.day, 23, 59),
        iconName: 'water_drop',
      ),

      // Weekly missions
      Mission(
        id: 'w1',
        title: 'Consistent Champion',
        description: 'Work out 5 days this week',
        type: MissionType.weekly,
        difficulty: MissionDifficulty.medium,
        targetValue: 5,
        currentValue: 3,
        xpReward: 200,
        startDate: now.subtract(Duration(days: now.weekday - 1)),
        endDate: now.add(Duration(days: 7 - now.weekday)),
        iconName: 'event_repeat',
      ),
      Mission(
        id: 'w2',
        title: 'Volume King',
        description: 'Lift 10,000 kg total',
        type: MissionType.weekly,
        difficulty: MissionDifficulty.hard,
        targetValue: 10000,
        currentValue: 6500,
        xpReward: 300,
        startDate: now.subtract(Duration(days: now.weekday - 1)),
        endDate: now.add(Duration(days: 7 - now.weekday)),
        iconName: 'trending_up',
      ),
      Mission(
        id: 'w3',
        title: 'PR Hunter',
        description: 'Set 2 new personal records',
        type: MissionType.weekly,
        difficulty: MissionDifficulty.hard,
        targetValue: 2,
        currentValue: 1,
        xpReward: 350,
        startDate: now.subtract(Duration(days: now.weekday - 1)),
        endDate: now.add(Duration(days: 7 - now.weekday)),
        iconName: 'emoji_events',
      ),

      // Monthly mission
      Mission(
        id: 'm1',
        title: 'Marathon Month',
        description: 'Complete 20 workouts',
        type: MissionType.monthly,
        difficulty: MissionDifficulty.legendary,
        targetValue: 20,
        currentValue: 12,
        xpReward: 500,
        startDate: DateTime(now.year, now.month, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
        iconName: 'military_tech',
      ),
    ];
  }

  void updateProgress(String missionId, int progress) {
    state = state.map((m) {
      if (m.id == missionId) {
        return m.copyWith(currentValue: progress);
      }
      return m;
    }).toList();
  }

  void completeMission(String missionId) {
    state = state.map((m) {
      if (m.id == missionId) {
        return m.copyWith(isCompleted: true);
      }
      return m;
    }).toList();
  }

  void refreshDailyMissions() {
    // In real app, would fetch new daily missions
    final currentMissions = state
        .where((m) => m.type != MissionType.daily)
        .toList();
    state = [
      ...currentMissions,
      ..._generateMissions().where((m) => m.type == MissionType.daily),
    ];
  }
}

/// Provider for streak data.
@riverpod
class StreakNotifier extends _$StreakNotifier {
  @override
  StreakData build() {
    final now = DateTime.now();
    return StreakData(
      currentStreak: 15,
      longestStreak: 32,
      streakDates: List.generate(15, (i) => now.subtract(Duration(days: i))),
      lastActivityDate: now.subtract(const Duration(hours: 20)),
      isAtRisk:
          now.hour >= 20 &&
          now.subtract(const Duration(hours: 20)).day != now.day,
    );
  }

  void incrementStreak() {
    final now = DateTime.now();
    final newStreak = state.currentStreak + 1;
    state = StreakData(
      currentStreak: newStreak,
      longestStreak: newStreak > state.longestStreak
          ? newStreak
          : state.longestStreak,
      streakDates: [now, ...state.streakDates],
      lastActivityDate: now,
      isAtRisk: false,
    );
  }

  void resetStreak() {
    state = StreakData(
      currentStreak: 1,
      longestStreak: state.longestStreak,
      streakDates: [DateTime.now()],
      lastActivityDate: DateTime.now(),
      isAtRisk: false,
    );
  }
}

/// Provider for leaderboard.
@riverpod
class LeaderboardNotifier extends _$LeaderboardNotifier {
  @override
  Map<LeaderboardType, List<LeaderboardEntry>> build() {
    return {
      for (final type in LeaderboardType.values)
        type: _generateLeaderboard(type),
    };
  }

  List<LeaderboardEntry> _generateLeaderboard(LeaderboardType type) {
    final random = Random(type.index);
    final names = [
      'FitnessPro',
      'IronWill',
      'GymRat99',
      'LiftMaster',
      'You',
      'SwolePatrol',
      'BeastMode',
      'GainsTrain',
      'RepKing',
      'FitFam',
    ];

    final entries = List.generate(10, (i) {
      final name = names[i];
      final level = random.nextInt(50) + 10;
      int score;
      switch (type) {
        case LeaderboardType.xp:
          score = (10 - i) * 500 + random.nextInt(200);
          break;
        case LeaderboardType.workouts:
          score = (10 - i) + random.nextInt(3);
          break;
        case LeaderboardType.volume:
          score = (10 - i) * 2000 + random.nextInt(1000);
          break;
        case LeaderboardType.streak:
          score = (10 - i) * 5 + random.nextInt(10);
          break;
      }

      return LeaderboardEntry(
        oderId: 'user_$i',
        userName: name,
        rank: i + 1,
        score: score,
        level: level,
        tier: LevelTier.fromLevel(level),
        isCurrentUser: name == 'You',
      );
    });

    // Sort by score descending
    entries.sort((a, b) => b.score.compareTo(a.score));

    // Update ranks
    return entries.asMap().entries.map((e) {
      return LeaderboardEntry(
        oderId: e.value.oderId,
        userName: e.value.userName,
        rank: e.key + 1,
        score: e.value.score,
        level: e.value.level,
        tier: e.value.tier,
        isCurrentUser: e.value.isCurrentUser,
      );
    }).toList();
  }

  void refresh() {
    state = {
      for (final type in LeaderboardType.values)
        type: _generateLeaderboard(type),
    };
  }
}
