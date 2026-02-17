// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wearable_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isWearableConnectedHash() =>
    r'eed8d0e401a541b6cd2a55e290b35454d453d5f1';

/// Provider for checking if wearable is connected.
///
/// Copied from [isWearableConnected].
@ProviderFor(isWearableConnected)
final isWearableConnectedProvider = AutoDisposeProvider<bool>.internal(
  isWearableConnected,
  name: r'isWearableConnectedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isWearableConnectedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsWearableConnectedRef = AutoDisposeProviderRef<bool>;
String _$connectedDeviceNotifierHash() =>
    r'af17e7c5b44360f640fe6bca093b350dcd952885';

/// Provider for connected wearable device.
///
/// Copied from [ConnectedDeviceNotifier].
@ProviderFor(ConnectedDeviceNotifier)
final connectedDeviceNotifierProvider =
    AutoDisposeNotifierProvider<
      ConnectedDeviceNotifier,
      WearableDevice?
    >.internal(
      ConnectedDeviceNotifier.new,
      name: r'connectedDeviceNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$connectedDeviceNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ConnectedDeviceNotifier = AutoDisposeNotifier<WearableDevice?>;
String _$availableDevicesNotifierHash() =>
    r'67e19d4f4b3bbd1a30b67bba7c39cf621fc019c3';

/// Provider for available wearable devices.
///
/// Copied from [AvailableDevicesNotifier].
@ProviderFor(AvailableDevicesNotifier)
final availableDevicesNotifierProvider =
    AutoDisposeNotifierProvider<
      AvailableDevicesNotifier,
      List<WearableDevice>
    >.internal(
      AvailableDevicesNotifier.new,
      name: r'availableDevicesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableDevicesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AvailableDevicesNotifier = AutoDisposeNotifier<List<WearableDevice>>;
String _$liveHealthDataNotifierHash() =>
    r'36b2660ad6294718a8f2d9403b7a946df1acf323';

/// Provider for real-time health data.
///
/// Copied from [LiveHealthDataNotifier].
@ProviderFor(LiveHealthDataNotifier)
final liveHealthDataNotifierProvider =
    AutoDisposeNotifierProvider<
      LiveHealthDataNotifier,
      WearableHealthData
    >.internal(
      LiveHealthDataNotifier.new,
      name: r'liveHealthDataNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$liveHealthDataNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LiveHealthDataNotifier = AutoDisposeNotifier<WearableHealthData>;
String _$wearableSettingsNotifierHash() =>
    r'fcb26a6375406998be09ddc9c6c2dba593da6742';

/// Provider for wearable settings.
///
/// Copied from [WearableSettingsNotifier].
@ProviderFor(WearableSettingsNotifier)
final wearableSettingsNotifierProvider =
    AutoDisposeNotifierProvider<
      WearableSettingsNotifier,
      WearableSettings
    >.internal(
      WearableSettingsNotifier.new,
      name: r'wearableSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$wearableSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WearableSettingsNotifier = AutoDisposeNotifier<WearableSettings>;
String _$workoutSyncsNotifierHash() =>
    r'fa4159f2adb81f82a2aab7e29156cd177e4ca7e2';

/// Provider for workout sync history.
///
/// Copied from [WorkoutSyncsNotifier].
@ProviderFor(WorkoutSyncsNotifier)
final workoutSyncsNotifierProvider =
    AutoDisposeNotifierProvider<
      WorkoutSyncsNotifier,
      List<WearableWorkoutSync>
    >.internal(
      WorkoutSyncsNotifier.new,
      name: r'workoutSyncsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutSyncsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WorkoutSyncsNotifier = AutoDisposeNotifier<List<WearableWorkoutSync>>;
String _$recoveryScoreNotifierHash() =>
    r'd243b138aada230fa40955c60b6c07987ab4cbec';

/// Provider for recovery score.
///
/// Copied from [RecoveryScoreNotifier].
@ProviderFor(RecoveryScoreNotifier)
final recoveryScoreNotifierProvider =
    AutoDisposeNotifierProvider<RecoveryScoreNotifier, RecoveryScore?>.internal(
      RecoveryScoreNotifier.new,
      name: r'recoveryScoreNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recoveryScoreNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RecoveryScoreNotifier = AutoDisposeNotifier<RecoveryScore?>;
String _$sleepDataNotifierHash() => r'5e49c5e440c20f5a00032dea3c7ea2cb664cf247';

/// Provider for sleep data.
///
/// Copied from [SleepDataNotifier].
@ProviderFor(SleepDataNotifier)
final sleepDataNotifierProvider =
    AutoDisposeNotifierProvider<
      SleepDataNotifier,
      List<WearableSleepData>
    >.internal(
      SleepDataNotifier.new,
      name: r'sleepDataNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sleepDataNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SleepDataNotifier = AutoDisposeNotifier<List<WearableSleepData>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
