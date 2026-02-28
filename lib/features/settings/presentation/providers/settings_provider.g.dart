// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$settingsNotifierHash() => r'ab980ab25a04409a23435dd32108a9e36ab92847';

/// Settings notifier with SharedPreferences persistence.
///
/// Copied from [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    NotifierProvider<SettingsNotifier, AppSettings>.internal(
      SettingsNotifier.new,
      name: r'settingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$settingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SettingsNotifier = Notifier<AppSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
