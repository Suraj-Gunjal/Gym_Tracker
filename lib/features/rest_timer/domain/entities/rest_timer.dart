/// Domain entity for rest timer state.
class RestTimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isPaused;
  final DateTime? startedAt;
  final String? exerciseName;

  const RestTimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    this.isRunning = false,
    this.isPaused = false,
    this.startedAt,
    this.exerciseName,
  });

  /// Progress from 0.0 (full) to 1.0 (empty)
  double get progress => 1.0 - (remainingSeconds / totalSeconds);

  /// Remaining time as formatted string (MM:SS)
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Whether the timer is complete
  bool get isComplete => remainingSeconds <= 0;

  const RestTimerState.initial()
    : totalSeconds = 90,
      remainingSeconds = 90,
      isRunning = false,
      isPaused = false,
      startedAt = null,
      exerciseName = null;

  RestTimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    bool? isPaused,
    DateTime? startedAt,
    String? exerciseName,
  }) {
    return RestTimerState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      startedAt: startedAt ?? this.startedAt,
      exerciseName: exerciseName ?? this.exerciseName,
    );
  }
}

/// Rest timer settings entity.
class RestTimerSettings {
  final String id;
  final int defaultRestSeconds;
  final int compoundRestSeconds;
  final int isolationRestSeconds;
  final bool autoStartTimer;
  final bool vibrateOnComplete;
  final bool soundOnComplete;
  final String soundName;
  final bool showNotification;
  final DateTime updatedAt;

  const RestTimerSettings({
    required this.id,
    this.defaultRestSeconds = 90,
    this.compoundRestSeconds = 180,
    this.isolationRestSeconds = 60,
    this.autoStartTimer = true,
    this.vibrateOnComplete = true,
    this.soundOnComplete = true,
    this.soundName = 'bell',
    this.showNotification = true,
    required this.updatedAt,
  });

  const RestTimerSettings.defaults()
    : id = 'default',
      defaultRestSeconds = 90,
      compoundRestSeconds = 180,
      isolationRestSeconds = 60,
      autoStartTimer = true,
      vibrateOnComplete = true,
      soundOnComplete = true,
      soundName = 'bell',
      showNotification = true,
      updatedAt = const _EpochDateTime();

  RestTimerSettings copyWith({
    String? id,
    int? defaultRestSeconds,
    int? compoundRestSeconds,
    int? isolationRestSeconds,
    bool? autoStartTimer,
    bool? vibrateOnComplete,
    bool? soundOnComplete,
    String? soundName,
    bool? showNotification,
    DateTime? updatedAt,
  }) {
    return RestTimerSettings(
      id: id ?? this.id,
      defaultRestSeconds: defaultRestSeconds ?? this.defaultRestSeconds,
      compoundRestSeconds: compoundRestSeconds ?? this.compoundRestSeconds,
      isolationRestSeconds: isolationRestSeconds ?? this.isolationRestSeconds,
      autoStartTimer: autoStartTimer ?? this.autoStartTimer,
      vibrateOnComplete: vibrateOnComplete ?? this.vibrateOnComplete,
      soundOnComplete: soundOnComplete ?? this.soundOnComplete,
      soundName: soundName ?? this.soundName,
      showNotification: showNotification ?? this.showNotification,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Helper class for const DateTime
class _EpochDateTime implements DateTime {
  const _EpochDateTime();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
