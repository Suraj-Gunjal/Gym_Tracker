// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$measurementStatsHash() => r'd495e7b2c60b34e9658b14fbac0a9bbdb4f274b0';

/// Provider for measurement statistics.
///
/// Copied from [measurementStats].
@ProviderFor(measurementStats)
final measurementStatsProvider =
    AutoDisposeProvider<Map<MeasurementType, MeasurementStats>>.internal(
      measurementStats,
      name: r'measurementStatsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$measurementStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MeasurementStatsRef =
    AutoDisposeProviderRef<Map<MeasurementType, MeasurementStats>>;
String _$measurementsNotifierHash() =>
    r'a6ef64f5218f13c1e26f82d0357524528125c5aa';

/// Provider for body measurements state.
///
/// Copied from [MeasurementsNotifier].
@ProviderFor(MeasurementsNotifier)
final measurementsNotifierProvider =
    AutoDisposeNotifierProvider<
      MeasurementsNotifier,
      List<BodyMeasurement>
    >.internal(
      MeasurementsNotifier.new,
      name: r'measurementsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$measurementsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MeasurementsNotifier = AutoDisposeNotifier<List<BodyMeasurement>>;
String _$measurementProfileNotifierHash() =>
    r'ad20ee0d9c573bbbfdc01a4ece043b1a06f76c15';

/// Provider for measurement profile (goals and settings).
///
/// Copied from [MeasurementProfileNotifier].
@ProviderFor(MeasurementProfileNotifier)
final measurementProfileNotifierProvider =
    AutoDisposeNotifierProvider<
      MeasurementProfileNotifier,
      MeasurementProfile
    >.internal(
      MeasurementProfileNotifier.new,
      name: r'measurementProfileNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$measurementProfileNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MeasurementProfileNotifier = AutoDisposeNotifier<MeasurementProfile>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
