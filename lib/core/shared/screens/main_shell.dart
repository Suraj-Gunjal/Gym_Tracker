import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features/workout/presentation/providers/workout_provider.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../widgets/sync_indicator.dart';

/// Main shell with bottom navigation bar.
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
      bottomNavigationBar: _BottomNavBar(hasActiveWorkout: hasActiveWorkout),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (hasActiveWorkout) {
            context.goToActiveWorkout();
          } else {
            _startNewWorkout(context, ref);
          }
        },
        icon: Icon(hasActiveWorkout ? Icons.play_arrow : Icons.add),
        label: Text(hasActiveWorkout ? 'Continue Workout' : 'Start Workout'),
        backgroundColor: hasActiveWorkout
            ? AppColors.secondary
            : AppColors.primary,
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

class _BottomNavBar extends StatelessWidget {
  final bool hasActiveWorkout;

  const _BottomNavBar({required this.hasActiveWorkout});

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

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => context.goToHome(),
          ),
          _NavItem(
            icon: Icons.fitness_center_outlined,
            selectedIcon: Icons.fitness_center,
            label: 'Exercises',
            isSelected: currentIndex == 1,
            onTap: () => context.goToExercises(),
          ),
          const SizedBox(width: 56), // Space for FAB
          _NavItem(
            icon: Icons.emoji_events_outlined,
            selectedIcon: Icons.emoji_events,
            label: 'PRs',
            isSelected: currentIndex == 2,
            onTap: () => context.goToPRs(),
          ),
          _NavItem(
            icon: Icons.more_horiz,
            selectedIcon: Icons.more_horiz,
            label: 'More',
            isSelected: currentIndex == 3,
            onTap: () => context.goToMore(),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 22,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textTertiaryDark,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textTertiaryDark,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
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
