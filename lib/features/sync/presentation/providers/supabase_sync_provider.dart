import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/supabase_sync_service.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/providers/database_provider.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../../pr/presentation/providers/pr_provider.dart';

// Supabase sync service provider
final supabaseSyncServiceProvider = Provider<SupabaseSyncService>((ref) {
  return SupabaseSyncService();
});

// Sync state
enum SyncStatus { idle, syncing, success, error, offline, notAuthenticated }

class SyncState {
  final SyncStatus status;
  final DateTime? lastSyncAt;
  final String? error;
  final int itemsPushed;
  final int itemsPulled;
  final int conflicts;
  final bool isEnabled;

  const SyncState({
    this.status = SyncStatus.idle,
    this.lastSyncAt,
    this.error,
    this.itemsPushed = 0,
    this.itemsPulled = 0,
    this.conflicts = 0,
    this.isEnabled = true,
  });

  SyncState copyWith({
    SyncStatus? status,
    DateTime? lastSyncAt,
    String? error,
    int? itemsPushed,
    int? itemsPulled,
    int? conflicts,
    bool? isEnabled,
  }) {
    return SyncState(
      status: status ?? this.status,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      error: error,
      itemsPushed: itemsPushed ?? this.itemsPushed,
      itemsPulled: itemsPulled ?? this.itemsPulled,
      conflicts: conflicts ?? this.conflicts,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  bool get isSyncing => status == SyncStatus.syncing;
  bool get hasError => status == SyncStatus.error;
  bool get isReady =>
      status != SyncStatus.syncing && status != SyncStatus.notAuthenticated;
}

class SupabaseSyncNotifier extends StateNotifier<SyncState> {
  final SupabaseSyncService _syncService;
  final Ref _ref;
  Timer? _autoSyncTimer;
  static const _lastSyncKey = 'supabase_last_sync';
  static const _deviceIdKey = 'sync_device_id';

  SupabaseSyncNotifier(this._syncService, this._ref)
    : super(const SyncState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadLastSyncTime();
    _startAutoSync();
  }

  Future<void> _loadLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncStr = prefs.getString(_lastSyncKey);
      if (lastSyncStr != null) {
        state = state.copyWith(lastSyncAt: DateTime.parse(lastSyncStr));
      }
    } catch (e) {
      debugPrint('Error loading last sync time: $e');
    }
  }

  Future<void> _saveLastSyncTime(DateTime time) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSyncKey, time.toIso8601String());
    } catch (e) {
      debugPrint('Error saving last sync time: $e');
    }
  }

  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString(_deviceIdKey);
    if (deviceId == null) {
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString(_deviceIdKey, deviceId);
    }
    return deviceId;
  }

  void _startAutoSync() {
    // Auto-sync every 5 minutes when authenticated
    _autoSyncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (state.isEnabled && _syncService.isAvailable) {
        sync(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }

  /// Check if sync is available
  bool get isAvailable => _syncService.isAvailable;

  /// Toggle sync on/off
  void setEnabled(bool enabled) {
    state = state.copyWith(isEnabled: enabled);
  }

  /// Perform a full sync (push then pull)
  Future<bool> sync({bool silent = false}) async {
    // Check if Supabase is available
    if (!SupabaseService.isAvailable) {
      if (!silent) {
        state = state.copyWith(
          status: SyncStatus.offline,
          error: 'Cloud sync not configured',
        );
      }
      return false;
    }

    // Check if authenticated
    if (!SupabaseService.isAuthenticated) {
      if (!silent) {
        state = state.copyWith(
          status: SyncStatus.notAuthenticated,
          error: 'Please sign in to sync',
        );
      }
      return false;
    }

    if (!silent) {
      state = state.copyWith(status: SyncStatus.syncing, error: null);
    }

    try {
      final deviceId = await _getDeviceId();
      int totalPushed = 0;
      int totalPulled = 0;

      // 1. Push local changes
      final pushResult = await _pushLocalChanges();
      totalPushed = pushResult;

      // 2. Pull remote changes
      final pullResult = await _pullRemoteChanges();
      totalPulled = pullResult;

      // 3. Update sync metadata
      await _syncService.updateLastSyncTime(deviceId);
      final now = DateTime.now();
      await _saveLastSyncTime(now);

      state = state.copyWith(
        status: SyncStatus.success,
        lastSyncAt: now,
        itemsPushed: totalPushed,
        itemsPulled: totalPulled,
        error: null,
      );

      debugPrint('✅ Sync complete: pushed $totalPushed, pulled $totalPulled');
      return true;
    } catch (e) {
      debugPrint('❌ Sync error: $e');
      if (!silent) {
        state = state.copyWith(status: SyncStatus.error, error: e.toString());
      }
      return false;
    }
  }

  Future<int> _pushLocalChanges() async {
    int pushed = 0;

    // Get local exercises (custom only)
    final exerciseRepo = _ref.read(exerciseRepositoryProvider);
    final allExercises = await exerciseRepo.getAllExercises();
    final customExercises = allExercises.where((e) => !e.isPredefined).toList();

    if (customExercises.isNotEmpty) {
      final result = await _syncService.pushExercises(customExercises);
      if (result.isSuccess) {
        pushed += result.data ?? 0;
      }
    }

    // Get local workouts
    final workoutRepo = _ref.read(workoutRepositoryProvider);
    final workouts = await workoutRepo.getAllWorkouts();

    if (workouts.isNotEmpty) {
      final result = await _syncService.pushWorkouts(workouts);
      if (result.isSuccess) {
        pushed += result.data ?? 0;
      }
    }

    // Get local PRs
    final prRepo = _ref.read(prRepositoryProvider);
    final prs = await prRepo.getAllPRs();

    if (prs.isNotEmpty) {
      final result = await _syncService.pushPersonalRecords(prs);
      if (result.isSuccess) {
        pushed += result.data ?? 0;
      }
    }

    return pushed;
  }

  Future<int> _pullRemoteChanges() async {
    int pulled = 0;

    final deviceId = await _getDeviceId();
    final lastSync = await _syncService.getLastSyncTime(deviceId);

    final result = await _syncService.pullAll(lastSync);

    if (result.isSuccess && result.data != null) {
      final data = result.data!;

      // Apply exercises
      final exercises = data['exercises'] ?? [];
      if (exercises.isNotEmpty) {
        await _applyExercises(exercises);
        pulled += exercises.length;
      }

      // Apply workouts
      final workouts = data['workouts'] ?? [];
      final workoutExercises = data['workout_exercises'] ?? [];
      final exerciseSets = data['exercise_sets'] ?? [];
      if (workouts.isNotEmpty) {
        await _applyWorkouts(workouts, workoutExercises, exerciseSets);
        pulled += workouts.length;
      }

      // Apply PRs
      final prs = data['personal_records'] ?? [];
      if (prs.isNotEmpty) {
        await _applyPersonalRecords(prs);
        pulled += prs.length;
      }

      // Refresh UI
      _ref.invalidate(allExercisesProvider);
      _ref.invalidate(allWorkoutsProvider);
      _ref.invalidate(allPRsProvider);
    }

    return pulled;
  }

  Future<void> _applyExercises(List<Map<String, dynamic>> exercises) async {
    final db = _ref.read(appDatabaseProvider);

    for (final exerciseData in exercises) {
      final companion = ExercisesCompanion(
        id: Value(exerciseData['id'] as String),
        name: Value(exerciseData['name'] as String),
        muscleGroup: Value(exerciseData['muscle_group'] as String),
        description: Value(exerciseData['description'] as String?),
        isPredefined: Value(exerciseData['is_predefined'] as bool? ?? false),
        updatedAt: Value(DateTime.parse(exerciseData['updated_at'] as String)),
        deleted: Value(exerciseData['deleted'] as bool? ?? false),
      );

      // Upsert - insert or replace
      await db.into(db.exercises).insertOnConflictUpdate(companion);
    }
  }

  Future<void> _applyWorkouts(
    List<Map<String, dynamic>> workouts,
    List<Map<String, dynamic>> workoutExercises,
    List<Map<String, dynamic>> exerciseSets,
  ) async {
    final db = _ref.read(appDatabaseProvider);

    // Apply workouts
    for (final workoutData in workouts) {
      final companion = WorkoutsCompanion(
        id: Value(workoutData['id'] as String),
        name: Value(workoutData['name'] as String?),
        startedAt: Value(DateTime.parse(workoutData['started_at'] as String)),
        completedAt: Value(
          workoutData['completed_at'] != null
              ? DateTime.parse(workoutData['completed_at'] as String)
              : null,
        ),
        notes: Value(workoutData['notes'] as String?),
        updatedAt: Value(DateTime.parse(workoutData['updated_at'] as String)),
        deleted: Value(workoutData['deleted'] as bool? ?? false),
      );

      await db.into(db.workouts).insertOnConflictUpdate(companion);
    }

    // Apply workout exercises
    for (final weData in workoutExercises) {
      final companion = WorkoutExercisesCompanion(
        id: Value(weData['id'] as String),
        workoutId: Value(weData['workout_id'] as String),
        exerciseId: Value(weData['exercise_id'] as String),
        orderIndex: Value(weData['order_index'] as int),
        notes: Value(weData['notes'] as String?),
        updatedAt: Value(DateTime.parse(weData['updated_at'] as String)),
        deleted: Value(weData['deleted'] as bool? ?? false),
      );

      await db.into(db.workoutExercises).insertOnConflictUpdate(companion);
    }

    // Apply exercise sets
    for (final setData in exerciseSets) {
      final companion = ExerciseSetsCompanion(
        id: Value(setData['id'] as String),
        workoutExerciseId: Value(setData['workout_exercise_id'] as String),
        setNumber: Value(setData['set_number'] as int),
        reps: Value(setData['reps'] as int),
        weight: Value((setData['weight'] as num).toDouble()),
        notes: Value(setData['notes'] as String?),
        completed: Value(setData['completed'] as bool? ?? true),
        updatedAt: Value(DateTime.parse(setData['updated_at'] as String)),
        deleted: Value(setData['deleted'] as bool? ?? false),
      );

      await db.into(db.exerciseSets).insertOnConflictUpdate(companion);
    }
  }

  Future<void> _applyPersonalRecords(List<Map<String, dynamic>> prs) async {
    final db = _ref.read(appDatabaseProvider);

    for (final prData in prs) {
      final companion = PersonalRecordsCompanion(
        id: Value(prData['id'] as String),
        exerciseId: Value(prData['exercise_id'] as String),
        prType: Value(prData['pr_type'] as String),
        value: Value((prData['value'] as num).toDouble()),
        atWeight: Value(
          prData['at_weight'] != null
              ? (prData['at_weight'] as num).toDouble()
              : null,
        ),
        workoutId: Value(prData['workout_id'] as String? ?? ''),
        setId: Value(prData['set_id'] as String?),
        achievedAt: Value(DateTime.parse(prData['achieved_at'] as String)),
        previousValue: Value(
          prData['previous_value'] != null
              ? (prData['previous_value'] as num).toDouble()
              : null,
        ),
        updatedAt: Value(DateTime.parse(prData['updated_at'] as String)),
        deleted: Value(prData['deleted'] as bool? ?? false),
      );

      await db.into(db.personalRecords).insertOnConflictUpdate(companion);
    }
  }

  /// Force push all local data (full backup)
  Future<bool> forceBackup() async {
    if (!_syncService.isAvailable) {
      state = state.copyWith(
        status: SyncStatus.error,
        error: 'Cloud sync not available',
      );
      return false;
    }

    state = state.copyWith(status: SyncStatus.syncing, error: null);

    try {
      // Get all local data
      final exerciseRepo = _ref.read(exerciseRepositoryProvider);
      final workoutRepo = _ref.read(workoutRepositoryProvider);
      final prRepo = _ref.read(prRepositoryProvider);

      final exercises = await exerciseRepo.getAllExercises();
      final workouts = await workoutRepo.getAllWorkouts();
      final prs = await prRepo.getAllPRs();

      final result = await _syncService.pushAll(
        exercises: exercises.where((e) => !e.isPredefined).toList(),
        workouts: workouts,
        personalRecords: prs,
      );

      if (result.isSuccess) {
        final stats = result.data!;
        final now = DateTime.now();
        await _saveLastSyncTime(now);

        state = state.copyWith(
          status: SyncStatus.success,
          lastSyncAt: now,
          itemsPushed: stats.pushed,
          error: null,
        );
        return true;
      } else {
        state = state.copyWith(status: SyncStatus.error, error: result.error);
        return false;
      }
    } catch (e) {
      state = state.copyWith(status: SyncStatus.error, error: e.toString());
      return false;
    }
  }

  /// Force pull all remote data (full restore)
  Future<bool> forceRestore() async {
    if (!_syncService.isAvailable) {
      state = state.copyWith(
        status: SyncStatus.error,
        error: 'Cloud sync not available',
      );
      return false;
    }

    state = state.copyWith(status: SyncStatus.syncing, error: null);

    try {
      // Pull all data (no since filter = get everything)
      final pulled = await _pullRemoteChanges();

      final now = DateTime.now();
      await _saveLastSyncTime(now);

      state = state.copyWith(
        status: SyncStatus.success,
        lastSyncAt: now,
        itemsPulled: pulled,
        error: null,
      );

      return true;
    } catch (e) {
      state = state.copyWith(status: SyncStatus.error, error: e.toString());
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null, status: SyncStatus.idle);
  }
}

// Main sync provider using Supabase
final supabaseSyncProvider =
    StateNotifierProvider<SupabaseSyncNotifier, SyncState>((ref) {
      return SupabaseSyncNotifier(ref.watch(supabaseSyncServiceProvider), ref);
    });

// Convenience providers
final lastSyncAtProvider = Provider<DateTime?>((ref) {
  return ref.watch(supabaseSyncProvider).lastSyncAt;
});

final isSyncingProvider = Provider<bool>((ref) {
  return ref.watch(supabaseSyncProvider).isSyncing;
});

final syncStatusProvider = Provider<SyncStatus>((ref) {
  return ref.watch(supabaseSyncProvider).status;
});

final isSyncAvailableProvider = Provider<bool>((ref) {
  return SupabaseService.isAvailable && SupabaseService.isAuthenticated;
});
