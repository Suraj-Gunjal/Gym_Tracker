import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/models/exercise_form.dart';

/// Abstract base class for exercise form analyzers.
abstract class ExerciseAnalyzer {
  /// The exercise this analyzer is for.
  CoachableExercise get exercise;

  /// Current rep phase.
  RepPhase _currentPhase = RepPhase.ready;
  RepPhase get currentPhase => _currentPhase;

  /// Rep counter.
  int _repCount = 0;
  int get repCount => _repCount;

  /// Scores for each completed rep.
  final List<double> _repScores = [];
  List<double> get repScores => List.unmodifiable(_repScores);

  /// Timestamp when analysis started.
  DateTime? _startTime;

  /// Track rep completion internally.
  bool _wasAtBottom = false;

  /// Reset the analyzer for a new set.
  void reset() {
    _currentPhase = RepPhase.ready;
    _repCount = 0;
    _repScores.clear();
    _startTime = null;
    _wasAtBottom = false;
  }

  /// Analyze a pose and return form feedback.
  FormAnalysisResult analyze(Pose pose) {
    _startTime ??= DateTime.now();

    // Calculate joint angles
    final angles = calculateAngles(pose);

    // Determine current phase
    final newPhase = determinePhase(angles);

    // Check for rep completion (went to bottom and came back up)
    bool repCompleted = false;
    if (_currentPhase == RepPhase.bottom ||
        _currentPhase == RepPhase.eccentric) {
      _wasAtBottom = true;
    }
    if (_wasAtBottom &&
        (newPhase == RepPhase.lockout || newPhase == RepPhase.ready)) {
      repCompleted = true;
      _wasAtBottom = false;
      _repCount++;
    }

    _currentPhase = newPhase;

    // Check form and generate feedback
    final feedback = checkForm(pose, angles);
    final quality = calculateQuality(feedback);

    if (repCompleted) {
      _repScores.add(quality.score);
    }

    return FormAnalysisResult(
      quality: quality,
      phase: _currentPhase,
      feedback: feedback,
      repCompleted: repCompleted,
      jointAngles: angles,
    );
  }

  /// Calculate relevant joint angles for this exercise.
  Map<String, double> calculateAngles(Pose pose);

  /// Determine the current phase of the exercise.
  RepPhase determinePhase(Map<String, double> angles);

  /// Check form and return feedback.
  List<FormFeedback> checkForm(Pose pose, Map<String, double> angles);

  /// Calculate overall quality from feedback.
  FormQuality calculateQuality(List<FormFeedback> feedback) {
    if (feedback.isEmpty) return FormQuality.good;

    final issues = feedback.where((f) => !f.isCorrect).length;
    final total = feedback.length;
    final correctRatio = (total - issues) / total;

    if (correctRatio >= 0.9) return FormQuality.perfect;
    if (correctRatio >= 0.7) return FormQuality.good;
    if (correctRatio >= 0.5) return FormQuality.needsWork;
    return FormQuality.poor;
  }

  /// Get set summary.
  SetFormSummary getSummary() {
    final duration = _startTime != null
        ? DateTime.now().difference(_startTime!)
        : Duration.zero;

    int perfect = 0, good = 0, poor = 0;
    for (final score in _repScores) {
      if (score >= 0.9) {
        perfect++;
      } else if (score >= 0.7) {
        good++;
      } else {
        poor++;
      }
    }

    final avgScore = _repScores.isEmpty
        ? 0.0
        : _repScores.reduce((a, b) => a + b) / _repScores.length;

    return SetFormSummary(
      totalReps: _repCount,
      perfectReps: perfect,
      goodReps: good,
      poorReps: poor,
      averageScore: avgScore,
      commonIssues: [], // Tracked via form analysis history
      duration: duration,
    );
  }
}
