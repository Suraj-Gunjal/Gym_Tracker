import '../../domain/models/exercise_form.dart';
import 'exercise_analyzer.dart';
import 'squat_analyzer.dart';
import 'bicep_curl_analyzer.dart';
import 'pushup_analyzer.dart';

/// Factory for creating exercise-specific analyzers.
class AnalyzerFactory {
  static final Map<CoachableExercise, ExerciseAnalyzer> _analyzers = {};

  /// Get or create an analyzer for the given exercise.
  static ExerciseAnalyzer getAnalyzer(CoachableExercise exercise) {
    if (!_analyzers.containsKey(exercise)) {
      _analyzers[exercise] = _createAnalyzer(exercise);
    }
    return _analyzers[exercise]!;
  }

  static ExerciseAnalyzer _createAnalyzer(CoachableExercise exercise) {
    switch (exercise) {
      case CoachableExercise.squat:
        return SquatAnalyzer();
      case CoachableExercise.bicepCurl:
        return BicepCurlAnalyzer();
      case CoachableExercise.pushUp:
        return PushUpAnalyzer();
      case CoachableExercise.deadlift:
        // Uses squat analyzer - similar hip hinge mechanics
        return SquatAnalyzer();
      case CoachableExercise.benchPress:
        // Uses push-up analyzer - similar pressing mechanics
        return PushUpAnalyzer();
      case CoachableExercise.shoulderPress:
        // Uses bicep curl analyzer - similar arm tracking
        return BicepCurlAnalyzer();
      case CoachableExercise.lunge:
        // Uses squat analyzer - similar leg tracking
        return SquatAnalyzer();
      case CoachableExercise.pullUp:
        // Uses bicep curl analyzer - similar arm tracking
        return BicepCurlAnalyzer();
    }
  }

  /// Reset a specific analyzer.
  static void resetAnalyzer(CoachableExercise exercise) {
    _analyzers[exercise]?.reset();
  }

  /// Reset all analyzers.
  static void resetAll() {
    for (final analyzer in _analyzers.values) {
      analyzer.reset();
    }
  }
}
