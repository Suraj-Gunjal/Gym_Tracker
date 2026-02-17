import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/body_measurement.dart';

part 'body_measurement_provider.g.dart';

/// Provider for body measurements
@riverpod
class BodyMeasurementsNotifier extends _$BodyMeasurementsNotifier {
  final _uuid = const Uuid();

  @override
  List<BodyMeasurement> build() {
    // Return sample data for demonstration
    return _getSampleMeasurements();
  }

  List<BodyMeasurement> _getSampleMeasurements() {
    final now = DateTime.now();
    return [
      BodyMeasurement(
        id: _uuid.v4(),
        measuredAt: now.subtract(const Duration(days: 30)),
        weightKg: 75.5,
        bodyFatPercent: 18.5,
        chestCm: 100,
        leftBicepCm: 35,
        rightBicepCm: 35.5,
        waistCm: 82,
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      BodyMeasurement(
        id: _uuid.v4(),
        measuredAt: now.subtract(const Duration(days: 14)),
        weightKg: 74.8,
        bodyFatPercent: 17.8,
        chestCm: 101,
        leftBicepCm: 35.5,
        rightBicepCm: 36,
        waistCm: 81,
        updatedAt: now.subtract(const Duration(days: 14)),
      ),
      BodyMeasurement(
        id: _uuid.v4(),
        measuredAt: now,
        weightKg: 74.2,
        bodyFatPercent: 17.0,
        chestCm: 102,
        leftBicepCm: 36,
        rightBicepCm: 36.5,
        waistCm: 80,
        updatedAt: now,
      ),
    ];
  }

  void addMeasurement(BodyMeasurement measurement) {
    state = [...state, measurement]
      ..sort((a, b) => b.measuredAt.compareTo(a.measuredAt));
  }

  void updateMeasurement(BodyMeasurement measurement) {
    state = [
      for (final m in state)
        if (m.id == measurement.id) measurement else m,
    ];
  }

  void deleteMeasurement(String id) {
    state = state.where((m) => m.id != id).toList();
  }

  BodyMeasurement createMeasurement({
    double? weightKg,
    double? bodyFatPercent,
    double? muscleMassKg,
    double? chestCm,
    double? leftBicepCm,
    double? rightBicepCm,
    double? waistCm,
    double? hipsCm,
    double? leftThighCm,
    double? rightThighCm,
    String? notes,
  }) {
    final measurement = BodyMeasurement(
      id: _uuid.v4(),
      measuredAt: DateTime.now(),
      weightKg: weightKg,
      bodyFatPercent: bodyFatPercent,
      muscleMassKg: muscleMassKg,
      chestCm: chestCm,
      leftBicepCm: leftBicepCm,
      rightBicepCm: rightBicepCm,
      waistCm: waistCm,
      hipsCm: hipsCm,
      leftThighCm: leftThighCm,
      rightThighCm: rightThighCm,
      notes: notes,
      updatedAt: DateTime.now(),
    );
    addMeasurement(measurement);
    return measurement;
  }
}

/// Latest measurement
@riverpod
BodyMeasurement? latestMeasurement(Ref ref) {
  final measurements = ref.watch(bodyMeasurementsNotifierProvider);
  if (measurements.isEmpty) return null;
  return measurements.first;
}

/// Measurement progress comparison (latest vs first)
@riverpod
MeasurementProgress? measurementProgress(Ref ref) {
  final measurements = ref.watch(bodyMeasurementsNotifierProvider);
  if (measurements.length < 2) return null;

  final latest = measurements.first;
  final oldest = measurements.last;

  return MeasurementProgress(
    weightChange: latest.weightKg != null && oldest.weightKg != null
        ? latest.weightKg! - oldest.weightKg!
        : null,
    bodyFatChange:
        latest.bodyFatPercent != null && oldest.bodyFatPercent != null
        ? latest.bodyFatPercent! - oldest.bodyFatPercent!
        : null,
    chestChange: latest.chestCm != null && oldest.chestCm != null
        ? latest.chestCm! - oldest.chestCm!
        : null,
    bicepChange: latest.avgBicepCm != null && oldest.avgBicepCm != null
        ? latest.avgBicepCm! - oldest.avgBicepCm!
        : null,
    waistChange: latest.waistCm != null && oldest.waistCm != null
        ? latest.waistCm! - oldest.waistCm!
        : null,
    periodDays: latest.measuredAt.difference(oldest.measuredAt).inDays,
  );
}

/// Measurement progress data
class MeasurementProgress {
  final double? weightChange;
  final double? bodyFatChange;
  final double? chestChange;
  final double? bicepChange;
  final double? waistChange;
  final int periodDays;

  const MeasurementProgress({
    this.weightChange,
    this.bodyFatChange,
    this.chestChange,
    this.bicepChange,
    this.waistChange,
    required this.periodDays,
  });
}

/// Selected measurement type for chart
@riverpod
class SelectedMeasurementType extends _$SelectedMeasurementType {
  @override
  MeasurementType build() => MeasurementType.weight;

  void select(MeasurementType type) {
    state = type;
  }
}

/// Chart data points for selected measurement type
@riverpod
List<MeasurementChartPoint> measurementChartData(Ref ref) {
  final measurements = ref.watch(bodyMeasurementsNotifierProvider);
  final selectedType = ref.watch(selectedMeasurementTypeProvider);

  return measurements.reversed.map((m) {
    double? value;
    switch (selectedType) {
      case MeasurementType.weight:
        value = m.weightKg;
        break;
      case MeasurementType.bodyFat:
        value = m.bodyFatPercent;
        break;
      case MeasurementType.muscleMass:
        value = m.muscleMassKg;
        break;
      case MeasurementType.chest:
        value = m.chestCm;
        break;
      case MeasurementType.biceps:
        value = m.avgBicepCm;
        break;
      case MeasurementType.waist:
        value = m.waistCm;
        break;
      case MeasurementType.hips:
        value = m.hipsCm;
        break;
      case MeasurementType.thighs:
        value = m.avgThighCm;
        break;
      default:
        value = null;
    }
    return MeasurementChartPoint(date: m.measuredAt, value: value);
  }).toList();
}

/// Chart point data
class MeasurementChartPoint {
  final DateTime date;
  final double? value;

  const MeasurementChartPoint({required this.date, this.value});
}
