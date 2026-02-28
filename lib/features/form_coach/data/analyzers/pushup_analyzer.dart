import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/models/exercise_form.dart';
import 'exercise_analyzer.dart';

/// Analyzer for push-up form.
class PushUpAnalyzer extends ExerciseAnalyzer {
  @override
  CoachableExercise get exercise => CoachableExercise.pushUp;

  // Ideal angle ranges
  static const double _elbowAngleBottom = 70.0; // Chest near ground
  static const double _elbowAngleTop = 160.0; // Arms extended

  @override
  Map<String, double> calculateAngles(Pose pose) {
    final angles = <String, double>{};

    // Left elbow angle (shoulder-elbow-wrist)
    final leftElbow = pose.calculateAngle(
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftElbow,
      PoseLandmarkType.leftWrist,
    );
    if (leftElbow != null) angles['leftElbow'] = leftElbow;

    // Right elbow angle
    final rightElbow = pose.calculateAngle(
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.rightElbow,
      PoseLandmarkType.rightWrist,
    );
    if (rightElbow != null) angles['rightElbow'] = rightElbow;

    // Hip angle (for checking body alignment)
    final hipAngle = pose.calculateAngle(
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftKnee,
    );
    if (hipAngle != null) angles['hip'] = hipAngle;

    // Average elbow angle
    if (angles.containsKey('leftElbow') && angles.containsKey('rightElbow')) {
      angles['avgElbow'] = (angles['leftElbow']! + angles['rightElbow']!) / 2;
    }

    return angles;
  }

  @override
  RepPhase determinePhase(Map<String, double> angles) {
    final elbowAngle =
        angles['avgElbow'] ?? angles['leftElbow'] ?? angles['rightElbow'];

    if (elbowAngle == null) return RepPhase.ready;

    if (elbowAngle >= _elbowAngleTop - 15) {
      return RepPhase.lockout;
    } else if (elbowAngle <= _elbowAngleBottom + 15) {
      return RepPhase.bottom;
    } else if (elbowAngle < 120) {
      if (currentPhase == RepPhase.bottom ||
          currentPhase == RepPhase.concentric) {
        return RepPhase.concentric; // Pushing up
      } else {
        return RepPhase.eccentric; // Going down
      }
    } else {
      return RepPhase.ready;
    }
  }

  @override
  List<FormFeedback> checkForm(Pose pose, Map<String, double> angles) {
    final feedback = <FormFeedback>[];

    // Check depth
    final elbowAngle = angles['avgElbow'] ?? angles['leftElbow'];
    if (elbowAngle != null && currentPhase == RepPhase.bottom) {
      if (elbowAngle > _elbowAngleBottom + 25) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Depth',
            message: 'Go lower! Chest closer to ground',
            isCorrect: false,
            angle: elbowAngle,
          ),
        );
      } else {
        feedback.add(
          FormFeedback(
            bodyPart: 'Depth',
            message: 'Good depth!',
            isCorrect: true,
            angle: elbowAngle,
          ),
        );
      }
    }

    // Check body alignment (plank position)
    final hipAngle = angles['hip'];
    if (hipAngle != null) {
      // Hip should be around 180 degrees (straight line)
      if (hipAngle < 150) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Hips',
            message: 'Hips sagging - tighten core!',
            isCorrect: false,
            angle: hipAngle,
          ),
        );
      } else if (hipAngle > 190) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Hips',
            message: 'Hips too high - flatten back',
            isCorrect: false,
            angle: hipAngle,
          ),
        );
      } else {
        feedback.add(
          FormFeedback(
            bodyPart: 'Body',
            message: 'Great body alignment!',
            isCorrect: true,
          ),
        );
      }
    }

    // Check elbow symmetry
    final leftElbow = angles['leftElbow'];
    final rightElbow = angles['rightElbow'];
    if (leftElbow != null && rightElbow != null) {
      final asymmetry = (leftElbow - rightElbow).abs();
      if (asymmetry > 20) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Arms',
            message: 'Uneven arm bend',
            isCorrect: false,
          ),
        );
      }
    }

    // Check elbow flare
    final leftShoulderLandmark = pose.getLandmark(
      PoseLandmarkType.leftShoulder,
    );
    final leftElbowLandmark = pose.getLandmark(PoseLandmarkType.leftElbow);
    final leftHip = pose.getLandmark(PoseLandmarkType.leftHip);

    if (leftShoulderLandmark != null &&
        leftElbowLandmark != null &&
        leftHip != null) {
      // Elbows should be at roughly 45 degrees, not flared out at 90
      // Check if elbow is too far from body line
      final bodyLineX = leftShoulderLandmark.x;
      final elbowX = leftElbowLandmark.x;
      final shoulderToHipDist = (leftShoulderLandmark.y - leftHip.y).abs();

      if ((elbowX - bodyLineX).abs() > shoulderToHipDist * 0.5) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Elbows',
            message: 'Tuck elbows closer (45°)',
            isCorrect: false,
          ),
        );
      } else {
        feedback.add(
          FormFeedback(
            bodyPart: 'Elbows',
            message: 'Good elbow position',
            isCorrect: true,
          ),
        );
      }
    }

    return feedback;
  }
}
