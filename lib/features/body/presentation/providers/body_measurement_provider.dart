import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/body_measurement_repository_impl.dart';
import '../../domain/entities/body_measurement.dart';

part 'body_measurement_provider.g.dart';

/// Provider for body measurement repository
@riverpod
BodyMeasurementRepository bodyMeasurementRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return BodyMeasurementRepository(db);
}

/// Provider for body measurements
@riverpod
class BodyMeasurementsNotifier extends _$BodyMeasurementsNotifier {
  final _uuid = const Uuid();

  @override
  Future<List<BodyMeasurement>> build() async {
    // Load real data from database
    final repository = ref.watch(bodyMeasurementRepositoryProvider);
    return repository.getAllMeasurements();
  }

  Future<void> addMeasurement(BodyMeasurement measurement) async {
    final repository = ref.read(bodyMeasurementRepositoryProvider);
    await repository.saveMeasurement(measurement);
    ref.invalidateSelf();
  }

  Future<void> updateMeasurement(BodyMeasurement measurement) async {
    final repository = ref.read(bodyMeasurementRepositoryProvider);
    await repository.saveMeasurement(measurement);
    ref.invalidateSelf();
  }

  Future<void> deleteMeasurement(String id) async {
    final repository = ref.read(bodyMeasurementRepositoryProvider);
    await repository.deleteMeasurement(id);
    ref.invalidateSelf();
  }

  Future<BodyMeasurement> createMeasurement({
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
  }) async {
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
    await addMeasurement(measurement);
    return measurement;
  }
}

/// Latest measurement
@riverpod
BodyMeasurement? latestMeasurement(Ref ref) {
  final measurementsAsync = ref.watch(bodyMeasurementsNotifierProvider);
  return measurementsAsync.when(
    data: (measurements) => measurements.isEmpty ? null : measurements.first,
    loading: () => null,
    error: (_, __) => null,
  );
}

/// Measurement progress comparison (latest vs first)
@riverpod
MeasurementProgress? measurementProgress(Ref ref) {
  final measurementsAsync = ref.watch(bodyMeasurementsNotifierProvider);
  return measurementsAsync.when(
    data: (measurements) {
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
    },
    loading: () => null,
    error: (_, __) => null,
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
  final measurementsAsync = ref.watch(bodyMeasurementsNotifierProvider);
  final selectedType = ref.watch(selectedMeasurementTypeProvider);

  return measurementsAsync.when(
    data: (measurements) {
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
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Chart point data
class MeasurementChartPoint {
  final DateTime date;
  final double? value;

  const MeasurementChartPoint({required this.date, this.value});
}
