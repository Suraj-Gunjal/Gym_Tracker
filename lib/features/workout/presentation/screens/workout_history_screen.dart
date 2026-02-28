import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../domain/entities/workout.dart';
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
              context.go(AppRoutes.calendar);
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
                  _showWorkoutDetail(context, workout);
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

  void _showWorkoutDetail(BuildContext context, Workout workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => _WorkoutDetailSheet(
          workout: workout,
          scrollController: scrollController,
        ),
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

/// Bottom sheet showing workout details
class _WorkoutDetailSheet extends ConsumerWidget {
  final Workout workout;
  final ScrollController scrollController;

  const _WorkoutDetailSheet({
    required this.workout,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(allExercisesProvider);
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    final totalSets = workout.exercises.fold<int>(
      0,
      (sum, e) => sum + e.sets.length,
    );
    final totalVolume = workout.exercises.fold<double>(
      0,
      (sum, e) =>
          sum + e.sets.fold<double>(0, (s, set) => s + (set.weight * set.reps)),
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Content
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // Header
                Text(
                  workout.name ?? 'Workout',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${dateFormat.format(workout.startedAt)} at ${timeFormat.format(workout.startedAt)}',
                  style: TextStyle(color: AppColors.textSecondaryDark),
                ),

                const SizedBox(height: 24),

                // Stats
                Row(
                  children: [
                    _DetailStatCard(
                      icon: Icons.fitness_center,
                      value: '${workout.exercises.length}',
                      label: 'Exercises',
                    ),
                    const SizedBox(width: 12),
                    _DetailStatCard(
                      icon: Icons.repeat,
                      value: '$totalSets',
                      label: 'Sets',
                    ),
                    const SizedBox(width: 12),
                    _DetailStatCard(
                      icon: Icons.monitor_weight_outlined,
                      value: '${(totalVolume / 1000).toStringAsFixed(1)}k',
                      label: 'Volume (kg)',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Exercises
                Text(
                  'Exercises',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ...workout.exercises.map((exercise) {
                  final exerciseName = exercisesAsync.maybeWhen(
                    data: (exercises) => exercises
                        .firstWhere(
                          (e) => e.id == exercise.exerciseId,
                          orElse: () => exercises.first,
                        )
                        .name,
                    orElse: () => 'Exercise',
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exerciseName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...exercise.sets.asMap().entries.map((entry) {
                          final set = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${entry.key + 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${set.weight} kg × ${set.reps} reps',
                                  style: TextStyle(
                                    color: AppColors.textSecondaryDark,
                                  ),
                                ),
                                if (set.completed) ...[
                                  const Spacer(),
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: AppColors.success,
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _DetailStatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
