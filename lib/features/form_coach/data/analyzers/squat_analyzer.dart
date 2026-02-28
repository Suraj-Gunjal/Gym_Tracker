import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/models/exercise_form.dart';
import 'exercise_analyzer.dart';

/// Analyzer for squat form.
class SquatAnalyzer extends ExerciseAnalyzer {
  @override
  CoachableExercise get exercise => CoachableExercise.squat;

  // Ideal angle ranges for squat
  static const double _kneeAngleBottom = 70.0; // At parallel
  static const double _kneeAngleTop = 170.0; // Standing
  // ignore: unused_field
  static const double _hipAngleBottom = 70.0;
  // ignore: unused_field
  static const double _hipAngleTop = 175.0;
  static const double _backAngleTolerance = 45.0; // Max forward lean

  @override
  Map<String, double> calculateAngles(Pose pose) {
    final angles = <String, double>{};

    // Left knee angle (hip-knee-ankle)
    final leftKnee = pose.calculateAngle(
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftKnee,
      PoseLandmarkType.leftAnkle,
    );
    if (leftKnee != null) angles['leftKnee'] = leftKnee;

    // Right knee angle
    final rightKnee = pose.calculateAngle(
      PoseLandmarkType.rightHip,
      PoseLandmarkType.rightKnee,
      PoseLandmarkType.rightAnkle,
    );
    if (rightKnee != null) angles['rightKnee'] = rightKnee;

    // Left hip angle (shoulder-hip-knee)
    final leftHip = pose.calculateAngle(
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftKnee,
    );
    if (leftHip != null) angles['leftHip'] = leftHip;

    // Right hip angle
    final rightHip = pose.calculateAngle(
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.rightHip,
      PoseLandmarkType.rightKnee,
    );
    if (rightHip != null) angles['rightHip'] = rightHip;

    // Average angles for symmetry
    if (angles.containsKey('leftKnee') && angles.containsKey('rightKnee')) {
      angles['avgKnee'] = (angles['leftKnee']! + angles['rightKnee']!) / 2;
    }
    if (angles.containsKey('leftHip') && angles.containsKey('rightHip')) {
      angles['avgHip'] = (angles['leftHip']! + angles['rightHip']!) / 2;
    }

    return angles;
  }

  @override
  RepPhase determinePhase(Map<String, double> angles) {
    final kneeAngle =
        angles['avgKnee'] ?? angles['leftKnee'] ?? angles['rightKnee'];

    if (kneeAngle == null) return RepPhase.ready;

    // Determine phase based on knee angle
    if (kneeAngle >= _kneeAngleTop - 15) {
      return RepPhase.lockout;
    } else if (kneeAngle <= _kneeAngleBottom + 10) {
      return RepPhase.bottom;
    } else if (kneeAngle < 120) {
      // Between bottom and standing
      if (currentPhase == RepPhase.bottom ||
          currentPhase == RepPhase.concentric) {
        return RepPhase.concentric;
      } else {
        return RepPhase.eccentric;
      }
    } else {
      return RepPhase.ready;
    }
  }

  @override
  List<FormFeedback> checkForm(Pose pose, Map<String, double> angles) {
    final feedback = <FormFeedback>[];

    // Check depth
    final kneeAngle = angles['avgKnee'] ?? angles['leftKnee'];
    if (kneeAngle != null) {
      if (currentPhase == RepPhase.bottom) {
        if (kneeAngle > _kneeAngleBottom + 20) {
          feedback.add(
            FormFeedback(
              bodyPart: 'Depth',
              message: 'Go deeper! Aim for parallel',
              isCorrect: false,
              angle: kneeAngle,
            ),
          );
        } else if (kneeAngle <= _kneeAngleBottom + 10) {
          feedback.add(
            FormFeedback(
              bodyPart: 'Depth',
              message: 'Great depth!',
              isCorrect: true,
              angle: kneeAngle,
            ),
          );
        }
      }
    }

    // Check knee symmetry
    final leftKnee = angles['leftKnee'];
    final rightKnee = angles['rightKnee'];
    if (leftKnee != null && rightKnee != null) {
      final asymmetry = (leftKnee - rightKnee).abs();
      if (asymmetry > 15) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Knees',
            message: 'Uneven knees - balance your weight',
            isCorrect: false,
          ),
        );
      } else {
        feedback.add(
          FormFeedback(
            bodyPart: 'Knees',
            message: 'Even knee bend',
            isCorrect: true,
          ),
        );
      }
    }

    // Check for knee cave (knees going inward)
    final leftKneeLandmark = pose.getLandmark(PoseLandmarkType.leftKnee);
    final rightKneeLandmark = pose.getLandmark(PoseLandmarkType.rightKnee);
    final leftAnkle = pose.getLandmark(PoseLandmarkType.leftAnkle);
    final rightAnkle = pose.getLandmark(PoseLandmarkType.rightAnkle);

    if (leftKneeLandmark != null &&
        leftAnkle != null &&
        rightKneeLandmark != null &&
        rightAnkle != null) {
      // Check if knees are tracking over toes
      final leftKneeX = leftKneeLandmark.x;
      final leftAnkleX = leftAnkle.x;
      final rightKneeX = rightKneeLandmark.x;
      final rightAnkleX = rightAnkle.x;

      // Knees should be at least as wide as ankles
      final kneeWidth = (leftKneeX - rightKneeX).abs();
      final ankleWidth = (leftAnkleX - rightAnkleX).abs();

      if (kneeWidth < ankleWidth * 0.85) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Knee Cave',
            message: 'Push knees out over toes',
            isCorrect: false,
          ),
        );
      }
    }

    // Check back angle (torso lean)
    final hipAngle = angles['avgHip'] ?? angles['leftHip'];
    if (hipAngle != null &&
        currentPhase != RepPhase.lockout &&
        currentPhase != RepPhase.ready) {
      if (hipAngle < 90 - _backAngleTolerance) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Back',
            message: 'Too much forward lean - chest up!',
            isCorrect: false,
            angle: hipAngle,
          ),
        );
      } else {
        feedback.add(
          FormFeedback(
            bodyPart: 'Back',
            message: 'Good torso position',
            isCorrect: true,
          ),
        );
      }
    }

    return feedback;
  }
}
