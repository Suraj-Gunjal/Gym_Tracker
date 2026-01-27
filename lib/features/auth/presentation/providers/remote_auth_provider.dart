import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/api_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/remote_auth_repository.dart';

// Service providers
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(storage: ref.watch(secureStorageProvider));
});

final remoteAuthRepositoryProvider = Provider<RemoteAuthRepository>((ref) {
  return RemoteAuthRepository(
    apiClient: ref.watch(apiClientProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Auth state
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class RemoteAuthState {
  final AuthStatus status;
  final AuthUser? user;
  final String? error;
  final bool isOnline;

  const RemoteAuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isOnline = false,
  });

  RemoteAuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? error,
    bool? isOnline,
  }) {
    return RemoteAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

class RemoteAuthNotifier extends StateNotifier<RemoteAuthState> {
  final RemoteAuthRepository _repository;
  final SecureStorageService _storage;

  RemoteAuthNotifier(this._repository, this._storage)
    : super(const RemoteAuthState()) {
    _init();
  }

  Future<void> _init() async {
    // Check if user has stored credentials
    final isLoggedIn = await _storage.isLoggedIn();
    if (isLoggedIn) {
      // Try to get user profile to validate token
      await refreshUser();
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }

    // Check server health
    final isOnline = await _repository.checkServerHealth();
    state = state.copyWith(isOnline: isOnline);
  }

  Future<bool> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    final result = await _repository.register(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (result.isSuccess && result.data != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.data!.user,
        isOnline: true,
      );
      return true;
    }

    state = state.copyWith(status: AuthStatus.error, error: result.error);
    return false;
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, error: null);

    final result = await _repository.login(email: email, password: password);

    if (result.isSuccess && result.data != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.data!.user,
        isOnline: true,
      );
      return true;
    }

    state = state.copyWith(status: AuthStatus.error, error: result.error);
    return false;
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    await _repository.logout();

    state = const RemoteAuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> refreshUser() async {
    final result = await _repository.getCurrentUser();

    if (result.isSuccess && result.data != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.data,
        isOnline: true,
      );
    } else {
      // Token might be expired, try to refresh
      final refreshResult = await _repository.refreshToken();
      if (refreshResult.isSuccess) {
        // Retry getting user
        final retryResult = await _repository.getCurrentUser();
        if (retryResult.isSuccess && retryResult.data != null) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: retryResult.data,
            isOnline: true,
          );
          return;
        }
      }

      // All attempts failed
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        isOnline: false,
      );
    }
  }

  Future<bool> updateProfile({String? displayName, String? avatarUrl}) async {
    final result = await _repository.updateProfile(
      displayName: displayName,
      avatarUrl: avatarUrl,
    );

    if (result.isSuccess && result.data != null) {
      state = state.copyWith(user: result.data);
      return true;
    }

    state = state.copyWith(error: result.error);
    return false;
  }

  Future<bool> deleteAccount() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _repository.deleteAccount();

    if (result.isSuccess) {
      state = const RemoteAuthState(status: AuthStatus.unauthenticated);
      return true;
    }

    state = state.copyWith(status: AuthStatus.error, error: result.error);
    return false;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> checkConnectivity() async {
    final isOnline = await _repository.checkServerHealth();
    state = state.copyWith(isOnline: isOnline);
  }
}

final remoteAuthProvider =
    StateNotifierProvider<RemoteAuthNotifier, RemoteAuthState>((ref) {
      return RemoteAuthNotifier(
        ref.watch(remoteAuthRepositoryProvider),
        ref.watch(secureStorageProvider),
      );
    });

// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(remoteAuthProvider).isAuthenticated;
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref.watch(remoteAuthProvider).isOnline;
});

final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(remoteAuthProvider).user;
});
