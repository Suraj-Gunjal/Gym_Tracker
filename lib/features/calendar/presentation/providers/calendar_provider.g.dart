// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedDayDataHash() => r'62c270f00edf876727397441e7dc19b2e5d6140f';

/// Provider for selected day's workouts.
///
/// Copied from [selectedDayData].
@ProviderFor(selectedDayData)
final selectedDayDataProvider = AutoDisposeProvider<CalendarDay?>.internal(
  selectedDayData,
  name: r'selectedDayDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedDayDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedDayDataRef = AutoDisposeProviderRef<CalendarDay?>;
String _$currentStreakHash() => r'14f846777d51eace28a0bc065789aa74746fabf7';

/// Provider for current streak.
///
/// Copied from [currentStreak].
@ProviderFor(currentStreak)
final currentStreakProvider = AutoDisposeProvider<WorkoutStreak>.internal(
  currentStreak,
  name: r'currentStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentStreakRef = AutoDisposeProviderRef<WorkoutStreak>;
String _$currentMonthStatsHash() => r'0cd902215b1984944480bf8f542245b262093829';

/// Provider for current month stats.
///
/// Copied from [currentMonthStats].
@ProviderFor(currentMonthStats)
final currentMonthStatsProvider = AutoDisposeProvider<CalendarMonth?>.internal(
  currentMonthStats,
  name: r'currentMonthStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMonthStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentMonthStatsRef = AutoDisposeProviderRef<CalendarMonth?>;
String _$calendarNotifierHash() => r'a5c3311b0334878ae637c555233ffe7d3be2c0a2';

/// Provider for calendar state.
///
/// Copied from [CalendarNotifier].
@ProviderFor(CalendarNotifier)
final calendarNotifierProvider =
    AutoDisposeNotifierProvider<CalendarNotifier, CalendarState>.internal(
      CalendarNotifier.new,
      name: r'calendarNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$calendarNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CalendarNotifier = AutoDisposeNotifier<CalendarState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
