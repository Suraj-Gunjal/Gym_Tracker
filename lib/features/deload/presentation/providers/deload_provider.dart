import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/deload.dart';

part 'deload_provider.g.dart';

/// Provider for deload settings.
@riverpod
class DeloadSettingsNotifier extends _$DeloadSettingsNotifier {
  @override
  DeloadSettings build() {
    return const DeloadSettings();
  }

  void updateSettings(DeloadSettings settings) {
    state = settings;
  }

  void setWeeksBetweenDeloads(int weeks) {
    state = state.copyWith(weeksBetweenDeloads: weeks);
  }

  void setPreferredStrategy(DeloadStrategy strategy) {
    state = state.copyWith(preferredStrategy: strategy);
  }

  void setAutoDetect(bool autoDetect) {
    state = state.copyWith(autoDetect: autoDetect);
  }

  void setFatigueThreshold(double threshold) {
    state = state.copyWith(fatigueThreshold: threshold);
  }
}

/// Provider for current fatigue indicators.
@riverpod
class FatigueIndicatorsNotifier extends _$FatigueIndicatorsNotifier {
  @override
  FatigueIndicators build() {
    // Simulated fatigue data
    return const FatigueIndicators(
      sleepQuality: 6.5,
      motivation: 7.0,
      soreness: 5.5,
      performance: 0.95,
      missedWorkouts: 0,
      consecutiveTrainingDays: 4,
      averageRPE: 7.5,
    );
  }

  void updateIndicators({
    double? sleepQuality,
    double? motivation,
    double? soreness,
    double? performance,
    int? missedWorkouts,
    int? consecutiveTrainingDays,
    double? averageRPE,
  }) {
    state = FatigueIndicators(
      sleepQuality: sleepQuality ?? state.sleepQuality,
      motivation: motivation ?? state.motivation,
      soreness: soreness ?? state.soreness,
      performance: performance ?? state.performance,
      missedWorkouts: missedWorkouts ?? state.missedWorkouts,
      consecutiveTrainingDays:
          consecutiveTrainingDays ?? state.consecutiveTrainingDays,
      averageRPE: averageRPE ?? state.averageRPE,
    );
  }
}

/// Provider for deload history.
@riverpod
class DeloadHistoryNotifier extends _$DeloadHistoryNotifier {
  @override
  List<DeloadWeek> build() {
    final now = DateTime.now();
    return [
      DeloadWeek(
        id: '1',
        startDate: now.subtract(const Duration(days: 35)),
        endDate: now.subtract(const Duration(days: 29)),
        strategy: DeloadStrategy.volume,
        trigger: DeloadTrigger.scheduled,
        volumeReduction: 0.5,
        intensityReduction: 0.0,
        isCompleted: true,
      ),
      DeloadWeek(
        id: '2',
        startDate: now.subtract(const Duration(days: 70)),
        endDate: now.subtract(const Duration(days: 64)),
        strategy: DeloadStrategy.intensity,
        trigger: DeloadTrigger.fatigue,
        volumeReduction: 0.0,
        intensityReduction: 0.4,
        notes: 'Felt run down after heavy training block',
        isCompleted: true,
      ),
    ];
  }

  void addDeload(DeloadWeek deload) {
    state = [deload, ...state];
  }

  void completeDeload(String id) {
    state = state.map((d) {
      if (d.id == id) {
        return d.copyWith(isCompleted: true, isActive: false);
      }
      return d;
    }).toList();
  }
}

/// Provider for active deload.
@riverpod
class ActiveDeloadNotifier extends _$ActiveDeloadNotifier {
  @override
  DeloadWeek? build() {
    return null;
  }

  void startDeload(DeloadWeek deload) {
    state = deload.copyWith(isActive: true);
  }

  void endDeload() {
    if (state != null) {
      ref
          .read(deloadHistoryNotifierProvider.notifier)
          .completeDeload(state!.id);
    }
    state = null;
  }
}

/// Provider for sleep entries.
@riverpod
class SleepEntriesNotifier extends _$SleepEntriesNotifier {
  @override
  List<SleepEntry> build() {
    final random = Random(42);
    final now = DateTime.now();

    return List.generate(14, (i) {
      final date = now.subtract(Duration(days: i));
      final quality = 5.0 + random.nextDouble() * 4;
      final hours = 5 + random.nextInt(4);

      return SleepEntry(
        id: 'sleep_$i',
        date: date,
        bedTime: DateTime(
          date.year,
          date.month,
          date.day,
          22,
          random.nextInt(60),
        ),
        wakeTime: DateTime(
          date.year,
          date.month,
          date.day + 1,
          6,
          random.nextInt(60),
        ),
        totalSleep: Duration(hours: hours, minutes: random.nextInt(60)),
        quality: quality,
        fromWearable: i % 3 == 0,
      );
    });
  }

  void addEntry(SleepEntry entry) {
    state = [entry, ...state];
  }

  void updateEntry(String id, SleepEntry entry) {
    state = state.map((e) => e.id == id ? entry : e).toList();
  }
}

/// Provider to calculate weeks since last deload.
@riverpod
int weeksSinceLastDeload(ref) {
  final history = ref.watch(deloadHistoryNotifierProvider);
  if (history.isEmpty) return 8;

  final lastDeload = history.first;
  return DateTime.now().difference(lastDeload.endDate).inDays ~/ 7;
}

/// Provider to check if deload is recommended.
@riverpod
bool deloadRecommended(ref) {
  final settings = ref.watch(deloadSettingsNotifierProvider);
  final fatigue = ref.watch(fatigueIndicatorsNotifierProvider);
  final weeksSince = ref.watch(weeksSinceLastDeloadProvider);

  if (!settings.autoDetect) {
    return weeksSince >= settings.weeksBetweenDeloads;
  }

  return weeksSince >= settings.weeksBetweenDeloads ||
      fatigue.fatigueScore >= settings.fatigueThreshold;
}

/// Provider to generate deload modifications for exercises.
@riverpod
List<DeloadModification> deloadModifications(ref, DeloadStrategy strategy) {
  // Mock exercise data
  final exercises = [
    ('ex1', 'Bench Press', 100.0, 4, 8),
    ('ex2', 'Squat', 140.0, 4, 6),
    ('ex3', 'Deadlift', 160.0, 3, 5),
    ('ex4', 'Overhead Press', 60.0, 4, 8),
    ('ex5', 'Barbell Row', 80.0, 4, 8),
  ];

  return exercises.map((e) {
    double weightMod, setsMod;

    switch (strategy) {
      case DeloadStrategy.volume:
        weightMod = 1.0;
        setsMod = 0.5;
        break;
      case DeloadStrategy.intensity:
        weightMod = 0.6;
        setsMod = 1.0;
        break;
      case DeloadStrategy.frequency:
        weightMod = 1.0;
        setsMod = 0.7;
        break;
      case DeloadStrategy.complete:
        weightMod = 0.0;
        setsMod = 0.0;
        break;
      case DeloadStrategy.active:
        weightMod = 0.3;
        setsMod = 0.3;
        break;
    }

    return DeloadModification(
      exerciseId: e.$1,
      exerciseName: e.$2,
      originalWeight: e.$3,
      deloadWeight: e.$3 * weightMod,
      originalSets: e.$4,
      deloadSets: (e.$4 * setsMod).round(),
      originalReps: e.$5,
      deloadReps: e.$5,
    );
  }).toList();
}

/// Provider for average sleep quality.
@riverpod
double averageSleepQuality(ref) {
  final entries = ref.watch(sleepEntriesNotifierProvider);
  if (entries.isEmpty) return 7.0;

  final recent = entries.take(7);
  return recent.map((e) => e.quality).reduce((a, b) => a + b) / recent.length;
}
