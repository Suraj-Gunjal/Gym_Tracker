import '../entities/entities.dart';

/// Result of PR detection containing any new PRs achieved.
class PRDetectionResult {
  /// List of new PRs achieved
  final List<PersonalRecord> newPRs;

  /// Whether any PR was achieved
  bool get hasPR => newPRs.isNotEmpty;

  /// Whether a max weight PR was achieved
  bool get hasMaxWeightPR => newPRs.any((pr) => pr.prType == PRType.maxWeight);

  /// Whether a max reps PR was achieved
  bool get hasMaxRepsPR => newPRs.any((pr) => pr.prType == PRType.maxReps);

  /// Whether a max volume PR was achieved
  bool get hasMaxVolumePR => newPRs.any((pr) => pr.prType == PRType.maxVolume);

  const PRDetectionResult({required this.newPRs});

  /// Empty result with no PRs
  const PRDetectionResult.empty() : newPRs = const [];
}
