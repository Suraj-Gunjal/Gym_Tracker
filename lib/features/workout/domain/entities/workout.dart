import 'workout_exercise.dart';

/// Domain entity representing a complete workout session.
///
/// A workout contains multiple exercises, each with multiple sets.
class Workout {
  /// Unique identifier (UUID format)
  final String id;

  /// Optional workout name (e.g., "Push Day", "Leg Day")
  final String? name;

  /// When the workout was started
  final DateTime startedAt;

  /// When the workout was completed (null if still in progress)
  final DateTime? completedAt;

  /// Optional notes about the workout
  final String? notes;

  /// All exercises performed in this workout
  final List<WorkoutExercise> exercises;

  /// Timestamp of last modification (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;

  const Workout({
    required this.id,
    this.name,
    required this.startedAt,
    this.completedAt,
    this.notes,
    this.exercises = const [],
    required this.updatedAt,
    this.deleted = false,
  });

  /// Whether the workout is still in progress
  bool get isInProgress => completedAt == null;

  /// Duration of the workout (null if still in progress)
  Duration? get duration => completedAt?.difference(startedAt);

  /// Total volume across all exercises
  double get totalVolume =>
      exercises.fold(0.0, (sum, ex) => sum + ex.totalVolume);

  /// Total number of sets across all exercises
  int get totalSets => exercises.fold(0, (sum, ex) => sum + ex.sets.length);

  /// Total number of exercises (excluding deleted)
  int get exerciseCount => exercises.where((e) => !e.deleted).length;

  /// Creates a copy with optional field overrides
  Workout copyWith({
    String? id,
    String? name,
    DateTime? startedAt,
    DateTime? completedAt,
    String? notes,
    List<WorkoutExercise>? exercises,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      exercises: exercises ?? this.exercises,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Workout && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Workout(id: $id, name: $name, exercises: ${exercises.length})';
}
