import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/timer.dart';
import '../providers/timer_provider.dart';

/// Full-featured timer screen.
class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
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
    final activeTimer = ref.watch(activeTimerNotifierProvider);
    final currentEquipment = ref.watch(currentEquipmentProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Timer'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: const [
            Tab(text: 'Rest'),
            Tab(text: 'Intervals'),
            Tab(text: 'Equipment'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Active timer display
          if (activeTimer != null) _buildActiveTimer(activeTimer),
          if (currentEquipment != null && activeTimer == null)
            _buildEquipmentBanner(currentEquipment),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRestTab(),
                _buildIntervalsTab(),
                _buildEquipmentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTimer(TimerState timer) {
    final color = Color(timer.type.colorValue);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.3), AppColors.surfaceDark],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          // Timer type badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(timer.type.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                timer.type.label,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              if (timer.currentRound != null) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: timer.isWorkPhase
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    timer.isWorkPhase ? 'WORK' : 'REST',
                    style: TextStyle(
                      color: timer.isWorkPhase
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 20),

          // Circular progress
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CustomPaint(
                  painter: _TimerProgressPainter(
                    progress: timer.progress,
                    color: color,
                    backgroundColor: AppColors.backgroundDark,
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    timer.formattedTime,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (timer.currentRound != null)
                    Text(
                      'Round ${timer.currentRound}/${timer.totalRounds}',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add time
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(activeTimerNotifierProvider.notifier).addSeconds(15);
                },
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.surfaceDark,
                  foregroundColor: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(width: 16),
              // Play/Pause
              IconButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  if (timer.isRunning) {
                    ref.read(activeTimerNotifierProvider.notifier).pause();
                  } else {
                    ref.read(activeTimerNotifierProvider.notifier).resume();
                  }
                },
                icon: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
                iconSize: 40,
                style: IconButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 16),
              // Stop
              IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  ref.read(activeTimerNotifierProvider.notifier).stop();
                },
                icon: const Icon(Icons.stop),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.2),
                  foregroundColor: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentBanner(EquipmentUsage equipment) {
    final isOvertime = equipment.isOvertime;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOvertime
            ? AppColors.warning.withValues(alpha: 0.15)
            : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: isOvertime
            ? Border.all(color: AppColors.warning.withValues(alpha: 0.5))
            : null,
      ),
      child: Row(
        children: [
          Text(equipment.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  equipment.name,
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${equipment.elapsedMinutes} min${equipment.targetMinutes != null ? ' / ${equipment.targetMinutes} min' : ''}',
                  style: TextStyle(
                    color: isOvertime
                        ? AppColors.warning
                        : AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(equipmentUsageNotifierProvider.notifier)
                  .stopUsing(equipment.id);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildRestTab() {
    final quickTimes = ref.watch(quickRestTimesProvider);
    final presets = ref
        .watch(timerPresetsNotifierProvider)
        .where((p) => p.type == TimerType.restTimer)
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionHeader(title: '⚡ Quick Start'),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: quickTimes.map((seconds) {
            return _QuickTimeButton(
              seconds: seconds,
              onTap: () {
                HapticFeedback.mediumImpact();
                ref
                    .read(activeTimerNotifierProvider.notifier)
                    .startTimer(TimerType.restTimer, seconds);
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
        const _SectionHeader(title: '📋 Presets'),
        ...presets.map(
          (preset) => _PresetCard(
            preset: preset,
            onTap: () {
              HapticFeedback.mediumImpact();
              ref
                  .read(activeTimerNotifierProvider.notifier)
                  .startTimer(preset.type, preset.seconds);
            },
          ),
        ),

        const SizedBox(height: 24),
        _buildCustomTimerSection(),

        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCustomTimerSection() {
    int minutes = 1;
    int seconds = 30;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Custom Timer',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Minutes
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => setState(
                          () => minutes = (minutes + 1).clamp(0, 59),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_up),
                        color: AppColors.textSecondaryDark,
                      ),
                      Text(
                        minutes.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(
                          () => minutes = (minutes - 1).clamp(0, 59),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        color: AppColors.textSecondaryDark,
                      ),
                      const Text(
                        'min',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ':',
                      style: TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Seconds
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => setState(
                          () => seconds = (seconds + 5).clamp(0, 55),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_up),
                        color: AppColors.textSecondaryDark,
                      ),
                      Text(
                        seconds.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(
                          () => seconds = (seconds - 5).clamp(0, 55),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down),
                        color: AppColors.textSecondaryDark,
                      ),
                      const Text(
                        'sec',
                        style: TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final totalSeconds = minutes * 60 + seconds;
                    if (totalSeconds > 0) {
                      HapticFeedback.mediumImpact();
                      ref
                          .read(activeTimerNotifierProvider.notifier)
                          .startTimer(TimerType.restTimer, totalSeconds);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Start'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIntervalsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _IntervalCard(
          title: 'Tabata',
          subtitle: '8 rounds: 20s work / 10s rest',
          emoji: '🔥',
          color: const Color(0xFFEF4444),
          onStart: () {
            HapticFeedback.heavyImpact();
            ref
                .read(activeTimerNotifierProvider.notifier)
                .startIntervalTimer(IntervalConfig.tabata);
          },
        ),
        _IntervalCard(
          title: 'EMOM',
          subtitle: '10 rounds: 40s work / 20s rest',
          emoji: '⚡',
          color: const Color(0xFF8B5CF6),
          onStart: () {
            HapticFeedback.heavyImpact();
            ref
                .read(activeTimerNotifierProvider.notifier)
                .startIntervalTimer(IntervalConfig.emom);
          },
        ),
        _IntervalCard(
          title: '10 Min AMRAP',
          subtitle: 'As many rounds as possible',
          emoji: '💪',
          color: const Color(0xFF22C55E),
          onStart: () {
            HapticFeedback.heavyImpact();
            ref
                .read(activeTimerNotifierProvider.notifier)
                .startTimer(TimerType.amrap, 600);
          },
        ),
        _IntervalCard(
          title: '20 Min AMRAP',
          subtitle: 'As many rounds as possible',
          emoji: '💪',
          color: const Color(0xFF22C55E),
          onStart: () {
            HapticFeedback.heavyImpact();
            ref
                .read(activeTimerNotifierProvider.notifier)
                .startTimer(TimerType.amrap, 1200);
          },
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildEquipmentTab() {
    final usages = ref.watch(equipmentUsageNotifierProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionHeader(title: '🏋️ Track Equipment'),
        const Text(
          'Let others know how long you\'ve been on equipment',
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: GymEquipment.values.map((equipment) {
            return ActionChip(
              avatar: Text(equipment.emoji),
              label: Text(
                equipment.label,
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 12,
                ),
              ),
              backgroundColor: AppColors.surfaceDark,
              onPressed: () => _showEquipmentTargetSheet(context, equipment),
            );
          }).toList(),
        ),

        if (usages.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionHeader(title: '⏱️ Active'),
          ...usages.map((usage) => _EquipmentUsageCard(usage: usage)),
        ],

        const SizedBox(height: 100),
      ],
    );
  }

  void _showEquipmentTargetSheet(BuildContext context, GymEquipment equipment) {
    int targetMinutes = 15;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(equipment.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Text(
                    equipment.label,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Target time (optional)',
                style: TextStyle(color: AppColors.textSecondaryDark),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => setState(
                      () => targetMinutes = (targetMinutes - 5).clamp(5, 60),
                    ),
                    icon: const Icon(Icons.remove),
                    color: AppColors.textSecondaryDark,
                  ),
                  Text(
                    '$targetMinutes min',
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(
                      () => targetMinutes = (targetMinutes + 5).clamp(5, 60),
                    ),
                    icon: const Icon(Icons.add),
                    color: AppColors.textSecondaryDark,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(equipmentUsageNotifierProvider.notifier)
                            .startUsing(equipment);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textSecondaryDark,
                      ),
                      child: const Text('No Target'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(equipmentUsageNotifierProvider.notifier)
                            .startUsing(
                              equipment,
                              targetMinutes: targetMinutes,
                            );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('Start'),
                    ),
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

class _QuickTimeButton extends StatelessWidget {
  final int seconds;
  final VoidCallback onTap;

  const _QuickTimeButton({required this.seconds, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    final label = minutes > 0
        ? '${minutes}:${secs.toString().padLeft(2, '0')}'
        : '${seconds}s';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final TimerPreset preset;
  final VoidCallback onTap;

  const _PresetCard({required this.preset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(preset.type.emoji, style: const TextStyle(fontSize: 24)),
        title: Text(
          preset.name,
          style: const TextStyle(color: AppColors.textPrimaryDark),
        ),
        trailing: const Icon(Icons.play_circle, color: AppColors.primary),
        onTap: onTap,
      ),
    );
  }
}

class _IntervalCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final VoidCallback onStart;

  const _IntervalCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onStart,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.play_circle, color: color, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _EquipmentUsageCard extends ConsumerWidget {
  final EquipmentUsage usage;

  const _EquipmentUsageCard({required this.usage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOvertime = usage.isOvertime;

    return Card(
      color: isOvertime
          ? AppColors.warning.withValues(alpha: 0.1)
          : AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Text(usage.emoji, style: const TextStyle(fontSize: 24)),
        title: Text(
          usage.name,
          style: const TextStyle(color: AppColors.textPrimaryDark),
        ),
        subtitle: Text(
          '${usage.elapsedMinutes} min${usage.targetMinutes != null ? ' / ${usage.targetMinutes} min' : ''}',
          style: TextStyle(
            color: isOvertime ? AppColors.warning : AppColors.textSecondaryDark,
            fontSize: 12,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.stop),
          color: AppColors.error,
          onPressed: () {
            ref
                .read(equipmentUsageNotifierProvider.notifier)
                .stopUsing(usage.id);
          },
        ),
      ),
    );
  }
}

class _TimerProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _TimerProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerProgressPainter oldDelegate) {
    return progress != oldDelegate.progress || color != oldDelegate.color;
  }
}
