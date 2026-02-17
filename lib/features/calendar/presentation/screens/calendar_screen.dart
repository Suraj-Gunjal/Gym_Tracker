import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/calendar_day.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/calendar_heat_map.dart';
import '../widgets/day_detail_sheet.dart';
import '../widgets/month_stats_card.dart';
import '../widgets/streak_banner.dart';

/// Beautiful calendar screen with heat map visualization.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with gradient
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.2),
                      AppColors.backgroundDark,
                    ],
                  ),
                ),
              ),
              title: Text(
                'Workout Calendar',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.today),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(calendarNotifierProvider.notifier).goToToday();
                },
                tooltip: 'Go to today',
              ),
              IconButton(
                icon: const Icon(Icons.view_module),
                onPressed: () => _showViewOptions(context, ref),
                tooltip: 'View options',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Streak Banner
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: StreakBanner(),
            ),
          ),

          // Month Navigation
          SliverToBoxAdapter(
            child: _MonthNavigator(
              month: calendarState.focusedMonth,
              onPrevious: () {
                HapticFeedback.selectionClick();
                ref.read(calendarNotifierProvider.notifier).previousMonth();
              },
              onNext: () {
                HapticFeedback.selectionClick();
                ref.read(calendarNotifierProvider.notifier).nextMonth();
              },
            ),
          ),

          // Calendar View
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: calendarState.viewMode == CalendarViewMode.year
                  ? const CalendarHeatMap()
                  : CalendarGrid(
                      month: calendarState.focusedMonth,
                      selectedDate: calendarState.selectedDate,
                      monthData: calendarState.currentMonthData,
                      onDateSelected: (date) {
                        HapticFeedback.selectionClick();
                        ref
                            .read(calendarNotifierProvider.notifier)
                            .selectDate(date);
                        _showDayDetail(context, date);
                      },
                    ),
            ),
          ),

          // Month Stats
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: MonthStatsCard(),
            ),
          ),

          // Legend
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _IntensityLegend(),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showViewOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ViewOptionsSheet(
        currentMode: ref.read(calendarNotifierProvider).viewMode,
        onModeSelected: (mode) {
          ref.read(calendarNotifierProvider.notifier).setViewMode(mode);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDayDetail(BuildContext context, DateTime date) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DayDetailSheet(date: date),
    );
  }
}

class _MonthNavigator extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthNavigator({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(backgroundColor: AppColors.surfaceDark),
          ),
          GestureDetector(
            onTap: () {
              // Could show month picker
            },
            child: Column(
              children: [
                Text(
                  months[month.month - 1],
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${month.year}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(backgroundColor: AppColors.surfaceDark),
          ),
        ],
      ),
    );
  }
}

class _IntensityLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Less',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiaryDark),
        ),
        const SizedBox(width: 8),
        ...List.generate(5, (index) {
          final intensity = (index + 1) * 2;
          final day = CalendarDay(
            date: DateTime.now(),
            workoutCount: 1,
            intensityLevel: intensity,
          );
          return Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: day.intensityColor,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
        const SizedBox(width: 8),
        Text(
          'More',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiaryDark),
        ),
      ],
    );
  }
}

class _ViewOptionsSheet extends StatelessWidget {
  final CalendarViewMode currentMode;
  final ValueChanged<CalendarViewMode> onModeSelected;

  const _ViewOptionsSheet({
    required this.currentMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiaryDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Calendar View',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _ViewOption(
            icon: Icons.calendar_view_month,
            title: 'Month View',
            subtitle: 'Classic calendar grid',
            isSelected: currentMode == CalendarViewMode.month,
            onTap: () => onModeSelected(CalendarViewMode.month),
          ),
          _ViewOption(
            icon: Icons.view_week,
            title: 'Week View',
            subtitle: 'Focus on current week',
            isSelected: currentMode == CalendarViewMode.week,
            onTap: () => onModeSelected(CalendarViewMode.week),
          ),
          _ViewOption(
            icon: Icons.grid_view,
            title: 'Year Heat Map',
            subtitle: 'GitHub-style activity view',
            isSelected: currentMode == CalendarViewMode.year,
            onTap: () => onModeSelected(CalendarViewMode.year),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _ViewOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF10B981).withOpacity(0.15)
              : AppColors.backgroundDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF10B981)
                : AppColors.textTertiaryDark.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF10B981).withOpacity(0.2)
                    : AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF10B981)
                    : AppColors.textSecondaryDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiaryDark,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF10B981)),
          ],
        ),
      ),
    );
  }
}
