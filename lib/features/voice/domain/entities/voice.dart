/// Enum for voice command categories.
enum VoiceCommandCategory {
  workout('Workout', 'workout'),
  timer('Timer', 'timer'),
  navigation('Navigation', 'navigation'),
  tracking('Tracking', 'tracking'),
  music('Music', 'music'),
  general('General', 'general');

  const VoiceCommandCategory(this.label, this.value);
  final String label;
  final String value;
}

/// Model representing a voice command.
class VoiceCommand {
  final String id;
  final String command;
  final List<String> aliases;
  final String description;
  final VoiceCommandCategory category;
  final String action;
  final Map<String, dynamic>? parameters;

  const VoiceCommand({
    required this.id,
    required this.command,
    this.aliases = const [],
    required this.description,
    required this.category,
    required this.action,
    this.parameters,
  });

  static const List<VoiceCommand> availableCommands = [
    // Workout commands
    VoiceCommand(
      id: 'start_workout',
      command: 'Start workout',
      aliases: ['begin workout', 'let\'s go', 'start training'],
      description: 'Start a new workout session',
      category: VoiceCommandCategory.workout,
      action: 'WORKOUT_START',
    ),
    VoiceCommand(
      id: 'finish_workout',
      command: 'Finish workout',
      aliases: ['end workout', 'I\'m done', 'complete workout'],
      description: 'End the current workout',
      category: VoiceCommandCategory.workout,
      action: 'WORKOUT_FINISH',
    ),
    VoiceCommand(
      id: 'next_set',
      command: 'Next set',
      aliases: ['done', 'set complete', 'finished set'],
      description: 'Log current set and move to next',
      category: VoiceCommandCategory.workout,
      action: 'SET_COMPLETE',
    ),
    VoiceCommand(
      id: 'skip_exercise',
      command: 'Skip exercise',
      aliases: ['next exercise', 'skip this'],
      description: 'Skip to the next exercise',
      category: VoiceCommandCategory.workout,
      action: 'EXERCISE_SKIP',
    ),
    VoiceCommand(
      id: 'add_set',
      command: 'Add set',
      aliases: ['one more set', 'extra set'],
      description: 'Add an additional set',
      category: VoiceCommandCategory.workout,
      action: 'SET_ADD',
    ),

    // Timer commands
    VoiceCommand(
      id: 'start_timer',
      command: 'Start timer',
      aliases: ['begin rest', 'rest timer'],
      description: 'Start the rest timer',
      category: VoiceCommandCategory.timer,
      action: 'TIMER_START',
    ),
    VoiceCommand(
      id: 'stop_timer',
      command: 'Stop timer',
      aliases: ['cancel timer', 'end timer'],
      description: 'Stop the current timer',
      category: VoiceCommandCategory.timer,
      action: 'TIMER_STOP',
    ),
    VoiceCommand(
      id: 'add_time',
      command: 'Add thirty seconds',
      aliases: ['add time', 'more time', 'extend rest'],
      description: 'Add 30 seconds to timer',
      category: VoiceCommandCategory.timer,
      action: 'TIMER_ADD',
      parameters: {'seconds': 30},
    ),

    // Tracking commands
    VoiceCommand(
      id: 'log_weight',
      command: 'Log weight [number]',
      aliases: ['set weight', 'weight is'],
      description: 'Log the weight for current set',
      category: VoiceCommandCategory.tracking,
      action: 'LOG_WEIGHT',
    ),
    VoiceCommand(
      id: 'log_reps',
      command: 'Log [number] reps',
      aliases: ['did [number] reps', '[number] reps'],
      description: 'Log reps for current set',
      category: VoiceCommandCategory.tracking,
      action: 'LOG_REPS',
    ),
    VoiceCommand(
      id: 'set_rpe',
      command: 'RPE [number]',
      aliases: ['effort [number]', 'rate [number]'],
      description: 'Set RPE for current set',
      category: VoiceCommandCategory.tracking,
      action: 'LOG_RPE',
    ),
    VoiceCommand(
      id: 'personal_record',
      command: 'That\'s a PR',
      aliases: ['new record', 'personal best'],
      description: 'Mark set as personal record',
      category: VoiceCommandCategory.tracking,
      action: 'MARK_PR',
    ),

    // Music commands
    VoiceCommand(
      id: 'play_music',
      command: 'Play music',
      aliases: ['start music', 'music on'],
      description: 'Start playing music',
      category: VoiceCommandCategory.music,
      action: 'MUSIC_PLAY',
    ),
    VoiceCommand(
      id: 'pause_music',
      command: 'Pause music',
      aliases: ['stop music', 'music off'],
      description: 'Pause music playback',
      category: VoiceCommandCategory.music,
      action: 'MUSIC_PAUSE',
    ),
    VoiceCommand(
      id: 'next_track',
      command: 'Next song',
      aliases: ['skip song', 'next track'],
      description: 'Play next track',
      category: VoiceCommandCategory.music,
      action: 'MUSIC_NEXT',
    ),

    // Navigation commands
    VoiceCommand(
      id: 'go_home',
      command: 'Go home',
      aliases: ['home screen', 'main menu'],
      description: 'Navigate to home screen',
      category: VoiceCommandCategory.navigation,
      action: 'NAV_HOME',
    ),
    VoiceCommand(
      id: 'show_progress',
      command: 'Show progress',
      aliases: ['my progress', 'view stats'],
      description: 'View progress dashboard',
      category: VoiceCommandCategory.navigation,
      action: 'NAV_PROGRESS',
    ),
    VoiceCommand(
      id: 'show_history',
      command: 'Workout history',
      aliases: ['past workouts', 'show history'],
      description: 'View workout history',
      category: VoiceCommandCategory.navigation,
      action: 'NAV_HISTORY',
    ),

    // General commands
    VoiceCommand(
      id: 'whats_next',
      command: 'What\'s next',
      aliases: ['next up', 'what do I do'],
      description: 'Announce next exercise/set',
      category: VoiceCommandCategory.general,
      action: 'ANNOUNCE_NEXT',
    ),
    VoiceCommand(
      id: 'workout_summary',
      command: 'Workout summary',
      aliases: ['how am I doing', 'progress so far'],
      description: 'Announce current workout stats',
      category: VoiceCommandCategory.general,
      action: 'ANNOUNCE_SUMMARY',
    ),
    VoiceCommand(
      id: 'help',
      command: 'Help',
      aliases: ['what can I say', 'voice commands'],
      description: 'List available commands',
      category: VoiceCommandCategory.general,
      action: 'SHOW_HELP',
    ),
  ];
}

/// Model for voice recognition state.
class VoiceRecognitionState {
  final bool isListening;
  final bool isProcessing;
  final String? recognizedText;
  final VoiceCommand? matchedCommand;
  final String? error;
  final DateTime? lastCommandTime;

  const VoiceRecognitionState({
    this.isListening = false,
    this.isProcessing = false,
    this.recognizedText,
    this.matchedCommand,
    this.error,
    this.lastCommandTime,
  });

  VoiceRecognitionState copyWith({
    bool? isListening,
    bool? isProcessing,
    String? recognizedText,
    VoiceCommand? matchedCommand,
    String? error,
    DateTime? lastCommandTime,
  }) {
    return VoiceRecognitionState(
      isListening: isListening ?? this.isListening,
      isProcessing: isProcessing ?? this.isProcessing,
      recognizedText: recognizedText ?? this.recognizedText,
      matchedCommand: matchedCommand ?? this.matchedCommand,
      error: error ?? this.error,
      lastCommandTime: lastCommandTime ?? this.lastCommandTime,
    );
  }
}

/// Model for voice settings.
class VoiceSettings {
  final bool voiceCommandsEnabled;
  final bool voiceFeedback;
  final bool announceExercises;
  final bool announceReps;
  final bool announceRestEnd;
  final String language;
  final bool wakeWordEnabled;
  final String wakeWord;
  final double sensitivity;
  final bool noiseCancellation;

  const VoiceSettings({
    this.voiceCommandsEnabled = true,
    this.voiceFeedback = true,
    this.announceExercises = true,
    this.announceReps = true,
    this.announceRestEnd = true,
    this.language = 'en-US',
    this.wakeWordEnabled = true,
    this.wakeWord = 'Hey Gym',
    this.sensitivity = 0.7,
    this.noiseCancellation = true,
  });

  VoiceSettings copyWith({
    bool? voiceCommandsEnabled,
    bool? voiceFeedback,
    bool? announceExercises,
    bool? announceReps,
    bool? announceRestEnd,
    String? language,
    bool? wakeWordEnabled,
    String? wakeWord,
    double? sensitivity,
    bool? noiseCancellation,
  }) {
    return VoiceSettings(
      voiceCommandsEnabled: voiceCommandsEnabled ?? this.voiceCommandsEnabled,
      voiceFeedback: voiceFeedback ?? this.voiceFeedback,
      announceExercises: announceExercises ?? this.announceExercises,
      announceReps: announceReps ?? this.announceReps,
      announceRestEnd: announceRestEnd ?? this.announceRestEnd,
      language: language ?? this.language,
      wakeWordEnabled: wakeWordEnabled ?? this.wakeWordEnabled,
      wakeWord: wakeWord ?? this.wakeWord,
      sensitivity: sensitivity ?? this.sensitivity,
      noiseCancellation: noiseCancellation ?? this.noiseCancellation,
    );
  }
}

/// Model for command history entry.
class VoiceCommandHistory {
  final String id;
  final String recognizedText;
  final VoiceCommand? matchedCommand;
  final bool wasSuccessful;
  final DateTime timestamp;
  final String? errorMessage;

  const VoiceCommandHistory({
    required this.id,
    required this.recognizedText,
    this.matchedCommand,
    required this.wasSuccessful,
    required this.timestamp,
    this.errorMessage,
  });
}
