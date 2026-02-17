import 'package:flutter/material.dart';

/// Export format options.
enum ExportFormat {
  json,
  csv,
  pdf;

  String get label {
    switch (this) {
      case ExportFormat.json:
        return 'JSON';
      case ExportFormat.csv:
        return 'CSV';
      case ExportFormat.pdf:
        return 'PDF Report';
    }
  }

  String get description {
    switch (this) {
      case ExportFormat.json:
        return 'Full backup with all data. Best for importing back.';
      case ExportFormat.csv:
        return 'Spreadsheet format. Easy to analyze in Excel.';
      case ExportFormat.pdf:
        return 'Beautiful formatted report with charts.';
    }
  }

  IconData get icon {
    switch (this) {
      case ExportFormat.json:
        return Icons.code;
      case ExportFormat.csv:
        return Icons.table_chart;
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
    }
  }

  String get extension {
    switch (this) {
      case ExportFormat.json:
        return 'json';
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.pdf:
        return 'pdf';
    }
  }
}

/// Data categories for export/import.
enum DataCategory {
  workouts,
  exercises,
  personalRecords,
  measurements,
  achievements,
  templates,
  settings;

  String get label {
    switch (this) {
      case DataCategory.workouts:
        return 'Workouts';
      case DataCategory.exercises:
        return 'Exercises';
      case DataCategory.personalRecords:
        return 'Personal Records';
      case DataCategory.measurements:
        return 'Body Measurements';
      case DataCategory.achievements:
        return 'Achievements';
      case DataCategory.templates:
        return 'Templates';
      case DataCategory.settings:
        return 'Settings';
    }
  }

  IconData get icon {
    switch (this) {
      case DataCategory.workouts:
        return Icons.fitness_center;
      case DataCategory.exercises:
        return Icons.sports_gymnastics;
      case DataCategory.personalRecords:
        return Icons.emoji_events;
      case DataCategory.measurements:
        return Icons.straighten;
      case DataCategory.achievements:
        return Icons.military_tech;
      case DataCategory.templates:
        return Icons.copy_all;
      case DataCategory.settings:
        return Icons.settings;
    }
  }
}

/// Export options configuration.
class ExportOptions {
  final ExportFormat format;
  final Set<DataCategory> categories;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool includeMedia;

  const ExportOptions({
    required this.format,
    required this.categories,
    this.startDate,
    this.endDate,
    this.includeMedia = false,
  });

  ExportOptions copyWith({
    ExportFormat? format,
    Set<DataCategory>? categories,
    DateTime? startDate,
    DateTime? endDate,
    bool? includeMedia,
  }) {
    return ExportOptions(
      format: format ?? this.format,
      categories: categories ?? this.categories,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      includeMedia: includeMedia ?? this.includeMedia,
    );
  }
}

/// Import result.
class ImportResult {
  final bool success;
  final int workoutsImported;
  final int exercisesImported;
  final int prsImported;
  final int measurementsImported;
  final int achievementsImported;
  final int templatesImported;
  final List<String> errors;
  final List<String> warnings;

  const ImportResult({
    required this.success,
    this.workoutsImported = 0,
    this.exercisesImported = 0,
    this.prsImported = 0,
    this.measurementsImported = 0,
    this.achievementsImported = 0,
    this.templatesImported = 0,
    this.errors = const [],
    this.warnings = const [],
  });

  int get totalImported =>
      workoutsImported +
      exercisesImported +
      prsImported +
      measurementsImported +
      achievementsImported +
      templatesImported;
}

/// Export job status.
class ExportJob {
  final String id;
  final ExportOptions options;
  final ExportStatus status;
  final double progress;
  final String? filePath;
  final String? error;
  final DateTime createdAt;
  final DateTime? completedAt;

  const ExportJob({
    required this.id,
    required this.options,
    required this.status,
    this.progress = 0.0,
    this.filePath,
    this.error,
    required this.createdAt,
    this.completedAt,
  });

  ExportJob copyWith({
    ExportStatus? status,
    double? progress,
    String? filePath,
    String? error,
    DateTime? completedAt,
  }) {
    return ExportJob(
      id: id,
      options: options,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      filePath: filePath ?? this.filePath,
      error: error ?? this.error,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Export job status.
enum ExportStatus {
  pending,
  processing,
  completed,
  failed;

  String get label {
    switch (this) {
      case ExportStatus.pending:
        return 'Pending';
      case ExportStatus.processing:
        return 'Processing';
      case ExportStatus.completed:
        return 'Completed';
      case ExportStatus.failed:
        return 'Failed';
    }
  }
}

/// Backup metadata.
class BackupMetadata {
  final String version;
  final DateTime createdAt;
  final String appVersion;
  final String deviceInfo;
  final Map<DataCategory, int> dataCounts;

  const BackupMetadata({
    required this.version,
    required this.createdAt,
    required this.appVersion,
    required this.deviceInfo,
    required this.dataCounts,
  });

  factory BackupMetadata.fromJson(Map<String, dynamic> json) {
    return BackupMetadata(
      version: json['version'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      appVersion: json['appVersion'] as String,
      deviceInfo: json['deviceInfo'] as String,
      dataCounts: (json['dataCounts'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          DataCategory.values.firstWhere((e) => e.name == key),
          value as int,
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'createdAt': createdAt.toIso8601String(),
      'appVersion': appVersion,
      'deviceInfo': deviceInfo,
      'dataCounts': dataCounts.map((k, v) => MapEntry(k.name, v)),
    };
  }
}
