// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exportNotifierHash() => r'e6d71a927a8c35658dd3d45613c86bed137c237e';

/// Provider for export state.
///
/// Copied from [ExportNotifier].
@ProviderFor(ExportNotifier)
final exportNotifierProvider =
    AutoDisposeNotifierProvider<ExportNotifier, ExportState>.internal(
      ExportNotifier.new,
      name: r'exportNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exportNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExportNotifier = AutoDisposeNotifier<ExportState>;
String _$importNotifierHash() => r'5e5991fcc94e0c9b7274448574189f82c871828f';

/// Provider for import state.
///
/// Copied from [ImportNotifier].
@ProviderFor(ImportNotifier)
final importNotifierProvider =
    AutoDisposeNotifierProvider<ImportNotifier, ImportState>.internal(
      ImportNotifier.new,
      name: r'importNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$importNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ImportNotifier = AutoDisposeNotifier<ImportState>;
String _$recentExportsHash() => r'e3e6ff9b20cc6fa41311d315ae09db4893deb2cc';

/// Provider for recent exports.
///
/// Copied from [RecentExports].
@ProviderFor(RecentExports)
final recentExportsProvider =
    AutoDisposeNotifierProvider<RecentExports, List<ExportJob>>.internal(
      RecentExports.new,
      name: r'recentExportsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recentExportsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RecentExports = AutoDisposeNotifier<List<ExportJob>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
