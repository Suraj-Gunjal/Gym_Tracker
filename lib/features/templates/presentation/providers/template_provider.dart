import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/workout_template_repository_impl.dart';
import '../../domain/entities/workout_template.dart';

part 'template_provider.g.dart';

/// Provider for workout template repository
@riverpod
WorkoutTemplateRepository workoutTemplateRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return WorkoutTemplateRepository(db);
}

/// Provider for workout templates
@riverpod
class TemplatesNotifier extends _$TemplatesNotifier {
  final _uuid = const Uuid();

  @override
  Future<List<WorkoutTemplate>> build() async {
    final repository = ref.watch(workoutTemplateRepositoryProvider);
    // Seed predefined templates if needed
    await repository.seedPredefinedTemplates();
    return repository.getAllTemplates();
  }

  Future<void> addTemplate(WorkoutTemplate template) async {
    final repository = ref.read(workoutTemplateRepositoryProvider);
    await repository.saveTemplate(template);
    ref.invalidateSelf();
  }

  Future<void> updateTemplate(WorkoutTemplate template) async {
    final repository = ref.read(workoutTemplateRepositoryProvider);
    await repository.saveTemplate(template);
    ref.invalidateSelf();
  }

  Future<void> deleteTemplate(String id) async {
    final repository = ref.read(workoutTemplateRepositoryProvider);
    await repository.deleteTemplate(id);
    ref.invalidateSelf();
  }

  Future<void> incrementUsage(String id) async {
    final repository = ref.read(workoutTemplateRepositoryProvider);
    await repository.incrementUsage(id);
    ref.invalidateSelf();
  }

  Future<WorkoutTemplate> createNewTemplate({
    required String name,
    String? description,
    Color? color,
    IconData? icon,
  }) async {
    final template = WorkoutTemplate(
      id: _uuid.v4(),
      name: name,
      description: description,
      color: color ?? const Color(0xFF6366F1),
      icon: icon ?? Icons.fitness_center,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await addTemplate(template);
    return template;
  }
}

/// Provider for currently selected template
@riverpod
class SelectedTemplate extends _$SelectedTemplate {
  @override
  WorkoutTemplate? build() => null;

  void select(WorkoutTemplate? template) {
    state = template;
  }
}

/// Filter state for templates
enum TemplateFilter { all, recent, custom, predefined }

@riverpod
class TemplateFilterNotifier extends _$TemplateFilterNotifier {
  @override
  TemplateFilter build() => TemplateFilter.all;

  void setFilter(TemplateFilter filter) {
    state = filter;
  }
}

/// Filtered templates based on current filter
@riverpod
List<WorkoutTemplate> filteredTemplates(Ref ref) {
  final templatesAsync = ref.watch(templatesNotifierProvider);
  final filter = ref.watch(templateFilterNotifierProvider);

  return templatesAsync.when(
    data: (templates) {
      switch (filter) {
        case TemplateFilter.all:
          return templates;
        case TemplateFilter.recent:
          final sorted = [...templates]
            ..sort((a, b) => (b.lastUsedAt ?? DateTime(1970))
                .compareTo(a.lastUsedAt ?? DateTime(1970)));
          return sorted.take(6).toList();
        case TemplateFilter.custom:
          return templates.where((t) => !t.isPredefined).toList();
        case TemplateFilter.predefined:
          return templates.where((t) => t.isPredefined).toList();
      }
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Template color options
final templateColorsProvider = Provider<List<Color>>((ref) {
  return const [
    Color(0xFFEF4444), // Red
    Color(0xFFF59E0B), // Amber
    Color(0xFF22C55E), // Green
    Color(0xFF3B82F6), // Blue
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFF14B8A6), // Teal
    Color(0xFF64748B), // Slate
  ];
});

/// Template icon options
final templateIconsProvider = Provider<List<IconData>>((ref) {
  return const [
    Icons.fitness_center,
    Icons.sports_gymnastics,
    Icons.directions_run,
    Icons.accessibility_new,
    Icons.directions_walk,
    Icons.self_improvement,
    Icons.sports_martial_arts,
    Icons.sports,
    Icons.bolt,
    Icons.local_fire_department,
  ];
});
