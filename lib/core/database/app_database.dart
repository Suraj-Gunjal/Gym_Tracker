import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/auth/data/models/user_table.dart';
import '../../features/exercise/data/models/exercise_table.dart';
import '../../features/pr/data/models/personal_record_table.dart';
import '../../features/workout/data/models/exercise_set_table.dart';
import '../../features/workout/data/models/workout_exercise_table.dart';
import '../../features/workout/data/models/workout_table.dart';

part 'app_database.g.dart';

/// Main Drift database for the Gym Tracker app.
///
/// Contains all tables and provides database access.
@DriftDatabase(
  tables: [
    Exercises,
    Workouts,
    WorkoutExercises,
    ExerciseSets,
    PersonalRecords,
    Users,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  /// Open the database connection using drift_flutter's driftDatabase.
  ///
  /// For native platforms: Uses sqlite3 with file-based storage.
  /// For web: Uses IndexedDB through OPFS (Origin Private File System).
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'gym_tracker_db',
      // Let drift_flutter handle web automatically with OPFS + IndexedDB fallback
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations will be handled here
      },
      beforeOpen: (details) async {
        // Enable foreign keys
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}
