// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$workoutTemplateRepositoryHash() =>
    r'6388a16a114f9848e5fd09d1a92d1a095fa05454';

/// Provider for workout template repository
///
/// Copied from [workoutTemplateRepository].
@ProviderFor(workoutTemplateRepository)
final workoutTemplateRepositoryProvider =
    AutoDisposeProvider<WorkoutTemplateRepository>.internal(
      workoutTemplateRepository,
      name: r'workoutTemplateRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$workoutTemplateRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WorkoutTemplateRepositoryRef =
    AutoDisposeProviderRef<WorkoutTemplateRepository>;
String _$filteredTemplatesHash() => r'fd1d191a207ff6be08023d98780c18867f242921';

/// Filtered templates based on current filter
///
/// Copied from [filteredTemplates].
@ProviderFor(filteredTemplates)
final filteredTemplatesProvider =
    AutoDisposeProvider<List<WorkoutTemplate>>.internal(
      filteredTemplates,
      name: r'filteredTemplatesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredTemplatesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredTemplatesRef = AutoDisposeProviderRef<List<WorkoutTemplate>>;
String _$templatesNotifierHash() => r'7145e21f91cd9f898fcec869a5f7c149829572ea';

/// Provider for workout templates
///
/// Copied from [TemplatesNotifier].
@ProviderFor(TemplatesNotifier)
final templatesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      TemplatesNotifier,
      List<WorkoutTemplate>
    >.internal(
      TemplatesNotifier.new,
      name: r'templatesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$templatesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TemplatesNotifier = AutoDisposeAsyncNotifier<List<WorkoutTemplate>>;
String _$selectedTemplateHash() => r'804c5022770b2bf41f340cc3f97d1f8e3bda4b70';

/// Provider for currently selected template
///
/// Copied from [SelectedTemplate].
@ProviderFor(SelectedTemplate)
final selectedTemplateProvider =
    AutoDisposeNotifierProvider<SelectedTemplate, WorkoutTemplate?>.internal(
      SelectedTemplate.new,
      name: r'selectedTemplateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedTemplateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedTemplate = AutoDisposeNotifier<WorkoutTemplate?>;
String _$templateFilterNotifierHash() =>
    r'1522c800fb97d1e24035b07e53f7c48039acb2d1';

/// See also [TemplateFilterNotifier].
@ProviderFor(TemplateFilterNotifier)
final templateFilterNotifierProvider =
    AutoDisposeNotifierProvider<
      TemplateFilterNotifier,
      TemplateFilter
    >.internal(
      TemplateFilterNotifier.new,
      name: r'templateFilterNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$templateFilterNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TemplateFilterNotifier = AutoDisposeNotifier<TemplateFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
