import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/achievement.dart';

/// Beautiful celebration dialog when user unlocks an achievement.
class AchievementCelebrationDialog extends StatefulWidget {
  final UserAchievement userAchievement;

  const AchievementCelebrationDialog({
    super.key,
    required this.userAchievement,
  });

  /// Show the achievement celebration dialog.
  static Future<void> show(
    BuildContext context,
    UserAchievement userAchievement,
  ) {
    HapticFeedback.heavyImpact();
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Achievement',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AchievementCelebrationDialog(userAchievement: userAchievement);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeIn,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  State<AchievementCelebrationDialog> createState() =>
      _AchievementCelebrationDialogState();
}

class _AchievementCelebrationDialogState
    extends State<AchievementCelebrationDialog>
    with TickerProviderStateMixin {
  late AnimationController _shineController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late Animation<double> _shineAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Shine animation
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _shineAnimation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shineController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color get _tierColor {
    final achievement = widget.userAchievement.achievement;
    if (achievement == null) return AppColors.primary;

    switch (achievement.tier) {
      case AchievementTier.bronze:
        return const Color(0xFFCD7F32);
      case AchievementTier.silver:
        return const Color(0xFFC0C0C0);
      case AchievementTier.gold:
        return const Color(0xFFFFD700);
      case AchievementTier.platinum:
        return const Color(0xFFE5E4E2);
      case AchievementTier.diamond:
        return const Color(0xFFB9F2FF);
    }
  }

  String get _tierEmoji {
    final achievement = widget.userAchievement.achievement;
    if (achievement == null) return '🏆';
    return achievement.tier.emoji;
  }

  IconData _getAchievementIcon() {
    final iconName =
        widget.userAchievement.achievement?.iconName ?? 'emoji_events';

    switch (iconName) {
      case 'emoji_events':
        return Icons.emoji_events;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'military_tech':
        return Icons.military_tech;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'trending_up':
        return Icons.trending_up;
      case 'star':
        return Icons.star;
      case 'flash_on':
        return Icons.flash_on;
      case 'calendar_month':
        return Icons.calendar_month;
      case 'sports_score':
        return Icons.sports_score;
      default:
        return Icons.emoji_events;
    }
  }

  @override
  Widget build(BuildContext context) {
    final achievement = widget.userAchievement.achievement;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          margin: const EdgeInsets.all(24),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Particles
              AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(320, 400),
                    painter: _ParticlePainter(
                      progress: _particleController.value,
                      color: _tierColor,
                    ),
                  );
                },
              ),

              // Main card
              Container(
                margin: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _tierColor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _tierColor.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 60),

                    // Achievement unlocked text
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _tierColor.withValues(alpha: 0.3),
                            _tierColor.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _tierEmoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ACHIEVEMENT UNLOCKED',
                            style: TextStyle(
                              color: _tierColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Achievement name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        achievement?.name ?? 'Achievement',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        achievement?.description ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // XP reward
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars,
                            color: AppColors.prGold,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '+${achievement?.xpReward ?? 100} XP',
                            style: const TextStyle(
                              color: AppColors.prGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tier badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _tierColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _tierColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        '${achievement?.tier.displayName ?? 'Bronze'} Achievement',
                        style: TextStyle(
                          color: _tierColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Dismiss button
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tierColor,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Awesome!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Medal icon at top
              Positioned(
                top: 0,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [_tierColor, _tierColor.withValues(alpha: 0.8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _tierColor.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Shine effect
                        AnimatedBuilder(
                          animation: _shineAnimation,
                          builder: (context, child) {
                            return ClipOval(
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withValues(alpha: 0.3),
                                      Colors.transparent,
                                    ],
                                    stops: [
                                      _shineAnimation.value - 0.3,
                                      _shineAnimation.value,
                                      _shineAnimation.value + 0.3,
                                    ].map((e) => e.clamp(0.0, 1.0)).toList(),
                                  ).createShader(bounds);
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                        Icon(
                          _getAchievementIcon(),
                          size: 48,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Particle painter for celebration effect.
class _ParticlePainter extends CustomPainter {
  final double progress;
  final Color color;
  final List<_Particle> particles;

  _ParticlePainter({required this.progress, required this.color})
    : particles = List.generate(30, (index) => _Particle(index));

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, 100);

    for (final particle in particles) {
      final adjustedProgress = (progress + particle.delay) % 1.0;
      final opacity = (1 - adjustedProgress).clamp(0.0, 1.0);

      final x =
          center.dx +
          math.cos(particle.angle) * particle.radius * adjustedProgress * 150;
      final y =
          center.dy +
          math.sin(particle.angle) * particle.radius * adjustedProgress * 150 +
          (adjustedProgress * 50); // Gravity effect

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity * 0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1 - adjustedProgress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _Particle {
  final double angle;
  final double radius;
  final double size;
  final double delay;
  final Color color;

  _Particle(int index)
    : angle = (index / 30) * 2 * math.pi + (math.Random().nextDouble() * 0.5),
      radius = 0.5 + math.Random().nextDouble() * 0.5,
      size = 3 + math.Random().nextDouble() * 4,
      delay = math.Random().nextDouble(),
      color = [
        const Color(0xFFFFD700),
        const Color(0xFFFFA500),
        const Color(0xFFFF6347),
        const Color(0xFF00CED1),
        const Color(0xFF9370DB),
        const Color(0xFF32CD32),
      ][index % 6];
}
