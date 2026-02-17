import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/calendar_provider.dart';

/// Animated streak banner showing workout consistency.
class StreakBanner extends ConsumerWidget {
  const StreakBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(currentStreakProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: streak.currentStreak > 0
              ? [
                  const Color(0xFFEF4444).withOpacity(0.2),
                  const Color(0xFFF97316).withOpacity(0.15),
                ]
              : [AppColors.surfaceDark, AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: streak.currentStreak > 0
              ? const Color(0xFFEF4444).withOpacity(0.3)
              : AppColors.textTertiaryDark.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Fire icon with animation
          _AnimatedFireIcon(
            isActive: streak.currentStreak > 0,
            isAtRisk: streak.isStreakAtRisk,
          ),
          const SizedBox(width: 16),

          // Streak info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${streak.currentStreak}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: streak.currentStreak > 0
                                ? const Color(0xFFEF4444)
                                : AppColors.textSecondaryDark,
                          ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'day streak',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (streak.isStreakAtRisk)
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Workout today to keep your streak!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    'Best: ${streak.longestStreak} days',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiaryDark,
                    ),
                  ),
              ],
            ),
          ),

          // Weekly progress
          _WeeklyProgressRing(
            progress: streak.weeklyProgress,
            current: streak.workoutsThisWeek,
            goal: streak.weeklyGoal,
            onTap: () => _showWeeklyGoalSheet(context, ref),
          ),
        ],
      ),
    );
  }

  void _showWeeklyGoalSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _WeeklyGoalSheet(
        currentGoal: ref.read(currentStreakProvider).weeklyGoal,
        onGoalChanged: (goal) {
          ref.read(calendarNotifierProvider.notifier).setWeeklyGoal(goal);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _AnimatedFireIcon extends StatefulWidget {
  final bool isActive;
  final bool isAtRisk;

  const _AnimatedFireIcon({required this.isActive, required this.isAtRisk});

  @override
  State<_AnimatedFireIcon> createState() => _AnimatedFireIconState();
}

class _AnimatedFireIconState extends State<_AnimatedFireIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_AnimatedFireIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _scaleAnimation.value : 1.0,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isActive
                  ? const Color(0xFFEF4444).withOpacity(0.2)
                  : AppColors.backgroundDark,
              boxShadow: widget.isActive
                  ? [
                      BoxShadow(
                        color: widget.isAtRisk
                            ? const Color(
                                0xFFF59E0B,
                              ).withOpacity(_glowAnimation.value)
                            : const Color(
                                0xFFEF4444,
                              ).withOpacity(_glowAnimation.value),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              Icons.local_fire_department,
              size: 32,
              color: widget.isActive
                  ? widget.isAtRisk
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFEF4444)
                  : AppColors.textTertiaryDark,
            ),
          ),
        );
      },
    );
  }
}

class _WeeklyProgressRing extends StatelessWidget {
  final double progress;
  final int current;
  final int goal;
  final VoidCallback onTap;

  const _WeeklyProgressRing({
    required this.progress,
    required this.current,
    required this.goal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background ring
            SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 4,
                backgroundColor: AppColors.backgroundDark,
                color: AppColors.backgroundDark,
              ),
            ),
            // Progress ring
            SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 4,
                backgroundColor: Colors.transparent,
                color: progress >= 1.0
                    ? const Color(0xFF10B981)
                    : AppColors.primary,
                strokeCap: StrokeCap.round,
              ),
            ),
            // Text
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$current/$goal',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'week',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textTertiaryDark,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyGoalSheet extends StatefulWidget {
  final int currentGoal;
  final ValueChanged<int> onGoalChanged;

  const _WeeklyGoalSheet({
    required this.currentGoal,
    required this.onGoalChanged,
  });

  @override
  State<_WeeklyGoalSheet> createState() => _WeeklyGoalSheetState();
}

class _WeeklyGoalSheetState extends State<_WeeklyGoalSheet> {
  late int _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.currentGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Weekly Workout Goal',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'How many workouts per week?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: List.generate(7, (index) {
              final goal = index + 1;
              final isSelected = goal == _selectedGoal;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedGoal = goal);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textTertiaryDark.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$goal',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondaryDark,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onGoalChanged(_selectedGoal),
              child: const Text('Save Goal'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
