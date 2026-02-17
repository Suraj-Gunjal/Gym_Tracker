import 'package:flutter/material.dart';

/// Represents a single day's workout summary for the calendar.
class CalendarDay {
  final DateTime date;
  final int workoutCount;
  final int totalDurationMinutes;
  final int totalSets;
  final double totalVolume;
  final int prsAchieved;
  final int intensityLevel;
  final List<String> muscleGroups;

  const CalendarDay({
    required this.date,
    this.workoutCount = 0,
    this.totalDurationMinutes = 0,
    this.totalSets = 0,
    this.totalVolume = 0.0,
    this.prsAchieved = 0,
    this.intensityLevel = 0,
    this.muscleGroups = const [],
  });

  /// Whether this day has any workouts.
  bool get hasWorkout => workoutCount > 0;

  /// Whether this day has a PR.
  bool get hasPR => prsAchieved > 0;

  /// Get intensity color for heat map.
  Color get intensityColor {
    if (!hasWorkout) return Colors.transparent;

    // Green gradient based on intensity
    const colors = [
      Color(0xFF064E3B), // Very light
      Color(0xFF065F46),
      Color(0xFF047857),
      Color(0xFF059669),
      Color(0xFF10B981),
      Color(0xFF34D399),
      Color(0xFF6EE7B7),
      Color(0xFFA7F3D0),
      Color(0xFFD1FAE5),
      Color(0xFFECFDF5), // Very intense
    ];

    final index = (intensityLevel - 1).clamp(0, 9);
    return colors[9 - index]; // Reverse so higher = brighter
  }

  /// Format duration as string.
  String get formattedDuration {
    if (totalDurationMinutes < 60) {
      return '${totalDurationMinutes}m';
    }
    final hours = totalDurationMinutes ~/ 60;
    final mins = totalDurationMinutes % 60;
    return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
  }

  /// Format volume as string.
  String get formattedVolume {
    if (totalVolume >= 1000000) {
      return '${(totalVolume / 1000000).toStringAsFixed(1)}M kg';
    }
    if (totalVolume >= 1000) {
      return '${(totalVolume / 1000).toStringAsFixed(1)}K kg';
    }
    return '${totalVolume.toStringAsFixed(0)} kg';
  }

  CalendarDay copyWith({
    DateTime? date,
    int? workoutCount,
    int? totalDurationMinutes,
    int? totalSets,
    double? totalVolume,
    int? prsAchieved,
    int? intensityLevel,
    List<String>? muscleGroups,
  }) {
    return CalendarDay(
      date: date ?? this.date,
      workoutCount: workoutCount ?? this.workoutCount,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      totalSets: totalSets ?? this.totalSets,
      totalVolume: totalVolume ?? this.totalVolume,
      prsAchieved: prsAchieved ?? this.prsAchieved,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      muscleGroups: muscleGroups ?? this.muscleGroups,
    );
  }
}

/// Represents workout streak data.
class WorkoutStreak {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastWorkoutDate;
  final DateTime? streakStartDate;
  final int weeklyGoal;
  final int workoutsThisWeek;

  const WorkoutStreak({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastWorkoutDate,
    this.streakStartDate,
    this.weeklyGoal = 3,
    this.workoutsThisWeek = 0,
  });

  /// Weekly progress as percentage.
  double get weeklyProgress =>
      weeklyGoal > 0 ? (workoutsThisWeek / weeklyGoal).clamp(0.0, 1.0) : 0.0;

  /// Whether weekly goal is achieved.
  bool get weeklyGoalAchieved => workoutsThisWeek >= weeklyGoal;

  /// Days until streak breaks (assuming daily workout needed).
  int get daysUntilStreakBreaks {
    if (lastWorkoutDate == null) return 0;
    final now = DateTime.now();
    final daysSince = now.difference(lastWorkoutDate!).inDays;
    return (2 - daysSince).clamp(0, 2); // 2-day grace period
  }

  /// Whether streak is at risk.
  bool get isStreakAtRisk => currentStreak > 0 && daysUntilStreakBreaks <= 1;

  WorkoutStreak copyWith({
    int? currentStreak,
    int? longestStreak,
    DateTime? lastWorkoutDate,
    DateTime? streakStartDate,
    int? weeklyGoal,
    int? workoutsThisWeek,
  }) {
    return WorkoutStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastWorkoutDate: lastWorkoutDate ?? this.lastWorkoutDate,
      streakStartDate: streakStartDate ?? this.streakStartDate,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      workoutsThisWeek: workoutsThisWeek ?? this.workoutsThisWeek,
    );
  }
}

/// Monthly calendar data.
class CalendarMonth {
  final int year;
  final int month;
  final Map<int, CalendarDay> days; // Day number -> CalendarDay
  final int totalWorkouts;
  final int totalPRs;
  final Duration totalDuration;

  const CalendarMonth({
    required this.year,
    required this.month,
    this.days = const {},
    this.totalWorkouts = 0,
    this.totalPRs = 0,
    this.totalDuration = Duration.zero,
  });

  /// Get the month name.
  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  /// Get short month name.
  String get shortMonthName {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  /// Number of days with workouts.
  int get activeDays => days.values.where((d) => d.hasWorkout).length;

  /// Workout frequency (workouts per week).
  double get frequency {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final weeks = daysInMonth / 7;
    return totalWorkouts / weeks;
  }

  /// Get day data for a specific day number.
  CalendarDay? getDay(int day) => days[day];
}

/// Calendar view mode.
enum CalendarViewMode { month, week, year }

/// State for the calendar feature.
class CalendarState {
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final CalendarViewMode viewMode;
  final Map<String, CalendarMonth> monthsCache; // "YYYY-MM" -> CalendarMonth
  final WorkoutStreak streak;
  final bool isLoading;
  final String? error;

  const CalendarState({
    required this.selectedDate,
    required this.focusedMonth,
    this.viewMode = CalendarViewMode.month,
    this.monthsCache = const {},
    this.streak = const WorkoutStreak(),
    this.isLoading = false,
    this.error,
  });

  /// Get cache key for a month.
  static String monthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  /// Get current month data.
  CalendarMonth? get currentMonthData => monthsCache[monthKey(focusedMonth)];

  /// Get selected day data.
  CalendarDay? get selectedDayData {
    final month = monthsCache[monthKey(selectedDate)];
    return month?.getDay(selectedDate.day);
  }

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? focusedMonth,
    CalendarViewMode? viewMode,
    Map<String, CalendarMonth>? monthsCache,
    WorkoutStreak? streak,
    bool? isLoading,
    String? error,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      viewMode: viewMode ?? this.viewMode,
      monthsCache: monthsCache ?? this.monthsCache,
      streak: streak ?? this.streak,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
