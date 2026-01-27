import '../entities/personal_record.dart';
import '../entities/pr_type.dart';

/// Abstract repository for Personal Record operations.
abstract class PRRepository {
  /// Get all PRs for an exercise
  Future<List<PersonalRecord>> getPRsForExercise(String exerciseId);

  /// Get all PRs for multiple exercises
  Future<Map<String, List<PersonalRecord>>> getPRsForExercises(
    List<String> exerciseIds,
  );

  /// Get the current PR of a specific type for an exercise
  Future<PersonalRecord?> getCurrentPR(String exerciseId, PRType prType);

  /// Get all PRs (optionally filtered)
  Future<List<PersonalRecord>> getAllPRs({bool includeDeleted = false});

  /// Save a new PR
  Future<void> savePR(PersonalRecord pr);

  /// Save multiple PRs
  Future<void> savePRs(List<PersonalRecord> prs);

  /// Soft delete a PR
  Future<void> deletePR(String id);

  /// Get PRs updated after a timestamp (for sync)
  Future<List<PersonalRecord>> getPRsUpdatedAfter(DateTime timestamp);

  /// Get PR history for an exercise and type (all previous records)
  Future<List<PersonalRecord>> getPRHistory(String exerciseId, PRType prType);
}
