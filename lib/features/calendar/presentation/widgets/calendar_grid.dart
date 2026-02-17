import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/calendar_day.dart';

/// Beautiful calendar grid with workout indicators.
class CalendarGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final CalendarMonth? monthData;
  final ValueChanged<DateTime> onDateSelected;

  const CalendarGrid({
    super.key,
    required this.month,
    required this.selectedDate,
    this.monthData,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Monday, 7 = Sunday
    final today = DateTime.now();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.textTertiaryDark.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map(
                  (day) => SizedBox(
                    width: 40,
                    child: Center(
                      child: Text(
                        day,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 8),

          // Calendar days
          ...List.generate(6, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (dayIndex) {
                  final dayNumber =
                      weekIndex * 7 + dayIndex + 1 - (firstWeekday - 1);

                  if (dayNumber < 1 || dayNumber > daysInMonth) {
                    return const SizedBox(width: 40, height: 40);
                  }

                  final date = DateTime(month.year, month.month, dayNumber);
                  final isToday =
                      date.year == today.year &&
                      date.month == today.month &&
                      date.day == today.day;
                  final isSelected =
                      date.year == selectedDate.year &&
                      date.month == selectedDate.month &&
                      date.day == selectedDate.day;
                  final dayData = monthData?.getDay(dayNumber);
                  final hasWorkout = dayData?.hasWorkout ?? false;
                  final hasPR = dayData?.hasPR ?? false;
                  final isFuture = date.isAfter(today);

                  return _DayCell(
                    day: dayNumber,
                    isToday: isToday,
                    isSelected: isSelected,
                    hasWorkout: hasWorkout,
                    hasPR: hasPR,
                    isFuture: isFuture,
                    intensityColor: dayData?.intensityColor,
                    onTap: () => onDateSelected(date),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DayCell extends StatefulWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool hasWorkout;
  final bool hasPR;
  final bool isFuture;
  final Color? intensityColor;
  final VoidCallback onTap;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.hasWorkout,
    required this.hasPR,
    required this.isFuture,
    this.intensityColor,
    required this.onTap,
  });

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(12),
            border: widget.isToday
                ? Border.all(color: const Color(0xFF10B981), width: 2)
                : widget.isSelected
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: widget.hasWorkout && !widget.isFuture
                ? [
                    BoxShadow(
                      color: (widget.intensityColor ?? const Color(0xFF10B981))
                          .withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${widget.day}',
                style: TextStyle(
                  color: _getTextColor(),
                  fontWeight: widget.isToday || widget.isSelected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              // PR indicator
              if (widget.hasPR)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.prGold,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.prGold.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              // Workout indicator dot
              if (widget.hasWorkout && !widget.hasPR)
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (widget.isFuture) return Colors.transparent;
    if (widget.hasWorkout && widget.intensityColor != null) {
      return widget.intensityColor!.withOpacity(0.3);
    }
    return Colors.transparent;
  }

  Color _getTextColor() {
    if (widget.isFuture) return AppColors.textTertiaryDark.withOpacity(0.5);
    if (widget.isSelected) return AppColors.primary;
    if (widget.isToday) return const Color(0xFF10B981);
    if (widget.hasWorkout) return Colors.white;
    return AppColors.textSecondaryDark;
  }
}
