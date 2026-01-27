import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/user.dart' as domain;

/// Mapper to convert between User domain entity and Drift data class.
class UserMapper {
  /// Convert Drift data class to domain entity
  static domain.User toDomain(db.User data) {
    return domain.User(
      id: data.id,
      email: data.email,
      displayName: data.displayName,
      accessToken: data.accessToken,
      refreshToken: data.refreshToken,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  /// Convert domain entity to Drift companion for insert/update
  static db.UsersCompanion toCompanion(domain.User entity) {
    return db.UsersCompanion.insert(
      id: entity.id,
      email: entity.email,
      displayName: Value(entity.displayName),
      accessToken: Value(entity.accessToken),
      refreshToken: Value(entity.refreshToken),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
