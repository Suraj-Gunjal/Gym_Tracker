import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/body_measurement.dart';

part 'measurements_provider.g.dart';

/// Provider for body measurements state.
@riverpod
class MeasurementsNotifier extends _$MeasurementsNotifier {
  @override
  List<BodyMeasurement> build() {
    // Load mock data - in production, load from database
    return _generateMockData();
  }

  void addMeasurement(MeasurementType type, double value, {String? note}) {
    final measurement = BodyMeasurement(
      id: const Uuid().v4(),
      type: type,
      value: value,
      recordedAt: DateTime.now(),
      note: note,
    );
    state = [measurement, ...state];
  }

  void updateMeasurement(String id, double value, {String? note}) {
    state = state.map((m) {
      if (m.id == id) {
        return m.copyWith(value: value, note: note);
      }
      return m;
    }).toList();
  }

  void deleteMeasurement(String id) {
    state = state.where((m) => m.id != id).toList();
  }

  List<BodyMeasurement> _generateMockData() {
    final measurements = <BodyMeasurement>[];
    final uuid = const Uuid();
    final now = DateTime.now();

    // Generate realistic progression data
    final baseValues = {
      MeasurementType.weight: 82.5,
      MeasurementType.bodyFat: 18.0,
      MeasurementType.chest: 102.0,
      MeasurementType.waist: 84.0,
      MeasurementType.hips: 98.0,
      MeasurementType.leftArm: 36.5,
      MeasurementType.rightArm: 37.0,
      MeasurementType.leftThigh: 58.0,
      MeasurementType.rightThigh: 58.5,
      MeasurementType.shoulders: 118.0,
    };

    // Generate 12 weeks of data
    for (var week = 0; week < 12; week++) {
      final date = now.subtract(Duration(days: week * 7));

      for (final entry in baseValues.entries) {
        // Simulate progress (weight/fat down, muscles up)
        double modifier;
        if (entry.key == MeasurementType.weight) {
          modifier = week * 0.3; // Losing 0.3kg/week
        } else if (entry.key == MeasurementType.bodyFat) {
          modifier = week * 0.2; // Losing 0.2%/week
        } else if (entry.key == MeasurementType.waist) {
          modifier = week * 0.15; // Losing waist
        } else {
          modifier = -week * 0.1; // Gaining muscle size
        }

        final value = entry.value + modifier + (week % 3 - 1) * 0.2;

        measurements.add(
          BodyMeasurement(
            id: uuid.v4(),
            type: entry.key,
            value: value,
            recordedAt: date,
            note: week == 0 ? 'Latest measurement' : null,
          ),
        );
      }
    }

    return measurements;
  }
}

/// Provider for measurement statistics.
@riverpod
Map<MeasurementType, MeasurementStats> measurementStats(
  MeasurementStatsRef ref,
) {
  final measurements = ref.watch(measurementsNotifierProvider);
  final stats = <MeasurementType, MeasurementStats>{};

  for (final type in MeasurementType.values) {
    final typeMeasurements = measurements.where((m) => m.type == type).toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    if (typeMeasurements.isEmpty) {
      stats[type] = MeasurementStats(type: type);
      continue;
    }

    final current = typeMeasurements.first.value;
    final previous = typeMeasurements.length > 1
        ? typeMeasurements[1].value
        : null;
    final values = typeMeasurements.map((m) => m.value).toList();

    double? change;
    double? changePercent;
    if (previous != null) {
      change = current - previous;
      changePercent = (change / previous) * 100;
    }

    stats[type] = MeasurementStats(
      type: type,
      current: current,
      previous: previous,
      min: values.reduce((a, b) => a < b ? a : b),
      max: values.reduce((a, b) => a > b ? a : b),
      average: values.reduce((a, b) => a + b) / values.length,
      change: change,
      changePercent: changePercent,
      history: typeMeasurements,
    );
  }

  return stats;
}

/// Provider for measurement profile (goals and settings).
@riverpod
class MeasurementProfileNotifier extends _$MeasurementProfileNotifier {
  @override
  MeasurementProfile build() {
    return MeasurementProfile(
      goalWeight: 78.0,
      goalBodyFat: 12.0,
      isMetric: true,
      startDate: DateTime.now().subtract(const Duration(days: 90)),
      goals: {
        MeasurementType.waist: 80.0,
        MeasurementType.chest: 106.0,
        MeasurementType.leftArm: 40.0,
        MeasurementType.rightArm: 40.0,
      },
    );
  }

  void setGoal(MeasurementType type, double? value) {
    final newGoals = Map<MeasurementType, double>.from(state.goals);
    if (value != null) {
      newGoals[type] = value;
    } else {
      newGoals.remove(type);
    }
    state = state.copyWith(goals: newGoals);
  }

  void setMetricSystem(bool isMetric) {
    state = state.copyWith(isMetric: isMetric);
  }

  void setGoalWeight(double? weight) {
    state = state.copyWith(goalWeight: weight);
  }

  void setGoalBodyFat(double? bodyFat) {
    state = state.copyWith(goalBodyFat: bodyFat);
  }
}
