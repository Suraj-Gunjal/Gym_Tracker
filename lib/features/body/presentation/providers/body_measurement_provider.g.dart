// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_measurement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$latestMeasurementHash() => r'3e472e8a91bffdc0610fdbe3b8e4fddcbc904b20';

/// Latest measurement
///
/// Copied from [latestMeasurement].
@ProviderFor(latestMeasurement)
final latestMeasurementProvider =
    AutoDisposeProvider<BodyMeasurement?>.internal(
      latestMeasurement,
      name: r'latestMeasurementProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$latestMeasurementHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LatestMeasurementRef = AutoDisposeProviderRef<BodyMeasurement?>;
String _$measurementProgressHash() =>
    r'c6e22f99d399e9ca3a74845b9cce5541534e51c5';

/// Measurement progress comparison (latest vs first)
///
/// Copied from [measurementProgress].
@ProviderFor(measurementProgress)
final measurementProgressProvider =
    AutoDisposeProvider<MeasurementProgress?>.internal(
      measurementProgress,
      name: r'measurementProgressProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$measurementProgressHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MeasurementProgressRef = AutoDisposeProviderRef<MeasurementProgress?>;
String _$measurementChartDataHash() =>
    r'8c97d10a374ce9d5e31c7e290e015ec615fa6d0a';

/// Chart data points for selected measurement type
///
/// Copied from [measurementChartData].
@ProviderFor(measurementChartData)
final measurementChartDataProvider =
    AutoDisposeProvider<List<MeasurementChartPoint>>.internal(
      measurementChartData,
      name: r'measurementChartDataProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$measurementChartDataHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MeasurementChartDataRef =
    AutoDisposeProviderRef<List<MeasurementChartPoint>>;
String _$bodyMeasurementsNotifierHash() =>
    r'9ea0589204f5bc2161b745feba9db586540afbc0';

/// Provider for body measurements
///
/// Copied from [BodyMeasurementsNotifier].
@ProviderFor(BodyMeasurementsNotifier)
final bodyMeasurementsNotifierProvider =
    AutoDisposeNotifierProvider<
      BodyMeasurementsNotifier,
      List<BodyMeasurement>
    >.internal(
      BodyMeasurementsNotifier.new,
      name: r'bodyMeasurementsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bodyMeasurementsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$BodyMeasurementsNotifier = AutoDisposeNotifier<List<BodyMeasurement>>;
String _$selectedMeasurementTypeHash() =>
    r'01b8a4517b29e1542f7e5cdb831ebe2080a6a296';

/// Selected measurement type for chart
///
/// Copied from [SelectedMeasurementType].
@ProviderFor(SelectedMeasurementType)
final selectedMeasurementTypeProvider =
    AutoDisposeNotifierProvider<
      SelectedMeasurementType,
      MeasurementType
    >.internal(
      SelectedMeasurementType.new,
      name: r'selectedMeasurementTypeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedMeasurementTypeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedMeasurementType = AutoDisposeNotifier<MeasurementType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
