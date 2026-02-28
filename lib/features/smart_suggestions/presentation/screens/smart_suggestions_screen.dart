import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/models/recommendation_models.dart';
import '../providers/smart_suggestions_provider.dart';

/// Screen for AI-powered workout suggestions.
class SmartSuggestionsScreen extends ConsumerWidget {
  const SmartSuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(smartSuggestionsStateProvider);
    final muscleRecovery = ref.watch(muscleRecoveryProvider);
    final weeklyAnalysis = ref.watch(weeklyAnalysisProvider);
    final workoutSuggestion = ref.watch(
      workoutSuggestionProvider(state.selectedGoal),
    );
    final overloadSuggestions = ref.watch(
      overloadSuggestionsProvider(state.selectedGoal),
    );

    return Scaffold(
      body: CustomScrollView(
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
                    const Color(0xFF6366F1).withValues(alpha: 0.2),
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
                              'Smart Suggestions',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'AI-powered workout recommendations',
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
                          color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Goal Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _GoalSelector(
                selectedGoal: state.selectedGoal,
                onGoalChanged: (goal) {
                  HapticFeedback.selectionClick();
                  ref
                      .read(smartSuggestionsStateProvider.notifier)
                      .setGoal(goal);
                },
              ),
            ),
          ),

          // Muscle Recovery Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _SectionHeader(
                title: 'Muscle Recovery',
                subtitle: 'Based on your recent workouts',
                icon: Icons.favorite,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: muscleRecovery.when(
                data: (data) => _MuscleRecoveryList(recoveryData: data),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ),

          // Today's Suggested Workout
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _SectionHeader(
                title: "Today's Workout",
                subtitle: 'Optimized for your recovery',
                icon: Icons.fitness_center,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: workoutSuggestion.when(
                data: (suggestion) => _WorkoutSuggestionCard(
                  suggestion: suggestion,
                  onStart: () {
                    HapticFeedback.heavyImpact();
                    context.goToActiveWorkout();
                  },
                ),
                loading: () => const _LoadingCard(),
                error: (e, _) => _ErrorCard(error: e.toString()),
              ),
            ),
          ),

          // Progressive Overload Suggestions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _SectionHeader(
                title: 'Progressive Overload',
                subtitle: 'Exercises to level up',
                icon: Icons.trending_up,
              ),
            ),
          ),

          overloadSuggestions.when(
            data: (suggestions) => SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index >= suggestions.length || index >= 5) return null;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: _OverloadSuggestionCard(
                    suggestion: suggestions[index],
                  ),
                );
              }, childCount: suggestions.length.clamp(0, 5)),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                SliverToBoxAdapter(child: _ErrorCard(error: e.toString())),
          ),

          // Weekly Analysis
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _SectionHeader(
                title: 'Weekly Analysis',
                subtitle: 'Training balance overview',
                icon: Icons.analytics,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: weeklyAnalysis.when(
                data: (analysis) => _WeeklyAnalysisCard(analysis: analysis),
                loading: () => const _LoadingCard(),
                error: (e, _) => _ErrorCard(error: e.toString()),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _GoalSelector extends StatelessWidget {
  final TrainingGoal selectedGoal;
  final ValueChanged<TrainingGoal> onGoalChanged;

  const _GoalSelector({
    required this.selectedGoal,
    required this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: TrainingGoal.values.map((goal) {
          final isSelected = goal == selectedGoal;
          return Expanded(
            child: GestureDetector(
              onTap: () => onGoalChanged(goal),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  goal.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondaryDark,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MuscleRecoveryList extends StatelessWidget {
  final List<MuscleRecoveryData> recoveryData;

  const _MuscleRecoveryList({required this.recoveryData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: recoveryData.length,
      itemBuilder: (context, index) {
        final data = recoveryData[index];
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _MuscleRecoveryCard(data: data),
        );
      },
    );
  }
}

class _MuscleRecoveryCard extends StatelessWidget {
  final MuscleRecoveryData data;

  const _MuscleRecoveryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: data.status.color.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Recovery circle
          SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: data.recoveryScore,
                  backgroundColor: data.status.color.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(data.status.color),
                  strokeWidth: 4,
                ),
                Text(
                  '${(data.recoveryScore * 100).round()}%',
                  style: TextStyle(
                    color: data.status.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.muscle.label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            data.status.label,
            style: TextStyle(fontSize: 10, color: data.status.color),
          ),
        ],
      ),
    );
  }
}

class _WorkoutSuggestionCard extends StatelessWidget {
  final WorkoutSuggestion suggestion;
  final VoidCallback onStart;

  const _WorkoutSuggestionCard({
    required this.suggestion,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'AI Suggested',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _ReadinessIndicator(readiness: suggestion.overallReadiness),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            suggestion.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${suggestion.exerciseCount} exercises • ${suggestion.totalSets} sets • ~${suggestion.estimatedDuration.inMinutes} min',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestion.targetMuscles.map((muscle) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  muscle.label,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow),
                  SizedBox(width: 8),
                  Text(
                    'Start Workout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadinessIndicator extends StatelessWidget {
  final double readiness;

  const _ReadinessIndicator({required this.readiness});

  @override
  Widget build(BuildContext context) {
    final color = readiness >= 0.8
        ? Colors.greenAccent
        : readiness >= 0.5
        ? Colors.yellowAccent
        : Colors.orangeAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.battery_charging_full, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            '${(readiness * 100).round()}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverloadSuggestionCard extends StatelessWidget {
  final ProgressiveOverloadSuggestion suggestion;

  const _OverloadSuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: suggestion.type == OverloadType.weight
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                suggestion.type.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.exercise.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  suggestion.reason,
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (suggestion.hasWeightIncrease)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${suggestion.weightIncrease.toStringAsFixed(1)}kg',
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            )
          else if (suggestion.hasRepsIncrease)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '+${suggestion.repsIncrease} reps',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WeeklyAnalysisCard extends StatelessWidget {
  final WeeklyAnalysis analysis;

  const _WeeklyAnalysisCard({required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                value: '${analysis.totalWorkouts}',
                label: 'Workouts',
                icon: Icons.fitness_center,
              ),
              _StatItem(
                value: '${analysis.totalSets}',
                label: 'Total Sets',
                icon: Icons.format_list_numbered,
              ),
              _StatItem(
                value: '${(analysis.totalVolume / 1000).toStringAsFixed(1)}k',
                label: 'Volume (kg)',
                icon: Icons.scale,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Balance score
          Row(
            children: [
              const Text(
                'Training Balance',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              _BalanceIndicator(score: analysis.balanceScore),
            ],
          ),
          const SizedBox(height: 12),

          // Balance bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: analysis.balanceScore,
              backgroundColor: AppColors.backgroundDark,
              valueColor: AlwaysStoppedAnimation(
                analysis.balanceScore >= 0.7
                    ? AppColors.success
                    : analysis.balanceScore >= 0.4
                    ? Colors.orange
                    : AppColors.error,
              ),
              minHeight: 6,
            ),
          ),

          // Neglected muscles warning
          if (analysis.neglectedMuscles.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Train more: ${analysis.neglectedMuscles.map((m) => m.label).join(", ")}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12),
        ),
      ],
    );
  }
}

class _BalanceIndicator extends StatelessWidget {
  final double score;

  const _BalanceIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score >= 0.7
        ? AppColors.success
        : score >= 0.4
        ? Colors.orange
        : AppColors.error;

    final label = score >= 0.7
        ? 'Balanced'
        : score >= 0.4
        ? 'Moderate'
        : 'Imbalanced';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String error;

  const _ErrorCard({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(error, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
