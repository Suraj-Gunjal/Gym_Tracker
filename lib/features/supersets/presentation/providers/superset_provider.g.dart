// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'superset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exerciseGroupsNotifierHash() =>
    r'e078602a2e5f2a0ebbb3f3fb132726df5cf96f9e';

/// State for managing exercise groups.
///
/// Copied from [ExerciseGroupsNotifier].
@ProviderFor(ExerciseGroupsNotifier)
final exerciseGroupsNotifierProvider =
    AutoDisposeNotifierProvider<
      ExerciseGroupsNotifier,
      List<ExerciseGroup>
    >.internal(
      ExerciseGroupsNotifier.new,
      name: r'exerciseGroupsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exerciseGroupsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExerciseGroupsNotifier = AutoDisposeNotifier<List<ExerciseGroup>>;
String _$groupTemplatesNotifierHash() =>
    r'a0bef33e1b165a12abccfcfba131980b6fce8df1';

/// Provider for group templates.
///
/// Copied from [GroupTemplatesNotifier].
@ProviderFor(GroupTemplatesNotifier)
final groupTemplatesNotifierProvider =
    AutoDisposeNotifierProvider<
      GroupTemplatesNotifier,
      List<GroupTemplate>
    >.internal(
      GroupTemplatesNotifier.new,
      name: r'groupTemplatesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$groupTemplatesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GroupTemplatesNotifier = AutoDisposeNotifier<List<GroupTemplate>>;
String _$activeGroupNotifierHash() =>
    r'1a7e4b5bc35f7a4d83e86f7e8c38d0565482be0b';

/// Provider for active superset during workout.
///
/// Copied from [ActiveGroupNotifier].
@ProviderFor(ActiveGroupNotifier)
final activeGroupNotifierProvider =
    AutoDisposeNotifierProvider<ActiveGroupNotifier, ExerciseGroup?>.internal(
      ActiveGroupNotifier.new,
      name: r'activeGroupNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeGroupNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ActiveGroupNotifier = AutoDisposeNotifier<ExerciseGroup?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
