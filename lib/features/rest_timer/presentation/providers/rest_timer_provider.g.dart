// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_timer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$restTimerSettingsNotifierHash() =>
    r'f65f25c6e039f86d313937de053ba1713dc1ab14';

/// Provider for rest timer settings
///
/// Copied from [RestTimerSettingsNotifier].
@ProviderFor(RestTimerSettingsNotifier)
final restTimerSettingsNotifierProvider =
    AutoDisposeNotifierProvider<
      RestTimerSettingsNotifier,
      RestTimerSettings
    >.internal(
      RestTimerSettingsNotifier.new,
      name: r'restTimerSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$restTimerSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RestTimerSettingsNotifier = AutoDisposeNotifier<RestTimerSettings>;
String _$restTimerNotifierHash() => r'7a9c6b2fff3a4184228f18ec08b985d833eec857';

/// Provider for active rest timer state
///
/// Copied from [RestTimerNotifier].
@ProviderFor(RestTimerNotifier)
final restTimerNotifierProvider =
    AutoDisposeNotifierProvider<RestTimerNotifier, RestTimerState>.internal(
      RestTimerNotifier.new,
      name: r'restTimerNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$restTimerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RestTimerNotifier = AutoDisposeNotifier<RestTimerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
