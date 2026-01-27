/// Domain entity representing a single set within a workout exercise.
///
/// Each set records reps performed and weight used.
class ExerciseSet {
  /// Unique identifier (UUID format)
  final String id;

  /// Reference to the parent workout exercise entry
  final String workoutExerciseId;

  /// Set number within the exercise (1, 2, 3...)
  final int setNumber;

  /// Number of repetitions performed
  final int reps;

  /// Weight used in kilograms (or user's preferred unit)
  final double weight;

  /// Optional notes for this specific set
  final String? notes;

  /// Whether this set was completed
  final bool completed;

  /// Timestamp of last modification (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;

  const ExerciseSet({
    required this.id,
    required this.workoutExerciseId,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.notes,
    this.completed = true,
    required this.updatedAt,
    this.deleted = false,
  });

  /// Calculate volume for this set (weight × reps)
  double get volume => weight * reps;

  /// Creates a copy with optional field overrides
  ExerciseSet copyWith({
    String? id,
    String? workoutExerciseId,
    int? setNumber,
    int? reps,
    double? weight,
    String? notes,
    bool? completed,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return ExerciseSet(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
      completed: completed ?? this.completed,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSet &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ExerciseSet(id: $id, set: $setNumber, reps: $reps, weight: $weight kg)';
}
