import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  /// Load month data (mock implementation - connect to actual data source).
  Future<void> _loadMonthData(DateTime month) async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulate loading data
      await Future.delayed(const Duration(milliseconds: 300));

      // Generate mock data for demonstration
      final days = <int, CalendarDay>{};
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      final random = DateTime.now().millisecondsSinceEpoch;

      int totalWorkouts = 0;
      int totalPRs = 0;
      int totalMinutes = 0;

      for (int day = 1; day <= daysInMonth; day++) {
        // Create some workout days based on pseudo-random pattern
        final hasWorkout = (day + random) % 3 == 0 || (day + random) % 7 == 0;
        if (hasWorkout && day <= DateTime.now().day ||
            month.isBefore(DateTime.now())) {
          final hasPR = (day + random) % 11 == 0;
          final duration = 45 + ((day * 7) % 60);
          final intensity = 3 + (day % 7);
          final sets = 12 + (day % 10);
          final volume = (sets * 50.0 * (1 + day % 5));

          days[day] = CalendarDay(
            date: DateTime(month.year, month.month, day),
            workoutCount: 1,
            totalDurationMinutes: duration,
            totalSets: sets,
            totalVolume: volume,
            prsAchieved: hasPR ? 1 : 0,
            intensityLevel: intensity,
            muscleGroups: _getMuscleGroupsForDay(day),
          );

          totalWorkouts++;
          if (hasPR) totalPRs++;
          totalMinutes += duration;
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

  /// Load streak data.
  Future<void> _loadStreakData() async {
    // Mock streak data
    state = state.copyWith(
      streak: WorkoutStreak(
        currentStreak: 12,
        longestStreak: 28,
        lastWorkoutDate: DateTime.now().subtract(const Duration(days: 1)),
        streakStartDate: DateTime.now().subtract(const Duration(days: 12)),
        weeklyGoal: 4,
        workoutsThisWeek: 3,
      ),
    );
  }

  /// Update weekly goal.
  void setWeeklyGoal(int goal) {
    state = state.copyWith(streak: state.streak.copyWith(weeklyGoal: goal));
  }

  List<String> _getMuscleGroupsForDay(int day) {
    final groups = [
      ['Chest', 'Triceps', 'Shoulders'],
      ['Back', 'Biceps'],
      ['Legs', 'Glutes'],
      ['Shoulders', 'Arms'],
      ['Full Body'],
    ];
    return groups[day % groups.length];
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
