import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/body_measurement.dart';
import '../providers/measurements_provider.dart';

/// Screen for tracking body measurements with charts.
class MeasurementsScreen extends ConsumerStatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  ConsumerState<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends ConsumerState<MeasurementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  MeasurementType _selectedType = MeasurementType.weight;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(measurementStatsProvider);
    final profile = ref.watch(measurementProfileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(stats, profile),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondaryDark,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'History'),
                Tab(text: 'Goals'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(stats, profile),
            _buildHistoryTab(stats, profile),
            _buildGoalsTab(stats, profile),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMeasurementSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Log'),
      ),
    );
  }

  Widget _buildHeader(
    Map<MeasurementType, MeasurementStats> stats,
    MeasurementProfile profile,
  ) {
    final weightStats = stats[MeasurementType.weight];
    final bodyFatStats = stats[MeasurementType.bodyFat];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.backgroundDark,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 60),
          child: Row(
            children: [
              Expanded(
                child: _HeaderStatCard(
                  title: 'Weight',
                  value: weightStats?.current?.toStringAsFixed(1) ?? '--',
                  unit: profile.isMetric ? 'kg' : 'lbs',
                  change: weightStats?.changeText ?? '--',
                  isPositive: weightStats?.hasImproved ?? false,
                  icon: Icons.monitor_weight_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeaderStatCard(
                  title: 'Body Fat',
                  value: bodyFatStats?.current?.toStringAsFixed(1) ?? '--',
                  unit: '%',
                  change: bodyFatStats?.changeText ?? '--',
                  isPositive: bodyFatStats?.hasImproved ?? false,
                  icon: Icons.percent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab(
    Map<MeasurementType, MeasurementStats> stats,
    MeasurementProfile profile,
  ) {
    final categories = [
      ('Weight & Body Comp', [MeasurementType.weight, MeasurementType.bodyFat]),
      (
        'Upper Body',
        [
          MeasurementType.chest,
          MeasurementType.shoulders,
          MeasurementType.leftArm,
          MeasurementType.rightArm,
        ],
      ),
      ('Core', [MeasurementType.waist, MeasurementType.hips]),
      (
        'Lower Body',
        [
          MeasurementType.leftThigh,
          MeasurementType.rightThigh,
          MeasurementType.leftCalf,
          MeasurementType.rightCalf,
        ],
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick progress chart
        _buildProgressChart(stats),
        const SizedBox(height: 24),

        // Categories
        for (final category in categories) ...[
          Text(
            category.$1,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          ...category.$2.map(
            (type) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _MeasurementCard(
                stats: stats[type] ?? MeasurementStats(type: type),
                profile: profile,
                onTap: () => setState(() => _selectedType = type),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildProgressChart(Map<MeasurementType, MeasurementStats> stats) {
    final selectedStats = stats[_selectedType];
    if (selectedStats == null || selectedStats.history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_selectedType.label} Progress',
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: selectedStats.hasImproved
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedStats.changePercentText,
                  style: TextStyle(
                    color: selectedStats.hasImproved
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: _SimpleLineChart(
              data: selectedStats.history
                  .take(12)
                  .toList()
                  .reversed
                  .map((m) => m.value)
                  .toList(),
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(
    Map<MeasurementType, MeasurementStats> stats,
    MeasurementProfile profile,
  ) {
    final measurements = ref.watch(measurementsNotifierProvider);
    final sortedMeasurements = [...measurements]
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    // Group by date
    final grouped = <String, List<BodyMeasurement>>{};
    for (final m in sortedMeasurements) {
      final key = DateFormat('MMM d, yyyy').format(m.recordedAt);
      grouped.putIfAbsent(key, () => []).add(m);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final date = grouped.keys.elementAt(index);
        final dayMeasurements = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                date,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            ...dayMeasurements.map(
              (m) => _HistoryItem(
                measurement: m,
                profile: profile,
                onDelete: () {
                  ref
                      .read(measurementsNotifierProvider.notifier)
                      .deleteMeasurement(m.id);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildGoalsTab(
    Map<MeasurementType, MeasurementStats> stats,
    MeasurementProfile profile,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Weight goal
        _GoalCard(
          type: MeasurementType.weight,
          current: stats[MeasurementType.weight]?.current,
          goal: profile.goalWeight,
          profile: profile,
          onGoalChanged: (value) {
            ref
                .read(measurementProfileNotifierProvider.notifier)
                .setGoalWeight(value);
          },
        ),
        const SizedBox(height: 12),

        // Body fat goal
        _GoalCard(
          type: MeasurementType.bodyFat,
          current: stats[MeasurementType.bodyFat]?.current,
          goal: profile.goalBodyFat,
          profile: profile,
          onGoalChanged: (value) {
            ref
                .read(measurementProfileNotifierProvider.notifier)
                .setGoalBodyFat(value);
          },
        ),
        const SizedBox(height: 24),

        const Text(
          'Body Measurements Goals',
          style: TextStyle(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),

        // Other goals
        for (final type in [
          MeasurementType.waist,
          MeasurementType.chest,
          MeasurementType.leftArm,
          MeasurementType.rightArm,
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _GoalCard(
              type: type,
              current: stats[type]?.current,
              goal: profile.goals[type],
              profile: profile,
              onGoalChanged: (value) {
                ref
                    .read(measurementProfileNotifierProvider.notifier)
                    .setGoal(type, value);
              },
            ),
          ),
      ],
    );
  }

  void _showAddMeasurementSheet(BuildContext context) {
    MeasurementType selectedType = MeasurementType.weight;
    final valueController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondaryDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Log Measurement',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),

              // Measurement type dropdown
              DropdownButtonFormField<MeasurementType>(
                value: selectedType,
                dropdownColor: AppColors.cardDark,
                decoration: InputDecoration(
                  labelText: 'Measurement Type',
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondaryDark,
                  ),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: MeasurementType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      '${type.emoji} ${type.label}',
                      style: const TextStyle(color: AppColors.textPrimaryDark),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setSheetState(() => selectedType = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Value input
              TextField(
                controller: valueController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: const TextStyle(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  labelText: 'Value',
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondaryDark,
                  ),
                  suffixText: selectedType.getUnit(true),
                  suffixStyle: const TextStyle(
                    color: AppColors.textSecondaryDark,
                  ),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Note input
              TextField(
                controller: noteController,
                style: const TextStyle(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  labelText: 'Note (optional)',
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondaryDark,
                  ),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final value = double.tryParse(valueController.text);
                    if (value != null) {
                      ref
                          .read(measurementsNotifierProvider.notifier)
                          .addMeasurement(
                            selectedType,
                            value,
                            note: noteController.text.isEmpty
                                ? null
                                : noteController.text,
                          );
                      Navigator.pop(context);
                      HapticFeedback.mediumImpact();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Measurement',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String change;
  final bool isPositive;
  final IconData icon;

  const _HeaderStatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.change,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  unit,
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.error.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: isPositive ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeasurementCard extends StatelessWidget {
  final MeasurementStats stats;
  final MeasurementProfile profile;
  final VoidCallback onTap;

  const _MeasurementCard({
    required this.stats,
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  stats.type.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stats.type.label,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    stats.current != null
                        ? '${stats.current!.toStringAsFixed(1)} ${stats.type.getUnit(profile.isMetric)}'
                        : 'No data',
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (stats.change != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: stats.hasImproved
                      ? AppColors.success.withValues(alpha: 0.2)
                      : AppColors.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  stats.changeText,
                  style: TextStyle(
                    color: stats.hasImproved
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textSecondaryDark),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final BodyMeasurement measurement;
  final MeasurementProfile profile;
  final VoidCallback onDelete;

  const _HistoryItem({
    required this.measurement,
    required this.profile,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(measurement.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(measurement.type.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    measurement.type.label,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (measurement.note != null)
                    Text(
                      measurement.note!,
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              '${measurement.value.toStringAsFixed(1)} ${measurement.type.getUnit(profile.isMetric)}',
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final MeasurementType type;
  final double? current;
  final double? goal;
  final MeasurementProfile profile;
  final ValueChanged<double?> onGoalChanged;

  const _GoalCard({
    required this.type,
    required this.current,
    required this.goal,
    required this.profile,
    required this.onGoalChanged,
  });

  double get progress {
    if (current == null || goal == null) return 0;
    // For weight/waist, we want to decrease
    if (type == MeasurementType.weight ||
        type == MeasurementType.waist ||
        type == MeasurementType.bodyFat) {
      if (current! <= goal!) return 1.0;
      return (goal! / current!).clamp(0.0, 1.0);
    }
    // For muscles, we want to increase
    if (current! >= goal!) return 1.0;
    return (current! / goal!).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(type.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  type.label,
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.textSecondaryDark,
                  size: 20,
                ),
                onPressed: () => _showEditGoalDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      current != null
                          ? '${current!.toStringAsFixed(1)} ${type.getUnit(profile.isMetric)}'
                          : '--',
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward,
                color: AppColors.textSecondaryDark,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Goal',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      goal != null
                          ? '${goal!.toStringAsFixed(1)} ${type.getUnit(profile.isMetric)}'
                          : 'Set goal',
                      style: TextStyle(
                        color: goal != null
                            ? AppColors.primary
                            : AppColors.textSecondaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (goal != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.cardDark,
                valueColor: AlwaysStoppedAnimation(
                  progress >= 1.0 ? AppColors.success : AppColors.primary,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).toInt()}% to goal',
              style: const TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showEditGoalDialog(BuildContext context) {
    final controller = TextEditingController(text: goal?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Set ${type.label} Goal',
          style: const TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimaryDark),
          decoration: InputDecoration(
            suffixText: type.getUnit(profile.isMetric),
            suffixStyle: const TextStyle(color: AppColors.textSecondaryDark),
            filled: true,
            fillColor: AppColors.cardDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onGoalChanged(null);
              Navigator.pop(context);
            },
            child: const Text('Remove Goal'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              onGoalChanged(value);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SimpleLineChart extends StatelessWidget {
  final List<double> data;
  final Color color;

  const _SimpleLineChart({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return CustomPaint(
      painter: _LineChartPainter(data: data, color: color),
      size: Size.infinite,
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _LineChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final min = data.reduce((a, b) => a < b ? a : b);
    final max = data.reduce((a, b) => a > b ? a : b);
    final range = max - min;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedY = range > 0 ? (data[i] - min) / range : 0.5;
      final y =
          size.height - (normalizedY * size.height * 0.8) - size.height * 0.1;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedY = range > 0 ? (data[i] - min) / range : 0.5;
      final y =
          size.height - (normalizedY * size.height * 0.8) - size.height * 0.1;
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}
