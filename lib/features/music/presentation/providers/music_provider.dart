import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/music.dart';

part 'music_provider.g.dart';

/// Provider for music playback state.
@riverpod
class MusicPlaybackNotifier extends _$MusicPlaybackNotifier {
  @override
  MusicPlaybackState build() {
    return const MusicPlaybackState();
  }

  void play() {
    state = state.copyWith(isPlaying: true);
  }

  void pause() {
    state = state.copyWith(isPlaying: false);
  }

  void togglePlayPause() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void seek(Duration position) {
    state = state.copyWith(position: position);
  }

  void setVolume(double volume) {
    state = state.copyWith(volume: volume.clamp(0, 1));
  }

  void toggleShuffle() {
    state = state.copyWith(shuffle: !state.shuffle);
  }

  void toggleRepeat() {
    state = state.copyWith(repeat: !state.repeat);
  }

  void playPlaylist(WorkoutPlaylist playlist, {int startIndex = 0}) {
    if (playlist.tracks.isEmpty) return;
    final track = playlist.tracks[startIndex];
    state = state.copyWith(
      activePlaylist: playlist,
      currentTrack: track,
      currentTrackIndex: startIndex,
      isPlaying: true,
      position: Duration.zero,
    );
  }

  void playTrack(MusicTrack track) {
    state = state.copyWith(
      currentTrack: track,
      isPlaying: true,
      position: Duration.zero,
    );
  }

  void nextTrack() {
    final playlist = state.activePlaylist;
    if (playlist == null || state.currentTrackIndex == null) return;

    int nextIndex = state.currentTrackIndex! + 1;
    if (state.shuffle) {
      nextIndex = Random().nextInt(playlist.tracks.length);
    } else if (nextIndex >= playlist.tracks.length) {
      if (state.repeat) {
        nextIndex = 0;
      } else {
        return;
      }
    }

    state = state.copyWith(
      currentTrack: playlist.tracks[nextIndex],
      currentTrackIndex: nextIndex,
      position: Duration.zero,
    );
  }

  void previousTrack() {
    final playlist = state.activePlaylist;
    if (playlist == null || state.currentTrackIndex == null) return;

    int prevIndex = state.currentTrackIndex! - 1;
    if (prevIndex < 0) {
      if (state.repeat) {
        prevIndex = playlist.tracks.length - 1;
      } else {
        state = state.copyWith(position: Duration.zero);
        return;
      }
    }

    state = state.copyWith(
      currentTrack: playlist.tracks[prevIndex],
      currentTrackIndex: prevIndex,
      position: Duration.zero,
    );
  }

  void stop() {
    state = const MusicPlaybackState();
  }

  void fadeForRest(double restVolume) {
    state = state.copyWith(volume: restVolume);
  }

  void restoreVolume(double normalVolume) {
    state = state.copyWith(volume: normalVolume);
  }
}

/// Provider for music preferences.
@riverpod
class MusicPreferencesNotifier extends _$MusicPreferencesNotifier {
  @override
  MusicPreferences build() {
    return const MusicPreferences();
  }

  void connectService(MusicService service) {
    state = state.copyWith(connectedService: service);
  }

  void disconnectService() {
    state = state.copyWith(connectedService: null);
  }

  void setAutoPlayOnWorkout(bool value) {
    state = state.copyWith(autoPlayOnWorkout: value);
  }

  void setMatchBpmToIntensity(bool value) {
    state = state.copyWith(matchBpmToIntensity: value);
  }

  void setDefaultCategory(PlaylistCategory category) {
    state = state.copyWith(defaultCategory: category);
  }

  void setBpmRange(int min, int max) {
    state = state.copyWith(preferredMinBpm: min, preferredMaxBpm: max);
  }

  void setFadeAudioOnRest(bool value) {
    state = state.copyWith(fadeAudioOnRest: value);
  }

  void setRestVolume(double volume) {
    state = state.copyWith(restVolume: volume.clamp(0, 1));
  }
}

/// Provider for workout playlists.
@riverpod
class PlaylistsNotifier extends _$PlaylistsNotifier {
  @override
  List<WorkoutPlaylist> build() {
    return _generateMockPlaylists();
  }

  List<WorkoutPlaylist> _generateMockPlaylists() {
    return [
      WorkoutPlaylist(
        id: '1',
        name: 'Beast Mode',
        description: 'High energy tracks for intense workouts',
        category: PlaylistCategory.strength,
        service: MusicService.spotify,
        targetBpm: 130,
        createdAt: DateTime.now(),
        tracks: _generateMockTracks(15, 125, 140),
      ),
      WorkoutPlaylist(
        id: '2',
        name: 'HIIT Power',
        description: 'Fast beats for interval training',
        category: PlaylistCategory.hiit,
        service: MusicService.spotify,
        targetBpm: 160,
        createdAt: DateTime.now(),
        tracks: _generateMockTracks(20, 150, 175),
      ),
      WorkoutPlaylist(
        id: '3',
        name: 'Cardio Zone',
        description: 'Keep moving with these tracks',
        category: PlaylistCategory.cardio,
        service: MusicService.spotify,
        targetBpm: 145,
        createdAt: DateTime.now(),
        tracks: _generateMockTracks(25, 135, 155),
      ),
      WorkoutPlaylist(
        id: '4',
        name: 'Warm Up Flow',
        description: 'Easy tempo to get started',
        category: PlaylistCategory.warmup,
        service: MusicService.spotify,
        targetBpm: 110,
        createdAt: DateTime.now(),
        tracks: _generateMockTracks(10, 100, 120),
      ),
      WorkoutPlaylist(
        id: '5',
        name: 'Cool Down Chill',
        description: 'Relax and recover',
        category: PlaylistCategory.cooldown,
        service: MusicService.spotify,
        targetBpm: 80,
        createdAt: DateTime.now(),
        tracks: _generateMockTracks(12, 60, 95),
      ),
      WorkoutPlaylist(
        id: '6',
        name: 'AI: Today\'s Lift',
        description: 'Generated based on your workout',
        category: PlaylistCategory.strength,
        service: MusicService.spotify,
        targetBpm: 128,
        isAIGenerated: true,
        createdAt: DateTime.now(),
        tracks: _generateMockTracks(18, 120, 135),
      ),
    ];
  }

  List<MusicTrack> _generateMockTracks(int count, int minBpm, int maxBpm) {
    final random = Random(42);
    final artists = [
      'Eminem',
      'Imagine Dragons',
      'AC/DC',
      'Metallica',
      'The Weeknd',
      'Kanye West',
      'Kendrick Lamar',
      'Linkin Park',
      'Rage Against The Machine',
      'Run The Jewels',
      'Daft Punk',
      'Justice',
      'Prodigy',
    ];
    final titles = [
      'Lose Yourself',
      'Thunder',
      'Back in Black',
      'Enter Sandman',
      'Blinding Lights',
      'Stronger',
      'HUMBLE.',
      'Numb',
      'Bulls on Parade',
      'Run the Jewels',
      'One More Time',
      'Genesis',
      'Firestarter',
      'Can\'t Hold Us',
      'Remember the Name',
      'Till I Collapse',
    ];

    return List.generate(count, (i) {
      return MusicTrack(
        id: 'track_$i',
        title: titles[i % titles.length],
        artist: artists[random.nextInt(artists.length)],
        duration: Duration(
          minutes: 3 + random.nextInt(2),
          seconds: random.nextInt(60),
        ),
        bpm: minBpm + random.nextInt(maxBpm - minBpm),
        isExplicit: random.nextBool(),
      );
    });
  }

  void addPlaylist(WorkoutPlaylist playlist) {
    state = [...state, playlist];
  }

  void removePlaylist(String playlistId) {
    state = state.where((p) => p.id != playlistId).toList();
  }
}

/// Provider for filtering playlists by category.
@riverpod
List<WorkoutPlaylist> playlistsByCategory(ref, PlaylistCategory category) {
  final playlists = ref.watch(playlistsNotifierProvider);
  return playlists.where((p) => p.category == category).toList();
}

/// Provider for AI-generated playlists.
@riverpod
List<WorkoutPlaylist> aiGeneratedPlaylists(ref) {
  final playlists = ref.watch(playlistsNotifierProvider);
  return playlists.where((p) => p.isAIGenerated).toList();
}

/// Provider for checking if music service is connected.
@riverpod
bool isMusicConnected(ref) {
  final prefs = ref.watch(musicPreferencesNotifierProvider);
  return prefs.connectedService != null;
}
