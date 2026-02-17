import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/wearable.dart';
import '../providers/wearable_provider.dart';

/// Screen for wearable device management and health data.
class WearableScreen extends ConsumerStatefulWidget {
  const WearableScreen({super.key});

  @override
  ConsumerState<WearableScreen> createState() => _WearableScreenState();
}

class _WearableScreenState extends ConsumerState<WearableScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isScanning = false;

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
    final connectedDevice = ref.watch(connectedDeviceNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Wearable'),
        actions: [
          if (connectedDevice != null)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showSettingsSheet(context),
            ),
        ],
        bottom: connectedDevice != null
            ? TabBar(
                controller: _tabController,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(icon: Icon(Icons.favorite), text: 'Live'),
                  Tab(icon: Icon(Icons.battery_std), text: 'Recovery'),
                  Tab(icon: Icon(Icons.bedtime), text: 'Sleep'),
                ],
              )
            : null,
      ),
      body: connectedDevice == null
          ? _NoDeviceView(isScanning: _isScanning, onScan: _startScan)
          : Column(
              children: [
                // Connected device header
                _ConnectedDeviceHeader(device: connectedDevice),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      _LiveDataTab(),
                      _RecoveryTab(),
                      _SleepTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _startScan() async {
    setState(() => _isScanning = true);
    await ref.read(availableDevicesNotifierProvider.notifier).scan();
    setState(() => _isScanning = false);
    if (mounted) {
      _showDeviceList(context);
    }
  }

  void _showDeviceList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _DeviceListSheet(),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _WearableSettingsSheet(),
    );
  }
}

/// View when no device is connected.
class _NoDeviceView extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onScan;

  const _NoDeviceView({required this.isScanning, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.watch, size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 32),
          const Text(
            'Connect Your Wearable',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Track heart rate, recovery, and sleep data from your smartwatch or fitness tracker',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 16),
          ),
          const SizedBox(height: 48),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isScanning ? null : onScan,
              icon: isScanning
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.bluetooth_searching),
              label: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Supported devices
          Text(
            'Supported Devices',
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: WearableType.values.map((type) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type.label,
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Sheet showing available devices.
class _DeviceListSheet extends ConsumerWidget {
  const _DeviceListSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(availableDevicesNotifierProvider);

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
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Available Devices',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (devices.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.bluetooth_disabled,
                      color: AppColors.textSecondaryDark,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No devices found',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...devices.map((device) => _DeviceTile(device: device)),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Tile for a device in the list.
class _DeviceTile extends ConsumerWidget {
  final WearableDevice device;

  const _DeviceTile({required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = switch (device.type) {
      WearableType.appleWatch => Icons.watch,
      WearableType.wearOS => Icons.watch,
      WearableType.fitbit => Icons.fitness_center,
      WearableType.garmin => Icons.explore,
      WearableType.samsung => Icons.watch,
      WearableType.whoop => Icons.radio_button_unchecked,
      WearableType.oura => Icons.radio_button_unchecked,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          device.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          device.type.label,
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        trailing: ElevatedButton(
          onPressed: () async {
            HapticFeedback.mediumImpact();
            await ref
                .read(connectedDeviceNotifierProvider.notifier)
                .connect(device);
            if (context.mounted) Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Connect'),
        ),
      ),
    );
  }
}

/// Header showing connected device info.
class _ConnectedDeviceHeader extends ConsumerWidget {
  final WearableDevice device;

  const _ConnectedDeviceHeader({required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.watch, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: device.isConnected ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      device.status.label,
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (device.batteryLevel != null)
            Row(
              children: [
                Icon(
                  device.batteryLevel! > 20
                      ? Icons.battery_std
                      : Icons.battery_alert,
                  color: device.batteryLevel! > 20
                      ? Colors.green
                      : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '${device.batteryLevel}%',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              ref.read(connectedDeviceNotifierProvider.notifier).disconnect();
            },
            icon: Icon(Icons.link_off, color: AppColors.textSecondaryDark),
          ),
        ],
      ),
    );
  }
}

/// Tab showing live health data.
class _LiveDataTab extends ConsumerWidget {
  const _LiveDataTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthData = ref.watch(liveHealthDataNotifierProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Heart rate card (large)
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.withValues(alpha: 0.3),
                AppColors.surfaceDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    '${healthData.heartRate ?? '--'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' bpm',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getZoneColor(
                    healthData.heartRateZone,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Zone ${healthData.heartRateZone ?? 1}: ${healthData.heartRateZoneName}',
                  style: TextStyle(
                    color: _getZoneColor(healthData.heartRateZone),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Stats grid
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.directions_walk,
                label: 'Steps',
                value: '${healthData.steps ?? 0}',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.local_fire_department,
                label: 'Calories',
                value: '${healthData.caloriesBurned ?? 0}',
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.timeline,
                label: 'HRV',
                value: '${healthData.hrv ?? '--'} ms',
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.air,
                label: 'Blood O₂',
                value: '${healthData.bloodOxygen ?? '--'}%',
                color: Colors.cyan,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatCard(
          icon: Icons.psychology,
          label: 'Stress Level',
          value: '${healthData.stressLevel ?? 0}/100',
          color: Colors.amber,
          subtitle: _getStressLabel(healthData.stressLevel ?? 0),
        ),
      ],
    );
  }

  Color _getZoneColor(int? zone) {
    return switch (zone) {
      1 => Colors.grey,
      2 => Colors.blue,
      3 => Colors.green,
      4 => Colors.orange,
      5 => Colors.red,
      _ => Colors.grey,
    };
  }

  String _getStressLabel(int stress) {
    if (stress < 25) return 'Relaxed';
    if (stress < 50) return 'Normal';
    if (stress < 75) return 'Elevated';
    return 'High';
  }
}

/// Stat card widget.
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String? subtitle;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.subtitle,
  });

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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: TextStyle(color: color, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

/// Tab showing recovery data.
class _RecoveryTab extends ConsumerWidget {
  const _RecoveryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recovery = ref.watch(recoveryScoreNotifierProvider);

    if (recovery == null) {
      return const Center(
        child: Text(
          'No recovery data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final color = recovery.score >= 70
        ? Colors.green
        : recovery.score >= 40
        ? Colors.orange
        : Colors.red;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Recovery score
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.3), AppColors.surfaceDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                '${recovery.score}',
                style: TextStyle(
                  color: color,
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Recovery Score',
                style: TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  recovery.readiness,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Recommendation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  recovery.recommendation,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Metrics
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.timeline,
                label: 'HRV',
                value: '${recovery.hrv} ms',
                color: Colors.purple,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.favorite,
                label: 'Resting HR',
                value: '${recovery.restingHeartRate} bpm',
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _StatCard(
          icon: Icons.bedtime,
          label: 'Sleep Score',
          value: '${recovery.sleepScore}/100',
          color: Colors.indigo,
        ),
      ],
    );
  }
}

/// Tab showing sleep data.
class _SleepTab extends ConsumerWidget {
  const _SleepTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepData = ref.watch(sleepDataNotifierProvider);

    if (sleepData.isEmpty) {
      return const Center(
        child: Text(
          'No sleep data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final latest = sleepData.first;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Latest sleep
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.withValues(alpha: 0.3),
                AppColors.surfaceDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bedtime, color: Colors.indigo, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    '${latest.totalSleep.inHours}h ${latest.totalSleep.inMinutes % 60}m',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                latest.sleepQuality,
                style: TextStyle(
                  color: _getQualityColor(latest.sleepScore),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              // Sleep stages
              _SleepStagesBar(data: latest),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Sleep metrics
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.nights_stay,
                label: 'Deep Sleep',
                value:
                    '${latest.deepSleep.inHours}h ${latest.deepSleep.inMinutes % 60}m',
                color: Colors.indigo,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.psychology,
                label: 'REM Sleep',
                value:
                    '${latest.remSleep.inHours}h ${latest.remSleep.inMinutes % 60}m',
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.timeline,
                label: 'Avg HRV',
                value: '${latest.averageHrv} ms',
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.favorite,
                label: 'Resting HR',
                value: '${latest.restingHeartRate} bpm',
                color: Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // History
        const Text(
          'Sleep History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        ...sleepData
            .skip(1)
            .take(6)
            .map((data) => _SleepHistoryTile(data: data)),
      ],
    );
  }

  Color _getQualityColor(int score) {
    if (score >= 85) return Colors.green;
    if (score >= 70) return Colors.lightGreen;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }
}

/// Sleep stages bar visualization.
class _SleepStagesBar extends StatelessWidget {
  final WearableSleepData data;

  const _SleepStagesBar({required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.totalSleep.inMinutes;
    final deep = data.deepSleep.inMinutes / total;
    final rem = data.remSleep.inMinutes / total;
    final light = data.lightSleep.inMinutes / total;
    final awake = data.awake.inMinutes / total;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: [
              _StageSegment(flex: (deep * 100).toInt(), color: Colors.indigo),
              _StageSegment(flex: (rem * 100).toInt(), color: Colors.purple),
              _StageSegment(flex: (light * 100).toInt(), color: Colors.blue),
              _StageSegment(flex: (awake * 100).toInt(), color: Colors.orange),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StageLegend(label: 'Deep', color: Colors.indigo),
            _StageLegend(label: 'REM', color: Colors.purple),
            _StageLegend(label: 'Light', color: Colors.blue),
            _StageLegend(label: 'Awake', color: Colors.orange),
          ],
        ),
      ],
    );
  }
}

class _StageSegment extends StatelessWidget {
  final int flex;
  final Color color;

  const _StageSegment({required this.flex, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex > 0 ? flex : 1,
      child: Container(height: 8, color: color),
    );
  }
}

class _StageLegend extends StatelessWidget {
  final String label;
  final Color color;

  const _StageLegend({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 11),
        ),
      ],
    );
  }
}

/// Tile for sleep history entry.
class _SleepHistoryTile extends StatelessWidget {
  final WearableSleepData data;

  const _SleepHistoryTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final dayName = _getDayName(data.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            dayName,
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '${data.totalSleep.inHours}h ${data.totalSleep.inMinutes % 60}m',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getScoreColor(data.sleepScore).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${data.sleepScore}',
              style: TextStyle(
                color: _getScoreColor(data.sleepScore),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 1) return 'Yesterday';
    if (diff < 7) {
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday -
          1];
    }
    return '${date.day}/${date.month}';
  }

  Color _getScoreColor(int score) {
    if (score >= 85) return Colors.green;
    if (score >= 70) return Colors.lightGreen;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }
}

/// Settings sheet for wearable.
class _WearableSettingsSheet extends ConsumerWidget {
  const _WearableSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(wearableSettingsNotifierProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Wearable Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _SettingSwitch(
              title: 'Auto Sync',
              subtitle: 'Automatically sync data from wearable',
              value: settings.autoSync,
              onChanged: (v) {
                ref
                    .read(wearableSettingsNotifierProvider.notifier)
                    .toggleAutoSync(v);
              },
            ),
            _SettingSwitch(
              title: 'Real-time Heart Rate',
              subtitle: 'Show live heart rate during workouts',
              value: settings.realTimeHeartRate,
              onChanged: (v) {
                ref
                    .read(wearableSettingsNotifierProvider.notifier)
                    .toggleRealTimeHeartRate(v);
              },
            ),
            _SettingSwitch(
              title: 'Show on Watch',
              subtitle: 'Display workout info on wearable',
              value: settings.showOnWearable,
              onChanged: (v) {
                ref
                    .read(wearableSettingsNotifierProvider.notifier)
                    .toggleShowOnWearable(v);
              },
            ),
            _SettingSwitch(
              title: 'Haptic Feedback',
              subtitle: 'Vibrate on set completion and timer end',
              value: settings.hapticFeedback,
              onChanged: (v) {
                ref
                    .read(wearableSettingsNotifierProvider.notifier)
                    .toggleHapticFeedback(v);
              },
            ),
            _SettingSwitch(
              title: 'Show Rest Timer',
              subtitle: 'Display countdown on wearable',
              value: settings.showRestTimer,
              onChanged: (v) {
                ref
                    .read(wearableSettingsNotifierProvider.notifier)
                    .toggleShowRestTimer(v);
              },
            ),
            _SettingSwitch(
              title: 'Show Current Exercise',
              subtitle: 'Display exercise name on wearable',
              value: settings.showCurrentExercise,
              onChanged: (v) {
                ref
                    .read(wearableSettingsNotifierProvider.notifier)
                    .toggleShowCurrentExercise(v);
              },
            ),
            _SettingSwitch(
              title: 'Show Set Counter',
              subtitle: 'Display set progress on wearable',
              value: settings.showSetCounter,
              onChanged: (v) {
                ref
                    .read(wearableSettingsNotifierProvider.notifier)
                    .toggleShowSetCounter(v);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Setting switch widget.
class _SettingSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: AppColors.textSecondaryDark),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
