import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/calendar_day.dart';

/// GitHub-style heat map for yearly workout visualization.
class CalendarHeatMap extends ConsumerWidget {
  const CalendarHeatMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textTertiaryDark.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${now.year} Activity',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '156 workouts',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Month labels
          Row(
            children: [
              const SizedBox(width: 24), // Space for day labels
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                      [
                            'J',
                            'F',
                            'M',
                            'A',
                            'M',
                            'J',
                            'J',
                            'A',
                            'S',
                            'O',
                            'N',
                            'D',
                          ]
                          .map(
                            (m) => Text(
                              m,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.textTertiaryDark,
                                    fontSize: 10,
                                  ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Heat map grid
          SizedBox(
            height: 100,
            child: Row(
              children: [
                // Day labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['M', 'W', 'F']
                      .map(
                        (d) => Text(
                          d,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textTertiaryDark,
                                fontSize: 10,
                              ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 8),

                // Grid cells
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final cellSize = (constraints.maxWidth / 53).clamp(
                        8.0,
                        14.0,
                      );
                      final spacing = 2.0;

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(53, (weekIndex) {
                            return Column(
                              children: List.generate(7, (dayIndex) {
                                final dayNumber = weekIndex * 7 + dayIndex;
                                final date = startOfYear.add(
                                  Duration(days: dayNumber),
                                );

                                if (date.year != now.year ||
                                    date.isAfter(now)) {
                                  return SizedBox(
                                    width: cellSize + spacing,
                                    height: cellSize + spacing,
                                  );
                                }

                                // Mock workout data - in production, get from provider
                                final hasWorkout = (dayNumber * 17) % 5 < 2;
                                final intensity = hasWorkout
                                    ? (dayNumber % 10) + 1
                                    : 0;
                                final dayData = hasWorkout
                                    ? CalendarDay(
                                        date: date,
                                        workoutCount: 1,
                                        intensityLevel: intensity,
                                      )
                                    : null;

                                return Padding(
                                  padding: EdgeInsets.all(spacing / 2),
                                  child: Tooltip(
                                    message: _formatTooltip(date, dayData),
                                    child: Container(
                                      width: cellSize,
                                      height: cellSize,
                                      decoration: BoxDecoration(
                                        color:
                                            dayData?.intensityColor ??
                                            AppColors.backgroundDark,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Less',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
              ),
              const SizedBox(width: 4),
              ...List.generate(5, (index) {
                final intensity = (index + 1) * 2;
                final day = CalendarDay(
                  date: DateTime.now(),
                  workoutCount: 1,
                  intensityLevel: intensity,
                );
                return Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index == 0
                        ? AppColors.backgroundDark
                        : day.intensityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
              const SizedBox(width: 4),
              Text(
                'More',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTooltip(DateTime date, CalendarDay? data) {
    final dateStr = '${date.day}/${date.month}/${date.year}';
    if (data == null) return '$dateStr: No workout';
    return '$dateStr: ${data.workoutCount} workout(s), ${data.formattedDuration}';
  }
}
