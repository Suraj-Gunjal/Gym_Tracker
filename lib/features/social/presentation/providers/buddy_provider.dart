import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/sharing.dart';

part 'buddy_provider.g.dart';

/// Provider for share card generation.
@riverpod
class ShareCardNotifier extends _$ShareCardNotifier {
  @override
  WorkoutShareCard? build() {
    return null;
  }

  void generateCard({
    required String workoutId,
    required String workoutName,
    required Duration duration,
    required List<String> exercises,
    required double totalVolume,
    required int totalSets,
    List<PRHighlight> prs = const [],
    String? note,
  }) {
    state = WorkoutShareCard(
      id: workoutId,
      oderId: 'user_1',
      userName: 'GymWarrior',
      workoutDate: DateTime.now(),
      workoutName: workoutName,
      duration: duration,
      exerciseCount: exercises.length,
      totalSets: totalSets,
      totalVolume: totalVolume,
      exerciseNames: exercises,
      prHighlights: prs,
      note: note,
      theme: ShareCardTheme.dark,
    );
  }

  void setTheme(ShareCardTheme theme) {
    if (state != null) {
      state = WorkoutShareCard(
        id: state!.id,
        oderId: state!.oderId,
        userName: state!.userName,
        avatarUrl: state!.avatarUrl,
        workoutDate: state!.workoutDate,
        workoutName: state!.workoutName,
        duration: state!.duration,
        exerciseCount: state!.exerciseCount,
        totalSets: state!.totalSets,
        totalVolume: state!.totalVolume,
        exerciseNames: state!.exerciseNames,
        prHighlights: state!.prHighlights,
        note: state!.note,
        theme: theme,
      );
    }
  }

  void clear() {
    state = null;
  }
}

/// Provider for nearby gym buddies.
@riverpod
class NearbyBuddiesNotifier extends _$NearbyBuddiesNotifier {
  @override
  List<GymBuddy> build() {
    return _generateMockBuddies();
  }

  List<GymBuddy> _generateMockBuddies() {
    final random = Random(42);
    final names = [
      'FitnessPro',
      'IronWill',
      'GymRat99',
      'LiftMaster',
      'SwolePatrol',
      'BeastMode',
      'GainsTrain',
      'RepKing',
      'FitFam',
      'GymBeast',
    ];
    final gyms = [
      'Iron Paradise',
      'FitLife 24',
      'Gold\'s Gym',
      'Planet Fitness',
    ];
    final styles = TrainingStyle.values;
    final times = WorkoutTime.values;
    final days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];

    return List.generate(10, (i) {
      final stylesToAdd = <String>[];
      for (int j = 0; j < 2 + random.nextInt(2); j++) {
        stylesToAdd.add(styles[random.nextInt(styles.length)].label);
      }

      return GymBuddy(
        id: 'buddy_$i',
        name: names[i],
        level: 10 + random.nextInt(50),
        homeGym: gyms[random.nextInt(gyms.length)],
        workoutDays: days.sublist(0, 3 + random.nextInt(4)),
        preferredTimes: [times[random.nextInt(times.length)].label],
        trainingStyles: stylesToAdd,
        experienceYears: 1 + random.nextInt(10),
        bio: i % 2 == 0 ? 'Looking for a lifting partner!' : null,
        compatibility: 50 + random.nextDouble() * 50,
        distance: 0.5 + random.nextDouble() * 9.5,
        isOnline: random.nextBool(),
        lastActive: DateTime.now().subtract(
          Duration(hours: random.nextInt(48)),
        ),
      );
    })..sort((a, b) => b.compatibility.compareTo(a.compatibility));
  }

  void refresh() {
    state = _generateMockBuddies();
  }
}

/// Provider for buddy preferences.
@riverpod
class BuddyPreferencesNotifier extends _$BuddyPreferencesNotifier {
  @override
  BuddyPreferences build() {
    return const BuddyPreferences(
      preferredStyles: [TrainingStyle.powerlifting, TrainingStyle.bodybuilding],
      preferredTimes: [WorkoutTime.evening],
      preferredDays: ['monday', 'wednesday', 'friday'],
      maxDistance: 10,
    );
  }

  void updatePreferences(BuddyPreferences preferences) {
    state = preferences;
  }

  void toggleStyle(TrainingStyle style) {
    final styles = List<TrainingStyle>.from(state.preferredStyles);
    if (styles.contains(style)) {
      styles.remove(style);
    } else {
      styles.add(style);
    }
    state = state.copyWith(preferredStyles: styles);
  }

  void toggleTime(WorkoutTime time) {
    final times = List<WorkoutTime>.from(state.preferredTimes);
    if (times.contains(time)) {
      times.remove(time);
    } else {
      times.add(time);
    }
    state = state.copyWith(preferredTimes: times);
  }

  void setMaxDistance(int distance) {
    state = state.copyWith(maxDistance: distance);
  }
}

/// Provider for buddy requests.
@riverpod
class BuddyRequestsNotifier extends _$BuddyRequestsNotifier {
  @override
  List<BuddyRequest> build() {
    return [
      BuddyRequest(
        id: '1',
        fromUserId: 'buddy_3',
        fromUserName: 'LiftMaster',
        toUserId: 'user_1',
        message: 'Hey! Looking for a lifting partner for leg days.',
        status: BuddyRequestStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  void sendRequest(String toUserId, {String? message}) {
    state = [
      BuddyRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fromUserId: 'user_1',
        fromUserName: 'You',
        toUserId: toUserId,
        message: message,
        status: BuddyRequestStatus.pending,
        createdAt: DateTime.now(),
      ),
      ...state,
    ];
  }

  void acceptRequest(String requestId) {
    state = state.map((r) {
      if (r.id == requestId) {
        return BuddyRequest(
          id: r.id,
          fromUserId: r.fromUserId,
          fromUserName: r.fromUserName,
          fromUserAvatar: r.fromUserAvatar,
          toUserId: r.toUserId,
          message: r.message,
          status: BuddyRequestStatus.accepted,
          createdAt: r.createdAt,
        );
      }
      return r;
    }).toList();
  }

  void declineRequest(String requestId) {
    state = state.map((r) {
      if (r.id == requestId) {
        return BuddyRequest(
          id: r.id,
          fromUserId: r.fromUserId,
          fromUserName: r.fromUserName,
          fromUserAvatar: r.fromUserAvatar,
          toUserId: r.toUserId,
          message: r.message,
          status: BuddyRequestStatus.declined,
          createdAt: r.createdAt,
        );
      }
      return r;
    }).toList();
  }
}

/// Provider for connected buddies.
@riverpod
class ConnectedBuddiesNotifier extends _$ConnectedBuddiesNotifier {
  @override
  List<GymBuddy> build() {
    return [];
  }

  void addBuddy(GymBuddy buddy) {
    if (!state.any((b) => b.id == buddy.id)) {
      state = [...state, buddy];
    }
  }

  void removeBuddy(String buddyId) {
    state = state.where((b) => b.id != buddyId).toList();
  }
}

/// Provider for live workout sessions.
@riverpod
class LiveSessionsNotifier extends _$LiveSessionsNotifier {
  @override
  List<LiveWorkoutSession> build() {
    return [
      LiveWorkoutSession(
        id: 'live_1',
        oderId: 'buddy_1',
        userName: 'FitnessPro',
        workoutName: 'Push Day',
        startTime: DateTime.now().subtract(const Duration(minutes: 32)),
        currentExercise: 'Incline Dumbbell Press',
        currentSet: 3,
        totalSets: 4,
        viewerCount: 5,
        participantIds: [],
      ),
      LiveWorkoutSession(
        id: 'live_2',
        oderId: 'buddy_5',
        userName: 'SwolePatrol',
        workoutName: 'Leg Day',
        startTime: DateTime.now().subtract(const Duration(minutes: 15)),
        currentExercise: 'Barbell Squat',
        currentSet: 2,
        totalSets: 5,
        viewerCount: 3,
        participantIds: [],
      ),
    ];
  }

  void startSession({required String workoutName, bool isPublic = true}) {
    state = [
      LiveWorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        oderId: 'user_1',
        userName: 'You',
        workoutName: workoutName,
        startTime: DateTime.now(),
        currentExercise: 'Warming up...',
        currentSet: 0,
        totalSets: 0,
        viewerCount: 0,
        isPublic: isPublic,
        participantIds: [],
      ),
      ...state,
    ];
  }

  void endSession(String sessionId) {
    state = state.where((s) => s.id != sessionId).toList();
  }

  void updateProgress(
    String sessionId,
    String exercise,
    int set,
    int totalSets,
  ) {
    state = state.map((s) {
      if (s.id == sessionId) {
        return LiveWorkoutSession(
          id: s.id,
          oderId: s.oderId,
          userName: s.userName,
          avatarUrl: s.avatarUrl,
          workoutName: s.workoutName,
          startTime: s.startTime,
          currentExercise: exercise,
          currentSet: set,
          totalSets: totalSets,
          viewerCount: s.viewerCount,
          isPublic: s.isPublic,
          participantIds: s.participantIds,
        );
      }
      return s;
    }).toList();
  }
}

/// Provider for pending request count.
@riverpod
int pendingRequestCount(ref) {
  final requests = ref.watch(buddyRequestsNotifierProvider);
  return requests
      .where(
        (r) => r.status == BuddyRequestStatus.pending && r.toUserId == 'user_1',
      )
      .length;
}
