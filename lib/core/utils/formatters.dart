import 'package:intl/intl.dart';

/// Utility class for formatting values.
class Formatters {
  Formatters._();

  /// Format weight with unit
  static String weight(double value, {String unit = 'kg', int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)} $unit';
  }

  /// Format duration from milliseconds
  static String duration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Format duration from Duration object
  static String durationFromDuration(Duration duration) {
    return Formatters.duration(duration.inMilliseconds);
  }

  /// Format date as relative (today, yesterday, etc.)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    final difference = today.difference(dateDay).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return DateFormat('EEEE').format(date); // Day name
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  /// Format date with time
  static String dateTime(DateTime date) {
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  }

  /// Format date only
  static String date(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format time only
  static String time(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format number with commas
  static String number(num value) {
    return NumberFormat('#,###').format(value);
  }

  /// Format percentage
  static String percentage(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Format volume (weight × reps)
  static String volume(double value, {String unit = 'kg'}) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}k $unit';
    }
    return '${value.toStringAsFixed(0)} $unit';
  }
}
