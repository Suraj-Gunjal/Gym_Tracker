import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/achievement.dart';

/// Card displaying an achievement with progress.
class AchievementCard extends StatelessWidget {
  final UserAchievement userAchievement;
  final bool compact;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.userAchievement,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final achievement = userAchievement.achievement;
    if (achievement == null) return const SizedBox();

    final color = Color(int.parse(achievement.color.replaceFirst('#', '0xFF')));
    final isUnlocked = userAchievement.isUnlocked;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: isUnlocked
              ? Border.all(color: color.withValues(alpha: 0.5), width: 2)
              : null,
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with tier indicator
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: compact ? 48 : 56,
                  height: compact ? 48 : 56,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? color.withValues(alpha: 0.2)
                        : AppColors.surfaceDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconData(achievement.iconName),
                    color: isUnlocked ? color : AppColors.textTertiaryDark,
                    size: compact ? 24 : 28,
                  ),
                ),
                if (isUnlocked)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.cardDark, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: compact ? 8 : 12),

            // Title
            Text(
              achievement.name,
              textAlign: TextAlign.center,
              maxLines: compact ? 1 : 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isUnlocked
                    ? AppColors.textPrimaryDark
                    : AppColors.textSecondaryDark,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 12 : 14,
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: 4),
              Text(
                achievement.tier.emoji,
                style: const TextStyle(fontSize: 14),
              ),
            ],
            const Spacer(),

            // Progress bar
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: userAchievement.progressPercent,
                    backgroundColor: AppColors.surfaceDark,
                    valueColor: AlwaysStoppedAnimation(
                      isUnlocked ? color : color.withValues(alpha: 0.5),
                    ),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${userAchievement.currentProgress}/${achievement.requirementValue}',
                  style: TextStyle(
                    color: AppColors.textTertiaryDark,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'emoji_events': Icons.emoji_events,
      'fitness_center': Icons.fitness_center,
      'military_tech': Icons.military_tech,
      'workspace_premium': Icons.workspace_premium,
      'local_fire_department': Icons.local_fire_department,
      'whatshot': Icons.whatshot,
      'bolt': Icons.bolt,
      'trending_up': Icons.trending_up,
      'wb_sunny': Icons.wb_sunny,
      'nightlight_round': Icons.nightlight_round,
      'weekend': Icons.weekend,
      'landscape': Icons.landscape,
    };
    return iconMap[iconName] ?? Icons.emoji_events;
  }
}
