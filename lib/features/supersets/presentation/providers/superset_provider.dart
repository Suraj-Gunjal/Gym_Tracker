import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/superset.dart';

part 'superset_provider.g.dart';

/// State for managing exercise groups.
@riverpod
class ExerciseGroupsNotifier extends _$ExerciseGroupsNotifier {
  @override
  List<ExerciseGroup> build() {
    return _generateMockGroups();
  }

  List<ExerciseGroup> _generateMockGroups() {
    return [
      ExerciseGroup(
        id: '1',
        name: 'Chest & Back Superset',
        type: GroupType.superset,
        exercises: [
          const GroupedExercise(
            id: '1',
            exerciseId: 'bench_press',
            exerciseName: 'Bench Press',
            order: 0,
            targetSets: 3,
            targetReps: 10,
            targetWeight: 80,
          ),
          const GroupedExercise(
            id: '2',
            exerciseId: 'bent_over_row',
            exerciseName: 'Bent Over Row',
            order: 1,
            targetSets: 3,
            targetReps: 10,
            targetWeight: 60,
          ),
        ],
        restBetweenRounds: 90,
        totalRounds: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      ExerciseGroup(
        id: '2',
        name: 'Arm Tri-set',
        type: GroupType.triset,
        exercises: [
          const GroupedExercise(
            id: '3',
            exerciseId: 'bicep_curl',
            exerciseName: 'Bicep Curl',
            order: 0,
            targetSets: 3,
            targetReps: 12,
            targetWeight: 15,
          ),
          const GroupedExercise(
            id: '4',
            exerciseId: 'tricep_pushdown',
            exerciseName: 'Tricep Pushdown',
            order: 1,
            targetSets: 3,
            targetReps: 12,
            targetWeight: 25,
          ),
          const GroupedExercise(
            id: '5',
            exerciseId: 'hammer_curl',
            exerciseName: 'Hammer Curl',
            order: 2,
            targetSets: 3,
            targetReps: 12,
            targetWeight: 12,
          ),
        ],
        restBetweenRounds: 60,
        totalRounds: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ExerciseGroup(
        id: '3',
        name: 'HIIT Circuit',
        type: GroupType.circuit,
        exercises: [
          const GroupedExercise(
            id: '6',
            exerciseId: 'burpees',
            exerciseName: 'Burpees',
            order: 0,
            targetSets: 4,
            targetReps: 10,
          ),
          const GroupedExercise(
            id: '7',
            exerciseId: 'mountain_climbers',
            exerciseName: 'Mountain Climbers',
            order: 1,
            targetSets: 4,
            targetReps: 20,
          ),
          const GroupedExercise(
            id: '8',
            exerciseId: 'jump_squats',
            exerciseName: 'Jump Squats',
            order: 2,
            targetSets: 4,
            targetReps: 15,
          ),
          const GroupedExercise(
            id: '9',
            exerciseId: 'plank',
            exerciseName: 'Plank Hold',
            order: 3,
            targetSets: 4,
            targetReps: 1,
            targetDuration: 30,
          ),
        ],
        restBetweenRounds: 120,
        restBetweenExercises: 15,
        totalRounds: 4,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void addGroup(ExerciseGroup group) {
    state = [...state, group];
  }

  void updateGroup(ExerciseGroup group) {
    state = state.map((g) => g.id == group.id ? group : g).toList();
  }

  void deleteGroup(String groupId) {
    state = state.where((g) => g.id != groupId).toList();
  }

  void addExerciseToGroup(String groupId, GroupedExercise exercise) {
    state = state.map((g) {
      if (g.id == groupId) {
        return g.copyWith(exercises: [...g.exercises, exercise]);
      }
      return g;
    }).toList();
  }

  void removeExerciseFromGroup(String groupId, String exerciseId) {
    state = state.map((g) {
      if (g.id == groupId) {
        return g.copyWith(
          exercises: g.exercises.where((e) => e.id != exerciseId).toList(),
        );
      }
      return g;
    }).toList();
  }

  void reorderExercises(String groupId, int oldIndex, int newIndex) {
    state = state.map((g) {
      if (g.id == groupId) {
        final exercises = [...g.exercises];
        final item = exercises.removeAt(oldIndex);
        exercises.insert(newIndex, item);
        return g.copyWith(
          exercises: exercises
              .asMap()
              .entries
              .map((e) => e.value.copyWith(order: e.key))
              .toList(),
        );
      }
      return g;
    }).toList();
  }
}

/// Provider for group templates.
@riverpod
class GroupTemplatesNotifier extends _$GroupTemplatesNotifier {
  @override
  List<GroupTemplate> build() {
    return [
      GroupTemplate(
        id: '1',
        name: 'Push-Pull Superset',
        type: GroupType.superset,
        exerciseIds: ['bench_press', 'bent_over_row'],
        restBetweenRounds: 90,
        isFavorite: true,
        usageCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastUsedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      GroupTemplate(
        id: '2',
        name: 'Leg Day Circuit',
        type: GroupType.circuit,
        exerciseIds: ['squat', 'lunges', 'leg_press', 'leg_curl'],
        restBetweenRounds: 120,
        restBetweenExercises: 20,
        defaultRounds: 4,
        usageCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastUsedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  void toggleFavorite(String templateId) {
    state = state.map((t) {
      if (t.id == templateId) {
        return GroupTemplate(
          id: t.id,
          name: t.name,
          type: t.type,
          exerciseIds: t.exerciseIds,
          restBetweenRounds: t.restBetweenRounds,
          restBetweenExercises: t.restBetweenExercises,
          defaultRounds: t.defaultRounds,
          isFavorite: !t.isFavorite,
          usageCount: t.usageCount,
          createdAt: t.createdAt,
          lastUsedAt: t.lastUsedAt,
        );
      }
      return t;
    }).toList();
  }
}

/// Provider for active superset during workout.
@riverpod
class ActiveGroupNotifier extends _$ActiveGroupNotifier {
  @override
  ExerciseGroup? build() => null;

  void startGroup(ExerciseGroup group) {
    state = group;
  }

  void endGroup() {
    state = null;
  }

  void completeRound() {
    // Track round completion
  }
}
