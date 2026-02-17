/// Social sharing and buddy finder entities.

/// Shareable workout card.
class WorkoutShareCard {
  final String id;
  final String oderId;
  final String userName;
  final String? avatarUrl;
  final DateTime workoutDate;
  final String workoutName;
  final Duration duration;
  final int exerciseCount;
  final int totalSets;
  final double totalVolume;
  final List<String> exerciseNames;
  final List<PRHighlight> prHighlights;
  final String? note;
  final ShareCardTheme theme;

  const WorkoutShareCard({
    required this.id,
    required this.oderId,
    required this.userName,
    this.avatarUrl,
    required this.workoutDate,
    required this.workoutName,
    required this.duration,
    required this.exerciseCount,
    required this.totalSets,
    required this.totalVolume,
    required this.exerciseNames,
    required this.prHighlights,
    this.note,
    this.theme = ShareCardTheme.dark,
  });

  String get durationDisplay {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  String get volumeDisplay {
    if (totalVolume >= 1000) {
      return '${(totalVolume / 1000).toStringAsFixed(1)}k kg';
    }
    return '${totalVolume.toStringAsFixed(0)} kg';
  }
}

/// PR highlight for share card.
class PRHighlight {
  final String exerciseName;
  final double weight;
  final int reps;
  final bool isAllTimePR;

  const PRHighlight({
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.isAllTimePR,
  });
}

/// Share card visual theme.
enum ShareCardTheme {
  dark(0xFF1A1A2E, 0xFFFFFFFF, 0xFF6C63FF),
  light(0xFFF5F5F5, 0xFF1A1A2E, 0xFF6C63FF),
  gradient(0xFF667EEA, 0xFFFFFFFF, 0xFFFFFFFF),
  neon(0xFF0D0D0D, 0xFF00FF87, 0xFFFF00E5),
  minimal(0xFFFFFFFF, 0xFF000000, 0xFF000000);

  final int backgroundColor;
  final int textColor;
  final int accentColor;

  const ShareCardTheme(this.backgroundColor, this.textColor, this.accentColor);
}

/// Gym buddy profile.
class GymBuddy {
  final String id;
  final String name;
  final String? avatarUrl;
  final int level;
  final String homeGym;
  final List<String> workoutDays; // ['monday', 'wednesday', 'friday']
  final List<String> preferredTimes; // ['morning', 'evening']
  final List<String> trainingStyles; // ['powerlifting', 'bodybuilding']
  final int experienceYears;
  final String? bio;
  final double compatibility; // 0-100 match score
  final double distance; // km from user
  final bool isOnline;
  final DateTime? lastActive;

  const GymBuddy({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.level,
    required this.homeGym,
    required this.workoutDays,
    required this.preferredTimes,
    required this.trainingStyles,
    required this.experienceYears,
    this.bio,
    required this.compatibility,
    required this.distance,
    this.isOnline = false,
    this.lastActive,
  });
}

/// Buddy request status.
enum BuddyRequestStatus {
  pending('Pending', 0xFFF59E0B),
  accepted('Accepted', 0xFF22C55E),
  declined('Declined', 0xFFEF4444);

  final String label;
  final int colorValue;

  const BuddyRequestStatus(this.label, this.colorValue);
}

/// Buddy connection request.
class BuddyRequest {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String? fromUserAvatar;
  final String toUserId;
  final String? message;
  final BuddyRequestStatus status;
  final DateTime createdAt;

  const BuddyRequest({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    this.fromUserAvatar,
    required this.toUserId,
    this.message,
    required this.status,
    required this.createdAt,
  });
}

/// Training styles for matching.
enum TrainingStyle {
  powerlifting('Powerlifting', '🏋️'),
  bodybuilding('Bodybuilding', '💪'),
  crossfit('CrossFit', '🔥'),
  calisthenics('Calisthenics', '🤸'),
  strongman('Strongman', '🦍'),
  weightLifting('Olympic Lifting', '🥇'),
  functional('Functional', '⚙️'),
  hybrid('Hybrid', '🔄');

  final String label;
  final String emoji;

  const TrainingStyle(this.label, this.emoji);
}

/// Preferred workout times.
enum WorkoutTime {
  earlyMorning('Early Morning', '5-7 AM', '🌅'),
  morning('Morning', '7-10 AM', '☀️'),
  midday('Midday', '10 AM-2 PM', '🌤️'),
  afternoon('Afternoon', '2-5 PM', '🌇'),
  evening('Evening', '5-8 PM', '🌆'),
  night('Night', '8-11 PM', '🌙');

  final String label;
  final String timeRange;
  final String emoji;

  const WorkoutTime(this.label, this.timeRange, this.emoji);
}

/// User's buddy preferences.
class BuddyPreferences {
  final List<TrainingStyle> preferredStyles;
  final List<WorkoutTime> preferredTimes;
  final List<String> preferredDays;
  final int maxDistance; // km
  final int? minExperience; // years
  final int? maxExperience;
  final String? preferredGym;

  const BuddyPreferences({
    required this.preferredStyles,
    required this.preferredTimes,
    required this.preferredDays,
    this.maxDistance = 10,
    this.minExperience,
    this.maxExperience,
    this.preferredGym,
  });

  BuddyPreferences copyWith({
    List<TrainingStyle>? preferredStyles,
    List<WorkoutTime>? preferredTimes,
    List<String>? preferredDays,
    int? maxDistance,
    int? minExperience,
    int? maxExperience,
    String? preferredGym,
  }) {
    return BuddyPreferences(
      preferredStyles: preferredStyles ?? this.preferredStyles,
      preferredTimes: preferredTimes ?? this.preferredTimes,
      preferredDays: preferredDays ?? this.preferredDays,
      maxDistance: maxDistance ?? this.maxDistance,
      minExperience: minExperience ?? this.minExperience,
      maxExperience: maxExperience ?? this.maxExperience,
      preferredGym: preferredGym ?? this.preferredGym,
    );
  }
}

/// Live workout session.
class LiveWorkoutSession {
  final String id;
  final String oderId;
  final String userName;
  final String? avatarUrl;
  final String workoutName;
  final DateTime startTime;
  final String currentExercise;
  final int currentSet;
  final int totalSets;
  final int viewerCount;
  final bool isPublic;
  final List<String> participantIds;

  const LiveWorkoutSession({
    required this.id,
    required this.oderId,
    required this.userName,
    this.avatarUrl,
    required this.workoutName,
    required this.startTime,
    required this.currentExercise,
    required this.currentSet,
    required this.totalSets,
    required this.viewerCount,
    this.isPublic = true,
    required this.participantIds,
  });

  Duration get elapsed => DateTime.now().difference(startTime);
}
