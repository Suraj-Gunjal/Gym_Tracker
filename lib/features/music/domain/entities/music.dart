/// Enum for music service providers.
enum MusicService {
  spotify('Spotify', 'spotify'),
  appleMusic('Apple Music', 'apple_music'),
  youtubeMusic('YouTube Music', 'youtube_music'),
  local('Local Music', 'local');

  const MusicService(this.label, this.value);
  final String label;
  final String value;
}

/// Enum for playlist categories.
enum PlaylistCategory {
  warmup('Warm Up', 'warmup'),
  hiit('HIIT', 'hiit'),
  strength('Strength', 'strength'),
  cardio('Cardio', 'cardio'),
  cooldown('Cool Down', 'cooldown'),
  motivation('Motivation', 'motivation'),
  focus('Focus', 'focus'),
  custom('Custom', 'custom');

  const PlaylistCategory(this.label, this.value);
  final String label;
  final String value;
}

/// Model representing a music track.
class MusicTrack {
  final String id;
  final String title;
  final String artist;
  final String? albumArt;
  final Duration duration;
  final int bpm;
  final bool isExplicit;

  const MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    this.albumArt,
    required this.duration,
    required this.bpm,
    this.isExplicit = false,
  });

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Model representing a workout playlist.
class WorkoutPlaylist {
  final String id;
  final String name;
  final String? description;
  final String? coverImage;
  final PlaylistCategory category;
  final List<MusicTrack> tracks;
  final MusicService service;
  final int? targetBpm;
  final bool isAIGenerated;
  final DateTime createdAt;

  const WorkoutPlaylist({
    required this.id,
    required this.name,
    this.description,
    this.coverImage,
    required this.category,
    required this.tracks,
    required this.service,
    this.targetBpm,
    this.isAIGenerated = false,
    required this.createdAt,
  });

  Duration get totalDuration =>
      Duration(seconds: tracks.fold(0, (sum, t) => sum + t.duration.inSeconds));

  int get averageBpm {
    if (tracks.isEmpty) return 0;
    return tracks.fold(0, (sum, t) => sum + t.bpm) ~/ tracks.length;
  }
}

/// Model representing the current playback state.
class MusicPlaybackState {
  final MusicTrack? currentTrack;
  final bool isPlaying;
  final Duration position;
  final double volume;
  final bool shuffle;
  final bool repeat;
  final WorkoutPlaylist? activePlaylist;
  final int? currentTrackIndex;

  const MusicPlaybackState({
    this.currentTrack,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.volume = 0.8,
    this.shuffle = false,
    this.repeat = false,
    this.activePlaylist,
    this.currentTrackIndex,
  });

  double get progress {
    if (currentTrack == null) return 0;
    if (currentTrack!.duration.inSeconds == 0) return 0;
    return position.inSeconds / currentTrack!.duration.inSeconds;
  }

  String get positionFormatted {
    final minutes = position.inMinutes;
    final seconds = position.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  MusicPlaybackState copyWith({
    MusicTrack? currentTrack,
    bool? isPlaying,
    Duration? position,
    double? volume,
    bool? shuffle,
    bool? repeat,
    WorkoutPlaylist? activePlaylist,
    int? currentTrackIndex,
  }) {
    return MusicPlaybackState(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      volume: volume ?? this.volume,
      shuffle: shuffle ?? this.shuffle,
      repeat: repeat ?? this.repeat,
      activePlaylist: activePlaylist ?? this.activePlaylist,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
    );
  }
}

/// Model for music preferences.
class MusicPreferences {
  final MusicService? connectedService;
  final bool autoPlayOnWorkout;
  final bool matchBpmToIntensity;
  final PlaylistCategory defaultCategory;
  final int preferredMinBpm;
  final int preferredMaxBpm;
  final bool fadeAudioOnRest;
  final double restVolume;

  const MusicPreferences({
    this.connectedService,
    this.autoPlayOnWorkout = true,
    this.matchBpmToIntensity = true,
    this.defaultCategory = PlaylistCategory.strength,
    this.preferredMinBpm = 120,
    this.preferredMaxBpm = 150,
    this.fadeAudioOnRest = true,
    this.restVolume = 0.3,
  });

  MusicPreferences copyWith({
    MusicService? connectedService,
    bool? autoPlayOnWorkout,
    bool? matchBpmToIntensity,
    PlaylistCategory? defaultCategory,
    int? preferredMinBpm,
    int? preferredMaxBpm,
    bool? fadeAudioOnRest,
    double? restVolume,
  }) {
    return MusicPreferences(
      connectedService: connectedService ?? this.connectedService,
      autoPlayOnWorkout: autoPlayOnWorkout ?? this.autoPlayOnWorkout,
      matchBpmToIntensity: matchBpmToIntensity ?? this.matchBpmToIntensity,
      defaultCategory: defaultCategory ?? this.defaultCategory,
      preferredMinBpm: preferredMinBpm ?? this.preferredMinBpm,
      preferredMaxBpm: preferredMaxBpm ?? this.preferredMaxBpm,
      fadeAudioOnRest: fadeAudioOnRest ?? this.fadeAudioOnRest,
      restVolume: restVolume ?? this.restVolume,
    );
  }
}

/// Model for BPM suggestions based on workout type.
class BpmSuggestion {
  final String workoutType;
  final int minBpm;
  final int maxBpm;
  final String description;

  const BpmSuggestion({
    required this.workoutType,
    required this.minBpm,
    required this.maxBpm,
    required this.description,
  });

  static const warmup = BpmSuggestion(
    workoutType: 'Warm Up',
    minBpm: 100,
    maxBpm: 120,
    description: 'Light tempo to get your body moving',
  );

  static const strength = BpmSuggestion(
    workoutType: 'Strength',
    minBpm: 120,
    maxBpm: 140,
    description: 'Steady beats for focused lifting',
  );

  static const hiit = BpmSuggestion(
    workoutType: 'HIIT',
    minBpm: 140,
    maxBpm: 180,
    description: 'High energy for intense intervals',
  );

  static const cardio = BpmSuggestion(
    workoutType: 'Cardio',
    minBpm: 130,
    maxBpm: 160,
    description: 'Motivating tempo for sustained effort',
  );

  static const cooldown = BpmSuggestion(
    workoutType: 'Cool Down',
    minBpm: 60,
    maxBpm: 100,
    description: 'Calming music for recovery',
  );

  static const all = [warmup, strength, hiit, cardio, cooldown];
}
