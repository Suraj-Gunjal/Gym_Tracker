// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_measurement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bodyMeasurementRepositoryHash() =>
    r'0a37dfe9186b54bafc21fbd45dab75991d124754';

/// Provider for body measurement repository
///
/// Copied from [bodyMeasurementRepository].
@ProviderFor(bodyMeasurementRepository)
final bodyMeasurementRepositoryProvider =
    AutoDisposeProvider<BodyMeasurementRepository>.internal(
      bodyMeasurementRepository,
      name: r'bodyMeasurementRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bodyMeasurementRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BodyMeasurementRepositoryRef =
    AutoDisposeProviderRef<BodyMeasurementRepository>;
String _$latestMeasurementHash() => r'0515e4894f8aeaf25113f4c4db402966d7ea5eb7';

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
    r'10a3f2593a13a5f24831421c5a580cbf80546375';

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
    r'aec59f9eb1dfb00ad8d9b305362c9ce17610c12a';

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
    r'b7ea6d5722dea123a700b4b51b507c084869a864';

/// Provider for body measurements
///
/// Copied from [BodyMeasurementsNotifier].
@ProviderFor(BodyMeasurementsNotifier)
final bodyMeasurementsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
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

typedef _$BodyMeasurementsNotifier =
    AutoDisposeAsyncNotifier<List<BodyMeasurement>>;
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
