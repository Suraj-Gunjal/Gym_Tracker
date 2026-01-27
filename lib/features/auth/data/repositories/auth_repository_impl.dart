import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/user.dart' as domain;
import '../../domain/repositories/auth_repository.dart';
import '../models/user_mapper.dart';

/// Implementation of AuthRepository using Drift database.
/// Note: This handles local storage. Backend auth calls will be added
/// when the sync feature is implemented.
class AuthRepositoryImpl implements AuthRepository {
  final db.AppDatabase _db;
  static const _uuid = Uuid();

  // In-memory cache for current user
  domain.User? _currentUser;

  AuthRepositoryImpl(this._db);

  @override
  Future<domain.User?> getCurrentUser() async {
    // Return cached user if available
    if (_currentUser != null) return _currentUser;

    // Try to get from database
    final query = _db.select(_db.users)
      ..where((tbl) => tbl.deleted.equals(false))
      ..limit(1);

    final user = await query.getSingleOrNull();
    if (user != null) {
      _currentUser = UserMapper.toDomain(user);
    }
    return _currentUser;
  }

  @override
  Future<void> saveUser(domain.User user) async {
    await _db
        .into(_db.users)
        .insertOnConflictUpdate(UserMapper.toCompanion(user));
    _currentUser = user;
  }

  @override
  Future<void> updateUser(domain.User user) async {
    final updatedUser = user.copyWith(updatedAt: DateTime.now());
    await saveUser(updatedUser);
  }

  @override
  Future<domain.User> login({
    required String email,
    required String password,
  }) async {
    // TODO: Implement actual backend auth when sync feature is added
    // For now, create/retrieve local user

    final existing = await getCurrentUser();
    if (existing != null && existing.email == email) {
      return existing;
    }

    // Create local user (will be synced later)
    final now = DateTime.now();
    final user = domain.User(
      id: _uuid.v4(),
      email: email,
      displayName: email.split('@').first,
      createdAt: now,
      updatedAt: now,
    );

    await saveUser(user);
    return user;
  }

  @override
  Future<domain.User> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // TODO: Implement actual backend registration when sync feature is added
    // For now, create local user

    final now = DateTime.now();
    final user = domain.User(
      id: _uuid.v4(),
      email: email,
      displayName: displayName ?? email.split('@').first,
      createdAt: now,
      updatedAt: now,
    );

    await saveUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    // Clear cached user
    _currentUser = null;

    // Optionally clear tokens but keep user data for offline access
    if (_currentUser != null) {
      final updatedUser = _currentUser!.copyWith(
        accessToken: null,
        refreshToken: null,
        updatedAt: DateTime.now(),
      );
      await saveUser(updatedUser);
      _currentUser = null;
    }
  }

  @override
  Future<String?> refreshToken() async {
    // TODO: Implement token refresh when sync feature is added
    return _currentUser?.accessToken;
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<void> deleteAccount() async {
    final user = await getCurrentUser();
    if (user == null) return;

    // Soft delete user
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(user.id))).write(
      db.UsersCompanion(
        deleted: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );

    _currentUser = null;
  }

  @override
  Future<List<domain.User>> getUsersUpdatedAfter(DateTime timestamp) async {
    final query = _db.select(_db.users)
      ..where((tbl) => tbl.updatedAt.isBiggerThanValue(timestamp));

    final users = await query.get();
    return users.map(UserMapper.toDomain).toList();
  }
}
