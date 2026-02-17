import 'package:flutter/material.dart';

/// Enum for follow status.
enum FollowStatus { none, pending, following, followers, mutual }

/// Enum for post visibility.
enum PostVisibility {
  public,
  followers,
  private;

  String get label {
    switch (this) {
      case PostVisibility.public:
        return 'Public';
      case PostVisibility.followers:
        return 'Followers';
      case PostVisibility.private:
        return 'Private';
    }
  }

  IconData get icon {
    switch (this) {
      case PostVisibility.public:
        return Icons.public;
      case PostVisibility.followers:
        return Icons.people;
      case PostVisibility.private:
        return Icons.lock;
    }
  }
}

/// Enum for activity types.
enum ActivityType {
  like,
  comment,
  follow,
  prBeat,
  badge,
  mention;

  IconData get icon {
    switch (this) {
      case ActivityType.like:
        return Icons.favorite;
      case ActivityType.comment:
        return Icons.chat_bubble;
      case ActivityType.follow:
        return Icons.person_add;
      case ActivityType.prBeat:
        return Icons.emoji_events;
      case ActivityType.badge:
        return Icons.military_tech;
      case ActivityType.mention:
        return Icons.alternate_email;
    }
  }

  Color get color {
    switch (this) {
      case ActivityType.like:
        return const Color(0xFFEF4444);
      case ActivityType.comment:
        return const Color(0xFF3B82F6);
      case ActivityType.follow:
        return const Color(0xFF10B981);
      case ActivityType.prBeat:
        return const Color(0xFFF59E0B);
      case ActivityType.badge:
        return const Color(0xFFA855F7);
      case ActivityType.mention:
        return const Color(0xFF6366F1);
    }
  }
}

/// Social profile entity.
class SocialProfile {
  final String id;
  final String userId;
  final String displayName;
  final String username;
  final String? bio;
  final String? avatarUrl;
  final int totalWorkouts;
  final int totalPRs;
  final int followersCount;
  final int followingCount;
  final bool isPublic;
  final FollowStatus followStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SocialProfile({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.username,
    this.bio,
    this.avatarUrl,
    this.totalWorkouts = 0,
    this.totalPRs = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.isPublic = true,
    this.followStatus = FollowStatus.none,
    required this.createdAt,
    required this.updatedAt,
  });

  SocialProfile copyWith({
    String? displayName,
    String? username,
    String? bio,
    String? avatarUrl,
    int? totalWorkouts,
    int? totalPRs,
    int? followersCount,
    int? followingCount,
    bool? isPublic,
    FollowStatus? followStatus,
  }) {
    return SocialProfile(
      id: id,
      userId: userId,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalPRs: totalPRs ?? this.totalPRs,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isPublic: isPublic ?? this.isPublic,
      followStatus: followStatus ?? this.followStatus,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// Shared workout post entity.
class SharedWorkout {
  final String id;
  final String userId;
  final String workoutId;
  final SocialProfile author;
  final WorkoutSummary workout;
  final String? caption;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final PostVisibility visibility;
  final DateTime createdAt;

  const SharedWorkout({
    required this.id,
    required this.userId,
    required this.workoutId,
    required this.author,
    required this.workout,
    this.caption,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.visibility = PostVisibility.public,
    required this.createdAt,
  });

  SharedWorkout copyWith({int? likesCount, int? commentsCount, bool? isLiked}) {
    return SharedWorkout(
      id: id,
      userId: userId,
      workoutId: workoutId,
      author: author,
      workout: workout,
      caption: caption,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      visibility: visibility,
      createdAt: createdAt,
    );
  }
}

/// Workout summary for feed display.
class WorkoutSummary {
  final String id;
  final String name;
  final Duration duration;
  final int exerciseCount;
  final int setCount;
  final double totalVolume;
  final int? prCount;
  final List<String> exerciseNames;
  final DateTime completedAt;

  const WorkoutSummary({
    required this.id,
    required this.name,
    required this.duration,
    required this.exerciseCount,
    required this.setCount,
    required this.totalVolume,
    this.prCount,
    required this.exerciseNames,
    required this.completedAt,
  });
}

/// Comment entity.
class WorkoutComment {
  final String id;
  final String userId;
  final String sharedWorkoutId;
  final SocialProfile author;
  final String content;
  final String? parentCommentId;
  final int likesCount;
  final bool isLiked;
  final List<WorkoutComment> replies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WorkoutComment({
    required this.id,
    required this.userId,
    required this.sharedWorkoutId,
    required this.author,
    required this.content,
    this.parentCommentId,
    this.likesCount = 0,
    this.isLiked = false,
    this.replies = const [],
    required this.createdAt,
    required this.updatedAt,
  });
}

/// Activity feed item entity.
class ActivityItem {
  final String id;
  final String userId;
  final SocialProfile actor;
  final ActivityType type;
  final String? referenceId;
  final String? referenceType;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const ActivityItem({
    required this.id,
    required this.userId,
    required this.actor,
    required this.type,
    this.referenceId,
    this.referenceType,
    required this.message,
    this.isRead = false,
    required this.createdAt,
  });
}

/// Feed state.
class FeedState {
  final List<SharedWorkout> posts;
  final bool isLoading;
  final bool hasMore;
  final String? error;
  final DateTime? lastFetched;

  const FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
    this.lastFetched,
  });

  FeedState copyWith({
    List<SharedWorkout>? posts,
    bool? isLoading,
    bool? hasMore,
    String? error,
    DateTime? lastFetched,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      lastFetched: lastFetched ?? this.lastFetched,
    );
  }
}
