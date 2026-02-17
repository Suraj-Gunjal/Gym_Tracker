import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/body_measurement.dart';

/// Tile displaying a measurement history entry.
class MeasurementHistoryTile extends StatelessWidget {
  final BodyMeasurement measurement;
  final VoidCallback? onTap;

  const MeasurementHistoryTile({
    super.key,
    required this.measurement,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardDark,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.straighten,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(
                            'EEEE, MMM d',
                          ).format(measurement.measuredAt),
                          style: TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat('h:mm a').format(measurement.measuredAt),
                          style: TextStyle(
                            color: AppColors.textTertiaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.textTertiaryDark),
                ],
              ),
              const SizedBox(height: 12),
              // Stats chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (measurement.weightKg != null)
                    _StatChip(
                      label: 'Weight',
                      value: '${measurement.weightKg!.toStringAsFixed(1)} kg',
                      color: AppColors.primary,
                    ),
                  if (measurement.bodyFatPercent != null)
                    _StatChip(
                      label: 'Body Fat',
                      value:
                          '${measurement.bodyFatPercent!.toStringAsFixed(1)}%',
                      color: AppColors.warning,
                    ),
                  if (measurement.chestCm != null)
                    _StatChip(
                      label: 'Chest',
                      value: '${measurement.chestCm!.toStringAsFixed(1)} cm',
                      color: AppColors.secondary,
                    ),
                  if (measurement.avgBicepCm != null)
                    _StatChip(
                      label: 'Biceps',
                      value: '${measurement.avgBicepCm!.toStringAsFixed(1)} cm',
                      color: AppColors.info,
                    ),
                  if (measurement.waistCm != null)
                    _StatChip(
                      label: 'Waist',
                      value: '${measurement.waistCm!.toStringAsFixed(1)} cm',
                      color: AppColors.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small stat chip
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 11),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
