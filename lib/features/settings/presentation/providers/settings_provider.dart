import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

/// Settings state model.
class AppSettings {
  final bool useMetricUnits;
  final bool enableNotifications;
  final bool enableSounds;
  final bool autoStartTimer;
  final bool keepScreenOn;
  final int defaultRestTimeSeconds;
  final bool isPremium;
  final List<ReminderTime> reminderTimes;

  const AppSettings({
    this.useMetricUnits = true,
    this.enableNotifications = true,
    this.enableSounds = true,
    this.autoStartTimer = true,
    this.keepScreenOn = false,
    this.defaultRestTimeSeconds = 90,
    this.isPremium = false,
    this.reminderTimes = const [],
  });

  AppSettings copyWith({
    bool? useMetricUnits,
    bool? enableNotifications,
    bool? enableSounds,
    bool? autoStartTimer,
    bool? keepScreenOn,
    int? defaultRestTimeSeconds,
    bool? isPremium,
    List<ReminderTime>? reminderTimes,
  }) {
    return AppSettings(
      useMetricUnits: useMetricUnits ?? this.useMetricUnits,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableSounds: enableSounds ?? this.enableSounds,
      autoStartTimer: autoStartTimer ?? this.autoStartTimer,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      defaultRestTimeSeconds:
          defaultRestTimeSeconds ?? this.defaultRestTimeSeconds,
      isPremium: isPremium ?? this.isPremium,
      reminderTimes: reminderTimes ?? this.reminderTimes,
    );
  }
}

/// Reminder time model.
class ReminderTime {
  final int hour;
  final int minute;
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday
  final bool enabled;

  const ReminderTime({
    required this.hour,
    required this.minute,
    this.daysOfWeek = const [1, 2, 3, 4, 5], // Weekdays by default
    this.enabled = true,
  });

  String get formattedTime {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final amPm = hour < 12 ? 'AM' : 'PM';
    return '$h:${minute.toString().padLeft(2, '0')} $amPm';
  }

  String get formattedDays {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (daysOfWeek.length == 7) return 'Every day';
    if (daysOfWeek.length == 5 && daysOfWeek.every((d) => d >= 1 && d <= 5))
      return 'Weekdays';
    if (daysOfWeek.length == 2 &&
        daysOfWeek.contains(6) &&
        daysOfWeek.contains(7))
      return 'Weekends';
    return daysOfWeek.map((d) => dayNames[d - 1]).join(', ');
  }

  ReminderTime copyWith({
    int? hour,
    int? minute,
    List<int>? daysOfWeek,
    bool? enabled,
  }) {
    return ReminderTime(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'hour': hour,
    'minute': minute,
    'daysOfWeek': daysOfWeek,
    'enabled': enabled,
  };

  factory ReminderTime.fromJson(Map<String, dynamic> json) => ReminderTime(
    hour: json['hour'] as int,
    minute: json['minute'] as int,
    daysOfWeek: List<int>.from(json['daysOfWeek'] as List),
    enabled: json['enabled'] as bool,
  );
}

/// Settings notifier with SharedPreferences persistence.
@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  static const _useMetricKey = 'settings_use_metric';
  static const _enableNotificationsKey = 'settings_enable_notifications';
  static const _enableSoundsKey = 'settings_enable_sounds';
  static const _autoStartTimerKey = 'settings_auto_start_timer';
  static const _keepScreenOnKey = 'settings_keep_screen_on';
  static const _defaultRestTimeKey = 'settings_default_rest_time';
  static const _isPremiumKey = 'settings_is_premium';
  static const _reminderTimesKey = 'settings_reminder_times';

  late SharedPreferences _prefs;

  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    final reminderTimesJson = _prefs.getStringList(_reminderTimesKey) ?? [];
    final reminderTimes = reminderTimesJson.map((json) {
      try {
        return ReminderTime.fromJson(
          Map<String, dynamic>.from(
            Uri.decodeFull(json).split('&').fold<Map<String, dynamic>>({}, (
              map,
              part,
            ) {
              final parts = part.split('=');
              if (parts.length == 2) {
                final key = parts[0];
                final value = parts[1];
                if (key == 'daysOfWeek') {
                  map[key] = value.split(',').map(int.parse).toList();
                } else if (key == 'enabled') {
                  map[key] = value == 'true';
                } else {
                  map[key] = int.parse(value);
                }
              }
              return map;
            }),
          ),
        );
      } catch (_) {
        return const ReminderTime(hour: 9, minute: 0);
      }
    }).toList();

    state = AppSettings(
      useMetricUnits: _prefs.getBool(_useMetricKey) ?? true,
      enableNotifications: _prefs.getBool(_enableNotificationsKey) ?? true,
      enableSounds: _prefs.getBool(_enableSoundsKey) ?? true,
      autoStartTimer: _prefs.getBool(_autoStartTimerKey) ?? true,
      keepScreenOn: _prefs.getBool(_keepScreenOnKey) ?? false,
      defaultRestTimeSeconds: _prefs.getInt(_defaultRestTimeKey) ?? 90,
      isPremium: _prefs.getBool(_isPremiumKey) ?? false,
      reminderTimes: reminderTimes,
    );
  }

  Future<void> setUseMetricUnits(bool value) async {
    state = state.copyWith(useMetricUnits: value);
    await _prefs.setBool(_useMetricKey, value);
  }

  Future<void> setEnableNotifications(bool value) async {
    state = state.copyWith(enableNotifications: value);
    await _prefs.setBool(_enableNotificationsKey, value);
  }

  Future<void> setEnableSounds(bool value) async {
    state = state.copyWith(enableSounds: value);
    await _prefs.setBool(_enableSoundsKey, value);
  }

  Future<void> setAutoStartTimer(bool value) async {
    state = state.copyWith(autoStartTimer: value);
    await _prefs.setBool(_autoStartTimerKey, value);
  }

  Future<void> setKeepScreenOn(bool value) async {
    state = state.copyWith(keepScreenOn: value);
    await _prefs.setBool(_keepScreenOnKey, value);
  }

  Future<void> setDefaultRestTime(int seconds) async {
    state = state.copyWith(defaultRestTimeSeconds: seconds);
    await _prefs.setInt(_defaultRestTimeKey, seconds);
  }

  Future<void> setIsPremium(bool value) async {
    state = state.copyWith(isPremium: value);
    await _prefs.setBool(_isPremiumKey, value);
  }

  Future<void> addReminderTime(ReminderTime reminder) async {
    final updated = [...state.reminderTimes, reminder];
    state = state.copyWith(reminderTimes: updated);
    await _saveReminderTimes(updated);
  }

  Future<void> updateReminderTime(int index, ReminderTime reminder) async {
    final updated = [...state.reminderTimes];
    if (index >= 0 && index < updated.length) {
      updated[index] = reminder;
      state = state.copyWith(reminderTimes: updated);
      await _saveReminderTimes(updated);
    }
  }

  Future<void> removeReminderTime(int index) async {
    final updated = [...state.reminderTimes];
    if (index >= 0 && index < updated.length) {
      updated.removeAt(index);
      state = state.copyWith(reminderTimes: updated);
      await _saveReminderTimes(updated);
    }
  }

  Future<void> _saveReminderTimes(List<ReminderTime> reminders) async {
    final jsonList = reminders.map((r) {
      return 'hour=${r.hour}&minute=${r.minute}&daysOfWeek=${r.daysOfWeek.join(',')}&enabled=${r.enabled}';
    }).toList();
    await _prefs.setStringList(_reminderTimesKey, jsonList);
  }
}
