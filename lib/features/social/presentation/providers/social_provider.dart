import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/social_entity.dart';

part 'social_provider.g.dart';

/// Provider for social feed.
@riverpod
class SocialFeed extends _$SocialFeed {
  @override
  FeedState build() {
    _loadFeed();
    return const FeedState(isLoading: true);
  }

  Future<void> _loadFeed() async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock data - In production, fetch from Supabase
    final posts = _generateMockFeed();
    state = state.copyWith(
      posts: posts,
      isLoading: false,
      hasMore: true,
      lastFetched: DateTime.now(),
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadFeed();
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true);

    await Future.delayed(const Duration(milliseconds: 500));

    final morePosts = _generateMockFeed(offset: state.posts.length);
    state = state.copyWith(
      posts: [...state.posts, ...morePosts],
      isLoading: false,
      hasMore: morePosts.isNotEmpty,
    );
  }

  void toggleLike(String postId) {
    final posts = state.posts.map((post) {
      if (post.id == postId) {
        return post.copyWith(
          isLiked: !post.isLiked,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
        );
      }
      return post;
    }).toList();
    state = state.copyWith(posts: posts);
  }

  List<SharedWorkout> _generateMockFeed({int offset = 0}) {
    final profiles = _mockProfiles;
    final workouts = <SharedWorkout>[];
    final uuid = const Uuid();

    for (var i = 0; i < 10; i++) {
      final profile = profiles[i % profiles.length];
      final hoursAgo = offset + i * 3;
      workouts.add(
        SharedWorkout(
          id: uuid.v4(),
          userId: profile.userId,
          workoutId: uuid.v4(),
          author: profile,
          workout: WorkoutSummary(
            id: uuid.v4(),
            name: _workoutNames[i % _workoutNames.length],
            duration: Duration(minutes: 45 + (i * 5) % 60),
            exerciseCount: 4 + i % 4,
            setCount: 12 + i % 8,
            totalVolume: 5000.0 + (i * 500),
            prCount: i % 3 == 0 ? 1 + i % 2 : null,
            exerciseNames: _getExercisesForWorkout(i),
            completedAt: DateTime.now().subtract(Duration(hours: hoursAgo)),
          ),
          caption: i % 2 == 0 ? _captions[i % _captions.length] : null,
          likesCount: 5 + (i * 3) % 50,
          commentsCount: 1 + i % 10,
          isLiked: i % 3 == 0,
          visibility: PostVisibility.public,
          createdAt: DateTime.now().subtract(Duration(hours: hoursAgo)),
        ),
      );
    }

    return workouts;
  }
}

/// Provider for user profile.
@riverpod
class UserProfile extends _$UserProfile {
  @override
  SocialProfile? build() {
    return _mockProfiles.first.copyWith(followStatus: FollowStatus.none);
  }

  void updateProfile({
    String? displayName,
    String? bio,
    String? avatarUrl,
    bool? isPublic,
  }) {
    if (state == null) return;
    state = state!.copyWith(
      displayName: displayName,
      bio: bio,
      avatarUrl: avatarUrl,
      isPublic: isPublic,
    );
  }
}

/// Provider for activity feed.
@riverpod
class ActivityFeedNotifier extends _$ActivityFeedNotifier {
  @override
  List<ActivityItem> build() {
    return _generateMockActivity();
  }

  void markAsRead(String id) {
    state = state.map((item) {
      if (item.id == id) {
        return ActivityItem(
          id: item.id,
          userId: item.userId,
          actor: item.actor,
          type: item.type,
          referenceId: item.referenceId,
          referenceType: item.referenceType,
          message: item.message,
          isRead: true,
          createdAt: item.createdAt,
        );
      }
      return item;
    }).toList();
  }

  void markAllAsRead() {
    state = state.map((item) {
      return ActivityItem(
        id: item.id,
        userId: item.userId,
        actor: item.actor,
        type: item.type,
        referenceId: item.referenceId,
        referenceType: item.referenceType,
        message: item.message,
        isRead: true,
        createdAt: item.createdAt,
      );
    }).toList();
  }

  List<ActivityItem> _generateMockActivity() {
    final uuid = const Uuid();
    final profiles = _mockProfiles;
    final activities = <ActivityItem>[];
    final types = ActivityType.values;

    for (var i = 0; i < 15; i++) {
      final profile = profiles[i % profiles.length];
      final type = types[i % types.length];
      activities.add(
        ActivityItem(
          id: uuid.v4(),
          userId: 'current_user',
          actor: profile,
          type: type,
          referenceId: uuid.v4(),
          referenceType: _getReferenceType(type),
          message: _getActivityMessage(type, profile.displayName),
          isRead: i > 5,
          createdAt: DateTime.now().subtract(Duration(hours: i * 2)),
        ),
      );
    }

    return activities;
  }
}

/// Provider for followers/following lists.
@riverpod
class FollowList extends _$FollowList {
  @override
  List<SocialProfile> build(String type) {
    // type: 'followers' or 'following'
    return _mockProfiles.map((p) {
      return p.copyWith(
        followStatus: type == 'following'
            ? FollowStatus.following
            : FollowStatus.followers,
      );
    }).toList();
  }

  void toggleFollow(String userId) {
    state = state.map((profile) {
      if (profile.userId == userId) {
        final newStatus = profile.followStatus == FollowStatus.following
            ? FollowStatus.none
            : FollowStatus.following;
        return profile.copyWith(followStatus: newStatus);
      }
      return profile;
    }).toList();
  }
}

/// Provider for discover users.
@riverpod
class DiscoverUsers extends _$DiscoverUsers {
  @override
  Future<List<SocialProfile>> build() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProfiles
        .map((p) => p.copyWith(followStatus: FollowStatus.none))
        .toList();
  }

  void toggleFollow(String userId) {
    state.whenData((profiles) {
      final updated = profiles.map((profile) {
        if (profile.userId == userId) {
          final newStatus = profile.followStatus == FollowStatus.following
              ? FollowStatus.none
              : FollowStatus.following;
          return profile.copyWith(followStatus: newStatus);
        }
        return profile;
      }).toList();
      state = AsyncData(updated);
    });
  }
}

// Helper data
final _mockProfiles = [
  SocialProfile(
    id: '1',
    userId: 'user_1',
    displayName: 'Alex Thompson',
    username: 'alexlifts',
    bio: '🏋️ Powerlifting enthusiast | 500kg total club | Always chasing PRs',
    avatarUrl: null,
    totalWorkouts: 234,
    totalPRs: 45,
    followersCount: 1205,
    followingCount: 389,
    isPublic: true,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    updatedAt: DateTime.now(),
  ),
  SocialProfile(
    id: '2',
    userId: 'user_2',
    displayName: 'Sarah Chen',
    username: 'sarahgains',
    bio: '💪 IFBB Pro | Online Coach | Transform your physique',
    avatarUrl: null,
    totalWorkouts: 456,
    totalPRs: 89,
    followersCount: 25400,
    followingCount: 234,
    isPublic: true,
    createdAt: DateTime.now().subtract(const Duration(days: 500)),
    updatedAt: DateTime.now(),
  ),
  SocialProfile(
    id: '3',
    userId: 'user_3',
    displayName: 'Mike Rodriguez',
    username: 'mikefit',
    bio: 'CrossFit athlete | Love pushing limits',
    avatarUrl: null,
    totalWorkouts: 189,
    totalPRs: 32,
    followersCount: 892,
    followingCount: 456,
    isPublic: true,
    createdAt: DateTime.now().subtract(const Duration(days: 200)),
    updatedAt: DateTime.now(),
  ),
  SocialProfile(
    id: '4',
    userId: 'user_4',
    displayName: 'Emma Williams',
    username: 'emmastrength',
    bio: '🏆 National champion | Strength coach',
    avatarUrl: null,
    totalWorkouts: 567,
    totalPRs: 112,
    followersCount: 8900,
    followingCount: 178,
    isPublic: true,
    createdAt: DateTime.now().subtract(const Duration(days: 600)),
    updatedAt: DateTime.now(),
  ),
  SocialProfile(
    id: '5',
    userId: 'user_5',
    displayName: 'James Park',
    username: 'jameslifts',
    bio: 'Just a regular guy trying to get strong 💪',
    avatarUrl: null,
    totalWorkouts: 78,
    totalPRs: 15,
    followersCount: 234,
    followingCount: 567,
    isPublic: true,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
    updatedAt: DateTime.now(),
  ),
];

const _workoutNames = [
  'Push Day',
  'Pull Day',
  'Leg Day',
  'Upper Body',
  'Lower Body',
  'Full Body',
  'Chest & Triceps',
  'Back & Biceps',
  'Shoulders & Arms',
  'Squat Focus',
];

const _captions = [
  '💪 New PR on bench today! Finally hit 100kg!',
  'Legs are going to be sore tomorrow 😅',
  'Consistency is key! Day 100 of my journey',
  'Morning workouts hit different ☀️',
  'Pushed through a tough one today. Mind over matter! 🧠',
  'Back in the gym after a week off. Felt great!',
  'Progressive overload is the way 📈',
  'Sunday gains 💪 No rest days!',
];

List<String> _getExercisesForWorkout(int index) {
  final exercises = [
    [
      'Bench Press',
      'Incline Dumbbell Press',
      'Tricep Pushdowns',
      'Lateral Raises',
    ],
    ['Deadlift', 'Barbell Rows', 'Pull-ups', 'Bicep Curls'],
    ['Squat', 'Leg Press', 'Romanian Deadlift', 'Leg Curls'],
    ['Overhead Press', 'Bench Press', 'Rows', 'Face Pulls'],
    ['Squat', 'Hip Thrust', 'Lunges', 'Calf Raises'],
  ];
  return exercises[index % exercises.length];
}

String _getReferenceType(ActivityType type) {
  switch (type) {
    case ActivityType.like:
    case ActivityType.comment:
      return 'workout';
    case ActivityType.follow:
      return 'user';
    case ActivityType.prBeat:
      return 'pr';
    case ActivityType.badge:
      return 'achievement';
    case ActivityType.mention:
      return 'comment';
  }
}

String _getActivityMessage(ActivityType type, String name) {
  switch (type) {
    case ActivityType.like:
      return '$name liked your workout';
    case ActivityType.comment:
      return '$name commented on your workout';
    case ActivityType.follow:
      return '$name started following you';
    case ActivityType.prBeat:
      return '$name beat your PR on Bench Press!';
    case ActivityType.badge:
      return '$name earned the "Century Club" badge';
    case ActivityType.mention:
      return '$name mentioned you in a comment';
  }
}
