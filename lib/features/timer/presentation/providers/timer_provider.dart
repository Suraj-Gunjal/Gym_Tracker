import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/timer.dart';

part 'timer_provider.g.dart';

/// Provider for active timer.
@riverpod
class ActiveTimerNotifier extends _$ActiveTimerNotifier {
  Timer? _timer;

  @override
  TimerState? build() {
    ref.onDispose(() => _timer?.cancel());
    return null;
  }

  void startTimer(TimerType type, int seconds) {
    _timer?.cancel();
    state = TimerState(
      type: type,
      totalSeconds: seconds,
      remainingSeconds: seconds,
      isRunning: true,
    );
    _startCountdown();
  }

  void startIntervalTimer(IntervalConfig config) {
    _timer?.cancel();
    state = TimerState(
      type: TimerType.tabata,
      totalSeconds: config.totalSeconds,
      remainingSeconds: config.workSeconds,
      isRunning: true,
      currentRound: 1,
      totalRounds: config.rounds,
      isWorkPhase: true,
    );
    _startIntervalCountdown(config);
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state == null) return;
      if (state!.remainingSeconds <= 0) {
        _timer?.cancel();
        state = state!.copyWith(isRunning: false, remainingSeconds: 0);
        return;
      }
      state = state!.copyWith(remainingSeconds: state!.remainingSeconds - 1);
    });
  }

  void _startIntervalCountdown(IntervalConfig config) {
    int currentRound = 1;
    bool isWorkPhase = true;
    int remaining = config.workSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state == null || !state!.isRunning) return;

      remaining--;

      if (remaining <= 0) {
        if (isWorkPhase) {
          // Switch to rest
          isWorkPhase = false;
          remaining = config.restSeconds;
        } else {
          // Switch to work or complete
          currentRound++;
          if (currentRound > config.rounds) {
            _timer?.cancel();
            state = state!.copyWith(isRunning: false, remainingSeconds: 0);
            return;
          }
          isWorkPhase = true;
          remaining = config.workSeconds;
        }
      }

      state = state!.copyWith(
        remainingSeconds: remaining,
        currentRound: currentRound,
        isWorkPhase: isWorkPhase,
      );
    });
  }

  void pause() {
    _timer?.cancel();
    if (state != null) {
      state = state!.copyWith(isRunning: false, isPaused: true);
    }
  }

  void resume() {
    if (state != null && state!.isPaused) {
      state = state!.copyWith(isRunning: true, isPaused: false);
      _startCountdown();
    }
  }

  void stop() {
    _timer?.cancel();
    state = null;
  }

  void addSeconds(int seconds) {
    if (state != null) {
      state = state!.copyWith(
        totalSeconds: state!.totalSeconds + seconds,
        remainingSeconds: state!.remainingSeconds + seconds,
      );
    }
  }
}

/// Provider for timer presets.
@riverpod
class TimerPresetsNotifier extends _$TimerPresetsNotifier {
  @override
  List<TimerPreset> build() {
    return const [
      TimerPreset(
        id: '1',
        name: '30 sec rest',
        type: TimerType.restTimer,
        seconds: 30,
      ),
      TimerPreset(
        id: '2',
        name: '60 sec rest',
        type: TimerType.restTimer,
        seconds: 60,
      ),
      TimerPreset(
        id: '3',
        name: '90 sec rest',
        type: TimerType.restTimer,
        seconds: 90,
      ),
      TimerPreset(
        id: '4',
        name: '2 min rest',
        type: TimerType.restTimer,
        seconds: 120,
      ),
      TimerPreset(
        id: '5',
        name: '3 min rest',
        type: TimerType.restTimer,
        seconds: 180,
      ),
      TimerPreset(
        id: '6',
        name: 'Tabata',
        type: TimerType.tabata,
        seconds: 240,
        rounds: 8,
        workSeconds: 20,
        restSeconds: 10,
      ),
      TimerPreset(
        id: '7',
        name: '10 min AMRAP',
        type: TimerType.amrap,
        seconds: 600,
      ),
    ];
  }

  void addPreset(TimerPreset preset) {
    state = [...state, preset];
  }

  void removePreset(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

/// Provider for equipment usage tracking.
@riverpod
class EquipmentUsageNotifier extends _$EquipmentUsageNotifier {
  @override
  List<EquipmentUsage> build() {
    return [];
  }

  void startUsing(GymEquipment equipment, {int? targetMinutes}) {
    state = [
      EquipmentUsage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: equipment.label,
        emoji: equipment.emoji,
        startTime: DateTime.now(),
        targetMinutes: targetMinutes,
      ),
      ...state,
    ];
  }

  void stopUsing(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

/// Provider for current equipment.
@riverpod
EquipmentUsage? currentEquipment(ref) {
  final usages = ref.watch(equipmentUsageNotifierProvider);
  return usages.isNotEmpty ? usages.first : null;
}

/// Provider for rest timer quick starts.
@riverpod
List<int> quickRestTimes(ref) {
  return [30, 45, 60, 90, 120, 180];
}
