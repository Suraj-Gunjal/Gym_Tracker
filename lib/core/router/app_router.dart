import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/profile_screen.dart';
import '../../features/exercise/presentation/screens/exercise_list_screen.dart';
import '../../features/exercise/presentation/screens/exercise_detail_screen.dart';
import '../../features/pr/presentation/screens/pr_list_screen.dart';
import '../../features/progress/presentation/screens/progress_screen.dart';
import '../../features/workout/presentation/screens/active_workout_screen.dart';
import '../../features/workout/presentation/screens/workout_history_screen.dart';
import '../shared/screens/main_shell.dart';
import '../shared/screens/splash_screen.dart';

/// Route names for type-safe navigation.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String home = '/';
  static const String workout = '/workout';
  static const String activeWorkout = '/workout/active';
  static const String workoutHistory = '/workout/history';
  static const String exercises = '/exercises';
  static const String exerciseDetail = '/exercises/:id';
  static const String prs = '/prs';
  static const String progress = '/progress';
  static const String settings = '/settings';
  static const String login = '/login';
  static const String profile = '/profile';
}

/// App router configuration using go_router.
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    // Splash screen
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // Main shell with bottom navigation
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        // Home/Dashboard
        GoRoute(
          path: AppRoutes.home,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: WorkoutHistoryScreen()),
        ),

        // Exercises tab
        GoRoute(
          path: AppRoutes.exercises,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ExerciseListScreen()),
        ),

        // PRs tab
        GoRoute(
          path: AppRoutes.prs,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PRListScreen()),
        ),

        // Progress tab
        GoRoute(
          path: AppRoutes.progress,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProgressScreen()),
        ),
      ],
    ),

    // Active workout (full screen, outside shell)
    GoRoute(
      path: AppRoutes.activeWorkout,
      builder: (context, state) => const ActiveWorkoutScreen(),
    ),

    // Exercise detail
    GoRoute(
      path: AppRoutes.exerciseDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ExerciseDetailScreen(exerciseId: id);
      },
    ),

    // Auth screens
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),

    // Profile screen
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

/// Navigation extensions for easier routing.
extension GoRouterExtension on BuildContext {
  void goToActiveWorkout() => go(AppRoutes.activeWorkout);
  void goToExercises() => go(AppRoutes.exercises);
  void goToExerciseDetail(String id) => go('/exercises/$id');
  void goToPRs() => go(AppRoutes.prs);
  void goToProgress() => go(AppRoutes.progress);
  void goToHome() => go(AppRoutes.home);
  void goToLogin() => go(AppRoutes.login);
  void goToProfile() => go(AppRoutes.profile);
}
