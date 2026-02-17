import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/music.dart';
import '../providers/music_provider.dart';

/// Screen for music integration and playback control.
class MusicScreen extends ConsumerStatefulWidget {
  const MusicScreen({super.key});

  @override
  ConsumerState<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends ConsumerState<MusicScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(musicPreferencesNotifierProvider);
    final isConnected = prefs.connectedService != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Workout Music'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(icon: Icon(Icons.library_music), text: 'Playlists'),
            Tab(icon: Icon(Icons.auto_awesome), text: 'AI Mix'),
            Tab(icon: Icon(Icons.speed), text: 'BPM'),
          ],
        ),
      ),
      body: isConnected
          ? Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [_PlaylistsTab(), _AIMixTab(), _BpmTab()],
                  ),
                ),
                const _MiniPlayer(),
              ],
            )
          : _ConnectServiceView(),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _MusicSettingsSheet(),
    );
  }
}

/// View when no music service is connected.
class _ConnectServiceView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.music_note, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 32),
          const Text(
            'Connect Your Music',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Link your music service to play workout playlists and get AI-curated mixes',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 16),
          ),
          const SizedBox(height: 48),
          ...MusicService.values.map(
            (service) => _ServiceConnectButton(service: service),
          ),
        ],
      ),
    );
  }
}

/// Button to connect a music service.
class _ServiceConnectButton extends ConsumerWidget {
  final MusicService service;

  const _ServiceConnectButton({required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = switch (service) {
      MusicService.spotify => Icons.library_music,
      MusicService.appleMusic => Icons.apple,
      MusicService.youtubeMusic => Icons.play_circle_fill,
      MusicService.local => Icons.folder,
    };

    final color = switch (service) {
      MusicService.spotify => const Color(0xFF1DB954),
      MusicService.appleMusic => const Color(0xFFFC3C44),
      MusicService.youtubeMusic => const Color(0xFFFF0000),
      MusicService.local => AppColors.primary,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            HapticFeedback.mediumImpact();
            ref
                .read(musicPreferencesNotifierProvider.notifier)
                .connectService(service);
          },
          icon: Icon(icon, color: Colors.white),
          label: Text('Connect ${service.label}'),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tab showing all playlists.
class _PlaylistsTab extends ConsumerWidget {
  const _PlaylistsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsNotifierProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Category filters
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: PlaylistCategory.values.map((cat) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat.label),
                  selected: false,
                  onSelected: (_) {},
                  backgroundColor: AppColors.surfaceDark,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: AppColors.textSecondaryDark),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Playlist grid
        ...playlists.map((playlist) => _PlaylistCard(playlist: playlist)),
      ],
    );
  }
}

/// Card for a playlist.
class _PlaylistCard extends ConsumerWidget {
  final WorkoutPlaylist playlist;

  const _PlaylistCard({required this.playlist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showPlaylistDetails(context, ref);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Album art placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  playlist.isAIGenerated
                      ? Icons.auto_awesome
                      : Icons.music_note,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          playlist.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (playlist.isAIGenerated)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'AI',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${playlist.tracks.length} tracks • ${playlist.category.label}',
                    style: TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.speed,
                        size: 14,
                        color: AppColors.textSecondaryDark,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${playlist.averageBpm} BPM',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.timer,
                        size: 14,
                        color: AppColors.textSecondaryDark,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${playlist.totalDuration.inMinutes} min',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Play button
            IconButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                ref
                    .read(musicPlaybackNotifierProvider.notifier)
                    .playPlaylist(playlist);
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaylistDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Header
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          playlist.description ?? '',
                          style: TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Play all button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref
                        .read(musicPlaybackNotifierProvider.notifier)
                        .playPlaylist(playlist);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tracks list
              Text(
                'Tracks (${playlist.tracks.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ...playlist.tracks.asMap().entries.map((entry) {
                final index = entry.key;
                final track = entry.value;
                return _TrackTile(
                  track: track,
                  index: index + 1,
                  onTap: () {
                    ref
                        .read(musicPlaybackNotifierProvider.notifier)
                        .playPlaylist(playlist, startIndex: index);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tile for a track in the list.
class _TrackTile extends StatelessWidget {
  final MusicTrack track;
  final int index;
  final VoidCallback onTap;

  const _TrackTile({
    required this.track,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              track.title,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (track.isExplicit)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'E',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        track.artist,
        style: TextStyle(color: AppColors.textSecondaryDark),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${track.bpm}',
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Text(
            track.formattedDuration,
            style: TextStyle(color: AppColors.textSecondaryDark),
          ),
        ],
      ),
    );
  }
}

/// Tab for AI-generated mixes.
class _AIMixTab extends ConsumerWidget {
  const _AIMixTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiPlaylists = ref.watch(aiGeneratedPlaylistsProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Generate new mix card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.3),
                AppColors.surfaceDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Workout Mix',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Generated based on your workout',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'AI analyzes your workout type, intensity, and duration to create the perfect playlist.',
                style: TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    // Generate AI mix
                  },
                  icon: const Icon(Icons.auto_fix_high),
                  label: const Text('Generate New Mix'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        if (aiPlaylists.isNotEmpty) ...[
          const Text(
            'Recent AI Mixes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...aiPlaylists.map((p) => _PlaylistCard(playlist: p)),
        ],
      ],
    );
  }
}

/// Tab for BPM-based music selection.
class _BpmTab extends ConsumerWidget {
  const _BpmTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Match Music to Workout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a workout type to find music with the optimal BPM',
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
        ),
        const SizedBox(height: 24),

        ...BpmSuggestion.all.map(
          (suggestion) => _BpmSuggestionCard(suggestion: suggestion),
        ),
      ],
    );
  }
}

/// Card for BPM suggestion.
class _BpmSuggestionCard extends StatelessWidget {
  final BpmSuggestion suggestion;

  const _BpmSuggestionCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    final color = switch (suggestion.workoutType) {
      'Warm Up' => Colors.orange,
      'Strength' => AppColors.primary,
      'HIIT' => Colors.red,
      'Cardio' => Colors.purple,
      'Cool Down' => Colors.cyan,
      _ => AppColors.primary,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.speed, color: color, size: 20),
                  const SizedBox(height: 2),
                  Text(
                    '${suggestion.minBpm}-${suggestion.maxBpm}',
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.workoutType,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  suggestion.description,
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              // Find music in this BPM range
            },
            icon: Icon(Icons.play_circle, color: color, size: 40),
          ),
        ],
      ),
    );
  }
}

/// Mini player widget at the bottom.
class _MiniPlayer extends ConsumerWidget {
  const _MiniPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playback = ref.watch(musicPlaybackNotifierProvider);

    if (playback.currentTrack == null) {
      return const SizedBox.shrink();
    }

    final track = playback.currentTrack!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: playback.progress,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Album art
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.music_note, color: Colors.white),
                ),
                const SizedBox(width: 12),

                // Track info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        track.artist,
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Controls
                IconButton(
                  onPressed: () {
                    ref
                        .read(musicPlaybackNotifierProvider.notifier)
                        .previousTrack();
                  },
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref
                        .read(musicPlaybackNotifierProvider.notifier)
                        .togglePlayPause();
                  },
                  icon: Icon(
                    playback.isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: AppColors.primary,
                    size: 44,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref
                        .read(musicPlaybackNotifierProvider.notifier)
                        .nextTrack();
                  },
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Sheet for music settings.
class _MusicSettingsSheet extends ConsumerWidget {
  const _MusicSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(musicPreferencesNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Music Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Connected service
          if (prefs.connectedService != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Connected to ${prefs.connectedService!.label}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(musicPreferencesNotifierProvider.notifier)
                          .disconnectService();
                    },
                    child: const Text('Disconnect'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Auto play
          SwitchListTile(
            title: const Text(
              'Auto-play on Workout',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Start music when you begin a workout',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
            value: prefs.autoPlayOnWorkout,
            onChanged: (v) {
              ref
                  .read(musicPreferencesNotifierProvider.notifier)
                  .setAutoPlayOnWorkout(v);
            },
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),

          // Match BPM
          SwitchListTile(
            title: const Text(
              'Match BPM to Intensity',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Adjust music tempo based on workout intensity',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
            value: prefs.matchBpmToIntensity,
            onChanged: (v) {
              ref
                  .read(musicPreferencesNotifierProvider.notifier)
                  .setMatchBpmToIntensity(v);
            },
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),

          // Fade during rest
          SwitchListTile(
            title: const Text(
              'Fade During Rest',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Lower volume during rest periods',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
            value: prefs.fadeAudioOnRest,
            onChanged: (v) {
              ref
                  .read(musicPreferencesNotifierProvider.notifier)
                  .setFadeAudioOnRest(v);
            },
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 16),

          // Rest volume slider
          if (prefs.fadeAudioOnRest) ...[
            Text(
              'Rest Volume: ${(prefs.restVolume * 100).toInt()}%',
              style: const TextStyle(color: Colors.white),
            ),
            Slider(
              value: prefs.restVolume,
              onChanged: (v) {
                ref
                    .read(musicPreferencesNotifierProvider.notifier)
                    .setRestVolume(v);
              },
              activeColor: AppColors.primary,
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
