// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentEquipmentHash() => r'fad47d3fcd23b70179d4ccb2a2c832dfb979a7db';

/// Provider for current equipment.
///
/// Copied from [currentEquipment].
@ProviderFor(currentEquipment)
final currentEquipmentProvider = AutoDisposeProvider<EquipmentUsage?>.internal(
  currentEquipment,
  name: r'currentEquipmentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentEquipmentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentEquipmentRef = AutoDisposeProviderRef<EquipmentUsage?>;
String _$quickRestTimesHash() => r'b63b004663af3cf79e241efde6104f9eb9f272b4';

/// Provider for rest timer quick starts.
///
/// Copied from [quickRestTimes].
@ProviderFor(quickRestTimes)
final quickRestTimesProvider = AutoDisposeProvider<List<int>>.internal(
  quickRestTimes,
  name: r'quickRestTimesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quickRestTimesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuickRestTimesRef = AutoDisposeProviderRef<List<int>>;
String _$activeTimerNotifierHash() =>
    r'6cfe5d1f34435ff772af22df6a0a83492532c930';

/// Provider for active timer.
///
/// Copied from [ActiveTimerNotifier].
@ProviderFor(ActiveTimerNotifier)
final activeTimerNotifierProvider =
    AutoDisposeNotifierProvider<ActiveTimerNotifier, TimerState?>.internal(
      ActiveTimerNotifier.new,
      name: r'activeTimerNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeTimerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveTimerNotifier = AutoDisposeNotifier<TimerState?>;
String _$timerPresetsNotifierHash() =>
    r'87fe98f247c42448dd7ecb404f23499e548cf0d2';

/// Provider for timer presets.
///
/// Copied from [TimerPresetsNotifier].
@ProviderFor(TimerPresetsNotifier)
final timerPresetsNotifierProvider =
    AutoDisposeNotifierProvider<
      TimerPresetsNotifier,
      List<TimerPreset>
    >.internal(
      TimerPresetsNotifier.new,
      name: r'timerPresetsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$timerPresetsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TimerPresetsNotifier = AutoDisposeNotifier<List<TimerPreset>>;
String _$equipmentUsageNotifierHash() =>
    r'f74deb6cd5fbe016dc8b0b8cac51aad62caeaf1b';

/// Provider for equipment usage tracking.
///
/// Copied from [EquipmentUsageNotifier].
@ProviderFor(EquipmentUsageNotifier)
final equipmentUsageNotifierProvider =
    AutoDisposeNotifierProvider<
      EquipmentUsageNotifier,
      List<EquipmentUsage>
    >.internal(
      EquipmentUsageNotifier.new,
      name: r'equipmentUsageNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$equipmentUsageNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EquipmentUsageNotifier = AutoDisposeNotifier<List<EquipmentUsage>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
