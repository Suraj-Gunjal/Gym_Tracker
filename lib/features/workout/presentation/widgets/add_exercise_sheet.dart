import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/domain/entities/muscle_group.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';

/// Bottom sheet for adding an exercise to a workout.
class AddExerciseSheet extends ConsumerStatefulWidget {
  final Function(Exercise) onExerciseSelected;

  const AddExerciseSheet({super.key, required this.onExerciseSelected});

  @override
  ConsumerState<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<AddExerciseSheet> {
  final _searchController = TextEditingController();
  MuscleGroup? _selectedMuscleGroup;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = _searchController.text;
    final exercisesAsync = searchQuery.isNotEmpty
        ? ref.watch(exerciseSearchProvider(searchQuery))
        : _selectedMuscleGroup != null
        ? ref.watch(exercisesByMuscleGroupProvider(_selectedMuscleGroup))
        : ref.watch(allExercisesProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiaryDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Add Exercise',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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

              const SizedBox(height: 16),

              // Muscle group filter
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: _selectedMuscleGroup == null,
                      onTap: () => setState(() => _selectedMuscleGroup = null),
                    ),
                    ...MuscleGroup.values
                        .take(10)
                        .map(
                          (group) => _FilterChip(
                            label: group.displayName,
                            isSelected: _selectedMuscleGroup == group,
                            color: AppColors.muscleGroupColors[group.name],
                            onTap: () =>
                                setState(() => _selectedMuscleGroup = group),
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
                    if (exercises.isEmpty) {
                      return const Center(child: Text('No exercises found'));
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = exercises[index];
                        return _ExerciseTile(
                          exercise: exercise,
                          onTap: () => widget.onExerciseSelected(exercise),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Error: $error')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
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
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondaryDark,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const _ExerciseTile({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final muscleColor =
        AppColors.muscleGroupColors[exercise.muscleGroup.name] ??
        AppColors.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: muscleColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(exercise.name),
        subtitle: Text(
          exercise.muscleGroup.displayName,
          style: TextStyle(color: muscleColor),
        ),
        trailing: exercise.isPredefined
            ? null
            : const Chip(
                label: Text('Custom', style: TextStyle(fontSize: 10)),
                padding: EdgeInsets.zero,
              ),
        onTap: onTap,
      ),
    );
  }
}
