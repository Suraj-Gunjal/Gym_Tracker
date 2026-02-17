import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/social_entity.dart';

/// List tile widget for displaying user info.
class UserListTile extends StatelessWidget {
  final SocialProfile user;
  final VoidCallback onFollow;
  final VoidCallback onTap;
  final bool showStats;

  const UserListTile({
    super.key,
    required this.user,
    required this.onFollow,
    required this.onTap,
    this.showStats = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFollowing =
        user.followStatus == FollowStatus.following ||
        user.followStatus == FollowStatus.mutual;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null
                  ? Text(
                      user.displayName[0].toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      if (user.followersCount > 1000) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ],
                    ],
                  ),
                  Text(
                    '@${user.username}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                  if (showStats) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.people, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          _formatCount(user.followersCount),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.fitness_center,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${user.totalWorkouts} workouts',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Follow button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: onFollow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFollowing
                      ? AppColors.surfaceLight
                      : AppColors.primary,
                  foregroundColor: isFollowing
                      ? Colors.grey[400]
                      : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: isFollowing
                        ? BorderSide(color: Colors.grey[700]!)
                        : BorderSide.none,
                  ),
                ),
                child: Text(
                  isFollowing ? 'Following' : 'Follow',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

/// Compact user chip for mentions, tags, etc.
class UserChip extends StatelessWidget {
  final SocialProfile user;
  final VoidCallback? onTap;
  final bool showRemove;
  final VoidCallback? onRemove;

  const UserChip({
    super.key,
    required this.user,
    this.onTap,
    this.showRemove = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                user.displayName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(user.displayName, style: const TextStyle(fontSize: 13)),
            if (showRemove) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onRemove,
                child: Icon(Icons.close, size: 16, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
