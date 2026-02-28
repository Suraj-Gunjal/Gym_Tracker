import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../domain/entities/calendar_day.dart';

part 'calendar_provider.g.dart';

/// Provider for calendar state.
@riverpod
class CalendarNotifier extends _$CalendarNotifier {
  @override
  CalendarState build() {
    final now = DateTime.now();
    _loadMonthData(now);
    _loadStreakData();
    return CalendarState(
      selectedDate: now,
      focusedMonth: DateTime(now.year, now.month),
    );
  }

  /// Select a specific date.
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  /// Navigate to a different month.
  void goToMonth(DateTime month) {
    final focusedMonth = DateTime(month.year, month.month);
    state = state.copyWith(focusedMonth: focusedMonth);
    _loadMonthData(focusedMonth);
  }

  /// Go to previous month.
  void previousMonth() {
    final prev = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month - 1,
    );
    goToMonth(prev);
  }

  /// Go to next month.
  void nextMonth() {
    final next = DateTime(
      state.focusedMonth.year,
      state.focusedMonth.month + 1,
    );
    goToMonth(next);
  }

  /// Go to today.
  void goToToday() {
    final now = DateTime.now();
    state = state.copyWith(
      selectedDate: now,
      focusedMonth: DateTime(now.year, now.month),
    );
    _loadMonthData(now);
  }

  /// Change view mode.
  void setViewMode(CalendarViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  /// Load month data from real workout repository.
  Future<void> _loadMonthData(DateTime month) async {
    state = state.copyWith(isLoading: true);

    try {
      final workoutRepository = ref.read(workoutRepositoryProvider);
      final exerciseRepository = ref.read(exerciseRepositoryProvider);

      // Get all workouts and exercises
      final allWorkouts = await workoutRepository.getAllWorkouts();
      final allExercises = await exerciseRepository.getAllExercises();

      // Create exercise lookup map
      final exerciseMap = {for (var e in allExercises) e.id: e};

      // Filter workouts for this month
      final monthStart = DateTime(month.year, month.month, 1);
      final monthEnd = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      final monthWorkouts = allWorkouts.where((w) {
        final workoutDate = w.completedAt ?? w.startedAt;
        return workoutDate.isAfter(
              monthStart.subtract(const Duration(days: 1)),
            ) &&
            workoutDate.isBefore(monthEnd.add(const Duration(days: 1)));
      }).toList();

      // Group workouts by day
      final days = <int, CalendarDay>{};
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

      int totalWorkouts = 0;
      int totalPRs = 0;
      int totalMinutes = 0;

      for (int day = 1; day <= daysInMonth; day++) {
        final dayStart = DateTime(month.year, month.month, day);
        final dayEnd = DateTime(month.year, month.month, day, 23, 59, 59);

        final dayWorkouts = monthWorkouts.where((w) {
          final workoutDate = w.completedAt ?? w.startedAt;
          return workoutDate.isAfter(
                dayStart.subtract(const Duration(seconds: 1)),
              ) &&
              workoutDate.isBefore(dayEnd.add(const Duration(seconds: 1)));
        }).toList();

        if (dayWorkouts.isNotEmpty) {
          int daySets = 0;
          double dayVolume = 0;
          int dayDurationMinutes = 0;
          final muscleGroups = <String>{};

          for (final workout in dayWorkouts) {
            // Calculate duration
            if (workout.duration != null) {
              dayDurationMinutes += workout.duration!.inMinutes;
            }

            for (final exercise in workout.exercises.where((e) => !e.deleted)) {
              // Get muscle group from exercise
              final exerciseInfo = exerciseMap[exercise.exerciseId];
              if (exerciseInfo != null) {
                muscleGroups.add(exerciseInfo.muscleGroup.name);
              }

              for (final set in exercise.sets.where((s) => s.completed)) {
                daySets++;
                dayVolume += set.weight * set.reps;
              }
            }
          }

          // Calculate intensity level (1-10 based on volume)
          final intensityLevel = _calculateIntensityLevel(dayVolume, daySets);

          days[day] = CalendarDay(
            date: DateTime(month.year, month.month, day),
            workoutCount: dayWorkouts.length,
            totalDurationMinutes: dayDurationMinutes,
            totalSets: daySets,
            totalVolume: dayVolume,
            prsAchieved: 0, // PRs tracked separately in PR feature
            intensityLevel: intensityLevel,
            muscleGroups: muscleGroups.toList(),
          );

          totalWorkouts += dayWorkouts.length;
          totalMinutes += dayDurationMinutes;
        }
      }

      final calendarMonth = CalendarMonth(
        year: month.year,
        month: month.month,
        days: days,
        totalWorkouts: totalWorkouts,
        totalPRs: totalPRs,
        totalDuration: Duration(minutes: totalMinutes),
      );

      final updatedCache = Map<String, CalendarMonth>.from(state.monthsCache);
      updatedCache[CalendarState.monthKey(month)] = calendarMonth;

      state = state.copyWith(monthsCache: updatedCache, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Calculate intensity level from volume and sets.
  int _calculateIntensityLevel(double volume, int sets) {
    if (sets == 0) return 0;

    // Calculate average volume per set
    final avgVolumePerSet = volume / sets;

    // Map to 1-10 scale (adjust thresholds as needed)
    if (avgVolumePerSet > 500) return 10;
    if (avgVolumePerSet > 400) return 9;
    if (avgVolumePerSet > 300) return 8;
    if (avgVolumePerSet > 250) return 7;
    if (avgVolumePerSet > 200) return 6;
    if (avgVolumePerSet > 150) return 5;
    if (avgVolumePerSet > 100) return 4;
    if (avgVolumePerSet > 50) return 3;
    if (avgVolumePerSet > 25) return 2;
    return 1;
  }

  /// Load streak data from real workouts.
  Future<void> _loadStreakData() async {
    try {
      final workoutRepository = ref.read(workoutRepositoryProvider);
      final allWorkouts = await workoutRepository.getAllWorkouts();

      // Get completed workouts sorted by date
      final completedWorkouts =
          allWorkouts.where((w) => w.completedAt != null).toList()
            ..sort((a, b) => b.completedAt!.compareTo(a.completedAt!));

      if (completedWorkouts.isEmpty) {
        state = state.copyWith(
          streak: const WorkoutStreak(
            currentStreak: 0,
            longestStreak: 0,
            weeklyGoal: 4,
            workoutsThisWeek: 0,
          ),
        );
        return;
      }

      // Calculate current streak
      int currentStreak = 0;
      int longestStreak = 0;
      int tempStreak = 0;
      DateTime? lastWorkoutDate = completedWorkouts.first.completedAt;
      DateTime? streakStartDate;

      // Group workouts by date (normalize to date only)
      final workoutDates =
          completedWorkouts
              .map(
                (w) => DateTime(
                  w.completedAt!.year,
                  w.completedAt!.month,
                  w.completedAt!.day,
                ),
              )
              .toSet()
              .toList()
            ..sort((a, b) => b.compareTo(a)); // Most recent first

      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      final yesterday = today.subtract(const Duration(days: 1));

      // Check if streak is active (worked out today or yesterday)
      bool streakActive = false;
      if (workoutDates.isNotEmpty) {
        final mostRecent = workoutDates.first;
        streakActive = mostRecent == today || mostRecent == yesterday;
      }

      if (streakActive && workoutDates.isNotEmpty) {
        streakStartDate = workoutDates.first;
        currentStreak = 1;

        for (int i = 1; i < workoutDates.length; i++) {
          final prevDate = workoutDates[i - 1];
          final currDate = workoutDates[i];
          final diff = prevDate.difference(currDate).inDays;

          if (diff == 1) {
            currentStreak++;
            streakStartDate = currDate;
          } else {
            break;
          }
        }
      }

      // Calculate longest streak ever
      if (workoutDates.isNotEmpty) {
        tempStreak = 1;
        longestStreak = 1;

        for (int i = 1; i < workoutDates.length; i++) {
          final prevDate = workoutDates[i - 1];
          final currDate = workoutDates[i];
          final diff = prevDate.difference(currDate).inDays;

          if (diff == 1) {
            tempStreak++;
            if (tempStreak > longestStreak) {
              longestStreak = tempStreak;
            }
          } else {
            tempStreak = 1;
          }
        }
      }

      // Calculate workouts this week
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      final workoutsThisWeek = completedWorkouts.where((w) {
        final workoutDate = DateTime(
          w.completedAt!.year,
          w.completedAt!.month,
          w.completedAt!.day,
        );
        return workoutDate.isAfter(
              weekStart.subtract(const Duration(days: 1)),
            ) &&
            workoutDate.isBefore(today.add(const Duration(days: 1)));
      }).length;

      state = state.copyWith(
        streak: WorkoutStreak(
          currentStreak: currentStreak,
          longestStreak: longestStreak > currentStreak
              ? longestStreak
              : currentStreak,
          lastWorkoutDate: lastWorkoutDate,
          streakStartDate: streakStartDate,
          weeklyGoal: state.streak.weeklyGoal,
          workoutsThisWeek: workoutsThisWeek,
        ),
      );
    } catch (e) {
      // Keep existing streak data on error
    }
  }

  /// Update weekly goal.
  void setWeeklyGoal(int goal) {
    state = state.copyWith(streak: state.streak.copyWith(weeklyGoal: goal));
  }

  /// Refresh all calendar data.
  Future<void> refresh() async {
    await _loadMonthData(state.focusedMonth);
    await _loadStreakData();
  }
}

/// Provider for selected day's workouts.
@riverpod
CalendarDay? selectedDayData(Ref ref) {
  final calendarState = ref.watch(calendarNotifierProvider);
  return calendarState.selectedDayData;
}

/// Provider for current streak.
@riverpod
WorkoutStreak currentStreak(Ref ref) {
  final calendarState = ref.watch(calendarNotifierProvider);
  return calendarState.streak;
}

/// Provider for current month stats.
@riverpod
CalendarMonth? currentMonthStats(Ref ref) {
  final calendarState = ref.watch(calendarNotifierProvider);
  return calendarState.currentMonthData;
}
