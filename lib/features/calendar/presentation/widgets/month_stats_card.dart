import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/calendar_provider.dart';

/// Card showing month statistics.
class MonthStatsCard extends ConsumerWidget {
  const MonthStatsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthData = ref.watch(currentMonthStatsProvider);

    if (monthData == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textTertiaryDark.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${monthData.monthName} Stats',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${monthData.activeDays} active days',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.fitness_center,
                  label: 'Workouts',
                  value: '${monthData.totalWorkouts}',
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.emoji_events,
                  label: 'PRs',
                  value: '${monthData.totalPRs}',
                  color: AppColors.prGold,
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.timer,
                  label: 'Time',
                  value: _formatDuration(monthData.totalDuration),
                  color: const Color(0xFF10B981),
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.trending_up,
                  label: 'Frequency',
                  value: '${monthData.frequency.toStringAsFixed(1)}/wk',
                  color: const Color(0xFFF59E0B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiaryDark),
        ),
      ],
    );
  }
}
