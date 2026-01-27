import 'muscle_group.dart';

/// Domain entity representing an exercise.
///
/// Exercises can be predefined (built-in) or custom (user-created).
/// Each exercise is tagged with a primary muscle group.
class Exercise {
  /// Unique identifier (UUID format)
  final String id;

  /// Exercise name (e.g., "Bench Press", "Squat")
  final String name;

  /// Primary muscle group targeted
  final MuscleGroup muscleGroup;

  /// Optional description or notes
  final String? description;

  /// Whether this is a predefined exercise (cannot be deleted)
  final bool isPredefined;

  /// Timestamp of last modification (for sync)
  final DateTime updatedAt;

  /// Soft delete flag (for sync)
  final bool deleted;

  const Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    this.description,
    this.isPredefined = false,
    required this.updatedAt,
    this.deleted = false,
  });

  /// Creates a copy with optional field overrides
  Exercise copyWith({
    String? id,
    String? name,
    MuscleGroup? muscleGroup,
    String? description,
    bool? isPredefined,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      description: description ?? this.description,
      isPredefined: isPredefined ?? this.isPredefined,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Exercise && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Exercise(id: $id, name: $name, muscleGroup: ${muscleGroup.displayName})';
}
