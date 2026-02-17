// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gamificationProfileNotifierHash() =>
    r'64809ce7c217f99eb6ff99e7ae1c995792b5e44b';

/// Provider for user's gamification profile.
///
/// Copied from [GamificationProfileNotifier].
@ProviderFor(GamificationProfileNotifier)
final gamificationProfileNotifierProvider =
    AutoDisposeNotifierProvider<
      GamificationProfileNotifier,
      GamificationProfile
    >.internal(
      GamificationProfileNotifier.new,
      name: r'gamificationProfileNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gamificationProfileNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GamificationProfileNotifier =
    AutoDisposeNotifier<GamificationProfile>;
String _$missionsNotifierHash() => r'06a9fe1ecfd7d3d21e52e0fdc6435e592bcfbb50';

/// Provider for missions.
///
/// Copied from [MissionsNotifier].
@ProviderFor(MissionsNotifier)
final missionsNotifierProvider =
    AutoDisposeNotifierProvider<MissionsNotifier, List<Mission>>.internal(
      MissionsNotifier.new,
      name: r'missionsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$missionsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MissionsNotifier = AutoDisposeNotifier<List<Mission>>;
String _$streakNotifierHash() => r'eeb6d509af68b0f2afe67da47b59402ed7499e36';

/// Provider for streak data.
///
/// Copied from [StreakNotifier].
@ProviderFor(StreakNotifier)
final streakNotifierProvider =
    AutoDisposeNotifierProvider<StreakNotifier, StreakData>.internal(
      StreakNotifier.new,
      name: r'streakNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$streakNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StreakNotifier = AutoDisposeNotifier<StreakData>;
String _$leaderboardNotifierHash() =>
    r'b77718bf2044645ee60b5a1b83a8b7806b4824c1';

/// Provider for leaderboard.
///
/// Copied from [LeaderboardNotifier].
@ProviderFor(LeaderboardNotifier)
final leaderboardNotifierProvider =
    AutoDisposeNotifierProvider<
      LeaderboardNotifier,
      Map<LeaderboardType, List<LeaderboardEntry>>
    >.internal(
      LeaderboardNotifier.new,
      name: r'leaderboardNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$leaderboardNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LeaderboardNotifier =
    AutoDisposeNotifier<Map<LeaderboardType, List<LeaderboardEntry>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
