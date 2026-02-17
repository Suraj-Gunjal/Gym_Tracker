import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/rest_timer_provider.dart';

/// Beautiful animated circular rest timer widget.
class RestTimerWidget extends ConsumerStatefulWidget {
  final bool showControls;
  final bool compact;
  final VoidCallback? onComplete;

  const RestTimerWidget({
    super.key,
    this.showControls = true,
    this.compact = false,
    this.onComplete,
  });

  @override
  ConsumerState<RestTimerWidget> createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends ConsumerState<RestTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(restTimerNotifierProvider);
    final presets = ref.watch(timerPresetsProvider);

    // Pulse animation when timer is about to complete
    if (timerState.isRunning &&
        timerState.remainingSeconds <= 5 &&
        timerState.remainingSeconds > 0) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController.stop();
        _pulseController.reset();
      }
    }

    // Check for completion
    if (timerState.isComplete && timerState.totalSeconds > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onComplete?.call();
      });
    }

    final size = widget.compact ? 120.0 : 200.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timer circle
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: timerState.isRunning && timerState.remainingSeconds <= 5
                  ? _pulseAnimation.value
                  : 1.0,
              child: child,
            );
          },
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circle
                CustomPaint(
                  size: Size(size, size),
                  painter: _TimerPainter(
                    progress: timerState.progress,
                    isRunning: timerState.isRunning,
                    isPaused: timerState.isPaused,
                    remainingSeconds: timerState.remainingSeconds,
                  ),
                ),
                // Time display
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timerState.formattedTime,
                      style: TextStyle(
                        fontSize: widget.compact ? 28 : 48,
                        fontWeight: FontWeight.bold,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: _getTimeColor(timerState),
                      ),
                    ),
                    if (timerState.exerciseName != null && !widget.compact) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Rest',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),

        if (widget.showControls) ...[
          const SizedBox(height: 24),

          // Play/Pause/Stop controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Subtract 15s
              _ControlButton(
                icon: Icons.remove,
                label: '-15s',
                onPressed: timerState.isRunning
                    ? () {
                        HapticFeedback.lightImpact();
                        ref
                            .read(restTimerNotifierProvider.notifier)
                            .subtractTime(15);
                      }
                    : null,
                small: true,
              ),
              const SizedBox(width: 16),

              // Main control button
              _MainControlButton(
                isRunning: timerState.isRunning,
                isPaused: timerState.isPaused,
                onPlayPause: () {
                  HapticFeedback.mediumImpact();
                  if (!timerState.isRunning) {
                    ref.read(restTimerNotifierProvider.notifier).startTimer();
                  } else if (timerState.isPaused) {
                    ref.read(restTimerNotifierProvider.notifier).resumeTimer();
                  } else {
                    ref.read(restTimerNotifierProvider.notifier).pauseTimer();
                  }
                },
                onStop: () {
                  HapticFeedback.mediumImpact();
                  ref.read(restTimerNotifierProvider.notifier).stopTimer();
                },
              ),
              const SizedBox(width: 16),

              // Add 15s
              _ControlButton(
                icon: Icons.add,
                label: '+15s',
                onPressed: timerState.isRunning
                    ? () {
                        HapticFeedback.lightImpact();
                        ref
                            .read(restTimerNotifierProvider.notifier)
                            .addTime(15);
                      }
                    : null,
                small: true,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Preset buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: presets.map((preset) {
              return _PresetChip(
                preset: preset,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(restTimerNotifierProvider.notifier)
                      .startTimer(seconds: preset.seconds);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Color _getTimeColor(timerState) {
    if (!timerState.isRunning) return AppColors.textPrimaryDark;
    if (timerState.remainingSeconds <= 5) return AppColors.error;
    if (timerState.remainingSeconds <= 10) return AppColors.warning;
    return AppColors.textPrimaryDark;
  }
}

/// Custom painter for the timer arc
class _TimerPainter extends CustomPainter {
  final double progress;
  final bool isRunning;
  final bool isPaused;
  final int remainingSeconds;

  _TimerPainter({
    required this.progress,
    required this.isRunning,
    required this.isPaused,
    required this.remainingSeconds,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    final strokeWidth = 12.0;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.cardDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressColor = _getProgressColor();
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          progressColor.withValues(alpha: 0.3),
          progressColor,
          progressColor,
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (1 - progress);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );

    // Glow effect when running
    if (isRunning && !isPaused) {
      final glowPaint = Paint()
        ..color = progressColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }
  }

  Color _getProgressColor() {
    if (!isRunning) return AppColors.primary;
    if (isPaused) return AppColors.warning;
    if (remainingSeconds <= 5) return AppColors.error;
    if (remainingSeconds <= 10) return AppColors.warning;
    return AppColors.primary;
  }

  @override
  bool shouldRepaint(_TimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isRunning != isRunning ||
        oldDelegate.isPaused != isPaused ||
        oldDelegate.remainingSeconds != remainingSeconds;
  }
}

/// Control button widget
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool small;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(small ? 12 : 16),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(small ? 12 : 16),
            child: Container(
              width: small ? 48 : 56,
              height: small ? 48 : 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(small ? 12 : 16),
                border: Border.all(
                  color: onPressed != null
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.transparent,
                ),
              ),
              child: Icon(
                icon,
                color: onPressed != null
                    ? AppColors.textPrimaryDark
                    : AppColors.textTertiaryDark,
                size: small ? 20 : 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: onPressed != null
                ? AppColors.textSecondaryDark
                : AppColors.textTertiaryDark,
          ),
        ),
      ],
    );
  }
}

/// Main play/pause/stop button
class _MainControlButton extends StatelessWidget {
  final bool isRunning;
  final bool isPaused;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;

  const _MainControlButton({
    required this.isRunning,
    required this.isPaused,
    required this.onPlayPause,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Play/Pause button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPlayPause,
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    !isRunning
                        ? Icons.play_arrow_rounded
                        : (isPaused
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded),
                    key: ValueKey(isRunning && !isPaused),
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Stop button (only show when running)
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: isRunning
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Material(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: onStop,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.stop_rounded,
                          color: AppColors.error,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// Preset time chip
class _PresetChip extends StatelessWidget {
  final TimerPreset preset;
  final VoidCallback onTap;

  const _PresetChip({required this.preset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Color(preset.color);

    return Material(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            preset.label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
