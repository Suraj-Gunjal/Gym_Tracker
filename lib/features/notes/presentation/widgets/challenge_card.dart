import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise_note.dart';

/// Beautiful challenge card widget.
class ChallengeCard extends StatefulWidget {
  final WorkoutChallenge challenge;
  final bool isCompleted;
  final VoidCallback? onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(
      int.parse(widget.challenge.color.replaceFirst('#', '0xFF')),
    );

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isCompleted
                ? AppColors.surfaceDark.withOpacity(0.5)
                : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isCompleted
                  ? const Color(0xFF10B981).withOpacity(0.3)
                  : color.withOpacity(0.3),
            ),
            boxShadow: widget.isCompleted
                ? null
                : [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          (widget.isCompleted ? const Color(0xFF10B981) : color)
                              .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getIcon(widget.challenge.iconName),
                      color: widget.isCompleted
                          ? const Color(0xFF10B981)
                          : color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Title and description
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.challenge.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      decoration: widget.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: widget.isCompleted
                                          ? AppColors.textTertiaryDark
                                          : null,
                                    ),
                              ),
                            ),
                            if (widget.isCompleted)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF10B981),
                                size: 20,
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${widget.challenge.daysRemaining}d left',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.challenge.description,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.textTertiaryDark),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (!widget.isCompleted) ...[
                const SizedBox(height: 16),

                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: widget.challenge.progress,
                          backgroundColor: AppColors.backgroundDark,
                          valueColor: AlwaysStoppedAnimation(color),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(widget.challenge.progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Progress text
                    Text(
                      '${widget.challenge.currentValue.toStringAsFixed(0)}/${widget.challenge.targetValue.toStringAsFixed(0)} ${widget.challenge.unit}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    // XP reward
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${widget.challenge.xpReward} XP',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: const Color(0xFFF59E0B),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completed!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+${widget.challenge.xpReward} XP earned',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFFF59E0B)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'fitness_center':
        return Icons.fitness_center;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'timer':
        return Icons.timer;
      case 'directions_walk':
        return Icons.directions_walk;
      default:
        return Icons.star;
    }
  }
}
