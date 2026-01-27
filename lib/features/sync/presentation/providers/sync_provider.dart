import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/remote_auth_provider.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../../pr/presentation/providers/pr_provider.dart';
import '../../data/models/sync_models.dart';
import '../../data/repositories/sync_repository.dart';

// Repository provider
final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Sync state
enum SyncStatus { idle, syncing, success, error, offline }

class SyncState {
  final SyncStatus status;
  final DateTime? lastSyncAt;
  final String? error;
  final int? itemsPushed;
  final int? itemsPulled;
  final int? conflicts;

  const SyncState({
    this.status = SyncStatus.idle,
    this.lastSyncAt,
    this.error,
    this.itemsPushed,
    this.itemsPulled,
    this.conflicts,
  });

  SyncState copyWith({
    SyncStatus? status,
    DateTime? lastSyncAt,
    String? error,
    int? itemsPushed,
    int? itemsPulled,
    int? conflicts,
  }) {
    return SyncState(
      status: status ?? this.status,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      error: error,
      itemsPushed: itemsPushed ?? this.itemsPushed,
      itemsPulled: itemsPulled ?? this.itemsPulled,
      conflicts: conflicts ?? this.conflicts,
    );
  }

  bool get isSyncing => status == SyncStatus.syncing;
  bool get hasError => status == SyncStatus.error;
}

class SyncNotifier extends StateNotifier<SyncState> {
  final SyncRepository _repository;
  final Ref _ref;

  SyncNotifier(this._repository, this._ref) : super(const SyncState()) {
    _loadLastSyncTime();
  }

  Future<void> _loadLastSyncTime() async {
    final lastSync = await _repository.getLastSyncAt();
    state = state.copyWith(lastSyncAt: lastSync);
  }

  /// Perform a full sync (push then pull)
  Future<bool> sync() async {
    // Check if authenticated
    final authState = _ref.read(remoteAuthProvider);
    if (!authState.isAuthenticated) {
      state = state.copyWith(
        status: SyncStatus.error,
        error: 'Not authenticated',
      );
      return false;
    }

    // Check if online
    if (!authState.isOnline) {
      state = state.copyWith(status: SyncStatus.offline);
      return false;
    }

    state = state.copyWith(status: SyncStatus.syncing, error: null);

    try {
      // Push local changes
      final pushResult = await _pushChanges();
      if (!pushResult) {
        return false;
      }

      // Pull server changes
      final pullResult = await _pullChanges();
      if (!pullResult) {
        return false;
      }

      state = state.copyWith(
        status: SyncStatus.success,
        lastSyncAt: DateTime.now(),
      );
      return true;
    } catch (e) {
      debugPrint('Sync error: $e');
      state = state.copyWith(status: SyncStatus.error, error: e.toString());
      return false;
    }
  }

  Future<bool> _pushChanges() async {
    // Get local data that needs to be synced
    // For simplicity, we'll push all custom exercises and recent workouts

    final exercises = await _getExercisesToSync();
    final workouts = await _getWorkoutsToSync();
    final prs = await _getPRsToSync();

    final result = await _repository.pushChanges(
      exercises: exercises,
      workouts: workouts,
      personalRecords: prs,
    );

    if (result.isSuccess && result.data != null) {
      state = state.copyWith(
        itemsPushed: result.data!.itemsPushed,
        conflicts: result.data!.conflicts,
      );
      return true;
    }

    state = state.copyWith(status: SyncStatus.error, error: result.error);
    return false;
  }

  Future<bool> _pullChanges() async {
    final result = await _repository.pullChanges();

    if (result.isSuccess && result.data != null) {
      final data = result.data!;

      // Apply pulled data to local database
      await _applyPulledData(data);

      state = state.copyWith(
        itemsPulled:
            data.exercises.length +
            data.workouts.length +
            data.personalRecords.length,
      );
      return true;
    }

    state = state.copyWith(status: SyncStatus.error, error: result.error);
    return false;
  }

  Future<List<SyncExercise>> _getExercisesToSync() async {
    // Get custom exercises from local database
    final exerciseRepo = _ref.read(exerciseRepositoryProvider);
    final exercises = await exerciseRepo.getAllExercises();

    return exercises
        .where((e) => !e.isPredefined)
        .map((e) => SyncExercise.fromEntity(e))
        .toList();
  }

  Future<List<SyncWorkout>> _getWorkoutsToSync() async {
    // Get workouts from local database
    final workoutRepo = _ref.read(workoutRepositoryProvider);
    final workouts = await workoutRepo.getAllWorkouts();

    return workouts.map((w) => SyncWorkout.fromEntity(w)).toList();
  }

  Future<List<SyncPersonalRecord>> _getPRsToSync() async {
    // Get PRs from local database
    final prRepo = _ref.read(prRepositoryProvider);
    final prs = await prRepo.getAllPRs();

    return prs.map((pr) => SyncPersonalRecord.fromEntity(pr)).toList();
  }

  Future<void> _applyPulledData(SyncPullResponse data) async {
    // Apply exercises
    // Note: In a full implementation, you would:
    // 1. Compare with local data
    // 2. Handle conflicts
    // 3. Update local database

    debugPrint('Pulled ${data.exercises.length} exercises');
    debugPrint('Pulled ${data.workouts.length} workouts');
    debugPrint('Pulled ${data.personalRecords.length} PRs');

    // For now, just invalidate providers to refresh UI
    _ref.invalidate(allExercisesProvider);
    _ref.invalidate(allWorkoutsProvider);
    _ref.invalidate(allPRsProvider);
  }

  void clearError() {
    state = state.copyWith(error: null, status: SyncStatus.idle);
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref.watch(syncRepositoryProvider), ref);
});

// Convenience providers
final lastSyncAtProvider = Provider<DateTime?>((ref) {
  return ref.watch(syncProvider).lastSyncAt;
});

final isSyncingProvider = Provider<bool>((ref) {
  return ref.watch(syncProvider).isSyncing;
});
