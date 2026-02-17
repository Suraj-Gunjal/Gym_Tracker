import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/rest_timer.dart';

part 'rest_timer_provider.g.dart';

/// Provider for rest timer settings
@riverpod
class RestTimerSettingsNotifier extends _$RestTimerSettingsNotifier {
  @override
  RestTimerSettings build() {
    return const RestTimerSettings.defaults();
  }

  void updateSettings(RestTimerSettings settings) {
    state = settings;
  }

  void setDefaultRestTime(int seconds) {
    state = state.copyWith(
      defaultRestSeconds: seconds,
      updatedAt: DateTime.now(),
    );
  }

  void setAutoStart(bool autoStart) {
    state = state.copyWith(
      autoStartTimer: autoStart,
      updatedAt: DateTime.now(),
    );
  }

  void setVibrate(bool vibrate) {
    state = state.copyWith(
      vibrateOnComplete: vibrate,
      updatedAt: DateTime.now(),
    );
  }

  void setSound(bool sound) {
    state = state.copyWith(soundOnComplete: sound, updatedAt: DateTime.now());
  }
}

/// Provider for active rest timer state
@riverpod
class RestTimerNotifier extends _$RestTimerNotifier {
  Timer? _timer;

  @override
  RestTimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return const RestTimerState.initial();
  }

  void startTimer({int? seconds, String? exerciseName}) {
    _timer?.cancel();

    final settings = ref.read(restTimerSettingsNotifierProvider);
    final duration = seconds ?? settings.defaultRestSeconds;

    state = RestTimerState(
      totalSeconds: duration,
      remainingSeconds: duration,
      isRunning: true,
      isPaused: false,
      startedAt: DateTime.now(),
      exerciseName: exerciseName,
    );

    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds <= 1) {
        _onTimerComplete();
        timer.cancel();
      } else {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      }
    });
  }

  void _onTimerComplete() {
    final settings = ref.read(restTimerSettingsNotifierProvider);

    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isPaused: false,
    );

    // Haptic feedback
    if (settings.vibrateOnComplete) {
      HapticFeedback.heavyImpact();
      Future.delayed(const Duration(milliseconds: 200), () {
        HapticFeedback.heavyImpact();
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        HapticFeedback.heavyImpact();
      });
    }
  }

  void pauseTimer() {
    if (!state.isRunning || state.isPaused) return;

    _timer?.cancel();
    state = state.copyWith(isRunning: true, isPaused: true);
  }

  void resumeTimer() {
    if (!state.isPaused) return;

    state = state.copyWith(isPaused: false);
    _startCountdown();
  }

  void stopTimer() {
    _timer?.cancel();
    state = const RestTimerState.initial();
  }

  void addTime(int seconds) {
    if (!state.isRunning) return;

    state = state.copyWith(
      totalSeconds: state.totalSeconds + seconds,
      remainingSeconds: state.remainingSeconds + seconds,
    );
  }

  void subtractTime(int seconds) {
    if (!state.isRunning) return;

    final newRemaining = (state.remainingSeconds - seconds).clamp(
      0,
      state.totalSeconds,
    );
    state = state.copyWith(remainingSeconds: newRemaining);

    if (newRemaining <= 0) {
      _onTimerComplete();
    }
  }

  void setCustomTime(int seconds) {
    if (state.isRunning) {
      stopTimer();
    }
    startTimer(seconds: seconds);
  }
}

/// Quick timer presets
final timerPresetsProvider = Provider<List<TimerPreset>>((ref) {
  return const [
    TimerPreset(label: '30s', seconds: 30, color: 0xFF22C55E),
    TimerPreset(label: '60s', seconds: 60, color: 0xFF3B82F6),
    TimerPreset(label: '90s', seconds: 90, color: 0xFF6366F1),
    TimerPreset(label: '2m', seconds: 120, color: 0xFFF59E0B),
    TimerPreset(label: '3m', seconds: 180, color: 0xFFEF4444),
    TimerPreset(label: '5m', seconds: 300, color: 0xFF8B5CF6),
  ];
});

/// Timer preset model
class TimerPreset {
  final String label;
  final int seconds;
  final int color;

  const TimerPreset({
    required this.label,
    required this.seconds,
    required this.color,
  });
}
