// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredPhotosHash() => r'28ae2bbcdb16cfee0c1bcc01c084fe64bcc7a35c';

/// Provider for filtered photos.
///
/// Copied from [filteredPhotos].
@ProviderFor(filteredPhotos)
final filteredPhotosProvider =
    AutoDisposeProvider<List<ProgressPhoto>>.internal(
      filteredPhotos,
      name: r'filteredPhotosProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredPhotosHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredPhotosRef = AutoDisposeProviderRef<List<ProgressPhoto>>;
String _$photoTimelineHash() => r'0ec77588c8f61dbcc2a2a77ce5de9922faa84764';

/// Provider for timeline view of photos.
///
/// Copied from [photoTimeline].
@ProviderFor(photoTimeline)
final photoTimelineProvider =
    AutoDisposeProvider<Map<String, List<ProgressPhoto>>>.internal(
      photoTimeline,
      name: r'photoTimelineProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$photoTimelineHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PhotoTimelineRef =
    AutoDisposeProviderRef<Map<String, List<ProgressPhoto>>>;
String _$photoGalleryNotifierHash() =>
    r'9c4610dd2def28315d3625894743231037540cfa';

/// Provider for progress photos state.
///
/// Copied from [PhotoGalleryNotifier].
@ProviderFor(PhotoGalleryNotifier)
final photoGalleryNotifierProvider =
    AutoDisposeNotifierProvider<
      PhotoGalleryNotifier,
      PhotoGalleryState
    >.internal(
      PhotoGalleryNotifier.new,
      name: r'photoGalleryNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$photoGalleryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PhotoGalleryNotifier = AutoDisposeNotifier<PhotoGalleryState>;
String _$photoComparisonNotifierHash() =>
    r'598c9dfdc542509de0cd9ac1309a21f86fd83928';

/// Provider for creating photo comparisons.
///
/// Copied from [PhotoComparisonNotifier].
@ProviderFor(PhotoComparisonNotifier)
final photoComparisonNotifierProvider =
    AutoDisposeNotifierProvider<
      PhotoComparisonNotifier,
      PhotoComparison?
    >.internal(
      PhotoComparisonNotifier.new,
      name: r'photoComparisonNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$photoComparisonNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PhotoComparisonNotifier = AutoDisposeNotifier<PhotoComparison?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
