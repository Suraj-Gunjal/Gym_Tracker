import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/body_measurement.dart';
import '../providers/body_measurement_provider.dart';
import '../widgets/add_measurement_sheet.dart';
import '../widgets/measurement_history_tile.dart';
import '../widgets/body_stats_card.dart';

/// Screen for body measurements and progress tracking.
class BodyMeasurementsScreen extends ConsumerWidget {
  const BodyMeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final measurements = ref.watch(bodyMeasurementsNotifierProvider);
    final latestMeasurement = ref.watch(latestMeasurementProvider);
    final progress = ref.watch(measurementProgressProvider);
    final selectedType = ref.watch(selectedMeasurementTypeProvider);
    final chartData = ref.watch(measurementChartDataProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Body Stats',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                onPressed: () {
                  // TODO: Progress photo feature
                },
              ),
            ],
          ),

          // Stats overview cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main stats row
                  Row(
                    children: [
                      Expanded(
                        child: BodyStatsCard(
                          title: 'Weight',
                          value: latestMeasurement?.weightKg != null
                              ? '${latestMeasurement!.weightKg!.toStringAsFixed(1)} kg'
                              : '--',
                          change: progress?.weightChange,
                          changeUnit: 'kg',
                          icon: Icons.monitor_weight_outlined,
                          color: AppColors.primary,
                          isPositiveGood: false,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BodyStatsCard(
                          title: 'Body Fat',
                          value: latestMeasurement?.bodyFatPercent != null
                              ? '${latestMeasurement!.bodyFatPercent!.toStringAsFixed(1)}%'
                              : '--',
                          change: progress?.bodyFatChange,
                          changeUnit: '%',
                          icon: Icons.pie_chart_outline,
                          color: AppColors.warning,
                          isPositiveGood: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: BodyStatsCard(
                          title: 'Chest',
                          value: latestMeasurement?.chestCm != null
                              ? '${latestMeasurement!.chestCm!.toStringAsFixed(1)} cm'
                              : '--',
                          change: progress?.chestChange,
                          changeUnit: 'cm',
                          icon: Icons.accessibility_new,
                          color: AppColors.secondary,
                          isPositiveGood: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BodyStatsCard(
                          title: 'Biceps',
                          value: latestMeasurement?.avgBicepCm != null
                              ? '${latestMeasurement!.avgBicepCm!.toStringAsFixed(1)} cm'
                              : '--',
                          change: progress?.bicepChange,
                          changeUnit: 'cm',
                          icon: Icons.fitness_center,
                          color: AppColors.info,
                          isPositiveGood: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Progress chart
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chart header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress Chart',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryDark,
                              ),
                        ),
                        if (progress != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${progress.periodDays} days',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Measurement type selector
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              MeasurementType.weight,
                              MeasurementType.bodyFat,
                              MeasurementType.chest,
                              MeasurementType.biceps,
                              MeasurementType.waist,
                            ].map((type) {
                              final isSelected = selectedType == type;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(type.displayName),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    HapticFeedback.selectionClick();
                                    ref
                                        .read(
                                          selectedMeasurementTypeProvider
                                              .notifier,
                                        )
                                        .select(type);
                                  },
                                  backgroundColor: AppColors.surfaceDark,
                                  selectedColor: AppColors.primary.withValues(
                                    alpha: 0.2,
                                  ),
                                  checkmarkColor: AppColors.primary,
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondaryDark,
                                    fontSize: 12,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Chart
                    SizedBox(
                      height: 200,
                      child: _MeasurementChart(
                        data: chartData,
                        measurementType: selectedType,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // History header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Show all history
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          // Measurement history list
          if (measurements.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(onAdd: () => _showAddMeasurement(context)),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final measurement = measurements[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MeasurementHistoryTile(
                      measurement: measurement,
                      onTap: () => _showMeasurementDetail(context, measurement),
                    ),
                  );
                }, childCount: measurements.length.clamp(0, 5)),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMeasurement(context),
        icon: const Icon(Icons.add),
        label: const Text('Log Measurement'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showAddMeasurement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const AddMeasurementSheet(),
    );
  }

  void _showMeasurementDetail(
    BuildContext context,
    BodyMeasurement measurement,
  ) {
    // TODO: Show measurement detail
  }
}

/// Progress chart widget
class _MeasurementChart extends StatelessWidget {
  final List<MeasurementChartPoint> data;
  final MeasurementType measurementType;

  const _MeasurementChart({required this.data, required this.measurementType});

  @override
  Widget build(BuildContext context) {
    final validData = data.where((p) => p.value != null).toList();
    if (validData.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
      );
    }

    final spots = validData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value!);
    }).toList();

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 0.95;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.05;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppColors.textTertiaryDark.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= validData.length) {
                  return const SizedBox();
                }
                final date = validData[value.toInt()].date;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('d/M').format(date),
                    style: TextStyle(
                      color: AppColors.textTertiaryDark,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxY - minY) / 4,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    color: AppColors.textTertiaryDark,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)} ${measurementType.unit}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.straighten_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No measurements yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your body stats to see progress over time',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add Measurement'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
