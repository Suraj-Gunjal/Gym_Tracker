import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/achievement.dart';
import '../providers/achievements_provider.dart';
import '../widgets/achievement_card.dart';
import '../widgets/level_progress_card.dart';
import '../widgets/stats_overview_card.dart';

/// Screen displaying achievements and gamification elements.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStatsAsync = ref.watch(userStatsNotifierProvider);
    final unlockedAchievements = ref.watch(unlockedAchievementsProvider);
    final inProgressAchievements = ref.watch(inProgressAchievementsProvider);
    final achievementsByCategory = ref.watch(achievementsByCategoryProvider);

    return userStatsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (userStats) => Scaffold(
        body: CustomScrollView(
          slivers: [
            // App Bar with level display
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.backgroundDark,
              flexibleSpace: FlexibleSpaceBar(
                background: _HeaderBackground(userStats: userStats),
              ),
            ),

            // Stats overview
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StatsOverviewCard(stats: userStats),
              ),
            ),

            // Level progress
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LevelProgressCard(stats: userStats),
              ),
            ),

            // Streak card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _StreakCard(
                  currentStreak: userStats.currentStreak,
                  longestStreak: userStats.longestStreak,
                ),
              ),
            ),

            // In Progress section
            if (inProgressAchievements.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    'Almost There! 🎯',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: inProgressAchievements.take(5).length,
                    itemBuilder: (context, index) {
                      final ua = inProgressAchievements[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          width: 140,
                          child: AchievementCard(
                            userAchievement: ua,
                            compact: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],

            // Recent unlocks
            if (unlockedAchievements.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recently Unlocked 🏆',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      Text(
                        '${unlockedAchievements.length} total',
                        style: TextStyle(color: AppColors.textSecondaryDark),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final ua = unlockedAchievements[index];
                    return AchievementCard(
                      userAchievement: ua,
                      onTap: () => _showAchievementDetail(context, ua),
                    );
                  }, childCount: unlockedAchievements.take(4).length),
                ),
              ),
            ],

            // All achievements by category
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'All Achievements',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ),
            ),

            // Category tabs
            SliverToBoxAdapter(
              child: _CategoryTabs(
                achievementsByCategory: achievementsByCategory,
              ),
            ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetail(BuildContext context, UserAchievement ua) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _AchievementDetailSheet(userAchievement: ua),
    );
  }
}

/// Header background with gradient and level display
class _HeaderBackground extends StatelessWidget {
  final UserStats userStats;

  const _HeaderBackground({required this.userStats});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.backgroundDark,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Achievements',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  // Level badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.military_tech,
                          color: AppColors.prGold,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Level ${userStats.level}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              userStats.title,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // XP display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: AppColors.prGold, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${userStats.totalXP} XP',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Streak card
class _StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;

  const _StreakCard({required this.currentStreak, required this.longestStreak});

  @override
  Widget build(BuildContext context) {
    final isOnFire = currentStreak >= 3;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOnFire
              ? [const Color(0xFFEF4444), const Color(0xFFF59E0B)]
              : [AppColors.cardDark, AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isOnFire
            ? [
                BoxShadow(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Flame icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isOnFire ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.local_fire_department,
              color: isOnFire ? Colors.white : AppColors.textTertiaryDark,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Streak',
                  style: TextStyle(
                    color: isOnFire
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.textSecondaryDark,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '$currentStreak',
                      style: TextStyle(
                        color: isOnFire
                            ? Colors.white
                            : AppColors.textPrimaryDark,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'days',
                      style: TextStyle(
                        color: isOnFire
                            ? Colors.white.withValues(alpha: 0.8)
                            : AppColors.textSecondaryDark,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Best streak
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isOnFire ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: isOnFire ? Colors.white : AppColors.prGold,
                  size: 18,
                ),
                const SizedBox(height: 2),
                Text(
                  '$longestStreak',
                  style: TextStyle(
                    color: isOnFire ? Colors.white : AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'best',
                  style: TextStyle(
                    color: isOnFire
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.textTertiaryDark,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Category tabs for browsing achievements
class _CategoryTabs extends StatefulWidget {
  final Map<AchievementCategory, List<UserAchievement>> achievementsByCategory;

  const _CategoryTabs({required this.achievementsByCategory});

  @override
  State<_CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<_CategoryTabs> {
  AchievementCategory _selectedCategory = AchievementCategory.workout;

  @override
  Widget build(BuildContext context) {
    final achievements = widget.achievementsByCategory[_selectedCategory] ?? [];

    return Column(
      children: [
        // Category chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: AchievementCategory.values.map((category) {
              final isSelected = _selectedCategory == category;
              final count =
                  widget.achievementsByCategory[category]
                      ?.where((ua) => ua.isUnlocked)
                      .length ??
                  0;
              final total =
                  widget.achievementsByCategory[category]?.length ?? 0;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(category.emoji),
                      const SizedBox(width: 4),
                      Text(category.displayName),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.2)
                              : AppColors.cardDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$count/$total',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textTertiaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedCategory = category);
                  },
                  backgroundColor: AppColors.cardDark,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondaryDark,
                  ),
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Achievements grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              return AchievementCard(userAchievement: achievements[index]);
            },
          ),
        ),
      ],
    );
  }
}

/// Achievement detail bottom sheet
class _AchievementDetailSheet extends StatelessWidget {
  final UserAchievement userAchievement;

  const _AchievementDetailSheet({required this.userAchievement});

  @override
  Widget build(BuildContext context) {
    final achievement = userAchievement.achievement;
    if (achievement == null) return const SizedBox();

    final color = Color(int.parse(achievement.color.replaceFirst('#', '0xFF')));

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiaryDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: userAchievement.isUnlocked
                  ? Border.all(color: color, width: 3)
                  : null,
            ),
            child: Icon(
              _getIconData(achievement.iconName),
              color: userAchievement.isUnlocked
                  ? color
                  : AppColors.textTertiaryDark,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            achievement.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryDark,
            ),
          ),
          const SizedBox(height: 8),

          // Tier badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${achievement.tier.emoji} ${achievement.tier.displayName}',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Progress
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(color: AppColors.textSecondaryDark),
                  ),
                  Text(
                    '${userAchievement.currentProgress}/${achievement.requirementValue}',
                    style: TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: userAchievement.progressPercent,
                  backgroundColor: AppColors.cardDark,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // XP reward
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: AppColors.prGold),
                const SizedBox(width: 8),
                Text(
                  '+${achievement.xpReward} XP',
                  style: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'emoji_events': Icons.emoji_events,
      'fitness_center': Icons.fitness_center,
      'military_tech': Icons.military_tech,
      'workspace_premium': Icons.workspace_premium,
      'local_fire_department': Icons.local_fire_department,
      'whatshot': Icons.whatshot,
      'bolt': Icons.bolt,
      'trending_up': Icons.trending_up,
      'wb_sunny': Icons.wb_sunny,
      'nightlight_round': Icons.nightlight_round,
      'weekend': Icons.weekend,
      'landscape': Icons.landscape,
    };
    return iconMap[iconName] ?? Icons.emoji_events;
  }
}
