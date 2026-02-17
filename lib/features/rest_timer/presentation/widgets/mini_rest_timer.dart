import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/rest_timer_provider.dart';
import '../widgets/rest_timer_widget.dart';

/// Compact mini rest timer that can be shown during active workout.
class MiniRestTimer extends ConsumerWidget {
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const MiniRestTimer({super.key, this.onTap, this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(restTimerNotifierProvider);

    if (!timerState.isRunning &&
        timerState.remainingSeconds == timerState.totalSeconds) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap ?? () => _showTimerBottomSheet(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getBackgroundColor(timerState),
              _getBackgroundColor(timerState).withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _getBackgroundColor(timerState).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Timer icon with pulse
            _PulsingIcon(
              isActive: timerState.isRunning && !timerState.isPaused,
              color: Colors.white,
            ),
            const SizedBox(width: 12),

            // Time display
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rest Timer',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    timerState.formattedTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),

            // Quick controls
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MiniControlButton(
                  icon: timerState.isPaused ? Icons.play_arrow : Icons.pause,
                  onTap: () {
                    if (timerState.isPaused) {
                      ref
                          .read(restTimerNotifierProvider.notifier)
                          .resumeTimer();
                    } else {
                      ref.read(restTimerNotifierProvider.notifier).pauseTimer();
                    }
                  },
                ),
                const SizedBox(width: 8),
                _MiniControlButton(
                  icon: Icons.add,
                  onTap: () {
                    ref.read(restTimerNotifierProvider.notifier).addTime(15);
                  },
                ),
                const SizedBox(width: 8),
                _MiniControlButton(
                  icon: Icons.close,
                  onTap: () {
                    ref.read(restTimerNotifierProvider.notifier).stopTimer();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(timerState) {
    if (timerState.isPaused) return AppColors.warning;
    if (timerState.remainingSeconds <= 5) return AppColors.error;
    if (timerState.remainingSeconds <= 10) return AppColors.warning;
    return AppColors.primary;
  }

  void _showTimerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const RestTimerWidget(showControls: true),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Pulsing icon for active timer
class _PulsingIcon extends StatefulWidget {
  final bool isActive;
  final Color color;

  const _PulsingIcon({required this.isActive, required this.color});

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_PulsingIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _animation.value : 1.0,
          child: child,
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.timer, color: widget.color, size: 24),
      ),
    );
  }
}

/// Mini control button
class _MiniControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
