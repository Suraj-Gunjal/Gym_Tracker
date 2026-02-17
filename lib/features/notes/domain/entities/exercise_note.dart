/// Exercise notes with form tips and personal customization.
class ExerciseNote {
  final String id;
  final String exerciseId;
  final String? userId;
  final String personalNotes;
  final List<String> formCues;
  final List<String> commonMistakes;
  final List<String> variations;
  final String? videoUrl;
  final String? gifUrl;
  final String muscleFocusTips;
  final String? breathingPattern;
  final String? tempoRecommendation;
  final bool isFavorite;
  final DateTime? lastUsedAt;
  final int timesPerformed;

  const ExerciseNote({
    required this.id,
    required this.exerciseId,
    this.userId,
    this.personalNotes = '',
    this.formCues = const [],
    this.commonMistakes = const [],
    this.variations = const [],
    this.videoUrl,
    this.gifUrl,
    this.muscleFocusTips = '',
    this.breathingPattern,
    this.tempoRecommendation,
    this.isFavorite = false,
    this.lastUsedAt,
    this.timesPerformed = 0,
  });

  /// Check if there are any form tips available.
  bool get hasFormTips => formCues.isNotEmpty || commonMistakes.isNotEmpty;

  /// Check if there's a video/gif available.
  bool get hasMedia => videoUrl != null || gifUrl != null;

  /// Tempo as a list of ints [eccentric, pause, concentric].
  List<int>? get tempoParsed {
    if (tempoRecommendation == null) return null;
    final parts = tempoRecommendation!.split('-');
    if (parts.length != 3) return null;
    return parts.map((p) => int.tryParse(p) ?? 0).toList();
  }

  ExerciseNote copyWith({
    String? id,
    String? exerciseId,
    String? userId,
    String? personalNotes,
    List<String>? formCues,
    List<String>? commonMistakes,
    List<String>? variations,
    String? videoUrl,
    String? gifUrl,
    String? muscleFocusTips,
    String? breathingPattern,
    String? tempoRecommendation,
    bool? isFavorite,
    DateTime? lastUsedAt,
    int? timesPerformed,
  }) {
    return ExerciseNote(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      userId: userId ?? this.userId,
      personalNotes: personalNotes ?? this.personalNotes,
      formCues: formCues ?? this.formCues,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      variations: variations ?? this.variations,
      videoUrl: videoUrl ?? this.videoUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      muscleFocusTips: muscleFocusTips ?? this.muscleFocusTips,
      breathingPattern: breathingPattern ?? this.breathingPattern,
      tempoRecommendation: tempoRecommendation ?? this.tempoRecommendation,
      isFavorite: isFavorite ?? this.isFavorite,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      timesPerformed: timesPerformed ?? this.timesPerformed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'userId': userId,
      'personalNotes': personalNotes,
      'formCues': formCues,
      'commonMistakes': commonMistakes,
      'variations': variations,
      'videoUrl': videoUrl,
      'gifUrl': gifUrl,
      'muscleFocusTips': muscleFocusTips,
      'breathingPattern': breathingPattern,
      'tempoRecommendation': tempoRecommendation,
      'isFavorite': isFavorite,
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'timesPerformed': timesPerformed,
    };
  }

  factory ExerciseNote.fromJson(Map<String, dynamic> json) {
    return ExerciseNote(
      id: json['id'] as String,
      exerciseId: json['exerciseId'] as String,
      userId: json['userId'] as String?,
      personalNotes: json['personalNotes'] as String? ?? '',
      formCues: (json['formCues'] as List<dynamic>?)?.cast<String>() ?? [],
      commonMistakes:
          (json['commonMistakes'] as List<dynamic>?)?.cast<String>() ?? [],
      variations: (json['variations'] as List<dynamic>?)?.cast<String>() ?? [],
      videoUrl: json['videoUrl'] as String?,
      gifUrl: json['gifUrl'] as String?,
      muscleFocusTips: json['muscleFocusTips'] as String? ?? '',
      breathingPattern: json['breathingPattern'] as String?,
      tempoRecommendation: json['tempoRecommendation'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.parse(json['lastUsedAt'] as String)
          : null,
      timesPerformed: json['timesPerformed'] as int? ?? 0,
    );
  }
}

/// Workout challenge entity.
class WorkoutChallenge {
  final String id;
  final String name;
  final String description;
  final ChallengeType type;
  final double targetValue;
  final double currentValue;
  final String unit;
  final int durationDays;
  final DateTime startDate;
  final DateTime endDate;
  final int xpReward;
  final String? badgeId;
  final bool isActive;
  final bool isCompleted;
  final int difficulty;
  final String iconName;
  final String color;

  const WorkoutChallenge({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    required this.unit,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    this.xpReward = 100,
    this.badgeId,
    this.isActive = true,
    this.isCompleted = false,
    this.difficulty = 3,
    this.iconName = 'fitness_center',
    this.color = '#6366F1',
  });

  /// Progress as percentage (0.0 - 1.0).
  double get progress => (currentValue / targetValue).clamp(0.0, 1.0);

  /// Days remaining.
  int get daysRemaining {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  /// Is challenge expired?
  bool get isExpired => DateTime.now().isAfter(endDate);

  /// Is challenge in progress?
  bool get isInProgress => isActive && !isCompleted && !isExpired;

  /// Difficulty stars string.
  String get difficultyStars => '★' * difficulty + '☆' * (5 - difficulty);

  WorkoutChallenge copyWith({
    String? id,
    String? name,
    String? description,
    ChallengeType? type,
    double? targetValue,
    double? currentValue,
    String? unit,
    int? durationDays,
    DateTime? startDate,
    DateTime? endDate,
    int? xpReward,
    String? badgeId,
    bool? isActive,
    bool? isCompleted,
    int? difficulty,
    String? iconName,
    String? color,
  }) {
    return WorkoutChallenge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unit: unit ?? this.unit,
      durationDays: durationDays ?? this.durationDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      xpReward: xpReward ?? this.xpReward,
      badgeId: badgeId ?? this.badgeId,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
      difficulty: difficulty ?? this.difficulty,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
    );
  }
}

/// Challenge types.
enum ChallengeType {
  volume, // Total weight lifted
  frequency, // Number of workouts
  streak, // Consecutive days
  strength, // Hit a specific PR
  time, // Total workout time
  exercise, // Perform specific exercise X times
}

/// Leaderboard entry for challenges.
class LeaderboardEntry {
  final String id;
  final String challengeId;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final double score;
  final int rank;
  final DateTime? completedAt;

  const LeaderboardEntry({
    required this.id,
    required this.challengeId,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.score,
    required this.rank,
    this.completedAt,
  });

  /// Whether entry has completed the challenge.
  bool get hasCompleted => completedAt != null;
}

/// Default form tips for common exercises.
class DefaultFormTips {
  static const Map<String, ExerciseNote> tips = {
    'bench_press': ExerciseNote(
      id: 'default_bench_press',
      exerciseId: 'bench_press',
      formCues: [
        'Retract shoulder blades and arch upper back',
        'Plant feet firmly on ground',
        'Grip bar slightly wider than shoulder width',
        'Lower bar to mid-chest with control',
        'Press up and slightly back toward rack',
        'Keep wrists straight throughout',
      ],
      commonMistakes: [
        'Bouncing bar off chest',
        'Flaring elbows too wide',
        'Lifting hips off bench',
        'Not keeping shoulder blades retracted',
        'Pressing bar straight up instead of arc',
      ],
      variations: ['Barbell', 'Dumbbell', 'Incline', 'Decline', 'Close-grip'],
      breathingPattern: 'Inhale on descent, hold at bottom, exhale on press',
      tempoRecommendation: '3-1-2',
      muscleFocusTips:
          'Focus on squeezing chest at top of movement. Feel stretch at bottom.',
    ),
    'squat': ExerciseNote(
      id: 'default_squat',
      exerciseId: 'squat',
      formCues: [
        'Brace core before descent',
        'Push knees out over toes',
        'Keep chest up and back neutral',
        'Hit parallel or below',
        'Drive through whole foot',
        'Stand tall and squeeze glutes at top',
      ],
      commonMistakes: [
        'Knees caving inward',
        'Leaning too far forward',
        'Not hitting depth',
        'Rounding lower back',
        'Rising on toes',
      ],
      variations: [
        'Back Squat',
        'Front Squat',
        'Goblet',
        'Bulgarian Split',
        'Hack Squat',
      ],
      breathingPattern: 'Big breath at top, hold through rep, exhale at top',
      tempoRecommendation: '3-1-1',
      muscleFocusTips:
          'Feel quads stretch at bottom. Drive through heels for glute emphasis.',
    ),
    'deadlift': ExerciseNote(
      id: 'default_deadlift',
      exerciseId: 'deadlift',
      formCues: [
        'Bar over mid-foot',
        'Hinge at hips, not squat down',
        'Pull slack out of bar',
        'Brace core and lift chest',
        'Push floor away with legs',
        'Lock out with hips, not back',
      ],
      commonMistakes: [
        'Starting with hips too low (squatting)',
        'Rounding lower back',
        'Bar drifting from body',
        'Hyperextending at lockout',
        'Jerking the bar off floor',
      ],
      variations: ['Conventional', 'Sumo', 'Romanian', 'Trap Bar', 'Deficit'],
      breathingPattern: 'Breath at top, brace down, exhale after lockout',
      tempoRecommendation: '2-0-1',
      muscleFocusTips:
          'Feel hamstrings load on descent. Drive hips forward at top.',
    ),
    'pull_up': ExerciseNote(
      id: 'default_pull_up',
      exerciseId: 'pull_up',
      formCues: [
        'Start from dead hang',
        'Depress shoulders first',
        'Pull elbows down and back',
        'Chin over bar at top',
        'Control the descent',
        'Full extension at bottom',
      ],
      commonMistakes: [
        'Using momentum/kipping',
        'Not going full range',
        'Shrugging shoulders at top',
        'Swinging body',
        'Partial reps',
      ],
      variations: [
        'Chin-up',
        'Wide grip',
        'Neutral grip',
        'Assisted',
        'Weighted',
      ],
      breathingPattern: 'Exhale on pull, inhale on descent',
      tempoRecommendation: '1-1-3',
      muscleFocusTips:
          'Initiate with lats, not biceps. Feel back squeeze at top.',
    ),
    'overhead_press': ExerciseNote(
      id: 'default_ohp',
      exerciseId: 'overhead_press',
      formCues: [
        'Grip just outside shoulders',
        'Brace core tight',
        'Press bar straight up',
        'Move head back then forward',
        'Lock out overhead',
        'Stack bar over mid-foot',
      ],
      commonMistakes: [
        'Excessive back arch',
        'Pressing in front of face',
        'Not locking out fully',
        'Flared elbows at bottom',
        'Using leg drive (unless push press)',
      ],
      variations: [
        'Barbell',
        'Dumbbell',
        'Seated',
        'Push Press',
        'Arnold Press',
      ],
      breathingPattern: 'Breath at bottom, press on exhale',
      tempoRecommendation: '2-0-2',
      muscleFocusTips:
          'Feel shoulders working. Keep tension in traps at lockout.',
    ),
    'barbell_row': ExerciseNote(
      id: 'default_row',
      exerciseId: 'barbell_row',
      formCues: [
        'Hinge to ~45 degrees',
        'Keep back flat/neutral',
        'Pull to lower chest/upper belly',
        'Squeeze shoulder blades together',
        'Control the negative',
        'Let arms extend fully',
      ],
      commonMistakes: [
        'Standing too upright',
        'Using momentum',
        'Not retracting scapula',
        'Pulling too high or low',
        'Rounding back',
      ],
      variations: [
        'Pendlay Row',
        'Dumbbell Row',
        'T-Bar Row',
        'Meadows Row',
        'Cable Row',
      ],
      breathingPattern: 'Exhale on pull, inhale on lower',
      tempoRecommendation: '1-1-2',
      muscleFocusTips:
          'Think about pulling elbows back, not hands. Feel lats engage.',
    ),
  };

  /// Get form tips for an exercise by name (lowercase, underscore-separated).
  static ExerciseNote? getTips(String exerciseName) {
    final key = exerciseName.toLowerCase().replaceAll(' ', '_');
    return tips[key];
  }
}
