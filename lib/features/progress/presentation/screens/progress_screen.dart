import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/progress_provider.dart';

/// Screen showing progress charts and statistics.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTimeRange = ref.watch(selectedTimeRangeProvider);
    final workoutStatsAsync = ref.watch(workoutStatsProvider);
    final mostUsedAsync = ref.watch(mostUsedExercisesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Time range selector
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: TimeRange.values.map((range) {
                final isSelected = selectedTimeRange == range;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(range.displayName),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(selectedTimeRangeProvider.notifier).state =
                          range;
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Workout stats
          workoutStatsAsync.when(
            data: (stats) => _StatsSection(stats: stats),
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const Text('Error loading stats'),
          ),
          const SizedBox(height: 24),

          // Most used exercises
          Text(
            'Most Used Exercises',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          mostUsedAsync.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.fitness_center_outlined,
                          size: 48,
                          color: AppColors.textTertiaryDark,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No workout data yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: exercises.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exerciseData = entry.value;
                  return _ExerciseUsageBar(
                    exerciseId: exerciseData.key,
                    count: exerciseData.value,
                    maxCount: exercises.first.value,
                    rank: index + 1,
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Error loading exercises'),
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final WorkoutStats stats;

  const _StatsSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main stats row
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.fitness_center,
                label: 'Total Workouts',
                value: '${stats.totalWorkouts}',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.repeat,
                label: 'Total Sets',
                value: '${stats.totalSets}',
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.monitor_weight_outlined,
                label: 'Total Volume',
                value: '${(stats.totalVolume / 1000).toStringAsFixed(0)}k kg',
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.timer_outlined,
                label: 'Avg Duration',
                value: _formatDuration(stats.averageWorkoutDuration),
                color: AppColors.info,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Activity summary
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${stats.workoutsThisWeek}',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      Text(
                        'This Week',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.textTertiaryDark.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${stats.workoutsThisMonth}',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                            ),
                      ),
                      Text(
                        'This Month',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ExerciseUsageBar extends ConsumerWidget {
  final String exerciseId;
  final int count;
  final int maxCount;
  final int rank;

  const _ExerciseUsageBar({
    required this.exerciseId,
    required this.count,
    required this.maxCount,
    required this.rank,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final percentage = maxCount > 0 ? count / maxCount : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Rank
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _getRankColor(rank).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getRankColor(rank),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Exercise name and bar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exercise #$exerciseId',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: AppColors.cardDark,
                      valueColor: AlwaysStoppedAnimation(_getRankColor(rank)),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Count
            Text(
              '$count',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return AppColors.prGold;
      case 2:
        return AppColors.prSilver;
      case 3:
        return AppColors.prBronze;
      default:
        return AppColors.primary;
    }
  }
}
