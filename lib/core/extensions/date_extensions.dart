/// Extension methods on DateTime for easier date manipulation.
extension DateExtensions on DateTime {
  /// Get the start of the day (midnight)
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get the end of the day (23:59:59.999)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Get the start of the week (Monday)
  DateTime get startOfWeek {
    final difference = weekday - 1;
    return subtract(Duration(days: difference)).startOfDay;
  }

  /// Get the end of the week (Sunday)
  DateTime get endOfWeek {
    final difference = 7 - weekday;
    return add(Duration(days: difference)).endOfDay;
  }

  /// Get the start of the month
  DateTime get startOfMonth => DateTime(year, month, 1);

  /// Get the end of the month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Get the start of the year
  DateTime get startOfYear => DateTime(year, 1, 1);

  /// Get the end of the year
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Check if this date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if this date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if this date is in the same week as now
  bool get isThisWeek {
    final now = DateTime.now();
    return isAfter(now.startOfWeek.subtract(const Duration(seconds: 1))) &&
        isBefore(now.endOfWeek.add(const Duration(seconds: 1)));
  }

  /// Check if this date is in the same month as now
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Check if this date is in the same year as now
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  /// Get the number of days in this month
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  /// Check if two dates are on the same day
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Get a date with a specific time
  DateTime withTime(int hour, [int minute = 0, int second = 0]) {
    return DateTime(year, month, day, hour, minute, second);
  }

  /// Add days to the date
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days from the date
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add weeks to the date
  DateTime addWeeks(int weeks) => add(Duration(days: weeks * 7));

  /// Add months to the date
  DateTime addMonths(int months) {
    var newMonth = month + months;
    var newYear = year;
    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth < 1) {
      newMonth += 12;
      newYear--;
    }
    final maxDay = DateTime(newYear, newMonth + 1, 0).day;
    return DateTime(newYear, newMonth, day > maxDay ? maxDay : day);
  }
}
