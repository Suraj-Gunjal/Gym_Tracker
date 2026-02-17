/// Domain entity representing a body measurement entry.
class BodyMeasurement {
  final String id;
  final DateTime measuredAt;
  final double? weightKg;
  final double? bodyFatPercent;
  final double? muscleMassKg;

  // Body part measurements in cm
  final double? neckCm;
  final double? shouldersCm;
  final double? chestCm;
  final double? leftBicepCm;
  final double? rightBicepCm;
  final double? leftForearmCm;
  final double? rightForearmCm;
  final double? waistCm;
  final double? hipsCm;
  final double? leftThighCm;
  final double? rightThighCm;
  final double? leftCalfCm;
  final double? rightCalfCm;

  final String? notes;
  final String? photoPath;
  final DateTime updatedAt;
  final bool deleted;

  const BodyMeasurement({
    required this.id,
    required this.measuredAt,
    this.weightKg,
    this.bodyFatPercent,
    this.muscleMassKg,
    this.neckCm,
    this.shouldersCm,
    this.chestCm,
    this.leftBicepCm,
    this.rightBicepCm,
    this.leftForearmCm,
    this.rightForearmCm,
    this.waistCm,
    this.hipsCm,
    this.leftThighCm,
    this.rightThighCm,
    this.leftCalfCm,
    this.rightCalfCm,
    this.notes,
    this.photoPath,
    required this.updatedAt,
    this.deleted = false,
  });

  /// Average bicep measurement
  double? get avgBicepCm {
    if (leftBicepCm != null && rightBicepCm != null) {
      return (leftBicepCm! + rightBicepCm!) / 2;
    }
    return leftBicepCm ?? rightBicepCm;
  }

  /// Average thigh measurement
  double? get avgThighCm {
    if (leftThighCm != null && rightThighCm != null) {
      return (leftThighCm! + rightThighCm!) / 2;
    }
    return leftThighCm ?? rightThighCm;
  }

  /// Calculate BMI if weight and height are available
  double? calculateBMI(double heightCm) {
    if (weightKg == null) return null;
    final heightM = heightCm / 100;
    return weightKg! / (heightM * heightM);
  }

  /// Check if any measurement is recorded
  bool get hasAnyMeasurement =>
      weightKg != null ||
      bodyFatPercent != null ||
      muscleMassKg != null ||
      neckCm != null ||
      shouldersCm != null ||
      chestCm != null ||
      leftBicepCm != null ||
      rightBicepCm != null ||
      leftForearmCm != null ||
      rightForearmCm != null ||
      waistCm != null ||
      hipsCm != null ||
      leftThighCm != null ||
      rightThighCm != null ||
      leftCalfCm != null ||
      rightCalfCm != null;

  BodyMeasurement copyWith({
    String? id,
    DateTime? measuredAt,
    double? weightKg,
    double? bodyFatPercent,
    double? muscleMassKg,
    double? neckCm,
    double? shouldersCm,
    double? chestCm,
    double? leftBicepCm,
    double? rightBicepCm,
    double? leftForearmCm,
    double? rightForearmCm,
    double? waistCm,
    double? hipsCm,
    double? leftThighCm,
    double? rightThighCm,
    double? leftCalfCm,
    double? rightCalfCm,
    String? notes,
    String? photoPath,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return BodyMeasurement(
      id: id ?? this.id,
      measuredAt: measuredAt ?? this.measuredAt,
      weightKg: weightKg ?? this.weightKg,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
      muscleMassKg: muscleMassKg ?? this.muscleMassKg,
      neckCm: neckCm ?? this.neckCm,
      shouldersCm: shouldersCm ?? this.shouldersCm,
      chestCm: chestCm ?? this.chestCm,
      leftBicepCm: leftBicepCm ?? this.leftBicepCm,
      rightBicepCm: rightBicepCm ?? this.rightBicepCm,
      leftForearmCm: leftForearmCm ?? this.leftForearmCm,
      rightForearmCm: rightForearmCm ?? this.rightForearmCm,
      waistCm: waistCm ?? this.waistCm,
      hipsCm: hipsCm ?? this.hipsCm,
      leftThighCm: leftThighCm ?? this.leftThighCm,
      rightThighCm: rightThighCm ?? this.rightThighCm,
      leftCalfCm: leftCalfCm ?? this.leftCalfCm,
      rightCalfCm: rightCalfCm ?? this.rightCalfCm,
      notes: notes ?? this.notes,
      photoPath: photoPath ?? this.photoPath,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BodyMeasurement &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Enum for measurement types (for tracking history)
enum MeasurementType {
  weight('Weight', 'kg', '⚖️'),
  bodyFat('Body Fat', '%', '📊'),
  muscleMass('Muscle Mass', 'kg', '💪'),
  neck('Neck', 'cm', '📏'),
  shoulders('Shoulders', 'cm', '📏'),
  chest('Chest', 'cm', '📏'),
  biceps('Biceps', 'cm', '💪'),
  forearms('Forearms', 'cm', '📏'),
  waist('Waist', 'cm', '📏'),
  hips('Hips', 'cm', '📏'),
  thighs('Thighs', 'cm', '🦵'),
  calves('Calves', 'cm', '📏');

  final String displayName;
  final String unit;
  final String emoji;

  const MeasurementType(this.displayName, this.unit, this.emoji);
}
