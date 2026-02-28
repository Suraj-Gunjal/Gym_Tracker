import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/weekly_insights_service.dart';
import '../../domain/models/weekly_insight.dart';

/// Provider for current week insights.
final currentWeekInsightProvider = FutureProvider<WeeklyInsight>((ref) async {
  final service = ref.watch(weeklyInsightsServiceProvider);
  return service.generateCurrentWeekInsights();
});

/// Provider for insights history.
final insightsHistoryProvider = FutureProvider.family<List<WeeklyInsight>, int>(
  (ref, weeks) async {
    final service = ref.watch(weeklyInsightsServiceProvider);
    return service.getInsightsHistory(weeks);
  },
);

/// State for the insights screen.
class InsightsScreenState {
  final int selectedWeekIndex;
  final bool showAllAchievements;
  final bool showAllRecommendations;

  const InsightsScreenState({
    this.selectedWeekIndex = 0,
    this.showAllAchievements = false,
    this.showAllRecommendations = false,
  });

  InsightsScreenState copyWith({
    int? selectedWeekIndex,
    bool? showAllAchievements,
    bool? showAllRecommendations,
  }) {
    return InsightsScreenState(
      selectedWeekIndex: selectedWeekIndex ?? this.selectedWeekIndex,
      showAllAchievements: showAllAchievements ?? this.showAllAchievements,
      showAllRecommendations:
          showAllRecommendations ?? this.showAllRecommendations,
    );
  }
}

/// Notifier for insights screen state.
class InsightsScreenNotifier extends StateNotifier<InsightsScreenState> {
  InsightsScreenNotifier() : super(const InsightsScreenState());

  void selectWeek(int index) {
    state = state.copyWith(selectedWeekIndex: index);
  }

  void toggleAchievements() {
    state = state.copyWith(showAllAchievements: !state.showAllAchievements);
  }

  void toggleRecommendations() {
    state = state.copyWith(
      showAllRecommendations: !state.showAllRecommendations,
    );
  }
}

/// Provider for insights screen state.
final insightsScreenStateProvider =
    StateNotifierProvider<InsightsScreenNotifier, InsightsScreenState>((ref) {
      return InsightsScreenNotifier();
    });
