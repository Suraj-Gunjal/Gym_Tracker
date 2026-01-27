import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../pr/domain/entities/pr_type.dart';
import '../../../pr/presentation/providers/pr_provider.dart';
import '../../../progress/presentation/providers/progress_provider.dart';
import '../providers/exercise_provider.dart';

/// Screen showing exercise details and history.
class ExerciseDetailScreen extends ConsumerWidget {
  final String exerciseId;

  const ExerciseDetailScreen({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseByIdProvider(exerciseId));
    final prsAsync = ref.watch(prsForExerciseProvider(exerciseId));
    final progressArgs = ExerciseProgressArgs(
      exerciseId: exerciseId,
      timeRange: TimeRange.month,
    );
    final progressAsync = ref.watch(exerciseProgressProvider(progressArgs));

    return exerciseAsync.when(
      data: (exercise) {
        if (exercise == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Exercise Not Found')),
            body: const Center(child: Text('This exercise does not exist')),
          );
        }

        final muscleColor =
            AppColors.muscleGroupColors[exercise.muscleGroup.name] ??
            AppColors.primary;

        return Scaffold(
          appBar: AppBar(title: Text(exercise.name)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Exercise info card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 40,
                            decoration: BoxDecoration(
                              color: muscleColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: muscleColor.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    exercise.muscleGroup.displayName,
                                    style: TextStyle(
                                      color: muscleColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!exercise.isPredefined)
                            const Icon(Icons.star, color: AppColors.prGold),
                        ],
                      ),
                      if (exercise.description != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          exercise.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // PRs section
              Text(
                'Personal Records',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              prsAsync.when(
                data: (prs) {
                  if (prs.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.emoji_events_outlined,
                              size: 48,
                              color: AppColors.textTertiaryDark,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No PRs yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Complete workouts to set records',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Row(
                    children: PRType.values.map((type) {
                      final pr = prs.where((p) => p.prType == type).firstOrNull;
                      return Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(
                                  type.emoji,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  type.displayName,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  pr != null
                                      ? type.formatValue(
                                          pr.value,
                                          atWeight: pr.atWeight,
                                        )
                                      : '-',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: pr != null
                                            ? AppColors.prGold
                                            : AppColors.textTertiaryDark,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Error loading PRs'),
              ),
              const SizedBox(height: 24),

              // Progress section
              Text('Progress', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              progressAsync.when(
                data: (progress) {
                  if (progress.maxWeightProgress.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.bar_chart_outlined,
                              size: 48,
                              color: AppColors.textTertiaryDark,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No data yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Complete workouts to see progress',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Simple stats for now - chart will be added later
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _ProgressStat(
                            label: 'Workouts',
                            value: '${progress.maxWeightProgress.length}',
                            icon: Icons.fitness_center,
                          ),
                          const Divider(),
                          _ProgressStat(
                            label: 'Best Weight',
                            value: progress.maxWeightProgress.isNotEmpty
                                ? '${progress.maxWeightProgress.map((p) => p.value).reduce((a, b) => a > b ? a : b).toStringAsFixed(1)} kg'
                                : '-',
                            icon: Icons.trending_up,
                          ),
                          const Divider(),
                          _ProgressStat(
                            label: 'Best Reps',
                            value: progress.maxRepsProgress.isNotEmpty
                                ? '${progress.maxRepsProgress.map((p) => p.value).reduce((a, b) => a > b ? a : b).toInt()}'
                                : '-',
                            icon: Icons.repeat,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text('Error loading progress'),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProgressStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
