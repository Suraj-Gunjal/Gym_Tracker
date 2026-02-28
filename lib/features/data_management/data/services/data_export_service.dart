import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/export_entity.dart';

/// Service for exporting and importing data.
class DataExportService {
  static const _uuid = Uuid();

  /// Export data to JSON format.
  static Future<ExportJob> exportToJson({
    required Set<DataCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final jobId = _uuid.v4();
    final options = ExportOptions(
      format: ExportFormat.json,
      categories: categories,
      startDate: startDate,
      endDate: endDate,
    );

    var job = ExportJob(
      id: jobId,
      options: options,
      status: ExportStatus.processing,
      createdAt: DateTime.now(),
    );

    try {
      // Gather data
      final data = await _gatherExportData(categories, startDate, endDate);

      // Create metadata
      final metadata = BackupMetadata(
        version: '1.0',
        createdAt: DateTime.now(),
        appVersion: '1.0.0',
        deviceInfo: _getDeviceInfo(),
        dataCounts: _countData(data),
      );

      // Build export structure
      final exportData = {'metadata': metadata.toJson(), 'data': data};

      // Write to file
      final filePath = await _writeToFile(
        jsonEncode(exportData),
        'gym_tracker_backup_${DateTime.now().millisecondsSinceEpoch}.json',
      );

      job = job.copyWith(
        status: ExportStatus.completed,
        progress: 1.0,
        filePath: filePath,
        completedAt: DateTime.now(),
      );
    } catch (e) {
      job = job.copyWith(status: ExportStatus.failed, error: e.toString());
    }

    return job;
  }

  /// Export data to CSV format.
  static Future<ExportJob> exportToCsv({
    required DataCategory category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final jobId = _uuid.v4();
    final options = ExportOptions(
      format: ExportFormat.csv,
      categories: {category},
      startDate: startDate,
      endDate: endDate,
    );

    var job = ExportJob(
      id: jobId,
      options: options,
      status: ExportStatus.processing,
      createdAt: DateTime.now(),
    );

    try {
      // Get data and convert to CSV
      final csvContent = await _generateCsv(category, startDate, endDate);

      // Write to file
      final filePath = await _writeToFile(
        csvContent,
        '${category.name}_export_${DateTime.now().millisecondsSinceEpoch}.csv',
      );

      job = job.copyWith(
        status: ExportStatus.completed,
        progress: 1.0,
        filePath: filePath,
        completedAt: DateTime.now(),
      );
    } catch (e) {
      job = job.copyWith(status: ExportStatus.failed, error: e.toString());
    }

    return job;
  }

  /// Import data from JSON backup.
  static Future<ImportResult> importFromJson(String filePath) async {
    try {
      final file = File(filePath);
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;

      // Validate metadata
      if (!data.containsKey('metadata')) {
        return const ImportResult(
          success: false,
          errors: ['Invalid backup file: missing metadata'],
        );
      }

      final metadata = BackupMetadata.fromJson(
        data['metadata'] as Map<String, dynamic>,
      );

      // Check version compatibility
      if (!_isVersionCompatible(metadata.version)) {
        return ImportResult(
          success: false,
          errors: ['Incompatible backup version: ${metadata.version}'],
        );
      }

      final importData = data['data'] as Map<String, dynamic>;
      final warnings = <String>[];

      // Import each category
      int workoutsImported = 0;
      int exercisesImported = 0;
      int prsImported = 0;
      int measurementsImported = 0;
      int achievementsImported = 0;
      int templatesImported = 0;

      // Note: Data import requires database injection - currently parses and validates only
      // Full import functionality available when file picker is implemented

      if (importData.containsKey('workouts')) {
        final workouts = importData['workouts'] as List;
        workoutsImported = workouts.length;
        // Workouts parsed successfully - import pending database injection
      }

      if (importData.containsKey('exercises')) {
        final exercises = importData['exercises'] as List;
        exercisesImported = exercises.length;
        // Exercises parsed successfully - import pending database injection
      }

      if (importData.containsKey('personalRecords')) {
        final prs = importData['personalRecords'] as List;
        prsImported = prs.length;
        // PRs parsed successfully - import pending database injection
      }

      if (importData.containsKey('measurements')) {
        final measurements = importData['measurements'] as List;
        measurementsImported = measurements.length;
        // Measurements parsed successfully - import pending database injection
      }

      if (importData.containsKey('achievements')) {
        final achievements = importData['achievements'] as List;
        achievementsImported = achievements.length;
        // Achievements parsed successfully - import pending database injection
      }

      if (importData.containsKey('templates')) {
        final templates = importData['templates'] as List;
        templatesImported = templates.length;
        // Templates parsed successfully - import pending database injection
      }

      return ImportResult(
        success: true,
        workoutsImported: workoutsImported,
        exercisesImported: exercisesImported,
        prsImported: prsImported,
        measurementsImported: measurementsImported,
        achievementsImported: achievementsImported,
        templatesImported: templatesImported,
        warnings: warnings,
      );
    } catch (e) {
      return ImportResult(success: false, errors: ['Failed to import: $e']);
    }
  }

  /// Share exported file.
  static Future<void> shareExport(String filePath) async {
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'Gym Tracker Backup',
      text: 'My Gym Tracker workout data backup',
    );
  }

  // Private helpers

  static Future<Map<String, dynamic>> _gatherExportData(
    Set<DataCategory> categories,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final data = <String, dynamic>{};

    // Mock data - In production, fetch from database
    if (categories.contains(DataCategory.workouts)) {
      data['workouts'] = _getMockWorkouts();
    }
    if (categories.contains(DataCategory.exercises)) {
      data['exercises'] = _getMockExercises();
    }
    if (categories.contains(DataCategory.personalRecords)) {
      data['personalRecords'] = _getMockPRs();
    }
    if (categories.contains(DataCategory.measurements)) {
      data['measurements'] = _getMockMeasurements();
    }
    if (categories.contains(DataCategory.achievements)) {
      data['achievements'] = _getMockAchievements();
    }
    if (categories.contains(DataCategory.templates)) {
      data['templates'] = _getMockTemplates();
    }

    return data;
  }

  static Future<String> _generateCsv(
    DataCategory category,
    DateTime? startDate,
    DateTime? endDate,
  ) async {
    final buffer = StringBuffer();

    switch (category) {
      case DataCategory.workouts:
        buffer.writeln('Date,Name,Duration (min),Exercises,Sets,Volume (kg)');
        final workouts = _getMockWorkouts();
        for (final w in workouts) {
          buffer.writeln(
            '${w['date']},${w['name']},${w['duration']},${w['exerciseCount']},${w['setCount']},${w['totalVolume']}',
          );
        }
        break;
      case DataCategory.personalRecords:
        buffer.writeln('Date,Exercise,Weight (kg),Reps');
        final prs = _getMockPRs();
        for (final pr in prs) {
          buffer.writeln(
            '${pr['date']},${pr['exercise']},${pr['weight']},${pr['reps']}',
          );
        }
        break;
      case DataCategory.measurements:
        buffer.writeln('Date,Weight (kg),Body Fat %,Chest,Waist,Arms');
        final measurements = _getMockMeasurements();
        for (final m in measurements) {
          buffer.writeln(
            '${m['date']},${m['weight']},${m['bodyFat']},${m['chest']},${m['waist']},${m['arms']}',
          );
        }
        break;
      default:
        buffer.writeln('Export not supported for this category');
    }

    return buffer.toString();
  }

  static Future<String> _writeToFile(String content, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);
    return file.path;
  }

  static String _getDeviceInfo() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  static Map<DataCategory, int> _countData(Map<String, dynamic> data) {
    final counts = <DataCategory, int>{};
    for (final category in DataCategory.values) {
      final key = category.name;
      if (data.containsKey(key) && data[key] is List) {
        counts[category] = (data[key] as List).length;
      }
    }
    return counts;
  }

  static bool _isVersionCompatible(String version) {
    return version == '1.0';
  }

  // Mock data generators
  static List<Map<String, dynamic>> _getMockWorkouts() {
    return List.generate(
      10,
      (i) => {
        'id': 'workout_$i',
        'date': DateTime.now().subtract(Duration(days: i)).toIso8601String(),
        'name': ['Push Day', 'Pull Day', 'Leg Day', 'Upper Body'][i % 4],
        'duration': 45 + i * 5,
        'exerciseCount': 4 + i % 3,
        'setCount': 12 + i % 6,
        'totalVolume': 5000.0 + i * 500,
      },
    );
  }

  static List<Map<String, dynamic>> _getMockExercises() {
    return [
      {'id': 'ex_1', 'name': 'Bench Press', 'category': 'Chest'},
      {'id': 'ex_2', 'name': 'Squat', 'category': 'Legs'},
      {'id': 'ex_3', 'name': 'Deadlift', 'category': 'Back'},
      {'id': 'ex_4', 'name': 'Overhead Press', 'category': 'Shoulders'},
    ];
  }

  static List<Map<String, dynamic>> _getMockPRs() {
    return List.generate(
      5,
      (i) => {
        'id': 'pr_$i',
        'date': DateTime.now()
            .subtract(Duration(days: i * 7))
            .toIso8601String(),
        'exercise': ['Bench Press', 'Squat', 'Deadlift'][i % 3],
        'weight': 100.0 + i * 10,
        'reps': 1,
      },
    );
  }

  static List<Map<String, dynamic>> _getMockMeasurements() {
    return List.generate(
      8,
      (i) => {
        'id': 'measure_$i',
        'date': DateTime.now()
            .subtract(Duration(days: i * 7))
            .toIso8601String(),
        'weight': 75.0 - i * 0.3,
        'bodyFat': 18.0 - i * 0.2,
        'chest': 100.0 + i * 0.5,
        'waist': 82.0 - i * 0.3,
        'arms': 38.0 + i * 0.2,
      },
    );
  }

  static List<Map<String, dynamic>> _getMockAchievements() {
    return [
      {
        'id': 'ach_1',
        'name': 'First Workout',
        'unlockedAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'ach_2',
        'name': '10 Workouts',
        'unlockedAt': DateTime.now().toIso8601String(),
      },
    ];
  }

  static List<Map<String, dynamic>> _getMockTemplates() {
    return [
      {'id': 'tmpl_1', 'name': 'Push Day Template', 'exerciseCount': 5},
      {'id': 'tmpl_2', 'name': 'Pull Day Template', 'exerciseCount': 5},
    ];
  }
}
