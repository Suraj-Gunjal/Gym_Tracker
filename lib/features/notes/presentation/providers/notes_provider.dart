import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/exercise_note.dart';

part 'notes_provider.g.dart';

/// Provider for exercise notes.
@riverpod
class ExerciseNotesNotifier extends _$ExerciseNotesNotifier {
  @override
  Map<String, ExerciseNote> build() {
    // Initialize with default form tips
    final notes = <String, ExerciseNote>{};
    DefaultFormTips.tips.forEach((key, value) {
      notes[key] = value;
    });
    return notes;
  }

  /// Get notes for a specific exercise.
  ExerciseNote? getNotes(String exerciseId) {
    final key = exerciseId.toLowerCase().replaceAll(' ', '_');
    return state[key];
  }

  /// Update or create notes for an exercise.
  void updateNotes(String exerciseId, ExerciseNote note) {
    final key = exerciseId.toLowerCase().replaceAll(' ', '_');
    state = {...state, key: note};
  }

  /// Toggle favorite status.
  void toggleFavorite(String exerciseId) {
    final key = exerciseId.toLowerCase().replaceAll(' ', '_');
    final existing = state[key];
    if (existing != null) {
      state = {
        ...state,
        key: existing.copyWith(isFavorite: !existing.isFavorite),
      };
    }
  }

  /// Add a form cue.
  void addFormCue(String exerciseId, String cue) {
    final key = exerciseId.toLowerCase().replaceAll(' ', '_');
    final existing = state[key];
    if (existing != null) {
      state = {
        ...state,
        key: existing.copyWith(formCues: [...existing.formCues, cue]),
      };
    }
  }

  /// Remove a form cue.
  void removeFormCue(String exerciseId, int index) {
    final key = exerciseId.toLowerCase().replaceAll(' ', '_');
    final existing = state[key];
    if (existing != null && index < existing.formCues.length) {
      final newCues = List<String>.from(existing.formCues)..removeAt(index);
      state = {...state, key: existing.copyWith(formCues: newCues)};
    }
  }

  /// Update personal notes.
  void updatePersonalNotes(String exerciseId, String notes) {
    final key = exerciseId.toLowerCase().replaceAll(' ', '_');
    final existing =
        state[key] ?? ExerciseNote(id: 'custom_$key', exerciseId: key);
    state = {...state, key: existing.copyWith(personalNotes: notes)};
  }

  /// Increment times performed.
  void incrementTimesPerformed(String exerciseId) {
    final key = exerciseId.toLowerCase().replaceAll(' ', '_');
    final existing = state[key];
    if (existing != null) {
      state = {
        ...state,
        key: existing.copyWith(
          timesPerformed: existing.timesPerformed + 1,
          lastUsedAt: DateTime.now(),
        ),
      };
    }
  }
}

/// Provider for workout challenges.
@riverpod
class ChallengesNotifier extends _$ChallengesNotifier {
  @override
  List<WorkoutChallenge> build() {
    return _generateSampleChallenges();
  }

  List<WorkoutChallenge> _generateSampleChallenges() {
    final now = DateTime.now();
    return [
      WorkoutChallenge(
        id: 'challenge_1',
        name: '10K Club',
        description: 'Lift 10,000 kg total this week',
        type: ChallengeType.volume,
        targetValue: 10000,
        currentValue: 6500,
        unit: 'kg',
        durationDays: 7,
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 4)),
        xpReward: 250,
        difficulty: 3,
        iconName: 'fitness_center',
        color: '#6366F1',
      ),
      WorkoutChallenge(
        id: 'challenge_2',
        name: 'Consistency King',
        description: 'Complete 4 workouts this week',
        type: ChallengeType.frequency,
        targetValue: 4,
        currentValue: 2,
        unit: 'workouts',
        durationDays: 7,
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 5)),
        xpReward: 200,
        difficulty: 2,
        iconName: 'calendar_today',
        color: '#10B981',
      ),
      WorkoutChallenge(
        id: 'challenge_3',
        name: 'Iron Marathon',
        description: 'Train for 7 consecutive days',
        type: ChallengeType.streak,
        targetValue: 7,
        currentValue: 4,
        unit: 'days',
        durationDays: 14,
        startDate: now.subtract(const Duration(days: 4)),
        endDate: now.add(const Duration(days: 10)),
        xpReward: 500,
        badgeId: 'iron_will',
        difficulty: 4,
        iconName: 'local_fire_department',
        color: '#EF4444',
      ),
      WorkoutChallenge(
        id: 'challenge_4',
        name: 'Bench Beast',
        description: 'Hit a new bench press PR',
        type: ChallengeType.strength,
        targetValue: 1,
        currentValue: 0,
        unit: 'PR',
        durationDays: 30,
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 25)),
        xpReward: 300,
        badgeId: 'bench_master',
        difficulty: 4,
        iconName: 'emoji_events',
        color: '#F59E0B',
      ),
      WorkoutChallenge(
        id: 'challenge_5',
        name: 'Time Under Tension',
        description: 'Accumulate 5 hours of gym time',
        type: ChallengeType.time,
        targetValue: 300,
        currentValue: 180,
        unit: 'minutes',
        durationDays: 14,
        startDate: now.subtract(const Duration(days: 7)),
        endDate: now.add(const Duration(days: 7)),
        xpReward: 350,
        difficulty: 3,
        iconName: 'timer',
        color: '#8B5CF6',
      ),
      WorkoutChallenge(
        id: 'challenge_6',
        name: 'Squat Century',
        description: 'Perform 100 squats total',
        type: ChallengeType.exercise,
        targetValue: 100,
        currentValue: 45,
        unit: 'reps',
        durationDays: 7,
        startDate: now.subtract(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 5)),
        xpReward: 150,
        difficulty: 2,
        iconName: 'directions_walk',
        color: '#EC4899',
      ),
    ];
  }

  /// Update challenge progress.
  void updateProgress(String challengeId, double newValue) {
    state = state.map((c) {
      if (c.id == challengeId) {
        final updated = c.copyWith(currentValue: newValue);
        if (updated.progress >= 1.0 && !c.isCompleted) {
          return updated.copyWith(isCompleted: true);
        }
        return updated;
      }
      return c;
    }).toList();
  }

  /// Complete a challenge.
  void completeChallenge(String challengeId) {
    state = state.map((c) {
      if (c.id == challengeId) {
        return c.copyWith(isCompleted: true, isActive: false);
      }
      return c;
    }).toList();
  }

  /// Get active challenges.
  List<WorkoutChallenge> get activeChallenges =>
      state.where((c) => c.isInProgress).toList();

  /// Get completed challenges.
  List<WorkoutChallenge> get completedChallenges =>
      state.where((c) => c.isCompleted).toList();
}

/// Provider for active challenges only.
@riverpod
List<WorkoutChallenge> activeChallenges(Ref ref) {
  final challenges = ref.watch(challengesNotifierProvider);
  return challenges.where((c) => c.isInProgress).toList();
}

/// Provider for specific exercise notes.
@riverpod
ExerciseNote? exerciseNotes(Ref ref, String exerciseId) {
  final notes = ref.watch(exerciseNotesNotifierProvider);
  final key = exerciseId.toLowerCase().replaceAll(' ', '_');
  return notes[key];
}
