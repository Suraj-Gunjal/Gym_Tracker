import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/data_export_service.dart';
import '../../domain/entities/export_entity.dart';

part 'export_provider.g.dart';

/// State for export screen.
class ExportState {
  final ExportFormat selectedFormat;
  final Set<DataCategory> selectedCategories;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isExporting;
  final double progress;
  final ExportJob? lastJob;
  final String? error;

  const ExportState({
    this.selectedFormat = ExportFormat.json,
    this.selectedCategories = const {},
    this.startDate,
    this.endDate,
    this.isExporting = false,
    this.progress = 0.0,
    this.lastJob,
    this.error,
  });

  ExportState copyWith({
    ExportFormat? selectedFormat,
    Set<DataCategory>? selectedCategories,
    DateTime? startDate,
    DateTime? endDate,
    bool? isExporting,
    double? progress,
    ExportJob? lastJob,
    String? error,
  }) {
    return ExportState(
      selectedFormat: selectedFormat ?? this.selectedFormat,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isExporting: isExporting ?? this.isExporting,
      progress: progress ?? this.progress,
      lastJob: lastJob ?? this.lastJob,
      error: error,
    );
  }
}

/// State for import screen.
class ImportState {
  final String? selectedFilePath;
  final bool isImporting;
  final double progress;
  final ImportResult? result;
  final String? error;

  const ImportState({
    this.selectedFilePath,
    this.isImporting = false,
    this.progress = 0.0,
    this.result,
    this.error,
  });

  ImportState copyWith({
    String? selectedFilePath,
    bool? isImporting,
    double? progress,
    ImportResult? result,
    String? error,
  }) {
    return ImportState(
      selectedFilePath: selectedFilePath ?? this.selectedFilePath,
      isImporting: isImporting ?? this.isImporting,
      progress: progress ?? this.progress,
      result: result ?? this.result,
      error: error,
    );
  }
}

/// Provider for export state.
@riverpod
class ExportNotifier extends _$ExportNotifier {
  @override
  ExportState build() {
    return ExportState(selectedCategories: DataCategory.values.toSet());
  }

  void setFormat(ExportFormat format) {
    state = state.copyWith(selectedFormat: format);
  }

  void toggleCategory(DataCategory category) {
    final categories = Set<DataCategory>.from(state.selectedCategories);
    if (categories.contains(category)) {
      categories.remove(category);
    } else {
      categories.add(category);
    }
    state = state.copyWith(selectedCategories: categories);
  }

  void selectAllCategories() {
    state = state.copyWith(selectedCategories: DataCategory.values.toSet());
  }

  void deselectAllCategories() {
    state = state.copyWith(selectedCategories: {});
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  Future<void> startExport() async {
    if (state.selectedCategories.isEmpty) {
      state = state.copyWith(error: 'Please select at least one category');
      return;
    }

    state = state.copyWith(isExporting: true, progress: 0.0, error: null);

    try {
      ExportJob job;

      if (state.selectedFormat == ExportFormat.json) {
        job = await DataExportService.exportToJson(
          categories: state.selectedCategories,
          startDate: state.startDate,
          endDate: state.endDate,
        );
      } else if (state.selectedFormat == ExportFormat.csv) {
        // For CSV, export first selected category
        job = await DataExportService.exportToCsv(
          category: state.selectedCategories.first,
          startDate: state.startDate,
          endDate: state.endDate,
        );
      } else {
        throw UnimplementedError('PDF export not yet implemented');
      }

      state = state.copyWith(isExporting: false, progress: 1.0, lastJob: job);
    } catch (e) {
      state = state.copyWith(isExporting: false, error: e.toString());
    }
  }

  Future<void> shareLastExport() async {
    if (state.lastJob?.filePath != null) {
      await DataExportService.shareExport(state.lastJob!.filePath!);
    }
  }
}

/// Provider for import state.
@riverpod
class ImportNotifier extends _$ImportNotifier {
  @override
  ImportState build() {
    return const ImportState();
  }

  void setFilePath(String path) {
    state = state.copyWith(selectedFilePath: path, error: null);
  }

  Future<void> startImport() async {
    if (state.selectedFilePath == null) {
      state = state.copyWith(error: 'Please select a file');
      return;
    }

    state = state.copyWith(isImporting: true, progress: 0.0, error: null);

    try {
      final result = await DataExportService.importFromJson(
        state.selectedFilePath!,
      );

      state = state.copyWith(isImporting: false, progress: 1.0, result: result);
    } catch (e) {
      state = state.copyWith(isImporting: false, error: e.toString());
    }
  }

  void clearResult() {
    state = const ImportState();
  }
}

/// Provider for recent exports.
@riverpod
class RecentExports extends _$RecentExports {
  @override
  List<ExportJob> build() {
    // In production, load from local storage
    return [];
  }

  void addExport(ExportJob job) {
    state = [job, ...state].take(10).toList();
  }

  void clearAll() {
    state = [];
  }
}
