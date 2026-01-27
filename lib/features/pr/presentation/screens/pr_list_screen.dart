import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../domain/entities/pr_type.dart';
import '../providers/pr_provider.dart';

/// Screen showing all personal records.
class PRListScreen extends ConsumerWidget {
  const PRListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prSummaryAsync = ref.watch(prSummaryProvider);
    final allPRsAsync = ref.watch(allPRsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Records')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary cards
          prSummaryAsync.when(
            data: (summary) => _PRSummarySection(summary: summary),
            loading: () => const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const Text('Error loading summary'),
          ),
          const SizedBox(height: 24),

          // All PRs list
          Text('All Records', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          allPRsAsync.when(
            data: (prs) {
              if (prs.isEmpty) {
                return _EmptyState();
              }

              // Group by exercise
              final grouped = <String, List<dynamic>>{};
              for (final pr in prs) {
                grouped.putIfAbsent(pr.exerciseId, () => []).add(pr);
              }

              return Column(
                children: grouped.entries.map((entry) {
                  return _ExercisePRCard(
                    exerciseId: entry.key,
                    prs: entry.value,
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Error: $error'),
          ),
        ],
      ),
    );
  }
}

class _PRSummarySection extends StatelessWidget {
  final PRSummary summary;

  const _PRSummarySection({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Total PRs card
        Card(
          color: AppColors.prGold.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 48,
                  color: AppColors.prGold,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${summary.totalPRs}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.prGold,
                      ),
                    ),
                    Text(
                      'Total Personal Records',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // PR type breakdown
        Row(
          children: [
            Expanded(
              child: _PRTypeCard(
                type: PRType.maxWeight,
                count: summary.maxWeightPRs,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PRTypeCard(
                type: PRType.maxReps,
                count: summary.maxRepsPRs,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PRTypeCard(
                type: PRType.maxVolume,
                count: summary.maxVolumePRs,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PRTypeCard extends StatelessWidget {
  final PRType type;
  final int count;

  const _PRTypeCard({required this.type, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(type.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              type.displayName,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExercisePRCard extends ConsumerWidget {
  final String exerciseId;
  final List<dynamic> prs;

  const _ExercisePRCard({required this.exerciseId, required this.prs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exerciseAsync = ref.watch(exerciseByIdProvider(exerciseId));
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: exerciseAsync.when(
        data: (exercise) {
          if (exercise == null) return const SizedBox.shrink();

          final muscleColor =
              AppColors.muscleGroupColors[exercise.muscleGroup.name] ??
              AppColors.primary;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: muscleColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: muscleColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            exercise.muscleGroup.displayName,
                            style: TextStyle(color: muscleColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // PRs list
              ...prs.map(
                (pr) => ListTile(
                  leading: Text(
                    pr.prType.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    pr.prType.formatValue(pr.value, atWeight: pr.atWeight),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${pr.prType.displayName} • ${dateFormat.format(pr.achievedAt)}',
                  ),
                  trailing: pr.previousValue != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '+${(pr.value - pr.previousValue!).toStringAsFixed(1)}',
                            style: const TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          );
        },
        loading: () => const ListTile(title: Text('Loading...')),
        error: (_, __) => const ListTile(title: Text('Error')),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 48),
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: AppColors.textTertiaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            'No personal records yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Complete workouts to start setting PRs! We\'ll track your max weight, max reps, and total volume.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
