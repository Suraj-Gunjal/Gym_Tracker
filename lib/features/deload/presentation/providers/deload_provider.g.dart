// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deload_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weeksSinceLastDeloadHash() =>
    r'1b39dd7f03c5a26381bc1eaf64c0c98b3cd73a04';

/// Provider to calculate weeks since last deload.
///
/// Copied from [weeksSinceLastDeload].
@ProviderFor(weeksSinceLastDeload)
final weeksSinceLastDeloadProvider = AutoDisposeProvider<int>.internal(
  weeksSinceLastDeload,
  name: r'weeksSinceLastDeloadProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeksSinceLastDeloadHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeksSinceLastDeloadRef = AutoDisposeProviderRef<int>;
String _$deloadRecommendedHash() => r'5250e0147b5fcb176511650e4c9ae3aff53fe32a';

/// Provider to check if deload is recommended.
///
/// Copied from [deloadRecommended].
@ProviderFor(deloadRecommended)
final deloadRecommendedProvider = AutoDisposeProvider<bool>.internal(
  deloadRecommended,
  name: r'deloadRecommendedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deloadRecommendedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeloadRecommendedRef = AutoDisposeProviderRef<bool>;
String _$deloadModificationsHash() =>
    r'5c962cb4ec332ff1ac4733ff0c56be1ba8dbbbeb';

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

/// Provider to generate deload modifications for exercises.
///
/// Copied from [deloadModifications].
@ProviderFor(deloadModifications)
const deloadModificationsProvider = DeloadModificationsFamily();

/// Provider to generate deload modifications for exercises.
///
/// Copied from [deloadModifications].
class DeloadModificationsFamily extends Family<List<DeloadModification>> {
  /// Provider to generate deload modifications for exercises.
  ///
  /// Copied from [deloadModifications].
  const DeloadModificationsFamily();

  /// Provider to generate deload modifications for exercises.
  ///
  /// Copied from [deloadModifications].
  DeloadModificationsProvider call(DeloadStrategy strategy) {
    return DeloadModificationsProvider(strategy);
  }

  @override
  DeloadModificationsProvider getProviderOverride(
    covariant DeloadModificationsProvider provider,
  ) {
    return call(provider.strategy);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deloadModificationsProvider';
}

/// Provider to generate deload modifications for exercises.
///
/// Copied from [deloadModifications].
class DeloadModificationsProvider
    extends AutoDisposeProvider<List<DeloadModification>> {
  /// Provider to generate deload modifications for exercises.
  ///
  /// Copied from [deloadModifications].
  DeloadModificationsProvider(DeloadStrategy strategy)
    : this._internal(
        (ref) => deloadModifications(ref as DeloadModificationsRef, strategy),
        from: deloadModificationsProvider,
        name: r'deloadModificationsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$deloadModificationsHash,
        dependencies: DeloadModificationsFamily._dependencies,
        allTransitiveDependencies:
            DeloadModificationsFamily._allTransitiveDependencies,
        strategy: strategy,
      );

  DeloadModificationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.strategy,
  }) : super.internal();

  final DeloadStrategy strategy;

  @override
  Override overrideWith(
    List<DeloadModification> Function(DeloadModificationsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeloadModificationsProvider._internal(
        (ref) => create(ref as DeloadModificationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        strategy: strategy,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DeloadModification>> createElement() {
    return _DeloadModificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeloadModificationsProvider && other.strategy == strategy;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, strategy.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DeloadModificationsRef
    on AutoDisposeProviderRef<List<DeloadModification>> {
  /// The parameter `strategy` of this provider.
  DeloadStrategy get strategy;
}

class _DeloadModificationsProviderElement
    extends AutoDisposeProviderElement<List<DeloadModification>>
    with DeloadModificationsRef {
  _DeloadModificationsProviderElement(super.provider);

  @override
  DeloadStrategy get strategy =>
      (origin as DeloadModificationsProvider).strategy;
}

String _$averageSleepQualityHash() =>
    r'c32f22841073ee1bca800a715c8180a2739b4851';

/// Provider for average sleep quality.
///
/// Copied from [averageSleepQuality].
@ProviderFor(averageSleepQuality)
final averageSleepQualityProvider = AutoDisposeProvider<double>.internal(
  averageSleepQuality,
  name: r'averageSleepQualityProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$averageSleepQualityHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AverageSleepQualityRef = AutoDisposeProviderRef<double>;
String _$deloadSettingsNotifierHash() =>
    r'f7c343ba2f5e07ccc642af9038c1213b9179ee33';

/// Provider for deload settings.
///
/// Copied from [DeloadSettingsNotifier].
@ProviderFor(DeloadSettingsNotifier)
final deloadSettingsNotifierProvider =
    AutoDisposeNotifierProvider<
      DeloadSettingsNotifier,
      DeloadSettings
    >.internal(
      DeloadSettingsNotifier.new,
      name: r'deloadSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deloadSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeloadSettingsNotifier = AutoDisposeNotifier<DeloadSettings>;
String _$fatigueIndicatorsNotifierHash() =>
    r'50df3e2476dcdd43e29207288114bccd82a227a1';

/// Provider for current fatigue indicators.
///
/// Copied from [FatigueIndicatorsNotifier].
@ProviderFor(FatigueIndicatorsNotifier)
final fatigueIndicatorsNotifierProvider =
    AutoDisposeNotifierProvider<
      FatigueIndicatorsNotifier,
      FatigueIndicators
    >.internal(
      FatigueIndicatorsNotifier.new,
      name: r'fatigueIndicatorsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fatigueIndicatorsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FatigueIndicatorsNotifier = AutoDisposeNotifier<FatigueIndicators>;
String _$deloadHistoryNotifierHash() =>
    r'd1555ea0c7d97e1be5b6b6da1f4777d4af032ef6';

/// Provider for deload history.
///
/// Copied from [DeloadHistoryNotifier].
@ProviderFor(DeloadHistoryNotifier)
final deloadHistoryNotifierProvider =
    AutoDisposeNotifierProvider<
      DeloadHistoryNotifier,
      List<DeloadWeek>
    >.internal(
      DeloadHistoryNotifier.new,
      name: r'deloadHistoryNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$deloadHistoryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeloadHistoryNotifier = AutoDisposeNotifier<List<DeloadWeek>>;
String _$activeDeloadNotifierHash() =>
    r'cb27d90a4d21902f1724fc86efd7c3df85f23380';

/// Provider for active deload.
///
/// Copied from [ActiveDeloadNotifier].
@ProviderFor(ActiveDeloadNotifier)
final activeDeloadNotifierProvider =
    AutoDisposeNotifierProvider<ActiveDeloadNotifier, DeloadWeek?>.internal(
      ActiveDeloadNotifier.new,
      name: r'activeDeloadNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeDeloadNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveDeloadNotifier = AutoDisposeNotifier<DeloadWeek?>;
String _$sleepEntriesNotifierHash() =>
    r'66d9a1e176d4e9a1a3a1df2abfb5cd61d76c2f17';

/// Provider for sleep entries.
///
/// Copied from [SleepEntriesNotifier].
@ProviderFor(SleepEntriesNotifier)
final sleepEntriesNotifierProvider =
    AutoDisposeNotifierProvider<
      SleepEntriesNotifier,
      List<SleepEntry>
    >.internal(
      SleepEntriesNotifier.new,
      name: r'sleepEntriesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sleepEntriesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SleepEntriesNotifier = AutoDisposeNotifier<List<SleepEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
