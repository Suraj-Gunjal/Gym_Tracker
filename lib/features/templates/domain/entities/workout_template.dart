import 'package:flutter/material.dart';

import '../../../exercise/domain/entities/exercise.dart';

/// Domain entity representing a workout template.
class WorkoutTemplate {
  final String id;
  final String name;
  final String? description;
  final Color color;
  final IconData icon;
  final int? estimatedMinutes;
  final int usageCount;
  final DateTime? lastUsedAt;
  final int sortOrder;
  final bool isPredefined;
  final List<TemplateExercise> exercises;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool deleted;

  const WorkoutTemplate({
    required this.id,
    required this.name,
    this.description,
    this.color = const Color(0xFF6366F1),
    this.icon = Icons.fitness_center,
    this.estimatedMinutes,
    this.usageCount = 0,
    this.lastUsedAt,
    this.sortOrder = 0,
    this.isPredefined = false,
    this.exercises = const [],
    required this.createdAt,
    required this.updatedAt,
    this.deleted = false,
  });

  /// Total number of sets in this template
  int get totalSets => exercises.fold(0, (sum, e) => sum + e.defaultSets);

  /// Muscle groups targeted
  Set<String> get muscleGroups => 
      exercises.map((e) => e.exercise?.muscleGroup.displayName ?? '').toSet()
        ..remove('');

  WorkoutTemplate copyWith({
    String? id,
    String? name,
    String? description,
    Color? color,
    IconData? icon,
    int? estimatedMinutes,
    int? usageCount,
    DateTime? lastUsedAt,
    int? sortOrder,
    bool? isPredefined,
    List<TemplateExercise>? exercises,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return WorkoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      usageCount: usageCount ?? this.usageCount,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      sortOrder: sortOrder ?? this.sortOrder,
      isPredefined: isPredefined ?? this.isPredefined,
      exercises: exercises ?? this.exercises,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutTemplate &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Domain entity for an exercise within a template.
class TemplateExercise {
  final String id;
  final String templateId;
  final String exerciseId;
  final Exercise? exercise; // Populated when fetching
  final int sortOrder;
  final int defaultSets;
  final int? defaultReps;
  final double? defaultWeight;
  final int defaultRestSeconds;
  final String? notes;
  final int? supersetGroup;
  final DateTime updatedAt;
  final bool deleted;

  const TemplateExercise({
    required this.id,
    required this.templateId,
    required this.exerciseId,
    this.exercise,
    required this.sortOrder,
    this.defaultSets = 3,
    this.defaultReps,
    this.defaultWeight,
    this.defaultRestSeconds = 90,
    this.notes,
    this.supersetGroup,
    required this.updatedAt,
    this.deleted = false,
  });

  bool get isSuperset => supersetGroup != null;

  TemplateExercise copyWith({
    String? id,
    String? templateId,
    String? exerciseId,
    Exercise? exercise,
    int? sortOrder,
    int? defaultSets,
    int? defaultReps,
    double? defaultWeight,
    int? defaultRestSeconds,
    String? notes,
    int? supersetGroup,
    DateTime? updatedAt,
    bool? deleted,
  }) {
    return TemplateExercise(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      exerciseId: exerciseId ?? this.exerciseId,
      exercise: exercise ?? this.exercise,
      sortOrder: sortOrder ?? this.sortOrder,
      defaultSets: defaultSets ?? this.defaultSets,
      defaultReps: defaultReps ?? this.defaultReps,
      defaultWeight: defaultWeight ?? this.defaultWeight,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      notes: notes ?? this.notes,
      supersetGroup: supersetGroup ?? this.supersetGroup,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
    );
  }
}
