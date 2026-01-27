import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';

/// Global provider for the AppDatabase instance.
///
/// This is the single source of truth for database access.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
