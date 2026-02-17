import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/warmup.dart';
import '../providers/warmup_provider.dart';

/// Screen for generating warm-up routines.
class WarmupGeneratorScreen extends ConsumerStatefulWidget {
  const WarmupGeneratorScreen({super.key});

  @override
  ConsumerState<WarmupGeneratorScreen> createState() =>
      _WarmupGeneratorScreenState();
}

class _WarmupGeneratorScreenState extends ConsumerState<WarmupGeneratorScreen> {
  final _weightController = TextEditingController(text: '80');
  final _exerciseController = TextEditingController(text: 'Bench Press');

  @override
  void dispose() {
    _weightController.dispose();
    _exerciseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(warmupSettingsNotifierProvider);
    final activeWarmup = ref.watch(activeWarmupNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Warm-up Generator'),
        actions: [
          IconButton(
            onPressed: () => _showSettingsSheet(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Section
            _buildInputSection(settings),
            const SizedBox(height: 24),

            // Active Warm-up
            if (activeWarmup != null) ...[
              _buildActiveWarmup(activeWarmup),
            ] else ...[
              // Protocol Preview
              _buildProtocolPreview(settings),
            ],

            const SizedBox(height: 24),

            // Suggested Warm-ups
            if (activeWarmup == null) _buildSuggestedSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(WarmupSettings settings) {
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
            'Generate Warm-up',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _exerciseController,
            style: const TextStyle(color: AppColors.textPrimaryDark),
            decoration: InputDecoration(
              labelText: 'Exercise',
              labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
              prefixIcon: const Icon(
                Icons.fitness_center,
                color: AppColors.textSecondaryDark,
              ),
              filled: true,
              fillColor: AppColors.backgroundDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.textPrimaryDark),
            decoration: InputDecoration(
              labelText: 'Working Weight (kg)',
              labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
              prefixIcon: const Icon(
                Icons.monitor_weight,
                color: AppColors.textSecondaryDark,
              ),
              filled: true,
              fillColor: AppColors.backgroundDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generateWarmup,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Generate Warm-up'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveWarmup(WarmupRoutine warmup) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warmup.exerciseName,
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Working weight: ${warmup.workingWeight}kg',
                  style: const TextStyle(color: AppColors.textSecondaryDark),
                ),
              ],
            ),
            TextButton.icon(
              onPressed: () {
                ref.read(activeWarmupNotifierProvider.notifier).clear();
              },
              icon: const Icon(Icons.close, size: 18),
              label: const Text('Clear'),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Progress bar
        LinearProgressIndicator(
          value: warmup.progress,
          backgroundColor: AppColors.surfaceDark,
          valueColor: const AlwaysStoppedAnimation(AppColors.success),
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 4),
        Text(
          '${warmup.completedSets}/${warmup.sets.length} sets completed',
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        ...warmup.sets.asMap().entries.map((entry) {
          final index = entry.key;
          final set = entry.value;
          return _WarmupSetCard(
            set: set,
            setNumber: index + 1,
            onComplete: () {
              HapticFeedback.mediumImpact();
              ref
                  .read(activeWarmupNotifierProvider.notifier)
                  .completeSet(index);
            },
          );
        }),
      ],
    );
  }

  Widget _buildProtocolPreview(WarmupSettings settings) {
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
              const Text(
                'Protocol',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  settings.defaultProtocol.name,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            settings.defaultProtocol.description,
            style: const TextStyle(color: AppColors.textSecondaryDark),
          ),
          Divider(height: 24, color: AppColors.borderDark),
          ...settings.defaultProtocol.template.asMap().entries.map((entry) {
            final type = entry.value.$1;
            final reps = entry.value.$2;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      type.label,
                      style: const TextStyle(color: AppColors.textPrimaryDark),
                    ),
                  ),
                  Text(
                    '$reps reps',
                    style: const TextStyle(color: AppColors.textSecondaryDark),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSuggestedSection() {
    final suggested = ref.watch(suggestedWarmupsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Start',
          style: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...suggested.map(
          (routine) => Card(
            color: AppColors.surfaceDark,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                routine.exerciseName,
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '${routine.workingWeight}kg • ${routine.sets.length} sets',
                style: const TextStyle(color: AppColors.textSecondaryDark),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondaryDark,
                size: 16,
              ),
              onTap: () {
                _exerciseController.text = routine.exerciseName;
                _weightController.text = routine.workingWeight.toString();
                _generateWarmup();
              },
            ),
          ),
        ),
      ],
    );
  }

  void _generateWarmup() {
    HapticFeedback.mediumImpact();
    final weight = double.tryParse(_weightController.text) ?? 80;
    final settings = ref.read(warmupSettingsNotifierProvider);

    ref
        .read(activeWarmupNotifierProvider.notifier)
        .generateWarmup(
          exerciseName: _exerciseController.text,
          workingWeight: weight,
          settings: settings,
        );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _WarmupSettingsSheet(),
    );
  }
}

class _WarmupSetCard extends StatelessWidget {
  final WarmupSet set;
  final int setNumber;
  final VoidCallback onComplete;

  const _WarmupSetCard({
    required this.set,
    required this.setNumber,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: set.isCompleted
          ? AppColors.success.withValues(alpha: 0.15)
          : AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: set.isCompleted ? null : onComplete,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: set.isCompleted
                      ? AppColors.success
                      : AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: set.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '$setNumber',
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      set.type.label,
                      style: TextStyle(
                        color: set.isCompleted
                            ? AppColors.success
                            : AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      set.type == WarmupSetType.activation
                          ? 'Mobility work'
                          : '${set.weight}kg × ${set.reps} reps',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              if (!set.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'TAP',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
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

class _WarmupSettingsSheet extends ConsumerWidget {
  const _WarmupSettingsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(warmupSettingsNotifierProvider);
    final notifier = ref.read(warmupSettingsNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Warm-up Settings',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Protocol',
            style: TextStyle(color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: WarmupProtocol.values.map((protocol) {
              final isSelected = settings.defaultProtocol == protocol;
              return ChoiceChip(
                label: Text(protocol.name),
                selected: isSelected,
                onSelected: (_) => notifier.updateProtocol(protocol),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.backgroundDark,
                labelStyle: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondaryDark,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Include Activation',
              style: TextStyle(color: AppColors.textPrimaryDark),
            ),
            subtitle: const Text(
              'Add mobility work before lifting',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
            value: settings.includeActivation,
            activeColor: AppColors.primary,
            onChanged: (_) => notifier.toggleActivation(),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text(
              'Bar Weight',
              style: TextStyle(color: AppColors.textPrimaryDark),
            ),
            subtitle: Text(
              '${settings.barWeight}kg',
              style: const TextStyle(color: AppColors.textSecondaryDark),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => notifier.updateBarWeight(
                    (settings.barWeight - 5).clamp(5, 25),
                  ),
                  icon: const Icon(Icons.remove_circle),
                  color: AppColors.primary,
                ),
                IconButton(
                  onPressed: () => notifier.updateBarWeight(
                    (settings.barWeight + 5).clamp(5, 25),
                  ),
                  icon: const Icon(Icons.add_circle),
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
