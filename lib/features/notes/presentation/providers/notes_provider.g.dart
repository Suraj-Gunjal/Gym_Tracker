// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeChallengesHash() => r'f97f6e53ee2659c87e958c2556fb61d5e6754bb2';

/// Provider for active challenges only.
///
/// Copied from [activeChallenges].
@ProviderFor(activeChallenges)
final activeChallengesProvider =
    AutoDisposeProvider<List<WorkoutChallenge>>.internal(
      activeChallenges,
      name: r'activeChallengesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeChallengesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveChallengesRef = AutoDisposeProviderRef<List<WorkoutChallenge>>;
String _$exerciseNotesHash() => r'ca6d3e91e239af0d9182e5fbbfd7607fdf6d4940';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider for specific exercise notes.
///
/// Copied from [exerciseNotes].
@ProviderFor(exerciseNotes)
const exerciseNotesProvider = ExerciseNotesFamily();

/// Provider for specific exercise notes.
///
/// Copied from [exerciseNotes].
class ExerciseNotesFamily extends Family<ExerciseNote?> {
  /// Provider for specific exercise notes.
  ///
  /// Copied from [exerciseNotes].
  const ExerciseNotesFamily();

  /// Provider for specific exercise notes.
  ///
  /// Copied from [exerciseNotes].
  ExerciseNotesProvider call(String exerciseId) {
    return ExerciseNotesProvider(exerciseId);
  }

  @override
  ExerciseNotesProvider getProviderOverride(
    covariant ExerciseNotesProvider provider,
  ) {
    return call(provider.exerciseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exerciseNotesProvider';
}

/// Provider for specific exercise notes.
///
/// Copied from [exerciseNotes].
class ExerciseNotesProvider extends AutoDisposeProvider<ExerciseNote?> {
  /// Provider for specific exercise notes.
  ///
  /// Copied from [exerciseNotes].
  ExerciseNotesProvider(String exerciseId)
    : this._internal(
        (ref) => exerciseNotes(ref as ExerciseNotesRef, exerciseId),
        from: exerciseNotesProvider,
        name: r'exerciseNotesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$exerciseNotesHash,
        dependencies: ExerciseNotesFamily._dependencies,
        allTransitiveDependencies:
            ExerciseNotesFamily._allTransitiveDependencies,
        exerciseId: exerciseId,
      );

  ExerciseNotesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.exerciseId,
  }) : super.internal();

  final String exerciseId;

  @override
  Override overrideWith(
    ExerciseNote? Function(ExerciseNotesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ExerciseNotesProvider._internal(
        (ref) => create(ref as ExerciseNotesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        exerciseId: exerciseId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<ExerciseNote?> createElement() {
    return _ExerciseNotesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExerciseNotesProvider && other.exerciseId == exerciseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, exerciseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExerciseNotesRef on AutoDisposeProviderRef<ExerciseNote?> {
  /// The parameter `exerciseId` of this provider.
  String get exerciseId;
}

class _ExerciseNotesProviderElement
    extends AutoDisposeProviderElement<ExerciseNote?>
    with ExerciseNotesRef {
  _ExerciseNotesProviderElement(super.provider);

  @override
  String get exerciseId => (origin as ExerciseNotesProvider).exerciseId;
}

String _$exerciseNotesNotifierHash() =>
    r'c53fc565d2f548787b2066828bd79dbdda332ba0';

/// Provider for exercise notes.
///
/// Copied from [ExerciseNotesNotifier].
@ProviderFor(ExerciseNotesNotifier)
final exerciseNotesNotifierProvider =
    AutoDisposeNotifierProvider<
      ExerciseNotesNotifier,
      Map<String, ExerciseNote>
    >.internal(
      ExerciseNotesNotifier.new,
      name: r'exerciseNotesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exerciseNotesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExerciseNotesNotifier =
    AutoDisposeNotifier<Map<String, ExerciseNote>>;
String _$challengesNotifierHash() =>
    r'0b70fb0299f0eea2b1e29cefa681b4e09ee78b93';

/// Provider for workout challenges.
///
/// Copied from [ChallengesNotifier].
@ProviderFor(ChallengesNotifier)
final challengesNotifierProvider =
    AutoDisposeNotifierProvider<
      ChallengesNotifier,
      List<WorkoutChallenge>
    >.internal(
      ChallengesNotifier.new,
      name: r'challengesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$challengesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChallengesNotifier = AutoDisposeNotifier<List<WorkoutChallenge>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
