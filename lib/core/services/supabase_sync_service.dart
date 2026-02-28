import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../features/exercise/domain/entities/exercise.dart';
import '../../../features/workout/domain/entities/workout.dart';
import '../../../features/pr/domain/entities/personal_record.dart';
import 'supabase_service.dart';

/// Result wrapper for sync operations
class SyncResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const SyncResult._({this.data, this.error, required this.isSuccess});

  factory SyncResult.success(T data) =>
      SyncResult._(data: data, isSuccess: true);

  factory SyncResult.failure(String error) =>
      SyncResult._(error: error, isSuccess: false);
}

/// Sync statistics
class SyncStats {
  final int pushed;
  final int pulled;
  final int conflicts;
  final DateTime syncedAt;

  const SyncStats({
    required this.pushed,
    required this.pulled,
    required this.conflicts,
    required this.syncedAt,
  });
}

/// Service for syncing local data with Supabase cloud.
class SupabaseSyncService {
  static const String _exercisesTable = 'exercises';
  static const String _workoutsTable = 'workouts';
  static const String _workoutExercisesTable = 'workout_exercises';
  static const String _exerciseSetsTable = 'exercise_sets';
  static const String _personalRecordsTable = 'personal_records';
  static const String _syncMetadataTable = 'sync_metadata';

  SupabaseClient get _client => SupabaseService.client;
  String? get _userId => SupabaseService.currentUser?.id;

  /// Check if sync is available
  bool get isAvailable =>
      SupabaseService.isAvailable && SupabaseService.isAuthenticated;

  // ============================================
  // EXERCISES SYNC
  // ============================================

  /// Push local exercises to Supabase
  Future<SyncResult<int>> pushExercises(List<Exercise> exercises) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      int pushed = 0;

      for (final exercise in exercises) {
        final data = {
          'id': exercise.id,
          'user_id': _userId,
          'name': exercise.name,
          'muscle_group': exercise.muscleGroup.name,
          'description': exercise.description,
          'is_predefined': exercise.isPredefined,
          'updated_at': exercise.updatedAt.toIso8601String(),
          'deleted': exercise.deleted,
        };

        await _client.from(_exercisesTable).upsert(data, onConflict: 'id');
        pushed++;
      }

      debugPrint('✅ Pushed $pushed exercises to Supabase');
      return SyncResult.success(pushed);
    } catch (e) {
      debugPrint('❌ Error pushing exercises: $e');
      return SyncResult.failure(e.toString());
    }
  }

  /// Pull exercises from Supabase since last sync
  Future<SyncResult<List<Map<String, dynamic>>>> pullExercises(
    DateTime? since,
  ) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      var query = _client
          .from(_exercisesTable)
          .select()
          .eq('user_id', _userId!);

      if (since != null) {
        query = query.gt('updated_at', since.toIso8601String());
      }

      final data = await query;
      debugPrint('✅ Pulled ${data.length} exercises from Supabase');
      return SyncResult.success(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      debugPrint('❌ Error pulling exercises: $e');
      return SyncResult.failure(e.toString());
    }
  }

  // ============================================
  // WORKOUTS SYNC
  // ============================================

  /// Push local workouts to Supabase
  Future<SyncResult<int>> pushWorkouts(List<Workout> workouts) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      int pushed = 0;

      for (final workout in workouts) {
        // Push workout
        final workoutData = {
          'id': workout.id,
          'user_id': _userId,
          'name': workout.name,
          'started_at': workout.startedAt.toIso8601String(),
          'completed_at': workout.completedAt?.toIso8601String(),
          'notes': workout.notes,
          'updated_at': workout.updatedAt.toIso8601String(),
          'deleted': workout.deleted,
        };

        await _client
            .from(_workoutsTable)
            .upsert(workoutData, onConflict: 'id');

        // Push workout exercises
        for (final we in workout.exercises) {
          final weData = {
            'id': we.id,
            'user_id': _userId,
            'workout_id': workout.id,
            'exercise_id': we.exerciseId,
            'order_index': we.orderIndex,
            'notes': we.notes,
            'updated_at': we.updatedAt.toIso8601String(),
            'deleted': we.deleted,
          };

          await _client
              .from(_workoutExercisesTable)
              .upsert(weData, onConflict: 'id');

          // Push exercise sets
          for (final set in we.sets) {
            final setData = {
              'id': set.id,
              'user_id': _userId,
              'workout_exercise_id': we.id,
              'set_number': set.setNumber,
              'reps': set.reps,
              'weight': set.weight,
              'notes': set.notes,
              'completed': set.completed,
              'updated_at': set.updatedAt.toIso8601String(),
              'deleted': set.deleted,
            };

            await _client
                .from(_exerciseSetsTable)
                .upsert(setData, onConflict: 'id');
          }
        }

        pushed++;
      }

      debugPrint('✅ Pushed $pushed workouts to Supabase');
      return SyncResult.success(pushed);
    } catch (e) {
      debugPrint('❌ Error pushing workouts: $e');
      return SyncResult.failure(e.toString());
    }
  }

  /// Pull workouts from Supabase since last sync
  Future<SyncResult<List<Map<String, dynamic>>>> pullWorkouts(
    DateTime? since,
  ) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      var query = _client.from(_workoutsTable).select().eq('user_id', _userId!);

      if (since != null) {
        query = query.gt('updated_at', since.toIso8601String());
      }

      final data = await query;
      debugPrint('✅ Pulled ${data.length} workouts from Supabase');
      return SyncResult.success(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      debugPrint('❌ Error pulling workouts: $e');
      return SyncResult.failure(e.toString());
    }
  }

  /// Pull workout exercises from Supabase
  Future<SyncResult<List<Map<String, dynamic>>>> pullWorkoutExercises(
    DateTime? since,
  ) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      var query = _client
          .from(_workoutExercisesTable)
          .select()
          .eq('user_id', _userId!);

      if (since != null) {
        query = query.gt('updated_at', since.toIso8601String());
      }

      final data = await query;
      return SyncResult.success(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return SyncResult.failure(e.toString());
    }
  }

  /// Pull exercise sets from Supabase
  Future<SyncResult<List<Map<String, dynamic>>>> pullExerciseSets(
    DateTime? since,
  ) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      var query = _client
          .from(_exerciseSetsTable)
          .select()
          .eq('user_id', _userId!);

      if (since != null) {
        query = query.gt('updated_at', since.toIso8601String());
      }

      final data = await query;
      return SyncResult.success(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      return SyncResult.failure(e.toString());
    }
  }

  // ============================================
  // PERSONAL RECORDS SYNC
  // ============================================

  /// Push personal records to Supabase
  Future<SyncResult<int>> pushPersonalRecords(
    List<PersonalRecord> records,
  ) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      int pushed = 0;

      for (final pr in records) {
        final data = {
          'id': pr.id,
          'user_id': _userId,
          'exercise_id': pr.exerciseId,
          'pr_type': pr.prType.name,
          'value': pr.value,
          'at_weight': pr.atWeight,
          'workout_id': pr.workoutId,
          'set_id': pr.setId,
          'achieved_at': pr.achievedAt.toIso8601String(),
          'previous_value': pr.previousValue,
          'updated_at': pr.updatedAt.toIso8601String(),
          'deleted': pr.deleted,
        };

        await _client
            .from(_personalRecordsTable)
            .upsert(data, onConflict: 'id');
        pushed++;
      }

      debugPrint('✅ Pushed $pushed personal records to Supabase');
      return SyncResult.success(pushed);
    } catch (e) {
      debugPrint('❌ Error pushing personal records: $e');
      return SyncResult.failure(e.toString());
    }
  }

  /// Pull personal records from Supabase
  Future<SyncResult<List<Map<String, dynamic>>>> pullPersonalRecords(
    DateTime? since,
  ) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      var query = _client
          .from(_personalRecordsTable)
          .select()
          .eq('user_id', _userId!);

      if (since != null) {
        query = query.gt('updated_at', since.toIso8601String());
      }

      final data = await query;
      debugPrint('✅ Pulled ${data.length} personal records from Supabase');
      return SyncResult.success(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      debugPrint('❌ Error pulling personal records: $e');
      return SyncResult.failure(e.toString());
    }
  }

  // ============================================
  // SYNC METADATA
  // ============================================

  /// Get last sync timestamp for this device
  Future<DateTime?> getLastSyncTime(String deviceId) async {
    if (!isAvailable) return null;

    try {
      final data = await _client
          .from(_syncMetadataTable)
          .select('last_sync_at')
          .eq('user_id', _userId!)
          .eq('device_id', deviceId)
          .maybeSingle();

      if (data != null && data['last_sync_at'] != null) {
        return DateTime.parse(data['last_sync_at'] as String);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting last sync time: $e');
      return null;
    }
  }

  /// Update last sync timestamp
  Future<void> updateLastSyncTime(String deviceId) async {
    if (!isAvailable) return;

    try {
      await _client.from(_syncMetadataTable).upsert({
        'user_id': _userId,
        'device_id': deviceId,
        'last_sync_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id,device_id');
    } catch (e) {
      debugPrint('Error updating last sync time: $e');
    }
  }

  // ============================================
  // REAL-TIME SUBSCRIPTIONS
  // ============================================

  /// Subscribe to real-time changes for exercises
  RealtimeChannel subscribeToExercises(
    void Function(Map<String, dynamic> payload) onInsert,
    void Function(Map<String, dynamic> payload) onUpdate,
    void Function(Map<String, dynamic> payload) onDelete,
  ) {
    return _client
        .channel('exercises_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: _exercisesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId!,
          ),
          callback: (payload) => onInsert(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: _exercisesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId!,
          ),
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: _exercisesTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId!,
          ),
          callback: (payload) => onDelete(payload.oldRecord),
        )
        .subscribe();
  }

  /// Subscribe to real-time changes for workouts
  RealtimeChannel subscribeToWorkouts(
    void Function(Map<String, dynamic> payload) onInsert,
    void Function(Map<String, dynamic> payload) onUpdate,
    void Function(Map<String, dynamic> payload) onDelete,
  ) {
    return _client
        .channel('workouts_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: _workoutsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId!,
          ),
          callback: (payload) => onInsert(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: _workoutsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId!,
          ),
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: _workoutsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: _userId!,
          ),
          callback: (payload) => onDelete(payload.oldRecord),
        )
        .subscribe();
  }

  /// Unsubscribe from a channel
  Future<void> unsubscribe(RealtimeChannel channel) async {
    await _client.removeChannel(channel);
  }

  // ============================================
  // BATCH OPERATIONS
  // ============================================

  /// Push all local data to Supabase (initial sync)
  Future<SyncResult<SyncStats>> pushAll({
    required List<Exercise> exercises,
    required List<Workout> workouts,
    required List<PersonalRecord> personalRecords,
  }) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      int totalPushed = 0;

      // Push exercises
      final exerciseResult = await pushExercises(exercises);
      if (exerciseResult.isSuccess) {
        totalPushed += exerciseResult.data ?? 0;
      }

      // Push workouts (includes workout exercises and sets)
      final workoutResult = await pushWorkouts(workouts);
      if (workoutResult.isSuccess) {
        totalPushed += workoutResult.data ?? 0;
      }

      // Push personal records
      final prResult = await pushPersonalRecords(personalRecords);
      if (prResult.isSuccess) {
        totalPushed += prResult.data ?? 0;
      }

      final stats = SyncStats(
        pushed: totalPushed,
        pulled: 0,
        conflicts: 0,
        syncedAt: DateTime.now(),
      );

      debugPrint('✅ Full push complete: $totalPushed items');
      return SyncResult.success(stats);
    } catch (e) {
      debugPrint('❌ Error in full push: $e');
      return SyncResult.failure(e.toString());
    }
  }

  /// Pull all data from Supabase since last sync
  Future<SyncResult<Map<String, List<Map<String, dynamic>>>>> pullAll(
    DateTime? since,
  ) async {
    if (!isAvailable) {
      return SyncResult.failure('Supabase not available or not authenticated');
    }

    try {
      final results = <String, List<Map<String, dynamic>>>{};

      // Pull exercises
      final exerciseResult = await pullExercises(since);
      if (exerciseResult.isSuccess) {
        results['exercises'] = exerciseResult.data ?? [];
      }

      // Pull workouts
      final workoutResult = await pullWorkouts(since);
      if (workoutResult.isSuccess) {
        results['workouts'] = workoutResult.data ?? [];
      }

      // Pull workout exercises
      final weResult = await pullWorkoutExercises(since);
      if (weResult.isSuccess) {
        results['workout_exercises'] = weResult.data ?? [];
      }

      // Pull exercise sets
      final setsResult = await pullExerciseSets(since);
      if (setsResult.isSuccess) {
        results['exercise_sets'] = setsResult.data ?? [];
      }

      // Pull personal records
      final prResult = await pullPersonalRecords(since);
      if (prResult.isSuccess) {
        results['personal_records'] = prResult.data ?? [];
      }

      debugPrint('✅ Full pull complete');
      return SyncResult.success(results);
    } catch (e) {
      debugPrint('❌ Error in full pull: $e');
      return SyncResult.failure(e.toString());
    }
  }
}
