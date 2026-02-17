import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/workout_template.dart';

part 'template_provider.g.dart';

/// Provider for workout templates
@riverpod
class TemplatesNotifier extends _$TemplatesNotifier {
  final _uuid = const Uuid();

  @override
  List<WorkoutTemplate> build() {
    // Return predefined templates
    return _getPredefinedTemplates();
  }

  List<WorkoutTemplate> _getPredefinedTemplates() {
    final now = DateTime.now();
    return [
      WorkoutTemplate(
        id: 'push-day',
        name: 'Push Day',
        description: 'Chest, Shoulders, Triceps',
        color: const Color(0xFFEF4444),
        icon: Icons.fitness_center,
        estimatedMinutes: 60,
        isPredefined: true,
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
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  void addTemplate(WorkoutTemplate template) {
    state = [...state, template];
  }

  void updateTemplate(WorkoutTemplate template) {
    state = [
      for (final t in state)
        if (t.id == template.id) template else t,
    ];
  }

  void deleteTemplate(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void incrementUsage(String id) {
    state = [
      for (final t in state)
        if (t.id == id)
          t.copyWith(
            usageCount: t.usageCount + 1,
            lastUsedAt: DateTime.now(),
          )
        else
          t,
    ];
  }

  WorkoutTemplate createNewTemplate({
    required String name,
    String? description,
    Color? color,
    IconData? icon,
  }) {
    final template = WorkoutTemplate(
      id: _uuid.v4(),
      name: name,
      description: description,
      color: color ?? const Color(0xFF6366F1),
      icon: icon ?? Icons.fitness_center,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    addTemplate(template);
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
  final templates = ref.watch(templatesNotifierProvider);
  final filter = ref.watch(templateFilterNotifierProvider);

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
