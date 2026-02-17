/// Body measurement types that can be tracked.
enum MeasurementType {
  weight('Weight', 'kg', 'lbs', '⚖️'),
  bodyFat('Body Fat', '%', '%', '📊'),
  chest('Chest', 'cm', 'in', '💪'),
  waist('Waist', 'cm', 'in', '📏'),
  hips('Hips', 'cm', 'in', '🍑'),
  leftArm('Left Arm', 'cm', 'in', '💪'),
  rightArm('Right Arm', 'cm', 'in', '💪'),
  leftThigh('Left Thigh', 'cm', 'in', '🦵'),
  rightThigh('Right Thigh', 'cm', 'in', '🦵'),
  leftCalf('Left Calf', 'cm', 'in', '🦵'),
  rightCalf('Right Calf', 'cm', 'in', '🦵'),
  shoulders('Shoulders', 'cm', 'in', '🏋️'),
  neck('Neck', 'cm', 'in', '👔'),
  forearm('Forearm', 'cm', 'in', '💪');

  final String label;
  final String metricUnit;
  final String imperialUnit;
  final String emoji;

  const MeasurementType(
    this.label,
    this.metricUnit,
    this.imperialUnit,
    this.emoji,
  );

  String getUnit(bool isMetric) => isMetric ? metricUnit : imperialUnit;
}

/// A single body measurement entry.
class BodyMeasurement {
  final String id;
  final MeasurementType type;
  final double value;
  final DateTime recordedAt;
  final String? note;

  const BodyMeasurement({
    required this.id,
    required this.type,
    required this.value,
    required this.recordedAt,
    this.note,
  });

  BodyMeasurement copyWith({
    String? id,
    MeasurementType? type,
    double? value,
    DateTime? recordedAt,
    String? note,
  }) {
    return BodyMeasurement(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      recordedAt: recordedAt ?? this.recordedAt,
      note: note ?? this.note,
    );
  }
}

/// Statistics for a measurement type.
class MeasurementStats {
  final MeasurementType type;
  final double? current;
  final double? previous;
  final double? min;
  final double? max;
  final double? average;
  final double? change;
  final double? changePercent;
  final List<BodyMeasurement> history;

  const MeasurementStats({
    required this.type,
    this.current,
    this.previous,
    this.min,
    this.max,
    this.average,
    this.change,
    this.changePercent,
    this.history = const [],
  });

  bool get hasImproved {
    if (change == null) return false;
    // For weight and waist, decrease is usually improvement
    if (type == MeasurementType.weight || type == MeasurementType.waist) {
      return change! < 0;
    }
    // For muscles, increase is usually improvement
    return change! > 0;
  }

  String get changeText {
    if (change == null) return '--';
    final sign = change! >= 0 ? '+' : '';
    return '$sign${change!.toStringAsFixed(1)}';
  }

  String get changePercentText {
    if (changePercent == null) return '--';
    final sign = changePercent! >= 0 ? '+' : '';
    return '$sign${changePercent!.toStringAsFixed(1)}%';
  }
}

/// User's measurement profile with goals.
class MeasurementProfile {
  final double? goalWeight;
  final double? goalBodyFat;
  final Map<MeasurementType, double> goals;
  final bool isMetric;
  final DateTime? startDate;

  const MeasurementProfile({
    this.goalWeight,
    this.goalBodyFat,
    this.goals = const {},
    this.isMetric = true,
    this.startDate,
  });

  MeasurementProfile copyWith({
    double? goalWeight,
    double? goalBodyFat,
    Map<MeasurementType, double>? goals,
    bool? isMetric,
    DateTime? startDate,
  }) {
    return MeasurementProfile(
      goalWeight: goalWeight ?? this.goalWeight,
      goalBodyFat: goalBodyFat ?? this.goalBodyFat,
      goals: goals ?? this.goals,
      isMetric: isMetric ?? this.isMetric,
      startDate: startDate ?? this.startDate,
    );
  }
}
