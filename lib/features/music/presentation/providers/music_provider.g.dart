// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playlistsByCategoryHash() =>
    r'04b97c1806015408972f6b055483cd75f9251ea9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for filtering playlists by category.
///
/// Copied from [playlistsByCategory].
@ProviderFor(playlistsByCategory)
const playlistsByCategoryProvider = PlaylistsByCategoryFamily();

/// Provider for filtering playlists by category.
///
/// Copied from [playlistsByCategory].
class PlaylistsByCategoryFamily extends Family<List<WorkoutPlaylist>> {
  /// Provider for filtering playlists by category.
  ///
  /// Copied from [playlistsByCategory].
  const PlaylistsByCategoryFamily();

  /// Provider for filtering playlists by category.
  ///
  /// Copied from [playlistsByCategory].
  PlaylistsByCategoryProvider call(PlaylistCategory category) {
    return PlaylistsByCategoryProvider(category);
  }

  @override
  PlaylistsByCategoryProvider getProviderOverride(
    covariant PlaylistsByCategoryProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'playlistsByCategoryProvider';
}

/// Provider for filtering playlists by category.
///
/// Copied from [playlistsByCategory].
class PlaylistsByCategoryProvider
    extends AutoDisposeProvider<List<WorkoutPlaylist>> {
  /// Provider for filtering playlists by category.
  ///
  /// Copied from [playlistsByCategory].
  PlaylistsByCategoryProvider(PlaylistCategory category)
    : this._internal(
        (ref) => playlistsByCategory(ref as PlaylistsByCategoryRef, category),
        from: playlistsByCategoryProvider,
        name: r'playlistsByCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$playlistsByCategoryHash,
        dependencies: PlaylistsByCategoryFamily._dependencies,
        allTransitiveDependencies:
            PlaylistsByCategoryFamily._allTransitiveDependencies,
        category: category,
      );

  PlaylistsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final PlaylistCategory category;

  @override
  Override overrideWith(
    List<WorkoutPlaylist> Function(PlaylistsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaylistsByCategoryProvider._internal(
        (ref) => create(ref as PlaylistsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<WorkoutPlaylist>> createElement() {
    return _PlaylistsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaylistsByCategoryRef on AutoDisposeProviderRef<List<WorkoutPlaylist>> {
  /// The parameter `category` of this provider.
  PlaylistCategory get category;
}

class _PlaylistsByCategoryProviderElement
    extends AutoDisposeProviderElement<List<WorkoutPlaylist>>
    with PlaylistsByCategoryRef {
  _PlaylistsByCategoryProviderElement(super.provider);

  @override
  PlaylistCategory get category =>
      (origin as PlaylistsByCategoryProvider).category;
}

String _$aiGeneratedPlaylistsHash() =>
    r'56557e765f90da26f3c89de11cde91a99ae00b29';

/// Provider for AI-generated playlists.
///
/// Copied from [aiGeneratedPlaylists].
@ProviderFor(aiGeneratedPlaylists)
final aiGeneratedPlaylistsProvider =
    AutoDisposeProvider<List<WorkoutPlaylist>>.internal(
      aiGeneratedPlaylists,
      name: r'aiGeneratedPlaylistsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiGeneratedPlaylistsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AiGeneratedPlaylistsRef = AutoDisposeProviderRef<List<WorkoutPlaylist>>;
String _$isMusicConnectedHash() => r'f2c61ad6a7cf629f8bfd1417fb373faede37e2de';

/// Provider for checking if music service is connected.
///
/// Copied from [isMusicConnected].
@ProviderFor(isMusicConnected)
final isMusicConnectedProvider = AutoDisposeProvider<bool>.internal(
  isMusicConnected,
  name: r'isMusicConnectedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isMusicConnectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsMusicConnectedRef = AutoDisposeProviderRef<bool>;
String _$musicPlaybackNotifierHash() =>
    r'262b0e7c971f505ef554ff60d35cc6bd3508e5c2';

/// Provider for music playback state.
///
/// Copied from [MusicPlaybackNotifier].
@ProviderFor(MusicPlaybackNotifier)
final musicPlaybackNotifierProvider =
    AutoDisposeNotifierProvider<
      MusicPlaybackNotifier,
      MusicPlaybackState
    >.internal(
      MusicPlaybackNotifier.new,
      name: r'musicPlaybackNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$musicPlaybackNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MusicPlaybackNotifier = AutoDisposeNotifier<MusicPlaybackState>;
String _$musicPreferencesNotifierHash() =>
    r'3d3237226e85b580543d42770698893f4baee5f2';

/// Provider for music preferences.
///
/// Copied from [MusicPreferencesNotifier].
@ProviderFor(MusicPreferencesNotifier)
final musicPreferencesNotifierProvider =
    AutoDisposeNotifierProvider<
      MusicPreferencesNotifier,
      MusicPreferences
    >.internal(
      MusicPreferencesNotifier.new,
      name: r'musicPreferencesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$musicPreferencesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MusicPreferencesNotifier = AutoDisposeNotifier<MusicPreferences>;
String _$playlistsNotifierHash() => r'7f77bbc8253241a2b9eaf257afea33278c3608c2';

/// Provider for workout playlists.
///
/// Copied from [PlaylistsNotifier].
@ProviderFor(PlaylistsNotifier)
final playlistsNotifierProvider =
    AutoDisposeNotifierProvider<
      PlaylistsNotifier,
      List<WorkoutPlaylist>
    >.internal(
      PlaylistsNotifier.new,
      name: r'playlistsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$playlistsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PlaylistsNotifier = AutoDisposeNotifier<List<WorkoutPlaylist>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
