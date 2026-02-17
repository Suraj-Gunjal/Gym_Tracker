import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/muscle_group.dart';
import '../providers/exercise_provider.dart';

/// Screen showing list of all exercises.
class ExerciseListScreen extends ConsumerStatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  final _searchController = TextEditingController();
  MuscleGroup? _selectedMuscleGroup;
  bool _showOnlyCustom = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = _getFilteredExercises();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
        actions: [
          IconButton(
            icon: Icon(
              _showOnlyCustom ? Icons.star : Icons.star_border,
              color: _showOnlyCustom ? AppColors.prGold : null,
            ),
            onPressed: () => setState(() => _showOnlyCustom = !_showOnlyCustom),
            tooltip: 'Show custom exercises only',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search exercises...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          // Muscle group filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _MuscleGroupChip(
                  label: 'All',
                  isSelected: _selectedMuscleGroup == null,
                  onTap: () => setState(() => _selectedMuscleGroup = null),
                ),
                ...MuscleGroup.values.map(
                  (group) => _MuscleGroupChip(
                    label: group.displayName,
                    isSelected: _selectedMuscleGroup == group,
                    color: AppColors.muscleGroupColors[group.name],
                    onTap: () => setState(() => _selectedMuscleGroup = group),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Exercise list
          Expanded(
            child: exercisesAsync.when(
              data: (exercises) {
                final filtered = _applyFilters(exercises);

                if (filtered.isEmpty) {
                  return _EmptyState(
                    showOnlyCustom: _showOnlyCustom,
                    onCreateExercise: () => _showCreateExerciseDialog(context),
                  );
                }

                // Group by muscle group
                final grouped = _groupByMuscle(filtered);

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final entry = grouped.entries.elementAt(index);
                    return _MuscleGroupSection(
                      muscleGroup: entry.key,
                      exercises: entry.value,
                      onExerciseTap: (exercise) =>
                          _showExerciseDetail(exercise),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateExerciseDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  AsyncValue<List<Exercise>> _getFilteredExercises() {
    final searchQuery = _searchController.text;

    if (searchQuery.isNotEmpty) {
      return ref.watch(exerciseSearchProvider(searchQuery));
    }

    if (_selectedMuscleGroup != null) {
      return ref.watch(exercisesByMuscleGroupProvider(_selectedMuscleGroup));
    }

    return ref.watch(allExercisesProvider);
  }

  List<Exercise> _applyFilters(List<Exercise> exercises) {
    if (_showOnlyCustom) {
      return exercises.where((e) => !e.isPredefined).toList();
    }
    return exercises;
  }

  Map<MuscleGroup, List<Exercise>> _groupByMuscle(List<Exercise> exercises) {
    final grouped = <MuscleGroup, List<Exercise>>{};

    for (final exercise in exercises) {
      grouped.putIfAbsent(exercise.muscleGroup, () => []).add(exercise);
    }

    return grouped;
  }

  void _showExerciseDetail(Exercise exercise) {
    // TODO: Navigate to exercise detail
  }

  void _showCreateExerciseDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CreateExerciseSheet(
        onCreated: (exercise) {
          ref.read(exerciseNotifierProvider.notifier).addExercise(exercise);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool showOnlyCustom;
  final VoidCallback onCreateExercise;

  const _EmptyState({
    required this.showOnlyCustom,
    required this.onCreateExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showOnlyCustom ? Icons.star_border : Icons.fitness_center,
            size: 64,
            color: AppColors.textTertiaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            showOnlyCustom ? 'No custom exercises yet' : 'No exercises found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            showOnlyCustom
                ? 'Create your own exercises to track'
                : 'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (showOnlyCustom) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onCreateExercise,
              icon: const Icon(Icons.add),
              label: const Text('Create Exercise'),
            ),
          ],
        ],
      ),
    );
  }
}

class _MuscleGroupChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _MuscleGroupChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: color ?? AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondaryDark,
        ),
      ),
    );
  }
}

class _MuscleGroupSection extends StatelessWidget {
  final MuscleGroup muscleGroup;
  final List<Exercise> exercises;
  final Function(Exercise) onExerciseTap;

  const _MuscleGroupSection({
    required this.muscleGroup,
    required this.exercises,
    required this.onExerciseTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        AppColors.muscleGroupColors[muscleGroup.name] ?? AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                muscleGroup.displayName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${exercises.length}',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Exercise cards
        ...exercises.map(
          (exercise) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(exercise.name),
              subtitle: exercise.description != null
                  ? Text(
                      exercise.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: exercise.isPredefined
                  ? null
                  : const Icon(Icons.star, color: AppColors.prGold, size: 18),
              onTap: () => onExerciseTap(exercise),
            ),
          ),
        ),

        const SizedBox(height: 8),
      ],
    );
  }
}

class _CreateExerciseSheet extends StatefulWidget {
  final Function(Exercise) onCreated;

  const _CreateExerciseSheet({required this.onCreated});

  @override
  State<_CreateExerciseSheet> createState() => _CreateExerciseSheetState();
}

class _CreateExerciseSheetState extends State<_CreateExerciseSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  MuscleGroup _selectedMuscleGroup = MuscleGroup.chest;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Exercise',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Exercise Name',
                hintText: 'e.g., Incline Dumbbell Press',
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Brief description or notes',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<MuscleGroup>(
              initialValue: _selectedMuscleGroup,
              decoration: const InputDecoration(labelText: 'Muscle Group'),
              items: MuscleGroup.values.map((group) {
                return DropdownMenuItem(
                  value: group,
                  child: Text(group.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedMuscleGroup = value);
                }
              },
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _createExercise,
              child: const Text('Create Exercise'),
            ),
          ],
        ),
      ),
    );
  }

  void _createExercise() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an exercise name')),
      );
      return;
    }

    final exercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      muscleGroup: _selectedMuscleGroup,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      isPredefined: false,
      updatedAt: DateTime.now(),
    );

    widget.onCreated(exercise);
  }
}
