// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$volumeAnalyticsNotifierHash() =>
    r'fc75de326289679340d4b514c9ac52f7e237eb69';

/// Provider for volume analytics.
///
/// Copied from [VolumeAnalyticsNotifier].
@ProviderFor(VolumeAnalyticsNotifier)
final volumeAnalyticsNotifierProvider =
    AutoDisposeNotifierProvider<
      VolumeAnalyticsNotifier,
      VolumeAnalytics
    >.internal(
      VolumeAnalyticsNotifier.new,
      name: r'volumeAnalyticsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$volumeAnalyticsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VolumeAnalyticsNotifier = AutoDisposeNotifier<VolumeAnalytics>;
String _$fatigueLevelsNotifierHash() =>
    r'fb2a6bb9604955f101a69ebfee73d3cccab7c6bd';

/// Provider for fatigue levels.
///
/// Copied from [FatigueLevelsNotifier].
@ProviderFor(FatigueLevelsNotifier)
final fatigueLevelsNotifierProvider =
    AutoDisposeNotifierProvider<
      FatigueLevelsNotifier,
      Map<MuscleGroup, FatigueLevel>
    >.internal(
      FatigueLevelsNotifier.new,
      name: r'fatigueLevelsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fatigueLevelsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FatigueLevelsNotifier =
    AutoDisposeNotifier<Map<MuscleGroup, FatigueLevel>>;
String _$intensityScoresNotifierHash() =>
    r'a647daec34176a3e24a08da9bc4dce0ae854aeae';

/// Provider for workout intensity scores.
///
/// Copied from [IntensityScoresNotifier].
@ProviderFor(IntensityScoresNotifier)
final intensityScoresNotifierProvider =
    AutoDisposeNotifierProvider<
      IntensityScoresNotifier,
      List<IntensityScore>
    >.internal(
      IntensityScoresNotifier.new,
      name: r'intensityScoresNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$intensityScoresNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$IntensityScoresNotifier = AutoDisposeNotifier<List<IntensityScore>>;
String _$pRPredictionsNotifierHash() =>
    r'0e6f53a76165c4566d0109ee8919ef192e897415';

/// Provider for PR predictions.
///
/// Copied from [PRPredictionsNotifier].
@ProviderFor(PRPredictionsNotifier)
final pRPredictionsNotifierProvider =
    AutoDisposeNotifierProvider<
      PRPredictionsNotifier,
      Map<String, double>
    >.internal(
      PRPredictionsNotifier.new,
      name: r'pRPredictionsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pRPredictionsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PRPredictionsNotifier = AutoDisposeNotifier<Map<String, double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
