// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$socialFeedHash() => r'a96e55f3bf6589d8855d7c0e179719ec7ec58809';

/// Provider for social feed.
///
/// Copied from [SocialFeed].
@ProviderFor(SocialFeed)
final socialFeedProvider =
    AutoDisposeNotifierProvider<SocialFeed, FeedState>.internal(
      SocialFeed.new,
      name: r'socialFeedProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$socialFeedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SocialFeed = AutoDisposeNotifier<FeedState>;
String _$userProfileHash() => r'b6d9c74e80366fe0d2b23f1ce120aca23ae67bf2';

/// Provider for user profile.
///
/// Copied from [UserProfile].
@ProviderFor(UserProfile)
final userProfileProvider =
    AutoDisposeNotifierProvider<UserProfile, SocialProfile?>.internal(
      UserProfile.new,
      name: r'userProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserProfile = AutoDisposeNotifier<SocialProfile?>;
String _$activityFeedNotifierHash() =>
    r'e79ae84ff62babc94049edf8850f20253613543e';

/// Provider for activity feed.
///
/// Copied from [ActivityFeedNotifier].
@ProviderFor(ActivityFeedNotifier)
final activityFeedNotifierProvider =
    AutoDisposeNotifierProvider<
      ActivityFeedNotifier,
      List<ActivityItem>
    >.internal(
      ActivityFeedNotifier.new,
      name: r'activityFeedNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activityFeedNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActivityFeedNotifier = AutoDisposeNotifier<List<ActivityItem>>;
String _$followListHash() => r'6e8eb49ed1ffff31e3a837d8fac2e8d157cab77f';

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

abstract class _$FollowList
    extends BuildlessAutoDisposeNotifier<List<SocialProfile>> {
  late final String type;

  List<SocialProfile> build(String type);
}

/// Provider for followers/following lists.
///
/// Copied from [FollowList].
@ProviderFor(FollowList)
const followListProvider = FollowListFamily();

/// Provider for followers/following lists.
///
/// Copied from [FollowList].
class FollowListFamily extends Family<List<SocialProfile>> {
  /// Provider for followers/following lists.
  ///
  /// Copied from [FollowList].
  const FollowListFamily();

  /// Provider for followers/following lists.
  ///
  /// Copied from [FollowList].
  FollowListProvider call(String type) {
    return FollowListProvider(type);
  }

  @override
  FollowListProvider getProviderOverride(
    covariant FollowListProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'followListProvider';
}

/// Provider for followers/following lists.
///
/// Copied from [FollowList].
class FollowListProvider
    extends AutoDisposeNotifierProviderImpl<FollowList, List<SocialProfile>> {
  /// Provider for followers/following lists.
  ///
  /// Copied from [FollowList].
  FollowListProvider(String type)
    : this._internal(
        () => FollowList()..type = type,
        from: followListProvider,
        name: r'followListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$followListHash,
        dependencies: FollowListFamily._dependencies,
        allTransitiveDependencies: FollowListFamily._allTransitiveDependencies,
        type: type,
      );

  FollowListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  List<SocialProfile> runNotifierBuild(covariant FollowList notifier) {
    return notifier.build(type);
  }

  @override
  Override overrideWith(FollowList Function() create) {
    return ProviderOverride(
      origin: this,
      override: FollowListProvider._internal(
        () => create()..type = type,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<FollowList, List<SocialProfile>>
  createElement() {
    return _FollowListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowListProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FollowListRef on AutoDisposeNotifierProviderRef<List<SocialProfile>> {
  /// The parameter `type` of this provider.
  String get type;
}

class _FollowListProviderElement
    extends AutoDisposeNotifierProviderElement<FollowList, List<SocialProfile>>
    with FollowListRef {
  _FollowListProviderElement(super.provider);

  @override
  String get type => (origin as FollowListProvider).type;
}

String _$discoverUsersHash() => r'aae1d5c0bafa2773692044e70897d73ddd76e01e';

/// Provider for discover users.
///
/// Copied from [DiscoverUsers].
@ProviderFor(DiscoverUsers)
final discoverUsersProvider =
    AutoDisposeAsyncNotifierProvider<
      DiscoverUsers,
      List<SocialProfile>
    >.internal(
      DiscoverUsers.new,
      name: r'discoverUsersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$discoverUsersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DiscoverUsers = AutoDisposeAsyncNotifier<List<SocialProfile>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
