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
import '../../features/templates/presentation/screens/templates_screen.dart';
import '../../features/body/presentation/screens/body_measurements_screen.dart';
import '../../features/achievements/presentation/screens/achievements_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/notes/presentation/screens/challenges_screen.dart';
import '../../features/social/presentation/screens/social_feed_screen.dart';
import '../../features/data_management/presentation/screens/data_management_screen.dart';
// Premium features
import '../../features/calculator/presentation/screens/one_rm_calculator_screen.dart';
import '../../features/calculator/presentation/screens/plate_calculator_screen.dart';
import '../../features/recovery/presentation/screens/muscle_heatmap_screen.dart';
import '../../features/programs/presentation/screens/workout_programs_screen.dart';
import '../../features/ai/presentation/screens/ai_recommendations_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/form_coach/presentation/screens/form_coach_screen.dart';
import '../../features/smart_suggestions/presentation/screens/smart_suggestions_screen.dart';
import '../../features/natural_log/presentation/screens/natural_log_screen.dart';
import '../../features/weekly_insights/presentation/screens/weekly_insights_screen.dart';
// New features
import '../../features/measurements/presentation/screens/measurements_screen.dart';
import '../../features/photos/presentation/screens/progress_photos_screen.dart';
import '../shared/screens/main_shell.dart';
import '../shared/screens/more_screen.dart';
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
  // New routes
  static const String templates = '/templates';
  static const String body = '/body';
  static const String achievements = '/achievements';
  static const String more = '/more';
  static const String calendar = '/calendar';
  static const String challenges = '/challenges';
  static const String social = '/social';
  static const String dataManagement = '/data-management';
  // Premium feature routes
  static const String oneRmCalculator = '/calculator/1rm';
  static const String plateCalculator = '/calculator/plates';
  static const String muscleHeatmap = '/recovery';
  static const String workoutPrograms = '/programs';
  static const String aiCoach = '/ai-coach';
  static const String settingsScreen = '/settings-screen';
  // New feature routes
  static const String measurements = '/measurements';
  static const String progressPhotos = '/photos';
  static const String formCoach = '/form-coach';
  static const String smartSuggestions = '/smart-suggestions';
  static const String naturalLog = '/natural-log';
  static const String weeklyInsights = '/weekly-insights';
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

        // Templates tab
        GoRoute(
          path: AppRoutes.templates,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: TemplatesScreen()),
        ),

        // Body measurements tab
        GoRoute(
          path: AppRoutes.body,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: BodyMeasurementsScreen()),
        ),

        // Achievements tab
        GoRoute(
          path: AppRoutes.achievements,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AchievementsScreen()),
        ),

        // More tab
        GoRoute(
          path: AppRoutes.more,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MoreScreen()),
        ),

        // Calendar tab
        GoRoute(
          path: AppRoutes.calendar,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: CalendarScreen()),
        ),

        // Challenges tab
        GoRoute(
          path: AppRoutes.challenges,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ChallengesScreen()),
        ),

        // Social tab
        GoRoute(
          path: AppRoutes.social,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SocialFeedScreen()),
        ),

        // Data Management
        GoRoute(
          path: AppRoutes.dataManagement,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: DataManagementScreen()),
        ),

        // Premium features
        GoRoute(
          path: AppRoutes.oneRmCalculator,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: OneRMCalculatorScreen()),
        ),

        GoRoute(
          path: AppRoutes.plateCalculator,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PlateCalculatorScreen()),
        ),

        GoRoute(
          path: AppRoutes.muscleHeatmap,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MuscleHeatmapScreen()),
        ),

        GoRoute(
          path: AppRoutes.workoutPrograms,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: WorkoutProgramsScreen()),
        ),

        GoRoute(
          path: AppRoutes.aiCoach,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: AIRecommendationsScreen()),
        ),

        GoRoute(
          path: AppRoutes.settingsScreen,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SettingsScreen()),
        ),

        // New features
        GoRoute(
          path: AppRoutes.measurements,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: MeasurementsScreen()),
        ),

        GoRoute(
          path: AppRoutes.progressPhotos,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: ProgressPhotosScreen()),
        ),

        GoRoute(
          path: AppRoutes.formCoach,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FormCoachScreen()),
        ),

        GoRoute(
          path: AppRoutes.smartSuggestions,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SmartSuggestionsScreen()),
        ),

        GoRoute(
          path: AppRoutes.naturalLog,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: NaturalLogScreen()),
        ),

        GoRoute(
          path: AppRoutes.weeklyInsights,
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: WeeklyInsightsScreen()),
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
  void goToTemplates() => go(AppRoutes.templates);
  void goToBody() => go(AppRoutes.body);
  void goToAchievements() => go(AppRoutes.achievements);
  void goToMore() => go(AppRoutes.more);
  void goToCalendar() => go(AppRoutes.calendar);
  void goToChallenges() => go(AppRoutes.challenges);
  void goToSocial() => go(AppRoutes.social);
  void goToDataManagement() => go(AppRoutes.dataManagement);
  // Premium features
  void goToOneRmCalculator() => go(AppRoutes.oneRmCalculator);
  void goToPlateCalculator() => go(AppRoutes.plateCalculator);
  void goToMuscleHeatmap() => go(AppRoutes.muscleHeatmap);
  void goToWorkoutPrograms() => go(AppRoutes.workoutPrograms);
  void goToAiCoach() => go(AppRoutes.aiCoach);
  void goToSettings() => go(AppRoutes.settingsScreen);
  // New features
  void goToMeasurements() => go(AppRoutes.measurements);
  void goToProgressPhotos() => go(AppRoutes.progressPhotos);
  void goToFormCoach() => go(AppRoutes.formCoach);
  void goToSmartSuggestions() => go(AppRoutes.smartSuggestions);
  void goToNaturalLog() => go(AppRoutes.naturalLog);
  void goToWeeklyInsights() => go(AppRoutes.weeklyInsights);
}
