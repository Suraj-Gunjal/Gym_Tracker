import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/database_provider.dart';
import '../../data/repositories/pr_repository_impl.dart';
import '../../domain/entities/personal_record.dart';
import '../../domain/entities/pr_type.dart';
import '../../domain/repositories/pr_repository.dart';

/// Provider for PRRepository
final prRepositoryProvider = Provider<PRRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return PRRepositoryImpl(db);
});

/// Provider for all PRs for a specific exercise
final prsForExerciseProvider =
    FutureProvider.family<List<PersonalRecord>, String>((
      ref,
      exerciseId,
    ) async {
      final repository = ref.watch(prRepositoryProvider);
      return repository.getPRsForExercise(exerciseId);
    });

/// Arguments for getting a specific type of PR for an exercise
class PRTypeArgs {
  final String exerciseId;
  final PRType prType;

  const PRTypeArgs({required this.exerciseId, required this.prType});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PRTypeArgs &&
          runtimeType == other.runtimeType &&
          exerciseId == other.exerciseId &&
          prType == other.prType;

  @override
  int get hashCode => exerciseId.hashCode ^ prType.hashCode;
}

/// Provider for current PR of a specific type for an exercise
final currentPRProvider = FutureProvider.family<PersonalRecord?, PRTypeArgs>((
  ref,
  args,
) async {
  final repository = ref.watch(prRepositoryProvider);
  return repository.getCurrentPR(args.exerciseId, args.prType);
});

/// Provider for all PRs across all exercises
final allPRsProvider = FutureProvider<List<PersonalRecord>>((ref) async {
  final repository = ref.watch(prRepositoryProvider);
  return repository.getAllPRs();
});

/// Provider for recent PRs (for dashboard)
final recentPRsProvider = FutureProvider<List<PersonalRecord>>((ref) async {
  final repository = ref.watch(prRepositoryProvider);
  final allPRs = await repository.getAllPRs();

  // Sort by achieved date and take most recent
  allPRs.sort((a, b) => b.achievedAt.compareTo(a.achievedAt));
  return allPRs.take(10).toList();
});

/// State class for PR summary
class PRSummary {
  final int totalPRs;
  final int maxWeightPRs;
  final int maxRepsPRs;
  final int maxVolumePRs;
  final List<PersonalRecord> recentPRs;

  const PRSummary({
    required this.totalPRs,
    required this.maxWeightPRs,
    required this.maxRepsPRs,
    required this.maxVolumePRs,
    required this.recentPRs,
  });
}

/// Provider for PR summary statistics
final prSummaryProvider = FutureProvider<PRSummary>((ref) async {
  final allPRs = await ref.watch(allPRsProvider.future);

  final maxWeightPRs = allPRs
      .where((pr) => pr.prType == PRType.maxWeight)
      .length;
  final maxRepsPRs = allPRs.where((pr) => pr.prType == PRType.maxReps).length;
  final maxVolumePRs = allPRs
      .where((pr) => pr.prType == PRType.maxVolume)
      .length;

  // Get recent PRs (last 5)
  final sortedPRs = [...allPRs]
    ..sort((a, b) => b.achievedAt.compareTo(a.achievedAt));
  final recentPRs = sortedPRs.take(5).toList();

  return PRSummary(
    totalPRs: allPRs.length,
    maxWeightPRs: maxWeightPRs,
    maxRepsPRs: maxRepsPRs,
    maxVolumePRs: maxVolumePRs,
    recentPRs: recentPRs,
  );
});

/// Notifier for managing PRs (delete/edit operations)
class PRNotifier extends StateNotifier<AsyncValue<List<PersonalRecord>>> {
  final PRRepository _repository;
  final Ref _ref;

  PRNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadPRs();
  }

  Future<void> _loadPRs() async {
    state = const AsyncValue.loading();
    try {
      final prs = await _repository.getAllPRs();
      state = AsyncValue.data(prs);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await _loadPRs();
  }

  Future<void> deletePR(String id) async {
    try {
      await _repository.deletePR(id);
      await _loadPRs();

      // Invalidate related providers
      _ref.invalidate(allPRsProvider);
      _ref.invalidate(recentPRsProvider);
      _ref.invalidate(prSummaryProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> savePR(PersonalRecord pr) async {
    try {
      await _repository.savePR(pr);
      await _loadPRs();

      // Invalidate related providers
      _ref.invalidate(allPRsProvider);
      _ref.invalidate(recentPRsProvider);
      _ref.invalidate(prSummaryProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for PRNotifier
final prNotifierProvider =
    StateNotifierProvider<PRNotifier, AsyncValue<List<PersonalRecord>>>((ref) {
      final repository = ref.watch(prRepositoryProvider);
      return PRNotifier(repository, ref);
    });

/// Extension for getting PR display info
extension PRTypeDisplay on PRType {
  String get displayName {
    switch (this) {
      case PRType.maxWeight:
        return 'Max Weight';
      case PRType.maxReps:
        return 'Max Reps';
      case PRType.maxVolume:
        return 'Max Volume';
    }
  }

  String get emoji {
    switch (this) {
      case PRType.maxWeight:
        return '🏋️';
      case PRType.maxReps:
        return '💪';
      case PRType.maxVolume:
        return '📊';
    }
  }

  String formatValue(double value, {double? atWeight}) {
    switch (this) {
      case PRType.maxWeight:
        return '${value.toStringAsFixed(1)} kg';
      case PRType.maxReps:
        final weightStr = atWeight != null
            ? ' @ ${atWeight.toStringAsFixed(1)} kg'
            : '';
        return '${value.toInt()} reps$weightStr';
      case PRType.maxVolume:
        return '${value.toStringAsFixed(0)} kg';
    }
  }
}
