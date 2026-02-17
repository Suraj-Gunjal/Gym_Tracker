import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/calendar_provider.dart';

/// Bottom sheet showing detailed workout info for a selected day.
class DayDetailSheet extends ConsumerWidget {
  final DateTime date;

  const DayDetailSheet({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarNotifierProvider);
    final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
    final monthData = calendarState.monthsCache[monthKey];
    final dayData = monthData?.getDay(date.day);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
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

                  // Date header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: dayData?.hasWorkout == true
                              ? const Color(0xFF10B981).withOpacity(0.15)
                              : AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${date.day}',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: dayData?.hasWorkout == true
                                        ? const Color(0xFF10B981)
                                        : AppColors.textSecondaryDark,
                                  ),
                            ),
                            Text(
                              _getWeekdayName(date.weekday),
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textTertiaryDark),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getMonthName(date.month),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${date.year}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondaryDark,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (dayData?.hasPR == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'PR Day!',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  if (dayData?.hasWorkout == true) ...[
                    // Workout stats
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Workout Summary',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _StatBox(
                                icon: Icons.timer,
                                value: dayData!.formattedDuration,
                                label: 'Duration',
                              ),
                              const SizedBox(width: 12),
                              _StatBox(
                                icon: Icons.fitness_center,
                                value: '${dayData.totalSets}',
                                label: 'Sets',
                              ),
                              const SizedBox(width: 12),
                              _StatBox(
                                icon: Icons.monitor_weight,
                                value: dayData.formattedVolume,
                                label: 'Volume',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Muscles worked
                    if (dayData.muscleGroups.isNotEmpty) ...[
                      Text(
                        'Muscles Worked',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: dayData.muscleGroups.map((muscle) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              muscle,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // View workout details
                            },
                            icon: const Icon(Icons.visibility),
                            label: const Text('View Details'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Repeat workout
                            },
                            icon: const Icon(Icons.replay),
                            label: const Text('Repeat'),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // No workout - show options
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.fitness_center,
                            size: 48,
                            color: AppColors.textTertiaryDark,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No workout logged',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            date.isAfter(DateTime.now())
                                ? 'This is a future date'
                                : 'Rest day or missed workout',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textTertiaryDark),
                          ),
                          if (!date.isAfter(DateTime.now())) ...[
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Log past workout
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Log Past Workout'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getWeekdayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
