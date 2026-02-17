import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../../pr/domain/entities/pr_detection_result.dart';
import '../../../rest_timer/presentation/widgets/mini_rest_timer.dart';
import '../../domain/entities/exercise_set.dart';
import '../../domain/entities/workout_exercise.dart';
import '../providers/workout_provider.dart';
import '../widgets/add_exercise_sheet.dart';
import '../widgets/pr_celebration_dialog.dart';
import '../widgets/set_input_row.dart';

/// Screen for active workout session.
class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() =>
      _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(activeWorkoutProvider);
    final workout = workoutState.workout;

    // Show PR celebration when a PR is detected
    ref.listen<ActiveWorkoutState>(activeWorkoutProvider, (previous, next) {
      if (next.lastPRResult != null && next.lastPRResult!.hasPR) {
        _showPRCelebration(next.lastPRResult!);
        ref.read(activeWorkoutProvider.notifier).clearPRResult();
      }
    });

    if (workout == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('No Active Workout')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No workout in progress'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.goToHome(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name ?? 'Workout'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(context),
        ),
        actions: [
          TextButton(
            onPressed: workoutState.isLoading ? null : () => _finishWorkout(),
            child: const Text('Finish'),
          ),
        ],
      ),
      body: Stack(
        children: [
          workout.exercises.isEmpty
              ? _EmptyWorkoutState(
                  onAddExercise: () => _showAddExercise(context),
                )
              : _WorkoutExerciseList(
                  exercises: workout.exercises,
                  onAddExercise: () => _showAddExercise(context),
                ),
          // Mini rest timer - shows when timer is active
          const Positioned(top: 8, right: 16, child: MiniRestTimer()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExercise(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddExercise(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddExerciseSheet(
        onExerciseSelected: (exercise) {
          ref.read(activeWorkoutProvider.notifier).addExercise(exercise.id);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showPRCelebration(PRDetectionResult result) {
    showDialog(
      context: context,
      builder: (context) => PRCelebrationDialog(result: result),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Workout?'),
        content: const Text(
          'Your workout progress will be saved. You can continue later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Workout'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.goToHome();
            },
            child: const Text('Save & Exit'),
          ),
          TextButton(
            onPressed: () {
              ref.read(activeWorkoutProvider.notifier).cancelWorkout();
              Navigator.pop(context);
              context.goToHome();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard Workout'),
          ),
        ],
      ),
    );
  }

  Future<void> _finishWorkout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finish Workout?'),
        content: const Text('Are you ready to complete this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finish'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(activeWorkoutProvider.notifier).completeWorkout();
      if (mounted) {
        context.goToHome();
      }
    }
  }
}

class _EmptyWorkoutState extends StatelessWidget {
  final VoidCallback onAddExercise;

  const _EmptyWorkoutState({required this.onAddExercise});

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
            'Add your first exercise',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add exercises to your workout',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAddExercise,
            icon: const Icon(Icons.add),
            label: const Text('Add Exercise'),
          ),
        ],
      ),
    );
  }
}

class _WorkoutExerciseList extends ConsumerWidget {
  final List<WorkoutExercise> exercises;
  final VoidCallback onAddExercise;

  const _WorkoutExerciseList({
    required this.exercises,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exercises.length + 1,
      itemBuilder: (context, index) {
        if (index == exercises.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 100),
            child: OutlinedButton.icon(
              onPressed: onAddExercise,
              icon: const Icon(Icons.add),
              label: const Text('Add Exercise'),
            ),
          );
        }

        final workoutExercise = exercises[index];
        return _WorkoutExerciseCard(
          workoutExercise: workoutExercise,
          exerciseNumber: index + 1,
        );
      },
    );
  }
}

class _WorkoutExerciseCard extends ConsumerStatefulWidget {
  final WorkoutExercise workoutExercise;
  final int exerciseNumber;

  const _WorkoutExerciseCard({
    required this.workoutExercise,
    required this.exerciseNumber,
  });

  @override
  ConsumerState<_WorkoutExerciseCard> createState() =>
      _WorkoutExerciseCardState();
}

class _WorkoutExerciseCardState extends ConsumerState<_WorkoutExerciseCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final exerciseAsync = ref.watch(
      exerciseByIdProvider(widget.workoutExercise.exerciseId),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Header
          exerciseAsync.when(
            data: (exercise) => _ExerciseHeader(
              exercise: exercise,
              exerciseNumber: widget.exerciseNumber,
              isExpanded: _isExpanded,
              onToggleExpand: () => setState(() => _isExpanded = !_isExpanded),
              onRemove: () => _removeExercise(),
            ),
            loading: () => const ListTile(title: Text('Loading...')),
            error: (_, __) => const ListTile(title: Text('Exercise not found')),
          ),

          // Sets
          if (_isExpanded) ...[
            const Divider(height: 1),
            _SetsSection(workoutExercise: widget.workoutExercise),
          ],
        ],
      ),
    );
  }

  void _removeExercise() {
    ref
        .read(activeWorkoutProvider.notifier)
        .removeExercise(widget.workoutExercise.id);
  }
}

class _ExerciseHeader extends StatelessWidget {
  final Exercise? exercise;
  final int exerciseNumber;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onRemove;

  const _ExerciseHeader({
    required this.exercise,
    required this.exerciseNumber,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary,
        child: Text(
          '$exerciseNumber',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(exercise?.name ?? 'Unknown Exercise'),
      subtitle: exercise?.muscleGroup != null
          ? Text(exercise!.muscleGroup.displayName)
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onRemove,
            color: AppColors.error,
          ),
          IconButton(
            icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onPressed: onToggleExpand,
          ),
        ],
      ),
    );
  }
}

class _SetsSection extends ConsumerStatefulWidget {
  final WorkoutExercise workoutExercise;

  const _SetsSection({required this.workoutExercise});

  @override
  ConsumerState<_SetsSection> createState() => _SetsSectionState();
}

class _SetsSectionState extends ConsumerState<_SetsSection> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLastUsedWeight();
  }

  Future<void> _loadLastUsedWeight() async {
    final lastWeight = await ref.read(
      lastUsedWeightProvider(widget.workoutExercise.exerciseId).future,
    );
    if (lastWeight != null && mounted) {
      _weightController.text = lastWeight.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              const SizedBox(
                width: 40,
                child: Text('Set', textAlign: TextAlign.center),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text('Previous')),
              const Expanded(child: Text('Weight (kg)')),
              const Expanded(child: Text('Reps')),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),

          // Existing sets
          ...widget.workoutExercise.sets.map(
            (set) => SetInputRow(
              set: set,
              onUpdate: (updatedSet) => _updateSet(updatedSet),
              onDelete: () => _deleteSet(set.id),
            ),
          ),

          // Add set row
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  '${widget.workoutExercise.sets.length + 1}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text('-')),
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'kg',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'reps',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                child: IconButton(
                  onPressed: _addSet,
                  icon: const Icon(
                    Icons.add_circle,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _addSet() async {
    final weight = double.tryParse(_weightController.text);
    final reps = int.tryParse(_repsController.text);

    if (weight == null || reps == null || reps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid weight and reps')),
      );
      return;
    }

    await ref
        .read(activeWorkoutProvider.notifier)
        .addSet(
          workoutExerciseId: widget.workoutExercise.id,
          reps: reps,
          weight: weight,
        );

    // Clear reps but keep weight for next set
    _repsController.clear();

    // Haptic feedback
    HapticFeedback.mediumImpact();
  }

  void _updateSet(ExerciseSet set) {
    ref.read(activeWorkoutProvider.notifier).updateSet(set);
  }

  void _deleteSet(String setId) {
    ref
        .read(activeWorkoutProvider.notifier)
        .deleteSet(setId, widget.workoutExercise.id);
  }
}
