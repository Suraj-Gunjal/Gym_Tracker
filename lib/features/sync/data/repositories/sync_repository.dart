import '../../../../core/config/api_config.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../models/sync_models.dart';

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

/// Repository for sync operations with the backend
class SyncRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storage;

  SyncRepository({ApiClient? apiClient, SecureStorageService? storage})
    : _apiClient = apiClient ?? ApiClient(),
      _storage = storage ?? SecureStorageService();

  /// Push local changes to the server
  Future<SyncResult<SyncPushResponse>> pushChanges({
    required List<SyncExercise> exercises,
    required List<SyncWorkout> workouts,
    required List<SyncPersonalRecord> personalRecords,
  }) async {
    final deviceId = await _storage.getDeviceId();
    if (deviceId == null) {
      return SyncResult.failure('Device ID not found');
    }

    final lastSyncAt = await _storage.getLastSyncAt();

    final request = SyncPushRequest(
      deviceId: deviceId,
      lastSyncAt: lastSyncAt,
      exercises: exercises,
      workouts: workouts,
      personalRecords: personalRecords,
    );

    final response = await _apiClient.post(
      ApiConfig.syncPush,
      body: request.toJson(),
    );

    if (response.isSuccess && response.dataAsMap != null) {
      final pushResponse = SyncPushResponse.fromJson(response.dataAsMap!);
      await _storage.setLastSyncAt(pushResponse.syncedAt);
      return SyncResult.success(pushResponse);
    }

    return SyncResult.failure(response.error ?? 'Push sync failed');
  }

  /// Pull server changes to local
  Future<SyncResult<SyncPullResponse>> pullChanges() async {
    final deviceId = await _storage.getDeviceId();
    if (deviceId == null) {
      return SyncResult.failure('Device ID not found');
    }

    final lastSyncAt = await _storage.getLastSyncAt();

    final request = SyncPullRequest(deviceId: deviceId, lastSyncAt: lastSyncAt);

    final response = await _apiClient.post(
      ApiConfig.syncPull,
      body: request.toJson(),
    );

    if (response.isSuccess && response.dataAsMap != null) {
      final pullResponse = SyncPullResponse.fromJson(response.dataAsMap!);
      await _storage.setLastSyncAt(pullResponse.syncedAt);
      return SyncResult.success(pullResponse);
    }

    return SyncResult.failure(response.error ?? 'Pull sync failed');
  }

  /// Get sync status
  Future<SyncResult<Map<String, dynamic>>> getSyncStatus() async {
    final response = await _apiClient.get(ApiConfig.syncStatus);

    if (response.isSuccess && response.dataAsMap != null) {
      return SyncResult.success(response.dataAsMap!);
    }

    return SyncResult.failure(response.error ?? 'Failed to get sync status');
  }

  /// Get last sync time
  Future<DateTime?> getLastSyncAt() async {
    return _storage.getLastSyncAt();
  }
}
