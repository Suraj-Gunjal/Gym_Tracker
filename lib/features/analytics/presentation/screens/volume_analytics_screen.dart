import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/volume_analytics.dart';
import '../providers/analytics_provider.dart';

/// Screen for volume analytics and insights.
class VolumeAnalyticsScreen extends ConsumerWidget {
  const VolumeAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(volumeAnalyticsNotifierProvider);
    final fatigue = ref.watch(fatigueLevelsNotifierProvider);
    final intensityScores = ref.watch(intensityScoresNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(analytics),
            ),
            title: const Text('Volume Analytics'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildOverviewCards(analytics),
                const SizedBox(height: 24),
                _buildVolumeChart(analytics),
                const SizedBox(height: 24),
                _buildMuscleBreakdown(analytics),
                const SizedBox(height: 24),
                _buildFatigueSection(fatigue),
                const SizedBox(height: 24),
                _buildRecentIntensity(intensityScores),
                const SizedBox(height: 24),
                if (analytics.recommendations.isNotEmpty)
                  _buildRecommendations(analytics),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(VolumeAnalytics analytics) {
    return Container(
      padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3B82F6).withValues(alpha: 0.2),
            AppColors.backgroundDark,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics,
                  color: Color(0xFF3B82F6),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Volume',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${analytics.totalWeeklySets} sets',
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: analytics.balanceScore >= 70
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Balance: ${analytics.balanceScore}%',
                  style: TextStyle(
                    color: analytics.balanceScore >= 70
                        ? AppColors.success
                        : AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(VolumeAnalytics analytics) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Total Reps',
            value: analytics.totalWeeklyReps.toString(),
            icon: Icons.repeat,
            color: const Color(0xFF22C55E),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            title: 'Volume',
            value:
                '${(analytics.totalWeeklyVolume / 1000).toStringAsFixed(1)}k',
            subtitle: 'kg lifted',
            icon: Icons.fitness_center,
            color: const Color(0xFFF59E0B),
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeChart(VolumeAnalytics analytics) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Volume by Muscle Group',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...analytics.currentWeek.entries.map((entry) {
            final muscle = entry.key;
            final volume = entry.value;
            final maxSets = 20.0;
            final progress = (volume.totalSets / maxSets).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(muscle.emoji),
                          const SizedBox(width: 8),
                          Text(
                            muscle.label,
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${volume.totalSets} sets',
                        style: TextStyle(
                          color: volume.isOptimal
                              ? AppColors.success
                              : AppColors.textSecondaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.backgroundDark,
                      valueColor: AlwaysStoppedAnimation(
                        Color(muscle.primaryColor),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMuscleBreakdown(VolumeAnalytics analytics) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Week over Week',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: analytics.trends.entries.map((entry) {
              final trend = entry.value;
              final isUp = trend.isTrendingUp;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(trend.muscleGroup.emoji),
                    const SizedBox(width: 6),
                    Text(
                      trend.muscleGroup.label,
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isUp ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isUp ? AppColors.success : AppColors.error,
                    ),
                    Text(
                      '${trend.volumeChangePercent.abs().toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: isUp ? AppColors.success : AppColors.error,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFatigueSection(Map<MuscleGroup, FatigueLevel> fatigue) {
    final sortedFatigue = fatigue.entries.toList()
      ..sort((a, b) => b.value.fatigueScore.compareTo(a.value.fatigueScore));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Fatigue Levels',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Recovery Guide',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...sortedFatigue.take(6).map((entry) {
            final level = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(level.statusEmoji),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      level.muscleGroup.label,
                      style: const TextStyle(color: AppColors.textPrimaryDark),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: level.fatigueScore / 100,
                        backgroundColor: AppColors.backgroundDark,
                        valueColor: AlwaysStoppedAnimation(
                          level.fatigueScore > 70
                              ? AppColors.error
                              : level.fatigueScore > 40
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    level.recoveryStatus,
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentIntensity(List<IntensityScore> scores) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Workout Intensity',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: scores.take(7).toList().reversed.map((score) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: score.score * 0.5,
                      decoration: BoxDecoration(
                        color: score.score >= 75
                            ? AppColors.error
                            : score.score >= 50
                            ? AppColors.warning
                            : AppColors.success,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${score.date.day}',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 10,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          if (scores.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Last workout: ${scores.first.difficultyLabel}',
                  style: const TextStyle(color: AppColors.textSecondaryDark),
                ),
                const SizedBox(width: 8),
                Text(scores.first.difficultyEmoji),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(VolumeAnalytics analytics) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Recommendations',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...analytics.recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: AppColors.primary)),
                  Expanded(
                    child: Text(
                      rec,
                      style: const TextStyle(color: AppColors.textPrimaryDark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}
