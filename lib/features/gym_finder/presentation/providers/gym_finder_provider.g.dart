// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_finder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredGymsHash() => r'5276dce0aa5ed1a93fc77d4992298b16570ec3ff';

/// Provider for filtered gyms.
///
/// Copied from [filteredGyms].
@ProviderFor(filteredGyms)
final filteredGymsProvider = AutoDisposeProvider<List<Gym>>.internal(
  filteredGyms,
  name: r'filteredGymsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredGymsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredGymsRef = AutoDisposeProviderRef<List<Gym>>;
String _$currentCheckInHash() => r'c7c2f2bfb80ab2c6754fee9d467b8cbd42550237';

/// Provider for current check-in status.
///
/// Copied from [currentCheckIn].
@ProviderFor(currentCheckIn)
final currentCheckInProvider = AutoDisposeProvider<GymCheckIn?>.internal(
  currentCheckIn,
  name: r'currentCheckInProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentCheckInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentCheckInRef = AutoDisposeProviderRef<GymCheckIn?>;
String _$isGymSavedHash() => r'cf18ff08f3892dba9f2ada2d02bc0faab423c660';

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

/// Provider to check if gym is saved.
///
/// Copied from [isGymSaved].
@ProviderFor(isGymSaved)
const isGymSavedProvider = IsGymSavedFamily();

/// Provider to check if gym is saved.
///
/// Copied from [isGymSaved].
class IsGymSavedFamily extends Family<bool> {
  /// Provider to check if gym is saved.
  ///
  /// Copied from [isGymSaved].
  const IsGymSavedFamily();

  /// Provider to check if gym is saved.
  ///
  /// Copied from [isGymSaved].
  IsGymSavedProvider call(String gymId) {
    return IsGymSavedProvider(gymId);
  }

  @override
  IsGymSavedProvider getProviderOverride(
    covariant IsGymSavedProvider provider,
  ) {
    return call(provider.gymId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isGymSavedProvider';
}

/// Provider to check if gym is saved.
///
/// Copied from [isGymSaved].
class IsGymSavedProvider extends AutoDisposeProvider<bool> {
  /// Provider to check if gym is saved.
  ///
  /// Copied from [isGymSaved].
  IsGymSavedProvider(String gymId)
    : this._internal(
        (ref) => isGymSaved(ref as IsGymSavedRef, gymId),
        from: isGymSavedProvider,
        name: r'isGymSavedProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isGymSavedHash,
        dependencies: IsGymSavedFamily._dependencies,
        allTransitiveDependencies: IsGymSavedFamily._allTransitiveDependencies,
        gymId: gymId,
      );

  IsGymSavedProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.gymId,
  }) : super.internal();

  final String gymId;

  @override
  Override overrideWith(bool Function(IsGymSavedRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: IsGymSavedProvider._internal(
        (ref) => create(ref as IsGymSavedRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        gymId: gymId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsGymSavedProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsGymSavedProvider && other.gymId == gymId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, gymId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsGymSavedRef on AutoDisposeProviderRef<bool> {
  /// The parameter `gymId` of this provider.
  String get gymId;
}

class _IsGymSavedProviderElement extends AutoDisposeProviderElement<bool>
    with IsGymSavedRef {
  _IsGymSavedProviderElement(super.provider);

  @override
  String get gymId => (origin as IsGymSavedProvider).gymId;
}

String _$nearbyGymsNotifierHash() =>
    r'61fffeb0a113ec81f01c7f550feaf29a6a736dd2';

/// Provider for nearby gyms.
///
/// Copied from [NearbyGymsNotifier].
@ProviderFor(NearbyGymsNotifier)
final nearbyGymsNotifierProvider =
    AutoDisposeNotifierProvider<NearbyGymsNotifier, List<Gym>>.internal(
      NearbyGymsNotifier.new,
      name: r'nearbyGymsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$nearbyGymsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NearbyGymsNotifier = AutoDisposeNotifier<List<Gym>>;
String _$gymFiltersNotifierHash() =>
    r'4700fa0178bed55cc6c45256541b83550ce7d606';

/// Provider for gym search filters.
///
/// Copied from [GymFiltersNotifier].
@ProviderFor(GymFiltersNotifier)
final gymFiltersNotifierProvider =
    AutoDisposeNotifierProvider<GymFiltersNotifier, GymSearchFilters>.internal(
      GymFiltersNotifier.new,
      name: r'gymFiltersNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gymFiltersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GymFiltersNotifier = AutoDisposeNotifier<GymSearchFilters>;
String _$savedGymsNotifierHash() => r'2902fc6ce14f29d640e2c6d63590b5251bf7a7bf';

/// Provider for saved/favorite gyms.
///
/// Copied from [SavedGymsNotifier].
@ProviderFor(SavedGymsNotifier)
final savedGymsNotifierProvider =
    AutoDisposeNotifierProvider<SavedGymsNotifier, List<SavedGym>>.internal(
      SavedGymsNotifier.new,
      name: r'savedGymsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$savedGymsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SavedGymsNotifier = AutoDisposeNotifier<List<SavedGym>>;
String _$gymCheckInsNotifierHash() =>
    r'413847aa27ab3ec5aaed3080f3d7ffb549f79e36';

/// Provider for gym check-ins.
///
/// Copied from [GymCheckInsNotifier].
@ProviderFor(GymCheckInsNotifier)
final gymCheckInsNotifierProvider =
    AutoDisposeNotifierProvider<GymCheckInsNotifier, List<GymCheckIn>>.internal(
      GymCheckInsNotifier.new,
      name: r'gymCheckInsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$gymCheckInsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GymCheckInsNotifier = AutoDisposeNotifier<List<GymCheckIn>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
