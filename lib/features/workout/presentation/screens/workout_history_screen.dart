import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../providers/workout_provider.dart';

/// Screen showing workout history.
class WorkoutHistoryScreen extends ConsumerWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentWorkouts = ref.watch(recentWorkoutsProvider(20));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              // TODO: Show calendar view
            },
          ),
        ],
      ),
      body: recentWorkouts.when(
        data: (workouts) {
          if (workouts.isEmpty) {
            return _EmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return _WorkoutCard(
                workout: workout,
                onTap: () {
                  // TODO: Navigate to workout detail
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
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
          Icon(
            Icons.fitness_center,
            size: 80,
            color: AppColors.textTertiaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            'No workouts yet',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start your first workout by tapping the button below!',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends ConsumerWidget {
  final dynamic workout;
  final VoidCallback onTap;

  const _WorkoutCard({required this.workout, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('h:mm a');

    // Calculate workout stats
    int totalSets = 0;
    double totalVolume = 0;
    final exerciseNames = <String>[];

    for (final exercise in workout.exercises) {
      for (final set in exercise.sets) {
        totalSets++;
        totalVolume += set.weight * set.reps;
      }

      // Get exercise name
      final exerciseData = ref.watch(exerciseByIdProvider(exercise.exerciseId));
      exerciseData.whenData((ex) {
        if (ex != null && !exerciseNames.contains(ex.name)) {
          exerciseNames.add(ex.name);
        }
      });
    }

    // Calculate duration
    String durationStr = '';
    if (workout.completedAt != null) {
      final duration = workout.completedAt!.difference(workout.startedAt);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      durationStr = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.name ?? 'Workout',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${dateFormat.format(workout.startedAt)} at ${timeFormat.format(workout.startedAt)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (durationStr.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            durationStr,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats row
              Row(
                children: [
                  _StatChip(
                    icon: Icons.fitness_center,
                    label: '${workout.exercises.length} exercises',
                  ),
                  const SizedBox(width: 12),
                  _StatChip(icon: Icons.repeat, label: '$totalSets sets'),
                  const SizedBox(width: 12),
                  _StatChip(
                    icon: Icons.monitor_weight_outlined,
                    label: '${(totalVolume / 1000).toStringAsFixed(1)}k kg',
                  ),
                ],
              ),

              // Exercise list preview
              if (exerciseNames.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  exerciseNames.take(3).join(' • ') +
                      (exerciseNames.length > 3
                          ? ' +${exerciseNames.length - 3} more'
                          : ''),
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondaryDark),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
