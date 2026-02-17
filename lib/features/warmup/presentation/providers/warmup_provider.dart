import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/warmup.dart';

part 'warmup_provider.g.dart';

/// Provider for warm-up settings.
@riverpod
class WarmupSettingsNotifier extends _$WarmupSettingsNotifier {
  @override
  WarmupSettings build() => const WarmupSettings();

  void updateProtocol(WarmupProtocol protocol) {
    state = state.copyWith(defaultProtocol: protocol);
  }

  void updateBarWeight(double weight) {
    state = state.copyWith(barWeight: weight);
  }

  void toggleActivation() {
    state = state.copyWith(includeActivation: !state.includeActivation);
  }

  void updateRestTime(int seconds) {
    state = state.copyWith(minRestSeconds: seconds);
  }
}

/// Provider for active warm-up routine.
@riverpod
class ActiveWarmupNotifier extends _$ActiveWarmupNotifier {
  @override
  WarmupRoutine? build() => null;

  /// Generate a warm-up routine for the given exercise and working weight.
  void generateWarmup({
    required String exerciseName,
    required double workingWeight,
    required WarmupSettings settings,
  }) {
    final sets = <WarmupSet>[];
    final protocol = settings.defaultProtocol;

    // Add activation set if enabled
    if (settings.includeActivation) {
      sets.add(
        const WarmupSet(
          type: WarmupSetType.activation,
          weight: 0,
          reps: 10,
          restSeconds: 30,
        ),
      );
    }

    // Generate sets based on protocol
    for (final (type, reps) in protocol.template) {
      double weight;
      if (type == WarmupSetType.empty) {
        weight = settings.barWeight;
      } else {
        weight = _roundToPlate(
          workingWeight * type.percentage,
          settings.barWeight,
        );
      }

      sets.add(
        WarmupSet(
          type: type,
          weight: weight,
          reps: reps,
          restSeconds: settings.minRestSeconds,
        ),
      );
    }

    // Estimate duration: ~45 seconds per set + rest
    final totalDuration =
        ((sets.length * 45 + sets.fold(0, (sum, s) => sum + s.restSeconds)) /
                60)
            .ceil();

    state = WarmupRoutine(
      exerciseName: exerciseName,
      workingWeight: workingWeight,
      sets: sets,
      totalDuration: totalDuration,
      generatedAt: DateTime.now(),
    );
  }

  /// Round weight to nearest plate increment.
  double _roundToPlate(double weight, double barWeight) {
    if (weight <= barWeight) return barWeight;
    // Round to nearest 2.5kg increment
    final plateWeight = weight - barWeight;
    final rounded = (plateWeight / 2.5).round() * 2.5;
    return barWeight + rounded;
  }

  /// Mark a warm-up set as completed.
  void completeSet(int index) {
    if (state == null) return;
    final sets = state!.sets.toList();
    sets[index] = sets[index].copyWith(isCompleted: true);
    state = WarmupRoutine(
      exerciseName: state!.exerciseName,
      workingWeight: state!.workingWeight,
      sets: sets,
      totalDuration: state!.totalDuration,
      generatedAt: state!.generatedAt,
    );
  }

  /// Reset all sets.
  void reset() {
    if (state == null) return;
    final sets = state!.sets
        .map((s) => s.copyWith(isCompleted: false))
        .toList();
    state = WarmupRoutine(
      exerciseName: state!.exerciseName,
      workingWeight: state!.workingWeight,
      sets: sets,
      totalDuration: state!.totalDuration,
      generatedAt: state!.generatedAt,
    );
  }

  /// Clear the warm-up routine.
  void clear() {
    state = null;
  }
}

/// Quick warm-up generator for common exercises.
@riverpod
List<WarmupRoutine> suggestedWarmups(SuggestedWarmupsRef ref) {
  final settings = ref.watch(warmupSettingsNotifierProvider);

  // Pre-generate warm-ups for common lifts
  final commonLifts = [
    ('Bench Press', 80.0),
    ('Squat', 100.0),
    ('Deadlift', 120.0),
    ('Overhead Press', 50.0),
  ];

  return commonLifts.map((lift) {
    final sets = <WarmupSet>[];
    final protocol = settings.defaultProtocol;

    for (final (type, reps) in protocol.template) {
      double weight;
      if (type == WarmupSetType.empty) {
        weight = settings.barWeight;
      } else {
        weight = lift.$2 * type.percentage;
      }

      sets.add(
        WarmupSet(
          type: type,
          weight: weight,
          reps: reps,
          restSeconds: settings.minRestSeconds,
        ),
      );
    }

    return WarmupRoutine(
      exerciseName: lift.$1,
      workingWeight: lift.$2,
      sets: sets,
      totalDuration: 5,
      generatedAt: DateTime.now(),
    );
  }).toList();
}
