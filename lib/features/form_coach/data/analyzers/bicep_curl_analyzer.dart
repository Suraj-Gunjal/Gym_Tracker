import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../domain/models/exercise_form.dart';
import 'exercise_analyzer.dart';

/// Analyzer for bicep curl form.
class BicepCurlAnalyzer extends ExerciseAnalyzer {
  @override
  CoachableExercise get exercise => CoachableExercise.bicepCurl;

  // Ideal angle ranges
  static const double _elbowAngleBottom = 40.0; // Fully contracted
  static const double _elbowAngleTop = 160.0; // Extended

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

    // Use the more bent arm (active arm)
    if (angles.containsKey('leftElbow') && angles.containsKey('rightElbow')) {
      angles['activeElbow'] = angles['leftElbow']! < angles['rightElbow']!
          ? angles['leftElbow']!
          : angles['rightElbow']!;
    } else if (angles.containsKey('leftElbow')) {
      angles['activeElbow'] = angles['leftElbow']!;
    } else if (angles.containsKey('rightElbow')) {
      angles['activeElbow'] = angles['rightElbow']!;
    }

    return angles;
  }

  @override
  RepPhase determinePhase(Map<String, double> angles) {
    final elbowAngle = angles['activeElbow'];

    if (elbowAngle == null) return RepPhase.ready;

    if (elbowAngle >= _elbowAngleTop - 20) {
      return RepPhase.lockout;
    } else if (elbowAngle <= _elbowAngleBottom + 15) {
      return RepPhase.bottom; // Peak contraction
    } else if (elbowAngle < 100) {
      if (currentPhase == RepPhase.bottom ||
          currentPhase == RepPhase.eccentric) {
        return RepPhase.eccentric; // Lowering after contraction
      } else {
        return RepPhase.concentric; // Curling up
      }
    } else {
      return RepPhase.ready;
    }
  }

  @override
  List<FormFeedback> checkForm(Pose pose, Map<String, double> angles) {
    final feedback = <FormFeedback>[];

    // Check full range of motion
    final elbowAngle = angles['activeElbow'];
    if (elbowAngle != null) {
      if (currentPhase == RepPhase.bottom ||
          currentPhase == RepPhase.concentric) {
        if (elbowAngle > _elbowAngleBottom + 25) {
          feedback.add(
            FormFeedback(
              bodyPart: 'Contraction',
              message: 'Squeeze harder at the top!',
              isCorrect: false,
              angle: elbowAngle,
            ),
          );
        } else {
          feedback.add(
            FormFeedback(
              bodyPart: 'Contraction',
              message: 'Full contraction!',
              isCorrect: true,
              angle: elbowAngle,
            ),
          );
        }
      }
    }

    // Check for elbow drift (elbows should stay pinned)
    final leftShoulder = pose.getLandmark(PoseLandmarkType.leftShoulder);
    final leftElbow = pose.getLandmark(PoseLandmarkType.leftElbow);
    final rightShoulder = pose.getLandmark(PoseLandmarkType.rightShoulder);
    // rightElbow available for future use

    if (leftShoulder != null && leftElbow != null) {
      final elbowDrift = (leftElbow.x - leftShoulder.x).abs();
      final shoulderWidth = rightShoulder != null
          ? (leftShoulder.x - rightShoulder.x).abs()
          : 100;

      if (elbowDrift > shoulderWidth * 0.3) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Elbows',
            message: 'Keep elbows pinned to your sides',
            isCorrect: false,
          ),
        );
      } else {
        feedback.add(
          FormFeedback(
            bodyPart: 'Elbows',
            message: 'Elbows stable',
            isCorrect: true,
          ),
        );
      }
    }

    // Check for body swing (using shoulder movement)
    final leftHip = pose.getLandmark(PoseLandmarkType.leftHip);
    if (leftShoulder != null && leftHip != null) {
      // Shoulder should be relatively vertical above hip
      final shoulderHipOffset = (leftShoulder.x - leftHip.x).abs();
      final torsoHeight = (leftShoulder.y - leftHip.y).abs();

      if (shoulderHipOffset > torsoHeight * 0.2) {
        feedback.add(
          FormFeedback(
            bodyPart: 'Body',
            message: 'No swinging! Keep body still',
            isCorrect: false,
          ),
        );
      }
    }

    return feedback;
  }
}
