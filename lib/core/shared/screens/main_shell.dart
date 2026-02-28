import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/workout/presentation/providers/workout_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../widgets/sync_indicator.dart';

/// Main shell with enhanced bottom navigation bar.
class MainShell extends ConsumerWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeWorkoutState = ref.watch(activeWorkoutProvider);
    final hasActiveWorkout = activeWorkoutState.workout != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Tracker'),
        actions: [
          const SyncStatusIndicator(),
          ProfileButton(onTap: () => context.push('/profile')),
          const SizedBox(width: 8),
        ],
      ),
      body: child,
      extendBody: true,
      bottomNavigationBar: _EnhancedBottomNavBar(
        hasActiveWorkout: hasActiveWorkout,
      ),
      floatingActionButton: _AnimatedWorkoutFAB(
        hasActiveWorkout: hasActiveWorkout,
        onPressed: () {
          if (hasActiveWorkout) {
            context.goToActiveWorkout();
          } else {
            _startNewWorkout(context, ref);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _startNewWorkout(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _StartWorkoutSheet(
        onStart: (name) {
          ref.read(activeWorkoutProvider.notifier).startWorkout(name: name);
          Navigator.pop(context);
          context.goToActiveWorkout();
        },
      ),
    );
  }
}

/// Animated FAB with pulse effect when workout is active.
class _AnimatedWorkoutFAB extends StatefulWidget {
  final bool hasActiveWorkout;
  final VoidCallback onPressed;

  const _AnimatedWorkoutFAB({
    required this.hasActiveWorkout,
    required this.onPressed,
  });

  @override
  State<_AnimatedWorkoutFAB> createState() => _AnimatedWorkoutFABState();
}

class _AnimatedWorkoutFABState extends State<_AnimatedWorkoutFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.hasActiveWorkout) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_AnimatedWorkoutFAB oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasActiveWorkout && !oldWidget.hasActiveWorkout) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.hasActiveWorkout && oldWidget.hasActiveWorkout) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.hasActiveWorkout ? _pulseAnimation.value : 1.0,
          child: Container(
            decoration: widget.hasActiveWorkout
                ? BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  )
                : null,
            child: FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.mediumImpact();
                widget.onPressed();
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  widget.hasActiveWorkout
                      ? Icons.play_arrow_rounded
                      : Icons.add_rounded,
                  key: ValueKey(widget.hasActiveWorkout),
                ),
              ),
              label: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  widget.hasActiveWorkout ? 'Continue' : 'Start Workout',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              backgroundColor: widget.hasActiveWorkout
                  ? AppColors.secondary
                  : AppColors.primary,
              elevation: widget.hasActiveWorkout ? 8 : 4,
            ),
          ),
        );
      },
    );
  }
}

/// Enhanced floating bottom navigation bar with glassmorphism effect.
class _EnhancedBottomNavBar extends StatelessWidget {
  final bool hasActiveWorkout;

  const _EnhancedBottomNavBar({required this.hasActiveWorkout});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = 0;
    if (location.startsWith(AppRoutes.exercises)) {
      currentIndex = 1;
    } else if (location.startsWith(AppRoutes.prs)) {
      currentIndex = 2;
    } else if (location.startsWith(AppRoutes.more) ||
        location.startsWith(AppRoutes.progress) ||
        location.startsWith(AppRoutes.templates) ||
        location.startsWith(AppRoutes.body) ||
        location.startsWith(AppRoutes.achievements)) {
      currentIndex = 3;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.borderDark.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _AnimatedNavItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () => context.goToHome(),
                  ),
                ),
                Expanded(
                  child: _AnimatedNavItem(
                    icon: Icons.fitness_center_outlined,
                    selectedIcon: Icons.fitness_center_rounded,
                    label: 'Exercises',
                    isSelected: currentIndex == 1,
                    onTap: () => context.goToExercises(),
                  ),
                ),
                const SizedBox(width: 72), // Space for FAB
                Expanded(
                  child: _AnimatedNavItem(
                    icon: Icons.emoji_events_outlined,
                    selectedIcon: Icons.emoji_events_rounded,
                    label: 'PRs',
                    isSelected: currentIndex == 2,
                    onTap: () => context.goToPRs(),
                    showBadge: false, // Can be made dynamic
                  ),
                ),
                Expanded(
                  child: _AnimatedNavItem(
                    icon: Icons.grid_view_outlined,
                    selectedIcon: Icons.grid_view_rounded,
                    label: 'More',
                    isSelected: currentIndex == 3,
                    onTap: () => context.goToMore(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated navigation item with scale and color transitions.
class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showBadge;
  const _AnimatedNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        widget.isSelected ? widget.selectedIcon : widget.icon,
                        key: ValueKey(widget.isSelected),
                        size: 24,
                        color: widget.isSelected
                            ? AppColors.primary
                            : AppColors.textTertiaryDark,
                      ),
                    ),
                  ),
                  if (widget.showBadge)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.surfaceDark,
                            width: 1.5,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 8,
                          minHeight: 8,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: widget.isSelected
                      ? AppColors.primary
                      : AppColors.textTertiaryDark,
                ),
                child: Text(widget.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartWorkoutSheet extends StatefulWidget {
  final Function(String?) onStart;

  const _StartWorkoutSheet({required this.onStart});

  @override
  State<_StartWorkoutSheet> createState() => _StartWorkoutSheetState();
}

class _StartWorkoutSheetState extends State<_StartWorkoutSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Start New Workout',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Workout name (optional)',
              prefixIcon: Icon(Icons.edit),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final name = _controller.text.trim();
              widget.onStart(name.isEmpty ? null : name);
            },
            child: const Text('Start Workout'),
          ),
        ],
      ),
    );
  }
}
