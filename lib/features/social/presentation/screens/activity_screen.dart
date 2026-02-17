import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/social_entity.dart';
import '../providers/social_provider.dart';

/// Activity/notifications screen.
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(activityFeedNotifierProvider);
    final unreadCount = activities.where((a) => !a.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                ref.read(activityFeedNotifierProvider.notifier).markAllAsRead();
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: activities.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No activity yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'When someone interacts with your workouts,\nyou\'ll see it here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _ActivityTile(
                  activity: activity,
                  onTap: () {
                    ref
                        .read(activityFeedNotifierProvider.notifier)
                        .markAsRead(activity.id);
                  },
                );
              },
            ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final ActivityItem activity;
  final VoidCallback onTap;

  const _ActivityTile({required this.activity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: activity.isRead ? null : AppColors.primary.withValues(alpha: 0.05),
      child: ListTile(
        onTap: onTap,
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                activity.actor.displayName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: activity.type.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 2),
                ),
                child: Icon(activity.type.icon, size: 10, color: Colors.white),
              ),
            ),
          ],
        ),
        title: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14),
            children: [
              TextSpan(
                text: activity.actor.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' ${_getActionText(activity.type)}',
                style: TextStyle(color: Colors.grey[300]),
              ),
            ],
          ),
        ),
        subtitle: Text(
          _formatTimeAgo(activity.createdAt),
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: !activity.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              )
            : null,
      ),
    );
  }

  String _getActionText(ActivityType type) {
    switch (type) {
      case ActivityType.like:
        return 'liked your workout';
      case ActivityType.comment:
        return 'commented on your workout';
      case ActivityType.follow:
        return 'started following you';
      case ActivityType.prBeat:
        return 'beat your PR! 🔥';
      case ActivityType.badge:
        return 'earned a new badge';
      case ActivityType.mention:
        return 'mentioned you';
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('MMM d').format(dateTime);
  }
}
