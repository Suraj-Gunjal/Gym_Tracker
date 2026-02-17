/// Types of exercise groupings.
enum GroupType {
  superset('Superset', '2 exercises, no rest between', '🔄'),
  triset('Tri-set', '3 exercises, no rest between', '🔺'),
  giantSet('Giant Set', '4+ exercises, no rest between', '💪'),
  circuit('Circuit', 'Multiple exercises, timed rest', '🔁'),
  dropSet('Drop Set', 'Same exercise, decreasing weight', '📉'),
  restPause('Rest-Pause', 'Brief rest, continue to failure', '⏸️'),
  cluster('Cluster Set', 'Intra-set rest periods', '🎯');

  final String label;
  final String description;
  final String emoji;

  const GroupType(this.label, this.description, this.emoji);
}

/// A single exercise within a superset/circuit.
class GroupedExercise {
  final String id;
  final String exerciseId;
  final String exerciseName;
  final int order;
  final int targetSets;
  final int targetReps;
  final double? targetWeight;
  final int? targetDuration; // For timed exercises
  final String? notes;

  const GroupedExercise({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.order,
    required this.targetSets,
    required this.targetReps,
    this.targetWeight,
    this.targetDuration,
    this.notes,
  });

  GroupedExercise copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    int? order,
    int? targetSets,
    int? targetReps,
    double? targetWeight,
    int? targetDuration,
    String? notes,
  }) {
    return GroupedExercise(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      order: order ?? this.order,
      targetSets: targetSets ?? this.targetSets,
      targetReps: targetReps ?? this.targetReps,
      targetWeight: targetWeight ?? this.targetWeight,
      targetDuration: targetDuration ?? this.targetDuration,
      notes: notes ?? this.notes,
    );
  }
}

/// An exercise group (superset, circuit, etc.).
class ExerciseGroup {
  final String id;
  final String name;
  final GroupType type;
  final List<GroupedExercise> exercises;
  final int restBetweenRounds; // seconds
  final int restBetweenExercises; // seconds (for circuits)
  final int totalRounds;
  final DateTime createdAt;
  final String? notes;

  const ExerciseGroup({
    required this.id,
    required this.name,
    required this.type,
    required this.exercises,
    this.restBetweenRounds = 90,
    this.restBetweenExercises = 0,
    this.totalRounds = 3,
    required this.createdAt,
    this.notes,
  });

  int get exerciseCount => exercises.length;

  int get estimatedDuration {
    // Rough estimate: 45 seconds per exercise + rest
    final exerciseTime = exercises.length * 45 * totalRounds;
    final restTime =
        (totalRounds - 1) * restBetweenRounds +
        (exercises.length - 1) * restBetweenExercises * totalRounds;
    return ((exerciseTime + restTime) / 60).round();
  }

  String get typeLabel => type.label;
  String get typeEmoji => type.emoji;

  ExerciseGroup copyWith({
    String? id,
    String? name,
    GroupType? type,
    List<GroupedExercise>? exercises,
    int? restBetweenRounds,
    int? restBetweenExercises,
    int? totalRounds,
    DateTime? createdAt,
    String? notes,
  }) {
    return ExerciseGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      exercises: exercises ?? this.exercises,
      restBetweenRounds: restBetweenRounds ?? this.restBetweenRounds,
      restBetweenExercises: restBetweenExercises ?? this.restBetweenExercises,
      totalRounds: totalRounds ?? this.totalRounds,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }
}

/// Saved superset/circuit template.
class GroupTemplate {
  final String id;
  final String name;
  final GroupType type;
  final List<String> exerciseIds;
  final int restBetweenRounds;
  final int restBetweenExercises;
  final int defaultRounds;
  final bool isFavorite;
  final int usageCount;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  const GroupTemplate({
    required this.id,
    required this.name,
    required this.type,
    required this.exerciseIds,
    this.restBetweenRounds = 90,
    this.restBetweenExercises = 0,
    this.defaultRounds = 3,
    this.isFavorite = false,
    this.usageCount = 0,
    required this.createdAt,
    this.lastUsedAt,
  });
}
