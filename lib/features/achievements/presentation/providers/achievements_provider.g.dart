// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unlockedAchievementsHash() =>
    r'9a0e4b9d32841814e797b42f9a564249e1534b6b';

/// Unlocked achievements
///
/// Copied from [unlockedAchievements].
@ProviderFor(unlockedAchievements)
final unlockedAchievementsProvider =
    AutoDisposeProvider<List<UserAchievement>>.internal(
      unlockedAchievements,
      name: r'unlockedAchievementsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$unlockedAchievementsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UnlockedAchievementsRef = AutoDisposeProviderRef<List<UserAchievement>>;
String _$inProgressAchievementsHash() =>
    r'c12d83c99cf3e1a844842d3892e7457e57f005c8';

/// In-progress achievements
///
/// Copied from [inProgressAchievements].
@ProviderFor(inProgressAchievements)
final inProgressAchievementsProvider =
    AutoDisposeProvider<List<UserAchievement>>.internal(
      inProgressAchievements,
      name: r'inProgressAchievementsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inProgressAchievementsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InProgressAchievementsRef =
    AutoDisposeProviderRef<List<UserAchievement>>;
String _$achievementsByCategoryHash() =>
    r'4c03a94c34e6cd8d9d1ce7f2b8c9b78755f98321';

/// Achievements by category
///
/// Copied from [achievementsByCategory].
@ProviderFor(achievementsByCategory)
final achievementsByCategoryProvider =
    AutoDisposeProvider<
      Map<AchievementCategory, List<UserAchievement>>
    >.internal(
      achievementsByCategory,
      name: r'achievementsByCategoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$achievementsByCategoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AchievementsByCategoryRef =
    AutoDisposeProviderRef<Map<AchievementCategory, List<UserAchievement>>>;
String _$newAchievementsCountHash() =>
    r'3f06c6a4a8b93c9334a5113f1acca035bd8b14d0';

/// New (unseen) achievements count
///
/// Copied from [newAchievementsCount].
@ProviderFor(newAchievementsCount)
final newAchievementsCountProvider = AutoDisposeProvider<int>.internal(
  newAchievementsCount,
  name: r'newAchievementsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newAchievementsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NewAchievementsCountRef = AutoDisposeProviderRef<int>;
String _$achievementsNotifierHash() =>
    r'9048b9cc974c78f73e8148e54fb5997cd3677bdf';

/// Provider for all achievements
///
/// Copied from [AchievementsNotifier].
@ProviderFor(AchievementsNotifier)
final achievementsNotifierProvider =
    AutoDisposeNotifierProvider<
      AchievementsNotifier,
      List<Achievement>
    >.internal(
      AchievementsNotifier.new,
      name: r'achievementsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$achievementsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AchievementsNotifier = AutoDisposeNotifier<List<Achievement>>;
String _$userAchievementsNotifierHash() =>
    r'4610cdebcd9acdf9a18e73a4c35ba3f208ca4c34';

/// Provider for user achievement progress
///
/// Copied from [UserAchievementsNotifier].
@ProviderFor(UserAchievementsNotifier)
final userAchievementsNotifierProvider =
    AutoDisposeNotifierProvider<
      UserAchievementsNotifier,
      List<UserAchievement>
    >.internal(
      UserAchievementsNotifier.new,
      name: r'userAchievementsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userAchievementsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserAchievementsNotifier = AutoDisposeNotifier<List<UserAchievement>>;
String _$userStatsNotifierHash() => r'4877553cc2b4bed87bc53da62268dadcfb246a38';

/// Provider for user stats
///
/// Copied from [UserStatsNotifier].
@ProviderFor(UserStatsNotifier)
final userStatsNotifierProvider =
    AutoDisposeNotifierProvider<UserStatsNotifier, UserStats>.internal(
      UserStatsNotifier.new,
      name: r'userStatsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userStatsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserStatsNotifier = AutoDisposeNotifier<UserStats>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
