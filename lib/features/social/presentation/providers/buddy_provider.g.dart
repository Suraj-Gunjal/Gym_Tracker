// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buddy_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingRequestCountHash() =>
    r'd36c5d42d3d6044176255cd93015af179a856bf8';

/// Provider for pending request count.
///
/// Copied from [pendingRequestCount].
@ProviderFor(pendingRequestCount)
final pendingRequestCountProvider = AutoDisposeProvider<int>.internal(
  pendingRequestCount,
  name: r'pendingRequestCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pendingRequestCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingRequestCountRef = AutoDisposeProviderRef<int>;
String _$shareCardNotifierHash() => r'ebca2a9d80e6b91378d2ee05ad4211a95550bdfa';

/// Provider for share card generation.
///
/// Copied from [ShareCardNotifier].
@ProviderFor(ShareCardNotifier)
final shareCardNotifierProvider =
    AutoDisposeNotifierProvider<ShareCardNotifier, WorkoutShareCard?>.internal(
      ShareCardNotifier.new,
      name: r'shareCardNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shareCardNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ShareCardNotifier = AutoDisposeNotifier<WorkoutShareCard?>;
String _$nearbyBuddiesNotifierHash() =>
    r'c4d5adcf85a5604df0851a5b53f85fd5b60902d3';

/// Provider for nearby gym buddies.
///
/// Copied from [NearbyBuddiesNotifier].
@ProviderFor(NearbyBuddiesNotifier)
final nearbyBuddiesNotifierProvider =
    AutoDisposeNotifierProvider<NearbyBuddiesNotifier, List<GymBuddy>>.internal(
      NearbyBuddiesNotifier.new,
      name: r'nearbyBuddiesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nearbyBuddiesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NearbyBuddiesNotifier = AutoDisposeNotifier<List<GymBuddy>>;
String _$buddyPreferencesNotifierHash() =>
    r'f7e44888b0e6f04d67e456c0a022b73bd66bb60b';

/// Provider for buddy preferences.
///
/// Copied from [BuddyPreferencesNotifier].
@ProviderFor(BuddyPreferencesNotifier)
final buddyPreferencesNotifierProvider =
    AutoDisposeNotifierProvider<
      BuddyPreferencesNotifier,
      BuddyPreferences
    >.internal(
      BuddyPreferencesNotifier.new,
      name: r'buddyPreferencesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$buddyPreferencesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BuddyPreferencesNotifier = AutoDisposeNotifier<BuddyPreferences>;
String _$buddyRequestsNotifierHash() =>
    r'2d58693cf485ebed5792cf4f37173b6a6e6e9835';

/// Provider for buddy requests.
///
/// Copied from [BuddyRequestsNotifier].
@ProviderFor(BuddyRequestsNotifier)
final buddyRequestsNotifierProvider =
    AutoDisposeNotifierProvider<
      BuddyRequestsNotifier,
      List<BuddyRequest>
    >.internal(
      BuddyRequestsNotifier.new,
      name: r'buddyRequestsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$buddyRequestsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BuddyRequestsNotifier = AutoDisposeNotifier<List<BuddyRequest>>;
String _$connectedBuddiesNotifierHash() =>
    r'8c80eedaa97e596745328f9a6f5690afbcd21892';

/// Provider for connected buddies.
///
/// Copied from [ConnectedBuddiesNotifier].
@ProviderFor(ConnectedBuddiesNotifier)
final connectedBuddiesNotifierProvider =
    AutoDisposeNotifierProvider<
      ConnectedBuddiesNotifier,
      List<GymBuddy>
    >.internal(
      ConnectedBuddiesNotifier.new,
      name: r'connectedBuddiesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectedBuddiesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ConnectedBuddiesNotifier = AutoDisposeNotifier<List<GymBuddy>>;
String _$liveSessionsNotifierHash() =>
    r'04d6c24038ce79e89ccffdb3442f9f9e12fbf725';

/// Provider for live workout sessions.
///
/// Copied from [LiveSessionsNotifier].
@ProviderFor(LiveSessionsNotifier)
final liveSessionsNotifierProvider =
    AutoDisposeNotifierProvider<
      LiveSessionsNotifier,
      List<LiveWorkoutSession>
    >.internal(
      LiveSessionsNotifier.new,
      name: r'liveSessionsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$liveSessionsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LiveSessionsNotifier = AutoDisposeNotifier<List<LiveWorkoutSession>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
