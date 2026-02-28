import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Represents the quality of form for an exercise rep.
enum FormQuality {
  perfect,
  good,
  needsWork,
  poor;

  String get label {
    switch (this) {
      case FormQuality.perfect:
        return 'Perfect!';
      case FormQuality.good:
        return 'Good';
      case FormQuality.needsWork:
        return 'Needs Work';
      case FormQuality.poor:
        return 'Poor Form';
    }
  }

  double get score {
    switch (this) {
      case FormQuality.perfect:
        return 1.0;
      case FormQuality.good:
        return 0.75;
      case FormQuality.needsWork:
        return 0.5;
      case FormQuality.poor:
        return 0.25;
    }
  }
}

/// Phase of an exercise rep (e.g., down phase of squat, up phase).
enum RepPhase {
  ready, // Starting position
  eccentric, // Lowering/negative phase
  bottom, // Bottom of movement
  concentric, // Lifting/positive phase
  lockout, // Top of movement
}

/// Feedback for a specific body part or joint.
class FormFeedback {
  final String bodyPart;
  final String message;
  final bool isCorrect;
  final double? angle; // Current angle if applicable

  const FormFeedback({
    required this.bodyPart,
    required this.message,
    required this.isCorrect,
    this.angle,
  });
}

/// Result of analyzing a single frame.
class FormAnalysisResult {
  final FormQuality quality;
  final RepPhase phase;
  final List<FormFeedback> feedback;
  final bool repCompleted;
  final Map<String, double> jointAngles;

  const FormAnalysisResult({
    required this.quality,
    required this.phase,
    required this.feedback,
    this.repCompleted = false,
    this.jointAngles = const {},
  });

  /// Get the most critical feedback (worst issue).
  FormFeedback? get criticalFeedback {
    final issues = feedback.where((f) => !f.isCorrect).toList();
    return issues.isNotEmpty ? issues.first : null;
  }

  /// Overall score from 0-100.
  int get score => (quality.score * 100).round();
}

/// Summary of a completed set.
class SetFormSummary {
  final int totalReps;
  final int perfectReps;
  final int goodReps;
  final int poorReps;
  final double averageScore;
  final List<String> commonIssues;
  final Duration duration;

  const SetFormSummary({
    required this.totalReps,
    required this.perfectReps,
    required this.goodReps,
    required this.poorReps,
    required this.averageScore,
    required this.commonIssues,
    required this.duration,
  });

  FormQuality get overallQuality {
    if (averageScore >= 0.9) return FormQuality.perfect;
    if (averageScore >= 0.7) return FormQuality.good;
    if (averageScore >= 0.5) return FormQuality.needsWork;
    return FormQuality.poor;
  }
}

/// Supported exercises for form coaching.
enum CoachableExercise {
  squat('Squat', '🏋️'),
  deadlift('Deadlift', '💪'),
  benchPress('Bench Press', '🛋️'),
  shoulderPress('Shoulder Press', '🙌'),
  bicepCurl('Bicep Curl', '💪'),
  lunge('Lunge', '🦵'),
  pushUp('Push Up', '👐'),
  pullUp('Pull Up', '🎯');

  final String displayName;
  final String emoji;

  const CoachableExercise(this.displayName, this.emoji);
}

/// Extension to calculate angles between pose landmarks.
extension PoseExtensions on Pose {
  /// Calculate angle at joint B given three points A-B-C.
  double? calculateAngle(
    PoseLandmarkType pointA,
    PoseLandmarkType pointB,
    PoseLandmarkType pointC,
  ) {
    final a = landmarks[pointA];
    final b = landmarks[pointB];
    final c = landmarks[pointC];

    if (a == null || b == null || c == null) return null;

    // Check confidence
    if (a.likelihood < 0.5 || b.likelihood < 0.5 || c.likelihood < 0.5) {
      return null;
    }

    // Calculate vectors
    final vectorBA = [a.x - b.x, a.y - b.y];
    final vectorBC = [c.x - b.x, c.y - b.y];

    // Calculate dot product and magnitudes
    final dotProduct = vectorBA[0] * vectorBC[0] + vectorBA[1] * vectorBC[1];
    final magnitudeBA = _magnitude(vectorBA);
    final magnitudeBC = _magnitude(vectorBC);

    if (magnitudeBA == 0 || magnitudeBC == 0) return null;

    // Calculate angle in degrees
    final cosAngle = dotProduct / (magnitudeBA * magnitudeBC);
    final clampedCos = cosAngle.clamp(-1.0, 1.0);
    final angleRad = _acos(clampedCos);
    return angleRad * 180 / 3.14159265359;
  }

  double _magnitude(List<double> vector) {
    return _sqrt(vector[0] * vector[0] + vector[1] * vector[1]);
  }

  double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 10; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  double _acos(double x) {
    // Taylor series approximation for acos
    return 1.5707963267948966 - _asin(x);
  }

  double _asin(double x) {
    // Taylor series for asin
    double result = x;
    double term = x;
    for (int n = 1; n < 10; n++) {
      term *= x * x * (2 * n - 1) * (2 * n - 1) / ((2 * n) * (2 * n + 1));
      result += term;
    }
    return result;
  }

  /// Get landmark position if confident enough.
  PoseLandmark? getLandmark(
    PoseLandmarkType type, {
    double minConfidence = 0.5,
  }) {
    final landmark = landmarks[type];
    if (landmark == null || landmark.likelihood < minConfidence) return null;
    return landmark;
  }
}
