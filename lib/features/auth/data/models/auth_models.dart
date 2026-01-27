/// Request model for user registration
class RegisterRequest {
  final String email;
  final String password;
  final String? displayName;

  const RegisterRequest({
    required this.email,
    required this.password,
    this.displayName,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    if (displayName != null) 'displayName': displayName,
  };
}

/// Request model for user login
class LoginRequest {
  final String email;
  final String password;
  final String? deviceName;
  final String? deviceId;

  const LoginRequest({
    required this.email,
    required this.password,
    this.deviceName,
    this.deviceId,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    if (deviceName != null) 'deviceName': deviceName,
    if (deviceId != null) 'deviceId': deviceId,
  };
}

/// Response model for authentication
class AuthResponse {
  final AuthUser user;
  final String accessToken;
  final String refreshToken;
  final String? deviceId;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    this.deviceId,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      deviceId: json['deviceId'] as String?,
    );
  }
}

/// User model from authentication response
class AuthUser {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final DateTime? lastSyncAt;
  final DateTime? createdAt;

  const AuthUser({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.lastSyncAt,
    this.createdAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      lastSyncAt: json['lastSyncAt'] != null
          ? DateTime.parse(json['lastSyncAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    if (displayName != null) 'displayName': displayName,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
    if (lastSyncAt != null) 'lastSyncAt': lastSyncAt!.toIso8601String(),
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
  };
}

/// Token refresh response
class TokenRefreshResponse {
  final String accessToken;
  final String refreshToken;

  const TokenRefreshResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    return TokenRefreshResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
