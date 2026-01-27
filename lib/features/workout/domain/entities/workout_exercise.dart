import 'exercise_set.dart';

/// Domain entity representing an exercise performed within a workout.
///
/// Links a workout to an exercise and contains all sets performed.
class WorkoutExercise {
  /// Unique identifier (UUID format)
  final String id;

  /// Reference to the parent workout
  final String workoutId;

  /// Reference to the exercise definition
  final String exerciseId;

  /// Order of this exercise within the workout (1, 2, 3...)
  final int orderIndex;

  /// Optional notes for this exercise in this workout
  final String? notes;

  /// All sets performed for this exercise
  final List<ExerciseSet> sets;

  /// Timestamp of last modification (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;

  const WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.orderIndex,
    this.notes,
    this.sets = const [],
    required this.updatedAt,
    this.deleted = false,
  });

  /// Total volume for this exercise (sum of all sets)
  double get totalVolume => sets.fold(0.0, (sum, set) => sum + set.volume);

  /// Total reps across all sets
  int get totalReps => sets.fold(0, (sum, set) => sum + set.reps);

  /// Maximum weight used in any set
  double get maxWeight => sets.isEmpty
      ? 0.0
      : sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);

  /// Number of completed sets
  int get completedSets => sets.where((s) => s.completed).length;

  /// Creates a copy with optional field overrides
  WorkoutExercise copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    int? orderIndex,
    String? notes,
    List<ExerciseSet>? sets,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      notes: notes ?? this.notes,
      sets: sets ?? this.sets,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExercise &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'WorkoutExercise(id: $id, exerciseId: $exerciseId, sets: ${sets.length})';
}
