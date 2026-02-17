// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warmup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$suggestedWarmupsHash() => r'34981184bae2ed1cc6e7501c5cffea093cf89750';

/// Quick warm-up generator for common exercises.
///
/// Copied from [suggestedWarmups].
@ProviderFor(suggestedWarmups)
final suggestedWarmupsProvider =
    AutoDisposeProvider<List<WarmupRoutine>>.internal(
      suggestedWarmups,
      name: r'suggestedWarmupsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suggestedWarmupsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SuggestedWarmupsRef = AutoDisposeProviderRef<List<WarmupRoutine>>;
String _$warmupSettingsNotifierHash() =>
    r'ba533289113e8d8eb6e7a1df12de2ca9828a6fa9';

/// Provider for warm-up settings.
///
/// Copied from [WarmupSettingsNotifier].
@ProviderFor(WarmupSettingsNotifier)
final warmupSettingsNotifierProvider =
    AutoDisposeNotifierProvider<
      WarmupSettingsNotifier,
      WarmupSettings
    >.internal(
      WarmupSettingsNotifier.new,
      name: r'warmupSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$warmupSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WarmupSettingsNotifier = AutoDisposeNotifier<WarmupSettings>;
String _$activeWarmupNotifierHash() =>
    r'eb241e5c0626549a4f6be5ac07559194b434827e';

/// Provider for active warm-up routine.
///
/// Copied from [ActiveWarmupNotifier].
@ProviderFor(ActiveWarmupNotifier)
final activeWarmupNotifierProvider =
    AutoDisposeNotifierProvider<ActiveWarmupNotifier, WarmupRoutine?>.internal(
      ActiveWarmupNotifier.new,
      name: r'activeWarmupNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeWarmupNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveWarmupNotifier = AutoDisposeNotifier<WarmupRoutine?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
