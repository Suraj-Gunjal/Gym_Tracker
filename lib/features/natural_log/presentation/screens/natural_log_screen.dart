import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../domain/models/parsed_workout.dart';
import '../providers/natural_log_provider.dart';

/// Screen for natural language workout logging.
class NaturalLogScreen extends ConsumerStatefulWidget {
  const NaturalLogScreen({super.key});

  @override
  ConsumerState<NaturalLogScreen> createState() => _NaturalLogScreenState();
}

class _NaturalLogScreenState extends ConsumerState<NaturalLogScreen> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    ref
        .read(naturalLogStateProvider.notifier)
        .updateInput(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(naturalLogStateProvider);
    final examples = ref.watch(examplePhrasesProvider);

    return Scaffold(
      body: GestureDetector(
        onTap: () => _focusNode.unfocus(),
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 20,
                  right: 20,
                  bottom: 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF10B981).withValues(alpha: 0.2),
                      AppColors.backgroundDark,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Quick Log',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Describe your workout in plain English',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textSecondaryDark,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.mic,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Input Area
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text Input
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _focusNode.hasFocus
                              ? AppColors.primary
                              : AppColors.surfaceDark,
                          width: 2,
                        ),
                      ),
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        maxLines: 4,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'e.g., "Bench press 3x8 at 100kg"',
                          hintStyle: TextStyle(
                            color: AppColors.textTertiaryDark,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              _textController.clear();
                              ref
                                  .read(naturalLogStateProvider.notifier)
                                  .clear();
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: state.hasInput && !state.isParsing
                                ? () {
                                    HapticFeedback.mediumImpact();
                                    ref
                                        .read(naturalLogStateProvider.notifier)
                                        .parseInput();
                                  }
                                : null,
                            icon: state.isParsing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.auto_awesome),
                            label: Text(
                              state.isParsing ? 'Parsing...' : 'Parse Workout',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Exercise Suggestions
            if (state.suggestions.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggestions',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.suggestions.map((exercise) {
                          return ActionChip(
                            label: Text(exercise.name),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              ref
                                  .read(naturalLogStateProvider.notifier)
                                  .applySuggestion(exercise);
                              _textController.text = ref
                                  .read(naturalLogStateProvider)
                                  .inputText;
                              _textController.selection =
                                  TextSelection.collapsed(
                                    offset: _textController.text.length,
                                  );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

            // Parsed Result
            if (state.parsedResult != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _ParsedResultCard(
                    result: state.parsedResult!,
                    onConfirm: () async {
                      HapticFeedback.heavyImpact();

                      final workoutNotifier = ref.read(
                        activeWorkoutProvider.notifier,
                      );
                      final currentWorkout = ref
                          .read(activeWorkoutProvider)
                          .workout;

                      // Start a new workout if none exists
                      if (currentWorkout == null) {
                        await workoutNotifier.startWorkout(
                          name:
                              state.parsedResult!.workoutName ??
                              'Quick Log Workout',
                        );
                      }

                      // Add each parsed exercise with its sets
                      for (final parsedExercise
                          in state.parsedResult!.exercises) {
                        if (parsedExercise.matchedExercise != null) {
                          // Add exercise to workout
                          await workoutNotifier.addExercise(
                            parsedExercise.matchedExercise!.id,
                          );

                          // Get the newly added workout exercise ID
                          final workoutState = ref.read(activeWorkoutProvider);
                          final workoutExercise =
                              workoutState.workout?.exercises.lastOrNull;

                          if (workoutExercise != null) {
                            // Add each set to the exercise
                            for (final parsedSet in parsedExercise.sets) {
                              await workoutNotifier.addSet(
                                workoutExerciseId: workoutExercise.id,
                                reps: parsedSet.reps,
                                weight: parsedSet.weight,
                              );
                            }
                          }
                        }
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Workout logged! 💪'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                        context.goToActiveWorkout();
                      }
                    },
                  ),
                ),
              ),

            // Example Phrases (when no input)
            if (!state.hasInput && !state.hasParsedResult)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.textSecondaryDark,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Try saying...',
                            style: TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...examples.map(
                        (example) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              _textController.text = example;
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceDark,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '"$example"',
                                style: TextStyle(
                                  color: AppColors.textSecondaryDark,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _ParsedResultCard extends StatelessWidget {
  final ParsedWorkout result;
  final VoidCallback onConfirm;

  const _ParsedResultCard({required this.result, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with confidence
        Row(
          children: [
            Text(
              'Parsed Result',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            _ConfidenceBadge(confidence: result.overallConfidence),
          ],
        ),
        const SizedBox(height: 16),

        // Exercises
        ...result.exercises.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ParsedExerciseCard(exercise: entry.value, index: entry.key),
          );
        }),

        // Issues/Warnings
        if (result.hasIssues) ...[
          const SizedBox(height: 8),
          ...result.issues.map(
            (issue) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _IssueCard(issue: issue),
            ),
          ),
        ],

        // Confirm button
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: result.exercises.isNotEmpty ? onConfirm : null,
            icon: const Icon(Icons.check),
            label: Text(
              result.exercises.isEmpty
                  ? 'No exercises found'
                  : 'Log ${result.totalSets} sets',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final ParseConfidence confidence;

  const _ConfidenceBadge({required this.confidence});

  @override
  Widget build(BuildContext context) {
    final color = confidence == ParseConfidence.high
        ? AppColors.success
        : confidence == ParseConfidence.medium
        ? Colors.orange
        : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            confidence == ParseConfidence.high
                ? Icons.check_circle
                : confidence == ParseConfidence.medium
                ? Icons.help
                : Icons.warning,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            confidence.label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParsedExerciseCard extends StatelessWidget {
  final ParsedExercise exercise;
  final int index;

  const _ParsedExerciseCard({required this.exercise, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: exercise.isMatched
              ? AppColors.success.withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise name
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.isMatched
                          ? exercise.matchedExercise!.name
                          : exercise.rawName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (!exercise.isMatched)
                      Text(
                        'Unknown exercise',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                  ],
                ),
              ),
              _ConfidenceBadge(confidence: exercise.confidence),
            ],
          ),
          const SizedBox(height: 12),

          // Sets summary
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: exercise.sets.asMap().entries.map((entry) {
              final set = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${set.reps} reps @ ${set.weight.toStringAsFixed(1)}kg',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
          ),

          // Alternatives
          if (exercise.alternatives.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Did you mean: ${exercise.alternatives.join(", ")}?',
              style: TextStyle(
                color: AppColors.textTertiaryDark,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final ParseIssue issue;

  const _IssueCard({required this.issue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.message,
                  style: const TextStyle(color: Colors.orange, fontSize: 13),
                ),
                if (issue.suggestion != null)
                  Text(
                    issue.suggestion!,
                    style: TextStyle(
                      color: Colors.orange.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
