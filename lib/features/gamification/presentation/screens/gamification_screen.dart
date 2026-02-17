import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/gamification.dart';
import '../providers/gamification_provider.dart';

/// Screen for XP, leveling, and missions.
class GamificationScreen extends ConsumerStatefulWidget {
  const GamificationScreen({super.key});

  @override
  ConsumerState<GamificationScreen> createState() => _GamificationScreenState();
}

class _GamificationScreenState extends ConsumerState<GamificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(gamificationProfileNotifierProvider);
    final streak = ref.watch(streakNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(profile, streak),
            ),
            title: innerBoxIsScrolled ? const Text('Level Up') : null,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondaryDark,
              tabs: const [
                Tab(text: 'Missions'),
                Tab(text: 'Leaderboard'),
                Tab(text: 'Rewards'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMissionsTab(),
            _buildLeaderboardTab(),
            _buildRewardsTab(profile),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(GamificationProfile profile, StreakData streak) {
    final tierColor = Color(profile.tier.colorValue);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 56,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [tierColor.withValues(alpha: 0.3), AppColors.backgroundDark],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Level badge
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: profile.levelProgress,
                      strokeWidth: 6,
                      backgroundColor: AppColors.surfaceDark,
                      valueColor: AlwaysStoppedAnimation(tierColor),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        profile.tier.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        '${profile.level}',
                        style: TextStyle(
                          color: tierColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.tier.title,
                      style: TextStyle(
                        color: tierColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.currentXP} / ${profile.xpToNextLevel} XP',
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${profile.xpRemaining} XP to level ${profile.level + 1}',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats row
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.local_fire_department,
                  label: 'Streak',
                  value: '${streak.currentStreak}',
                  color: streak.isAtRisk
                      ? AppColors.warning
                      : const Color(0xFFF97316),
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.star,
                  label: 'Total XP',
                  value: '${profile.totalXP}',
                  color: const Color(0xFFF59E0B),
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.emoji_events,
                  label: 'Best Streak',
                  value: '${streak.longestStreak}',
                  color: const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Streak warning
          if (streak.isAtRisk)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: AppColors.warning, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Work out today to keep your streak!',
                      style: TextStyle(color: AppColors.warning, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMissionsTab() {
    final missions = ref.watch(missionsNotifierProvider);

    // Group by type
    final daily = missions.where((m) => m.type == MissionType.daily).toList();
    final weekly = missions.where((m) => m.type == MissionType.weekly).toList();
    final monthly = missions
        .where((m) => m.type == MissionType.monthly)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (daily.isNotEmpty) ...[
          _SectionHeader(title: '${MissionType.daily.emoji} Daily Missions'),
          ...daily.map((m) => _MissionCard(mission: m)),
        ],
        if (weekly.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionHeader(title: '${MissionType.weekly.emoji} Weekly Missions'),
          ...weekly.map((m) => _MissionCard(mission: m)),
        ],
        if (monthly.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionHeader(
            title: '${MissionType.monthly.emoji} Monthly Missions',
          ),
          ...monthly.map((m) => _MissionCard(mission: m)),
        ],
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildLeaderboardTab() {
    final leaderboards = ref.watch(leaderboardNotifierProvider);

    return DefaultTabController(
      length: LeaderboardType.values.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondaryDark,
            tabs: LeaderboardType.values
                .map((t) => Tab(text: t.label))
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: LeaderboardType.values.map((type) {
                final entries = leaderboards[type] ?? [];
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _LeaderboardCard(entry: entry, type: type);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsTab(GamificationProfile profile) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionHeader(title: '🎁 Recent XP'),
        ...profile.recentXP.take(10).map((xp) => _XPCard(transaction: xp)),
        const SizedBox(height: 24),
        const _SectionHeader(title: '🏆 Level Rewards'),
        _buildLevelRewards(profile),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildLevelRewards(GamificationProfile profile) {
    final rewards = [
      (
        level: 10,
        reward: 'Custom Profile Badge',
        unlocked: profile.level >= 10,
      ),
      (level: 25, reward: 'Advanced Analytics', unlocked: profile.level >= 25),
      (level: 50, reward: 'Elite Status', unlocked: profile.level >= 50),
      (level: 75, reward: 'Master Title', unlocked: profile.level >= 75),
      (level: 100, reward: 'Legend Badge', unlocked: profile.level >= 100),
    ];

    return Column(
      children: rewards.map((r) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: r.unlocked
                ? AppColors.success.withValues(alpha: 0.15)
                : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: r.unlocked
                ? Border.all(color: AppColors.success.withValues(alpha: 0.5))
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: r.unlocked
                      ? AppColors.success
                      : AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: r.unlocked
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '${r.level}',
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${r.level}',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      r.reward,
                      style: TextStyle(
                        color: r.unlocked
                            ? AppColors.success
                            : AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (r.unlocked)
                const Icon(Icons.verified, color: AppColors.success),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MissionCard extends ConsumerWidget {
  final Mission mission;

  const _MissionCard({required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diffColor = Color(mission.difficulty.colorValue);

    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: diffColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    mission.isCompleted ? Icons.check : Icons.flag,
                    color: diffColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.title,
                        style: TextStyle(
                          color: mission.isCompleted
                              ? AppColors.textSecondaryDark
                              : AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                          decoration: mission.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Text(
                        mission.description,
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '+${mission.xpReward} XP',
                    style: const TextStyle(
                      color: Color(0xFFF59E0B),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (!mission.isCompleted) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: mission.progress,
                        backgroundColor: AppColors.backgroundDark,
                        valueColor: AlwaysStoppedAnimation(diffColor),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${mission.currentValue}/${mission.targetValue}',
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
            if (mission.canComplete) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    ref
                        .read(missionsNotifierProvider.notifier)
                        .completeMission(mission.id);
                    ref
                        .read(gamificationProfileNotifierProvider.notifier)
                        .addXP(XPSource.missionCompleted);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: diffColor),
                  child: const Text('Claim Reward'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final LeaderboardEntry entry;
  final LeaderboardType type;

  const _LeaderboardCard({required this.entry, required this.type});

  @override
  Widget build(BuildContext context) {
    final isTopThree = entry.rank <= 3;
    final medals = ['🥇', '🥈', '🥉'];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: entry.isCurrentUser
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.5))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: isTopThree
                ? Text(
                    medals[entry.rank - 1],
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    '#${entry.rank}',
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: Color(
              entry.tier.colorValue,
            ).withValues(alpha: 0.2),
            child: Text(entry.tier.emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.userName,
                  style: TextStyle(
                    color: entry.isCurrentUser
                        ? AppColors.primary
                        : AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Level ${entry.level} ${entry.tier.title}',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatScore(entry.score, type),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatScore(int score, LeaderboardType type) {
    switch (type) {
      case LeaderboardType.xp:
        return '${score}xp';
      case LeaderboardType.workouts:
        return '$score';
      case LeaderboardType.volume:
        return '${(score / 1000).toStringAsFixed(1)}k';
      case LeaderboardType.streak:
        return '${score}d';
    }
  }
}

class _XPCard extends StatelessWidget {
  final XPTransaction transaction;

  const _XPCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.star, color: Color(0xFFF59E0B), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.source.label,
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _timeAgo(transaction.earnedAt),
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '+${transaction.amount}',
            style: const TextStyle(
              color: Color(0xFFF59E0B),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
