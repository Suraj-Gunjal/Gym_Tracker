/// Domain entity representing an authenticated user.
///
/// Used for cloud sync authentication.
class User {
  /// Unique identifier (UUID format)
  final String id;

  /// User's email address
  final String email;

  /// User's display name
  final String? displayName;

  /// JWT access token for API calls
  final String? accessToken;

  /// JWT refresh token for getting new access tokens
  final String? refreshToken;

  /// When the user account was created
  final DateTime createdAt;

  /// Timestamp of last modification (for sync)
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.accessToken,
    this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Whether the user is currently authenticated
  bool get isAuthenticated => accessToken != null;

  /// Creates a copy with optional field overrides
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? accessToken,
    String? refreshToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email)';
}
