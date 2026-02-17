import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/achievement.dart';

/// Overview card showing key user statistics.
class StatsOverviewCard extends StatelessWidget {
  final UserStats stats;

  const StatsOverviewCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.fitness_center,
            value: '${stats.totalWorkouts}',
            label: 'Workouts',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            icon: Icons.emoji_events,
            value: '${stats.totalPRs}',
            label: 'PRs',
            color: AppColors.prGold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatItem(
            icon: Icons.timer,
            value: _formatMinutes(stats.totalMinutes),
            label: 'Time',
            color: AppColors.info,
          ),
        ),
      ],
    );
  }

  String _formatMinutes(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final hours = minutes ~/ 60;
    if (hours < 24) return '${hours}h';
    final days = hours ~/ 24;
    return '${days}d';
  }
}

/// Individual stat item
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
