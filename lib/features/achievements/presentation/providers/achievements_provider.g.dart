// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievements_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$achievementRepositoryHash() =>
    r'2220cbd9b376f3c15cd9c8e7cf8b1d6445339a5e';

/// Provider for achievement repository
///
/// Copied from [achievementRepository].
@ProviderFor(achievementRepository)
final achievementRepositoryProvider =
    AutoDisposeProvider<AchievementRepository>.internal(
      achievementRepository,
      name: r'achievementRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$achievementRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AchievementRepositoryRef =
    AutoDisposeProviderRef<AchievementRepository>;
String _$unlockedAchievementsHash() =>
    r'fd6cd993fa7df6fd75adb5e8d281dd0039852720';

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
    r'118df153a57e6a2a5a05bc0f288176f70687038c';

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
    r'c548e4835baf3c66081985df4dfcea97ba670d7c';

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
    r'68adbb6a9a1170a06d5e67e491b8d1a943a19a64';

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
    r'97cb78d14fea1a71f8e7ef8e6785c319d9fe0527';

/// Provider for all achievements
///
/// Copied from [AchievementsNotifier].
@ProviderFor(AchievementsNotifier)
final achievementsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
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

typedef _$AchievementsNotifier = AutoDisposeAsyncNotifier<List<Achievement>>;
String _$userAchievementsNotifierHash() =>
    r'a881555c14dd355e84184cbc9051722b0307d137';

/// Provider for user achievement progress
///
/// Copied from [UserAchievementsNotifier].
@ProviderFor(UserAchievementsNotifier)
final userAchievementsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
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

typedef _$UserAchievementsNotifier =
    AutoDisposeAsyncNotifier<List<UserAchievement>>;
String _$userStatsNotifierHash() => r'4ea24d7802fe9201300b69c2bf9b8a398cff5c7a';

/// Provider for user stats
///
/// Copied from [UserStatsNotifier].
@ProviderFor(UserStatsNotifier)
final userStatsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UserStatsNotifier, UserStats>.internal(
      UserStatsNotifier.new,
      name: r'userStatsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userStatsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserStatsNotifier = AutoDisposeAsyncNotifier<UserStats>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
