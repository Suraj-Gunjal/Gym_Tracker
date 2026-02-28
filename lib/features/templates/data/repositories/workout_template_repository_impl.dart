import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../../exercise/domain/entities/exercise.dart';
import '../../domain/entities/workout_template.dart';

/// Repository for workout templates using Drift database.
class WorkoutTemplateRepository {
  final db.AppDatabase _db;
  static const _uuid = Uuid();

  WorkoutTemplateRepository(this._db);

  /// Get all templates ordered by sort order.
  Future<List<WorkoutTemplate>> getAllTemplates({
    bool includeDeleted = false,
  }) async {
    var query = _db.select(_db.workoutTemplates);

    if (!includeDeleted) {
      query = query..where((tbl) => tbl.deleted.equals(false));
    }

    query = query..orderBy([
      (tbl) => OrderingTerm.asc(tbl.sortOrder),
      (tbl) => OrderingTerm.asc(tbl.name),
    ]);

    final rows = await query.get();
    final templates = <WorkoutTemplate>[];

    for (final row in rows) {
      final exercises = await _getTemplateExercises(row.id);
      templates.add(_mapToEntity(row, exercises));
    }

    return templates;
  }

  /// Get a single template by ID.
  Future<WorkoutTemplate?> getTemplateById(String id) async {
    final query = _db.select(_db.workoutTemplates)
      ..where((tbl) => tbl.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final exercises = await _getTemplateExercises(id);
    return _mapToEntity(row, exercises);
  }

  /// Get predefined (system) templates.
  Future<List<WorkoutTemplate>> getPredefinedTemplates() async {
    final query = _db.select(_db.workoutTemplates)
      ..where((tbl) => tbl.isPredefined.equals(true))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]);

    final rows = await query.get();
    final templates = <WorkoutTemplate>[];

    for (final row in rows) {
      final exercises = await _getTemplateExercises(row.id);
      templates.add(_mapToEntity(row, exercises));
    }

    return templates;
  }

  /// Save a template.
  Future<WorkoutTemplate> saveTemplate(WorkoutTemplate template) async {
    final id = template.id.isEmpty ? _uuid.v4() : template.id;
    final now = DateTime.now();

    final companion = db.WorkoutTemplatesCompanion(
      id: Value(id),
      name: Value(template.name),
      description: Value(template.description),
      color: Value(template.color.value.toRadixString(16).padLeft(8, '0')),
      iconName: Value(_iconToName(template.icon)),
      estimatedMinutes: Value(template.estimatedMinutes),
      usageCount: Value(template.usageCount),
      lastUsedAt: Value(template.lastUsedAt),
      sortOrder: Value(template.sortOrder),
      isPredefined: Value(template.isPredefined),
      createdAt: Value(template.createdAt),
      updatedAt: Value(now),
      deleted: Value(template.deleted),
    );

    await _db.into(_db.workoutTemplates).insertOnConflictUpdate(companion);

    // Save template exercises
    for (final exercise in template.exercises) {
      await _saveTemplateExercise(id, exercise);
    }

    return template.copyWith(id: id, updatedAt: now);
  }

  /// Update template usage count.
  Future<void> incrementUsage(String id) async {
    final now = DateTime.now();
    final template = await getTemplateById(id);
    if (template == null) return;

    await (_db.update(_db.workoutTemplates)
          ..where((tbl) => tbl.id.equals(id)))
        .write(db.WorkoutTemplatesCompanion(
      usageCount: Value(template.usageCount + 1),
      lastUsedAt: Value(now),
      updatedAt: Value(now),
    ));
  }

  /// Delete a template (soft delete).
  Future<void> deleteTemplate(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.workoutTemplates)
          ..where((tbl) => tbl.id.equals(id)))
        .write(db.WorkoutTemplatesCompanion(
      deleted: const Value(true),
      updatedAt: Value(now),
    ));
  }

  /// Seed predefined templates if they don't exist.
  Future<void> seedPredefinedTemplates() async {
    final existing = await getPredefinedTemplates();
    if (existing.isNotEmpty) return;

    final now = DateTime.now();
    final predefined = [
      WorkoutTemplate(
        id: 'push-day',
        name: 'Push Day',
        description: 'Chest, Shoulders, Triceps',
        color: const Color(0xFFEF4444),
        icon: Icons.fitness_center,
        estimatedMinutes: 60,
        isPredefined: true,
        sortOrder: 1,
        createdAt: now,
        updatedAt: now,
      ),
      WorkoutTemplate(
        id: 'pull-day',
        name: 'Pull Day',
        description: 'Back, Biceps, Rear Delts',
        color: const Color(0xFF3B82F6),
        icon: Icons.fitness_center,
        estimatedMinutes: 60,
        isPredefined: true,
        sortOrder: 2,
        createdAt: now,
        updatedAt: now,
      ),
      WorkoutTemplate(
        id: 'leg-day',
        name: 'Leg Day',
        description: 'Quads, Hamstrings, Glutes, Calves',
        color: const Color(0xFF22C55E),
        icon: Icons.directions_run,
        estimatedMinutes: 75,
        isPredefined: true,
        sortOrder: 3,
        createdAt: now,
        updatedAt: now,
      ),
      WorkoutTemplate(
        id: 'upper-body',
        name: 'Upper Body',
        description: 'Full upper body workout',
        color: const Color(0xFFF59E0B),
        icon: Icons.accessibility_new,
        estimatedMinutes: 60,
        isPredefined: true,
        sortOrder: 4,
        createdAt: now,
        updatedAt: now,
      ),
      WorkoutTemplate(
        id: 'lower-body',
        name: 'Lower Body',
        description: 'Full lower body workout',
        color: const Color(0xFF8B5CF6),
        icon: Icons.directions_walk,
        estimatedMinutes: 60,
        isPredefined: true,
        sortOrder: 5,
        createdAt: now,
        updatedAt: now,
      ),
      WorkoutTemplate(
        id: 'full-body',
        name: 'Full Body',
        description: 'Complete full body workout',
        color: const Color(0xFF6366F1),
        icon: Icons.sports_gymnastics,
        estimatedMinutes: 90,
        isPredefined: true,
        sortOrder: 6,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final template in predefined) {
      await saveTemplate(template);
    }
  }

  /// Get template exercises.
  Future<List<TemplateExercise>> _getTemplateExercises(String templateId) async {
    final query = _db.select(_db.templateExercises)
      ..where((tbl) => tbl.templateId.equals(templateId))
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.sortOrder)]);

    final rows = await query.get();
    final exercises = <TemplateExercise>[];

    for (final row in rows) {
      // Get exercise info
      final exerciseQuery = _db.select(_db.exercises)
        ..where((tbl) => tbl.id.equals(row.exerciseId));
      final exerciseRow = await exerciseQuery.getSingleOrNull();

      exercises.add(TemplateExercise(
        id: row.id,
        templateId: row.templateId,
        exerciseId: row.exerciseId,
        exercise: exerciseRow != null ? _mapExercise(exerciseRow) : null,
        sortOrder: row.sortOrder,
        defaultSets: row.defaultSets,
        defaultReps: row.defaultReps,
        defaultWeight: row.defaultWeight,
        defaultRestSeconds: row.defaultRestSeconds,
        notes: row.notes,
        supersetGroup: row.supersetGroup,
        updatedAt: row.updatedAt,
        deleted: row.deleted,
      ));
    }

    return exercises;
  }

  /// Save template exercise.
  Future<void> _saveTemplateExercise(
    String templateId,
    TemplateExercise exercise,
  ) async {
    final id = exercise.id.isEmpty ? _uuid.v4() : exercise.id;
    final now = DateTime.now();

    final companion = db.TemplateExercisesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      exerciseId: Value(exercise.exerciseId),
      sortOrder: Value(exercise.sortOrder),
      defaultSets: Value(exercise.defaultSets),
      defaultReps: Value(exercise.defaultReps),
      defaultWeight: Value(exercise.defaultWeight),
      defaultRestSeconds: Value(exercise.defaultRestSeconds),
      notes: Value(exercise.notes),
      supersetGroup: Value(exercise.supersetGroup),
      updatedAt: Value(now),
      deleted: Value(exercise.deleted),
    );

    await _db.into(_db.templateExercises).insertOnConflictUpdate(companion);
  }

  /// Map database row to domain entity.
  WorkoutTemplate _mapToEntity(
    db.WorkoutTemplate row,
    List<TemplateExercise> exercises,
  ) {
    return WorkoutTemplate(
      id: row.id,
      name: row.name,
      description: row.description,
      color: _parseColor(row.color),
      icon: _parseIcon(row.iconName),
      estimatedMinutes: row.estimatedMinutes,
      usageCount: row.usageCount,
      lastUsedAt: row.lastUsedAt,
      sortOrder: row.sortOrder,
      isPredefined: row.isPredefined,
      exercises: exercises,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deleted: row.deleted,
    );
  }

  /// Parse color from hex string.
  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }

  /// Parse icon from name.
  IconData _parseIcon(String name) {
    const iconMap = {
      'fitness_center': Icons.fitness_center,
      'directions_run': Icons.directions_run,
      'accessibility_new': Icons.accessibility_new,
      'directions_walk': Icons.directions_walk,
      'sports_gymnastics': Icons.sports_gymnastics,
    };
    return iconMap[name] ?? Icons.fitness_center;
  }

  /// Convert icon to name.
  String _iconToName(IconData icon) {
    if (icon == Icons.fitness_center) return 'fitness_center';
    if (icon == Icons.directions_run) return 'directions_run';
    if (icon == Icons.accessibility_new) return 'accessibility_new';
    if (icon == Icons.directions_walk) return 'directions_walk';
    if (icon == Icons.sports_gymnastics) return 'sports_gymnastics';
    return 'fitness_center';
  }

  /// Map exercise row to domain.
  Exercise _mapExercise(db.Exercise row) {
    return Exercise(
      id: row.id,
      // Simplified mapping - in real implementation, use full mapper
      name: row.name,
      muscleGroup: _parseMuscleGroup(row.muscleGroup),
      updatedAt: row.updatedAt,
    );
  }

  /// Parse muscle group from string.
  dynamic _parseMuscleGroup(String value) {
    // Import from exercise entity
    return value;
  }
}
