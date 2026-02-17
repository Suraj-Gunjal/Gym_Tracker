import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/deload.dart';
import '../providers/deload_provider.dart';

/// Screen for deload planning and management.
class DeloadPlannerScreen extends ConsumerStatefulWidget {
  const DeloadPlannerScreen({super.key});

  @override
  ConsumerState<DeloadPlannerScreen> createState() =>
      _DeloadPlannerScreenState();
}

class _DeloadPlannerScreenState extends ConsumerState<DeloadPlannerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    final fatigue = ref.watch(fatigueIndicatorsNotifierProvider);
    final isDeloadRecommended = ref.watch(deloadRecommendedProvider);
    final activeDeload = ref.watch(activeDeloadNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Deload Planner'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Sleep'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(fatigue, isDeloadRecommended, activeDeload),
          _buildSleepTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(
    FatigueIndicators fatigue,
    bool isRecommended,
    DeloadWeek? activeDeload,
  ) {
    final weeksSince = ref.watch(weeksSinceLastDeloadProvider);
    final settings = ref.watch(deloadSettingsNotifierProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Active deload banner
        if (activeDeload != null) _buildActiveDeloadBanner(activeDeload),

        // Fatigue gauge
        _FatigueGauge(score: fatigue.fatigueScore),

        const SizedBox(height: 16),

        // Recommendation banner
        if (isRecommended && activeDeload == null)
          _buildRecommendationBanner(fatigue),

        const SizedBox(height: 16),

        // Fatigue indicators
        const _SectionHeader(title: '📊 Fatigue Indicators'),
        _buildIndicatorCard(
          'Sleep Quality',
          '${fatigue.sleepQuality.toStringAsFixed(1)}/10',
          fatigue.sleepQuality / 10,
          _getQualityColor(fatigue.sleepQuality),
        ),
        _buildIndicatorCard(
          'Motivation',
          '${fatigue.motivation.toStringAsFixed(1)}/10',
          fatigue.motivation / 10,
          _getQualityColor(fatigue.motivation),
        ),
        _buildIndicatorCard(
          'Soreness',
          '${fatigue.soreness.toStringAsFixed(1)}/10',
          fatigue.soreness / 10,
          _getInverseColor(fatigue.soreness),
        ),
        _buildIndicatorCard(
          'Performance',
          '${(fatigue.performance * 100).toStringAsFixed(0)}%',
          fatigue.performance,
          _getQualityColor(fatigue.performance * 10),
        ),
        _buildIndicatorCard(
          'Avg RPE',
          fatigue.averageRPE.toStringAsFixed(1),
          fatigue.averageRPE / 10,
          _getInverseColor(fatigue.averageRPE),
        ),

        const SizedBox(height: 24),

        // Stats
        const _SectionHeader(title: '📅 Schedule'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _StatRow(
                label: 'Weeks Since Last Deload',
                value: '$weeksSince weeks',
                color: weeksSince >= settings.weeksBetweenDeloads
                    ? AppColors.warning
                    : AppColors.textPrimaryDark,
              ),
              const Divider(color: AppColors.backgroundDark),
              _StatRow(
                label: 'Scheduled Interval',
                value: 'Every ${settings.weeksBetweenDeloads} weeks',
                color: AppColors.textPrimaryDark,
              ),
              const Divider(color: AppColors.backgroundDark),
              _StatRow(
                label: 'Preferred Strategy',
                value: settings.preferredStrategy.label,
                color: Color(settings.preferredStrategy.colorValue),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Start deload button
        if (activeDeload == null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showStartDeloadSheet(context),
              icon: const Icon(Icons.spa),
              label: const Text('Schedule Deload'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

        const SizedBox(height: 24),

        // Settings
        const _SectionHeader(title: '⚙️ Settings'),
        _buildSettingsCard(settings),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildActiveDeloadBanner(DeloadWeek deload) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(deload.strategy.colorValue).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(deload.strategy.colorValue).withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(deload.strategy.colorValue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.spa, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Deload',
                      style: TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${deload.daysRemaining} days remaining',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(activeDeloadNotifierProvider.notifier).endDeload();
                },
                child: const Text('End Early'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            deload.strategy.label,
            style: TextStyle(
              color: Color(deload.strategy.colorValue),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            deload.strategy.description,
            style: const TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationBanner(FatigueIndicators fatigue) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: AppColors.warning),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Deload Recommended',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fatigue score: ${fatigue.fatigueScore.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(
    String label,
    String value,
    double progress,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondaryDark),
            ),
          ),
          SizedBox(
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                backgroundColor: AppColors.backgroundDark,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(DeloadSettings settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Auto-detect Fatigue',
              style: TextStyle(color: AppColors.textPrimaryDark),
            ),
            subtitle: const Text(
              'Recommend deload based on indicators',
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 12,
              ),
            ),
            value: settings.autoDetect,
            onChanged: (value) {
              ref
                  .read(deloadSettingsNotifierProvider.notifier)
                  .setAutoDetect(value);
            },
            activeColor: AppColors.primary,
          ),
          const Divider(color: AppColors.backgroundDark),
          ListTile(
            title: const Text(
              'Deload Interval',
              style: TextStyle(color: AppColors.textPrimaryDark),
            ),
            trailing: DropdownButton<int>(
              value: settings.weeksBetweenDeloads,
              dropdownColor: AppColors.surfaceDark,
              items: [3, 4, 5, 6, 7, 8].map((w) {
                return DropdownMenuItem(
                  value: w,
                  child: Text(
                    '$w weeks',
                    style: const TextStyle(color: AppColors.textPrimaryDark),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(deloadSettingsNotifierProvider.notifier)
                      .setWeeksBetweenDeloads(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTab() {
    final sleepEntries = ref.watch(sleepEntriesNotifierProvider);
    final avgQuality = ref.watch(averageSleepQualityProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Average quality card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6366F1).withValues(alpha: 0.3),
                AppColors.surfaceDark,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.bedtime, color: Color(0xFF6366F1), size: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '7-Day Average',
                    style: TextStyle(color: AppColors.textSecondaryDark),
                  ),
                  Text(
                    '${avgQuality.toStringAsFixed(1)}/10',
                    style: TextStyle(
                      color: _getQualityColor(avgQuality),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddSleepSheet(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Log'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const _SectionHeader(title: '📊 Sleep History'),

        ...sleepEntries.take(14).map((entry) => _SleepCard(entry: entry)),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildHistoryTab() {
    final history = ref.watch(deloadHistoryNotifierProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (history.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppColors.textSecondaryDark.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No deload history',
                    style: TextStyle(color: AppColors.textSecondaryDark),
                  ),
                ],
              ),
            ),
          )
        else
          ...history.map((deload) => _DeloadHistoryCard(deload: deload)),
        const SizedBox(height: 100),
      ],
    );
  }

  void _showStartDeloadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _StartDeloadSheet(),
    );
  }

  void _showAddSleepSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddSleepSheet(),
    );
  }

  Color _getQualityColor(double value) {
    if (value >= 7) return AppColors.success;
    if (value >= 5) return AppColors.warning;
    return AppColors.error;
  }

  Color _getInverseColor(double value) {
    if (value <= 3) return AppColors.success;
    if (value <= 6) return AppColors.warning;
    return AppColors.error;
  }
}

class _FatigueGauge extends StatelessWidget {
  final double score;

  const _FatigueGauge({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score < 40
        ? AppColors.success
        : score < 60
        ? AppColors.warning
        : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Overall Fatigue',
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 12,
                  backgroundColor: AppColors.backgroundDark,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Column(
                children: [
                  Text(
                    '${score.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: color,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    score < 40
                        ? 'Fresh'
                        : score < 60
                        ? 'Moderate'
                        : 'High',
                    style: TextStyle(color: color, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondaryDark),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SleepCard extends StatelessWidget {
  final SleepEntry entry;

  const _SleepCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final color = entry.quality >= 7
        ? AppColors.success
        : entry.quality >= 5
        ? AppColors.warning
        : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${entry.quality.toStringAsFixed(0)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(entry.date),
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (entry.totalSleep != null)
                  Text(
                    '${entry.totalSleep!.inHours}h ${entry.totalSleep!.inMinutes % 60}m',
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (entry.fromWearable)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '⌚ Watch',
                style: TextStyle(color: Color(0xFF6366F1), fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}';
  }
}

class _DeloadHistoryCard extends StatelessWidget {
  final DeloadWeek deload;

  const _DeloadHistoryCard({required this.deload});

  @override
  Widget build(BuildContext context) {
    final strategyColor = Color(deload.strategy.colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: strategyColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.spa, color: strategyColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deload.strategy.label,
                  style: TextStyle(
                    color: strategyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_formatDate(deload.startDate)} - ${_formatDate(deload.endDate)}',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
                Text(
                  deload.trigger.label,
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (deload.isCompleted)
            const Icon(Icons.check_circle, color: AppColors.success, size: 20),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

class _StartDeloadSheet extends ConsumerStatefulWidget {
  const _StartDeloadSheet();

  @override
  ConsumerState<_StartDeloadSheet> createState() => _StartDeloadSheetState();
}

class _StartDeloadSheetState extends ConsumerState<_StartDeloadSheet> {
  DeloadStrategy _strategy = DeloadStrategy.volume;
  int _duration = 7;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start Deload',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Strategy',
            style: TextStyle(color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 8),
          ...DeloadStrategy.values.map(
            (strategy) => RadioListTile<DeloadStrategy>(
              value: strategy,
              groupValue: _strategy,
              title: Text(
                strategy.label,
                style: const TextStyle(color: AppColors.textPrimaryDark),
              ),
              subtitle: Text(
                strategy.description,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 11,
                ),
              ),
              activeColor: Color(strategy.colorValue),
              onChanged: (value) {
                setState(() => _strategy = value!);
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Duration:',
                style: TextStyle(color: AppColors.textSecondaryDark),
              ),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: _duration,
                dropdownColor: AppColors.surfaceDark,
                items: [5, 7, 10].map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(
                      '$d days',
                      style: const TextStyle(color: AppColors.textPrimaryDark),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _duration = value!);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final now = DateTime.now();
                final deload = DeloadWeek(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  startDate: now,
                  endDate: now.add(Duration(days: _duration - 1)),
                  strategy: _strategy,
                  trigger: DeloadTrigger.manual,
                  volumeReduction: _strategy == DeloadStrategy.volume ? 0.5 : 0,
                  intensityReduction: _strategy == DeloadStrategy.intensity
                      ? 0.4
                      : 0,
                );
                ref
                    .read(activeDeloadNotifierProvider.notifier)
                    .startDeload(deload);
                ref
                    .read(deloadHistoryNotifierProvider.notifier)
                    .addDeload(deload);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(_strategy.colorValue),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Start Deload'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddSleepSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddSleepSheet> createState() => _AddSleepSheetState();
}

class _AddSleepSheetState extends ConsumerState<_AddSleepSheet> {
  double _quality = 7.0;
  int _hours = 7;
  int _minutes = 30;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Log Sleep',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sleep Quality',
            style: TextStyle(color: AppColors.textSecondaryDark),
          ),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _quality,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  activeColor: AppColors.primary,
                  onChanged: (value) => setState(() => _quality = value),
                ),
              ),
              Text(
                _quality.toStringAsFixed(0),
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Sleep Duration',
            style: TextStyle(color: AppColors.textSecondaryDark),
          ),
          Row(
            children: [
              DropdownButton<int>(
                value: _hours,
                dropdownColor: AppColors.surfaceDark,
                items: List.generate(14, (i) => i + 1).map((h) {
                  return DropdownMenuItem(
                    value: h,
                    child: Text(
                      '${h}h',
                      style: const TextStyle(color: AppColors.textPrimaryDark),
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _hours = value!),
              ),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: _minutes,
                dropdownColor: AppColors.surfaceDark,
                items: [0, 15, 30, 45].map((m) {
                  return DropdownMenuItem(
                    value: m,
                    child: Text(
                      '${m}m',
                      style: const TextStyle(color: AppColors.textPrimaryDark),
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _minutes = value!),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final entry = SleepEntry(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  date: DateTime.now(),
                  totalSleep: Duration(hours: _hours, minutes: _minutes),
                  quality: _quality,
                );
                ref.read(sleepEntriesNotifierProvider.notifier).addEntry(entry);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
