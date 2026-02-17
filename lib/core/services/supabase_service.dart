import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Supabase service for cloud sync and authentication.
class SupabaseService {
  static SupabaseClient? _client;

  /// Initialize Supabase client.
  static Future<void> initialize() async {
    if (!SupabaseConfig.isConfigured) {
      debugPrint('⚠️ Supabase not configured. Running in offline mode.');
      return;
    }

    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
    );

    _client = Supabase.instance.client;
    debugPrint('✅ Supabase initialized successfully');
  }

  /// Get the Supabase client.
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call initialize() first.');
    }
    return _client!;
  }

  /// Check if Supabase is available.
  static bool get isAvailable => _client != null && SupabaseConfig.isConfigured;

  /// Get current user.
  static User? get currentUser => _client?.auth.currentUser;

  /// Check if user is authenticated.
  static bool get isAuthenticated => currentUser != null;

  /// Sign up with email and password.
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: displayName != null ? {'display_name': displayName} : null,
    );

    // Create user profile
    if (response.user != null) {
      await client.from(SupabaseConfig.usersTable).insert({
        'id': response.user!.id,
        'email': email,
        'display_name': displayName,
      });
    }

    return response;
  }

  /// Sign in with email and password.
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  /// Sign in with Google.
  static Future<bool> signInWithGoogle() async {
    final response = await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : 'io.supabase.gymtracker://login-callback/',
    );
    return response;
  }

  /// Sign in with Apple.
  static Future<bool> signInWithApple() async {
    final response = await client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: kIsWeb ? null : 'io.supabase.gymtracker://login-callback/',
    );
    return response;
  }

  /// Sign out.
  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Reset password.
  static Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  /// Update user profile.
  static Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    final userId = currentUser?.id;
    if (userId == null) return;

    final updates = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };
    if (displayName != null) updates['display_name'] = displayName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

    await client
        .from(SupabaseConfig.usersTable)
        .update(updates)
        .eq('id', userId);
  }

  /// Upload avatar image.
  static Future<String> uploadAvatar(Uint8List bytes, String fileName) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final path = '$userId/$fileName';
    await client.storage
        .from(SupabaseConfig.avatarsBucket)
        .uploadBinary(path, bytes);

    return client.storage.from(SupabaseConfig.avatarsBucket).getPublicUrl(path);
  }

  /// Listen to auth state changes.
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}

/// Sync service for offline-first data synchronization.
class SyncService {
  final SupabaseClient _client;

  SyncService(this._client);

  /// Sync workouts to cloud.
  Future<void> syncWorkouts(List<Map<String, dynamic>> workouts) async {
    if (!SupabaseService.isAuthenticated) return;

    for (final workout in workouts) {
      await _client
          .from(SupabaseConfig.workoutsTable)
          .upsert(workout, onConflict: 'id');
    }
  }

  /// Fetch workouts from cloud.
  Future<List<Map<String, dynamic>>> fetchWorkouts({
    DateTime? since,
    int limit = 100,
  }) async {
    if (!SupabaseService.isAuthenticated) return [];

    PostgrestFilterBuilder query = _client
        .from(SupabaseConfig.workoutsTable)
        .select()
        .eq('user_id', SupabaseService.currentUser!.id);

    if (since != null) {
      query = query.gte('updated_at', since.toIso8601String());
    }

    final response = await query
        .order('started_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Sync personal records.
  Future<void> syncPersonalRecords(List<Map<String, dynamic>> prs) async {
    if (!SupabaseService.isAuthenticated) return;

    for (final pr in prs) {
      await _client
          .from(SupabaseConfig.personalRecordsTable)
          .upsert(pr, onConflict: 'id');
    }
  }

  /// Fetch personal records from cloud.
  Future<List<Map<String, dynamic>>> fetchPersonalRecords() async {
    if (!SupabaseService.isAuthenticated) return [];

    final response = await _client
        .from(SupabaseConfig.personalRecordsTable)
        .select()
        .eq('user_id', SupabaseService.currentUser!.id)
        .order('achieved_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Subscribe to realtime workout changes.
  RealtimeChannel subscribeToWorkouts(
    void Function(Map<String, dynamic>) onInsert,
    void Function(Map<String, dynamic>) onUpdate,
    void Function(Map<String, dynamic>) onDelete,
  ) {
    return _client
        .channel(SupabaseConfig.workoutsChannel)
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: SupabaseConfig.workoutsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: SupabaseService.currentUser?.id,
          ),
          callback: (payload) => onInsert(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: SupabaseConfig.workoutsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: SupabaseService.currentUser?.id,
          ),
          callback: (payload) => onUpdate(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: SupabaseConfig.workoutsTable,
          callback: (payload) => onDelete(payload.oldRecord),
        )
        .subscribe();
  }

  /// Subscribe to realtime PR changes.
  RealtimeChannel subscribeToPRs(void Function(Map<String, dynamic>) onNewPR) {
    return _client
        .channel(SupabaseConfig.prsChannel)
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: SupabaseConfig.personalRecordsTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: SupabaseService.currentUser?.id,
          ),
          callback: (payload) => onNewPR(payload.newRecord),
        )
        .subscribe();
  }
}
