import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Card displaying a body stat with change indicator.
class BodyStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final double? change;
  final String changeUnit;
  final IconData icon;
  final Color color;
  final bool isPositiveGood;

  const BodyStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.change,
    this.changeUnit = '',
    required this.icon,
    required this.color,
    this.isPositiveGood = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change != null && change! > 0;
    final isGood = isPositiveGood ? isPositive : !isPositive;
    final changeColor = change == null || change == 0
        ? AppColors.textTertiaryDark
        : (isGood ? AppColors.success : AppColors.error);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              if (change != null && change != 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: changeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        color: changeColor,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${change!.abs().toStringAsFixed(1)}$changeUnit',
                        style: TextStyle(
                          color: changeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            title,
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
          ),
          const SizedBox(height: 4),

          // Value
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
