// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rpe_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rpeStatsHash() => r'4fb8e240f84236a06149d7acf85852f6dcaee7b3';

/// Provider for RPE statistics.
///
/// Copied from [rpeStats].
@ProviderFor(rpeStats)
final rpeStatsProvider = AutoDisposeProvider<RPEStats>.internal(
  rpeStats,
  name: r'rpeStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$rpeStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RpeStatsRef = AutoDisposeProviderRef<RPEStats>;
String _$calculateTotalTUTHash() => r'4a08d91496527a2698f6823288114ed7135c6f3b';

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

/// Provider for TUT calculations.
///
/// Copied from [calculateTotalTUT].
@ProviderFor(calculateTotalTUT)
const calculateTotalTUTProvider = CalculateTotalTUTFamily();

/// Provider for TUT calculations.
///
/// Copied from [calculateTotalTUT].
class CalculateTotalTUTFamily extends Family<int> {
  /// Provider for TUT calculations.
  ///
  /// Copied from [calculateTotalTUT].
  const CalculateTotalTUTFamily();

  /// Provider for TUT calculations.
  ///
  /// Copied from [calculateTotalTUT].
  CalculateTotalTUTProvider call(List<(int, Tempo?)> sets) {
    return CalculateTotalTUTProvider(sets);
  }

  @override
  CalculateTotalTUTProvider getProviderOverride(
    covariant CalculateTotalTUTProvider provider,
  ) {
    return call(provider.sets);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'calculateTotalTUTProvider';
}

/// Provider for TUT calculations.
///
/// Copied from [calculateTotalTUT].
class CalculateTotalTUTProvider extends AutoDisposeProvider<int> {
  /// Provider for TUT calculations.
  ///
  /// Copied from [calculateTotalTUT].
  CalculateTotalTUTProvider(List<(int, Tempo?)> sets)
    : this._internal(
        (ref) => calculateTotalTUT(ref as CalculateTotalTUTRef, sets),
        from: calculateTotalTUTProvider,
        name: r'calculateTotalTUTProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$calculateTotalTUTHash,
        dependencies: CalculateTotalTUTFamily._dependencies,
        allTransitiveDependencies:
            CalculateTotalTUTFamily._allTransitiveDependencies,
        sets: sets,
      );

  CalculateTotalTUTProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sets,
  }) : super.internal();

  final List<(int, Tempo?)> sets;

  @override
  Override overrideWith(int Function(CalculateTotalTUTRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: CalculateTotalTUTProvider._internal(
        (ref) => create(ref as CalculateTotalTUTRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sets: sets,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _CalculateTotalTUTProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateTotalTUTProvider && other.sets == sets;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sets.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CalculateTotalTUTRef on AutoDisposeProviderRef<int> {
  /// The parameter `sets` of this provider.
  List<(int, Tempo?)> get sets;
}

class _CalculateTotalTUTProviderElement extends AutoDisposeProviderElement<int>
    with CalculateTotalTUTRef {
  _CalculateTotalTUTProviderElement(super.provider);

  @override
  List<(int, Tempo?)> get sets => (origin as CalculateTotalTUTProvider).sets;
}

String _$extendedSetDataNotifierHash() =>
    r'ab5cc09368d5c142ea6f85bf514782916c9991a8';

/// Provider for RPE/Tempo data per set.
///
/// Copied from [ExtendedSetDataNotifier].
@ProviderFor(ExtendedSetDataNotifier)
final extendedSetDataNotifierProvider =
    AutoDisposeNotifierProvider<
      ExtendedSetDataNotifier,
      Map<String, ExtendedSetData>
    >.internal(
      ExtendedSetDataNotifier.new,
      name: r'extendedSetDataNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$extendedSetDataNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExtendedSetDataNotifier =
    AutoDisposeNotifier<Map<String, ExtendedSetData>>;
String _$defaultTempoNotifierHash() =>
    r'dfba2dd0b194edc16e0dd02966222a9ad411286c';

/// Provider for default tempo setting.
///
/// Copied from [DefaultTempoNotifier].
@ProviderFor(DefaultTempoNotifier)
final defaultTempoNotifierProvider =
    AutoDisposeNotifierProvider<DefaultTempoNotifier, Tempo>.internal(
      DefaultTempoNotifier.new,
      name: r'defaultTempoNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$defaultTempoNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DefaultTempoNotifier = AutoDisposeNotifier<Tempo>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
