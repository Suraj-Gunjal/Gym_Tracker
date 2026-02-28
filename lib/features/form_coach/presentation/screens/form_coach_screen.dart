import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/exercise_form.dart';
import '../providers/form_coach_provider.dart';

/// Screen for AI-powered form coaching.
class FormCoachScreen extends ConsumerStatefulWidget {
  const FormCoachScreen({super.key});

  @override
  ConsumerState<FormCoachScreen> createState() => _FormCoachScreenState();
}

class _FormCoachScreenState extends ConsumerState<FormCoachScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize camera on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(formCoachProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    ref.read(formCoachProvider.notifier).stopAnalysis();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(formCoachProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('AI Form Coach'),
        actions: [
          if (state.isInitialized)
            IconButton(
              icon: const Icon(Icons.cameraswitch),
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(formCoachProvider.notifier).switchCamera();
              },
            ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(FormCoachState state) {
    if (state.error != null) {
      return _buildError(state.error!);
    }

    if (!state.isInitialized) {
      return _buildLoading();
    }

    if (state.selectedExercise == null) {
      return _buildExerciseSelector();
    }

    return _buildCameraView(state);
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Initializing camera...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 64),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(formCoachProvider.notifier).initialize();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSelector() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Exercise',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose an exercise to get real-time form feedback',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: CoachableExercise.values.length,
                itemBuilder: (context, index) {
                  final exercise = CoachableExercise.values[index];
                  return _ExerciseCard(
                    exercise: exercise,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      ref
                          .read(formCoachProvider.notifier)
                          .selectExercise(exercise);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView(FormCoachState state) {
    final controller = state.cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return _buildLoading();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Camera preview
        ClipRect(
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.previewSize?.height ?? 1,
                height: controller.value.previewSize?.width ?? 1,
                child: CameraPreview(controller),
              ),
            ),
          ),
        ),

        // Pose overlay (skeleton visualization)
        if (state.currentPose != null && state.isRunning)
          CustomPaint(
            painter: PoseOverlayPainter(
              pose: state.currentPose!,
              cameraSize: controller.value.previewSize!,
              quality: state.lastAnalysis?.quality ?? FormQuality.good,
            ),
          ),

        // Top info bar
        Positioned(top: 0, left: 0, right: 0, child: _buildTopBar(state)),

        // Feedback overlay
        if (state.isRunning && state.lastAnalysis != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 150,
            child: _FeedbackOverlay(analysis: state.lastAnalysis!),
          ),

        // Rep counter
        if (state.isRunning)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: _RepCounter(
              count: state.repCount,
              quality: state.lastAnalysis?.quality,
            ),
          ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildBottomControls(state),
        ),
      ],
    );
  }

  Widget _buildTopBar(FormCoachState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.selectedExercise?.emoji ?? '',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state.selectedExercise?.displayName ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (state.isRunning)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fiber_manual_record,
                  color: Colors.white,
                  size: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(FormCoachState state) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Change exercise
          _ControlButton(
            icon: Icons.swap_horiz,
            label: 'Change',
            onTap: () {
              HapticFeedback.lightImpact();
              if (state.isRunning) {
                ref.read(formCoachProvider.notifier).stopAnalysis();
              }
              // Clear exercise selection
              ref
                  .read(formCoachProvider.notifier)
                  .selectExercise(state.selectedExercise!);
              // Force back to selector
              ref.invalidate(formCoachProvider);
              ref.read(formCoachProvider.notifier).initialize();
            },
          ),

          // Start/Stop button
          GestureDetector(
            onTap: () {
              HapticFeedback.heavyImpact();
              if (state.isRunning) {
                ref.read(formCoachProvider.notifier).stopAnalysis();
                _showSummary(state);
              } else {
                ref.read(formCoachProvider.notifier).startAnalysis();
              }
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: state.isRunning ? AppColors.error : AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color:
                        (state.isRunning ? AppColors.error : AppColors.primary)
                            .withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                state.isRunning ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),

          // Summary
          _ControlButton(
            icon: Icons.assessment,
            label: 'Summary',
            onTap: () {
              HapticFeedback.lightImpact();
              _showSummary(state);
            },
          ),
        ],
      ),
    );
  }

  void _showSummary(FormCoachState state) {
    final summary = ref.read(formCoachProvider.notifier).getSummary();
    if (summary == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SummarySheet(summary: summary),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final CoachableExercise exercise;
  final VoidCallback onTap;

  const _ExerciseCard({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceDark,
              AppColors.surfaceDark.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(exercise.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              exercise.displayName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RepCounter extends StatelessWidget {
  final int count;
  final FormQuality? quality;

  const _RepCounter({required this.count, this.quality});

  @override
  Widget build(BuildContext context) {
    final color = switch (quality) {
      FormQuality.perfect => AppColors.success,
      FormQuality.good => AppColors.primary,
      FormQuality.needsWork => Colors.orange,
      FormQuality.poor => AppColors.error,
      null => AppColors.primary,
    };

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color, width: 3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$count',
              style: TextStyle(
                color: color,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'REPS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackOverlay extends StatelessWidget {
  final FormAnalysisResult analysis;

  const _FeedbackOverlay({required this.analysis});

  @override
  Widget build(BuildContext context) {
    final criticalFeedback = analysis.criticalFeedback;
    if (criticalFeedback == null && analysis.quality == FormQuality.perfect) {
      return _buildPositiveFeedback();
    }

    if (criticalFeedback == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  criticalFeedback.bodyPart,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  criticalFeedback.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositiveFeedback() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 12),
          Text(
            'Perfect Form! 💪',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SummarySheet extends StatelessWidget {
  final SetFormSummary summary;

  const _SummarySheet({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Set Summary',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              _QualityBadge(quality: summary.overallQuality),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                value: '${summary.totalReps}',
                label: 'Total Reps',
                icon: Icons.repeat,
              ),
              _StatItem(
                value: '${(summary.averageScore * 100).round()}%',
                label: 'Form Score',
                icon: Icons.stars,
              ),
              _StatItem(
                value: _formatDuration(summary.duration),
                label: 'Duration',
                icon: Icons.timer,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _RepQualityBar(
                  label: 'Perfect',
                  count: summary.perfectReps,
                  total: summary.totalReps,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RepQualityBar(
                  label: 'Good',
                  count: summary.goodReps,
                  total: summary.totalReps,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _RepQualityBar(
                  label: 'Needs Work',
                  count: summary.poorReps,
                  total: summary.totalReps,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}

class _QualityBadge extends StatelessWidget {
  final FormQuality quality;

  const _QualityBadge({required this.quality});

  @override
  Widget build(BuildContext context) {
    final color = switch (quality) {
      FormQuality.perfect => AppColors.success,
      FormQuality.good => AppColors.primary,
      FormQuality.needsWork => Colors.orange,
      FormQuality.poor => AppColors.error,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        quality.label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12),
        ),
      ],
    );
  }
}

class _RepQualityBar extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _RepQualityBar({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: total > 0 ? count / total : 0,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Painter for pose skeleton overlay.
class PoseOverlayPainter extends CustomPainter {
  final Pose pose;
  final Size cameraSize;
  final FormQuality quality;

  PoseOverlayPainter({
    required this.pose,
    required this.cameraSize,
    required this.quality,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final color = switch (quality) {
      FormQuality.perfect => AppColors.success,
      FormQuality.good => AppColors.primary,
      FormQuality.needsWork => Colors.orange,
      FormQuality.poor => AppColors.error,
    };

    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..style = PaintingStyle.fill;

    // Draw connections
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.rightShoulder,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftElbow,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.leftElbow,
      PoseLandmarkType.leftWrist,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.rightElbow,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.rightElbow,
      PoseLandmarkType.rightWrist,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftHip,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.rightHip,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.rightHip,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftKnee,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.leftKnee,
      PoseLandmarkType.leftAnkle,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.rightHip,
      PoseLandmarkType.rightKnee,
    );
    _drawLine(
      canvas,
      size,
      paint,
      PoseLandmarkType.rightKnee,
      PoseLandmarkType.rightAnkle,
    );

    // Draw key points
    for (final landmark in pose.landmarks.values) {
      if (landmark.likelihood > 0.5) {
        final point = _translatePoint(landmark, size);
        canvas.drawCircle(point, 6, pointPaint);
        canvas.drawCircle(point, 6, paint);
      }
    }
  }

  void _drawLine(
    Canvas canvas,
    Size size,
    Paint paint,
    PoseLandmarkType type1,
    PoseLandmarkType type2,
  ) {
    final landmark1 = pose.landmarks[type1];
    final landmark2 = pose.landmarks[type2];

    if (landmark1 == null || landmark2 == null) return;
    if (landmark1.likelihood < 0.5 || landmark2.likelihood < 0.5) return;

    final point1 = _translatePoint(landmark1, size);
    final point2 = _translatePoint(landmark2, size);
    canvas.drawLine(point1, point2, paint);
  }

  Offset _translatePoint(PoseLandmark landmark, Size size) {
    // Scale from camera coordinates to screen coordinates
    final x = landmark.x * size.width / cameraSize.width;
    final y = landmark.y * size.height / cameraSize.height;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant PoseOverlayPainter oldDelegate) {
    return oldDelegate.pose != pose || oldDelegate.quality != quality;
  }
}
