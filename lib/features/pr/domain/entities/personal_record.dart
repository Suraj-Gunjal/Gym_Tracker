import 'pr_type.dart';

/// Domain entity representing a Personal Record (PR).
///
/// PRs are automatically detected when a user beats their previous best
/// for a specific exercise and PR type.
class PersonalRecord {
  /// Unique identifier (UUID format)
  final String id;

  /// Reference to the exercise this PR is for
  final String exerciseId;

  /// Type of PR (max weight, max reps, max volume)
  final PRType prType;

  /// The record value (weight in kg, reps count, or volume)
  final double value;

  /// For max reps PR: the weight at which the reps were performed
  final double? atWeight;

  /// Reference to the workout where this PR was achieved
  final String workoutId;

  /// Reference to the specific set where this PR was achieved
  final String? setId;

  /// When the PR was achieved
  final DateTime achievedAt;

  /// Previous record value (for comparison/celebration)
  final double? previousValue;

  /// Timestamp of last modification (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;

  const PersonalRecord({
    required this.id,
    required this.exerciseId,
    required this.prType,
    required this.value,
    this.atWeight,
    required this.workoutId,
    this.setId,
    required this.achievedAt,
    this.previousValue,
    required this.updatedAt,
    this.deleted = false,
  });

  /// Calculate improvement percentage over previous record
  double? get improvementPercent {
    if (previousValue == null || previousValue == 0) return null;
    return ((value - previousValue!) / previousValue!) * 100;
  }

  /// Human-readable description of the PR
  String get description {
    switch (prType) {
      case PRType.maxWeight:
        return '${value.toStringAsFixed(1)} kg';
      case PRType.maxReps:
        return '${value.toInt()} reps @ ${atWeight?.toStringAsFixed(1)} kg';
      case PRType.maxVolume:
        return '${value.toStringAsFixed(0)} kg total volume';
    }
  }

  /// Creates a copy with optional field overrides
  PersonalRecord copyWith({
    String? id,
    String? exerciseId,
    PRType? prType,
    double? value,
    double? atWeight,
    String? workoutId,
    String? setId,
    DateTime? achievedAt,
    double? previousValue,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return PersonalRecord(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      prType: prType ?? this.prType,
      value: value ?? this.value,
      atWeight: atWeight ?? this.atWeight,
      workoutId: workoutId ?? this.workoutId,
      setId: setId ?? this.setId,
      achievedAt: achievedAt ?? this.achievedAt,
      previousValue: previousValue ?? this.previousValue,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalRecord &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PersonalRecord(id: $id, exerciseId: $exerciseId, type: ${prType.displayName}, value: $value)';
}
