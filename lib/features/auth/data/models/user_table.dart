import 'package:drift/drift.dart';

/// Drift table for users.
///
/// Stores authenticated user info locally.
class Users extends Table {
  /// UUID primary key
  TextColumn get id => text()();

  /// User's email
  TextColumn get email => text().unique()();

  /// Display name
  TextColumn get displayName => text().nullable()();

  /// JWT access token
  TextColumn get accessToken => text().nullable()();

  /// JWT refresh token
  TextColumn get refreshToken => text().nullable()();

  /// Account creation date
  DateTimeColumn get createdAt => dateTime()();

  /// Last modification timestamp
  DateTimeColumn get updatedAt => dateTime()();

  /// Soft delete flag
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
