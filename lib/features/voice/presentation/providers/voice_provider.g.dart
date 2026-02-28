// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$commandsByCategoryHash() =>
    r'b919e69b58e12dc474df8d1dd6a7b084db908515';

/// Provider for available commands by category.
///
/// Copied from [commandsByCategory].
@ProviderFor(commandsByCategory)
final commandsByCategoryProvider =
    AutoDisposeProvider<Map<VoiceCommandCategory, List<VoiceCommand>>>.internal(
      commandsByCategory,
      name: r'commandsByCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$commandsByCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CommandsByCategoryRef =
    AutoDisposeProviderRef<Map<VoiceCommandCategory, List<VoiceCommand>>>;
String _$isVoiceEnabledHash() => r'0f0963233e06d1ad0afc1700da085cc41ccfe729';

/// Provider for checking if voice is enabled.
///
/// Copied from [isVoiceEnabled].
@ProviderFor(isVoiceEnabled)
final isVoiceEnabledProvider = AutoDisposeProvider<bool>.internal(
  isVoiceEnabled,
  name: r'isVoiceEnabledProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isVoiceEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsVoiceEnabledRef = AutoDisposeProviderRef<bool>;
String _$voiceRecognitionNotifierHash() =>
    r'1727ec23cd4299cd2eece0e7abda3be989ff4592';

/// Provider for voice recognition state.
///
/// Copied from [VoiceRecognitionNotifier].
@ProviderFor(VoiceRecognitionNotifier)
final voiceRecognitionNotifierProvider =
    AutoDisposeNotifierProvider<
      VoiceRecognitionNotifier,
      VoiceRecognitionState
    >.internal(
      VoiceRecognitionNotifier.new,
      name: r'voiceRecognitionNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$voiceRecognitionNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VoiceRecognitionNotifier = AutoDisposeNotifier<VoiceRecognitionState>;
String _$voiceSettingsNotifierHash() =>
    r'4cf89c464819bf7ca31fcc3def747de646fe51bc';

/// Provider for voice settings.
///
/// Copied from [VoiceSettingsNotifier].
@ProviderFor(VoiceSettingsNotifier)
final voiceSettingsNotifierProvider =
    AutoDisposeNotifierProvider<VoiceSettingsNotifier, VoiceSettings>.internal(
      VoiceSettingsNotifier.new,
      name: r'voiceSettingsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$voiceSettingsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VoiceSettingsNotifier = AutoDisposeNotifier<VoiceSettings>;
String _$voiceCommandHistoryNotifierHash() =>
    r'719dd0638d40ea58490c452278881117b208e764';

/// Provider for voice command history.
///
/// Copied from [VoiceCommandHistoryNotifier].
@ProviderFor(VoiceCommandHistoryNotifier)
final voiceCommandHistoryNotifierProvider =
    AutoDisposeNotifierProvider<
      VoiceCommandHistoryNotifier,
      List<VoiceCommandHistory>
    >.internal(
      VoiceCommandHistoryNotifier.new,
      name: r'voiceCommandHistoryNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$voiceCommandHistoryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$VoiceCommandHistoryNotifier =
    AutoDisposeNotifier<List<VoiceCommandHistory>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
