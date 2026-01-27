import '../../domain/entities/user.dart';

/// Abstract repository for User/Auth operations.
abstract class AuthRepository {
  /// Get the current logged-in user
  Future<User?> getCurrentUser();

  /// Save user data locally
  Future<void> saveUser(User user);

  /// Update user profile
  Future<void> updateUser(User user);

  /// Login with email/password
  Future<User> login({required String email, required String password});

  /// Register new user
  Future<User> register({
    required String email,
    required String password,
    String? displayName,
  });

  /// Logout (clear local auth data)
  Future<void> logout();

  /// Refresh access token
  Future<String?> refreshToken();

  /// Check if user has valid auth
  Future<bool> isAuthenticated();

  /// Delete user account
  Future<void> deleteAccount();

  /// Get users updated after timestamp (for sync)
  Future<List<User>> getUsersUpdatedAfter(DateTime timestamp);
}
