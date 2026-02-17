import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/rpe_tempo.dart';
import '../providers/rpe_provider.dart';

/// Widget for selecting RPE value.
class RPESelector extends ConsumerWidget {
  final String setId;
  final RPE? currentRPE;
  final Function(RPE)? onChanged;

  const RPESelector({
    super.key,
    required this.setId,
    this.currentRPE,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RPE (Rate of Perceived Exertion)',
          style: TextStyle(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: RPE.values.map((rpe) {
            final isSelected = currentRPE == rpe;
            final color = Color(int.parse('FF${rpe.colorHex}', radix: 16));
            return GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onChanged?.call(rpe);
                ref
                    .read(extendedSetDataNotifierProvider.notifier)
                    .updateRPE(setId, rpe);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.3)
                      : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? color : AppColors.borderDark,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      rpe.value.toString(),
                      style: TextStyle(
                        color: isSelected ? color : AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${rpe.rir} RIR',
                      style: TextStyle(
                        color: isSelected ? color : AppColors.textSecondaryDark,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (currentRPE != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(
                int.parse('FF${currentRPE!.colorHex}', radix: 16),
              ).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Color(
                    int.parse('FF${currentRPE!.colorHex}', radix: 16),
                  ),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentRPE!.label,
                        style: TextStyle(
                          color: Color(
                            int.parse('FF${currentRPE!.colorHex}', radix: 16),
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentRPE!.description,
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
          ),
        ],
      ],
    );
  }
}

/// Widget for selecting tempo.
class TempoSelector extends ConsumerStatefulWidget {
  final String setId;
  final Tempo? currentTempo;
  final Function(Tempo)? onChanged;

  const TempoSelector({
    super.key,
    required this.setId,
    this.currentTempo,
    this.onChanged,
  });

  @override
  ConsumerState<TempoSelector> createState() => _TempoSelectorState();
}

class _TempoSelectorState extends ConsumerState<TempoSelector> {
  late Tempo _tempo;

  @override
  void initState() {
    super.initState();
    _tempo = widget.currentTempo ?? Tempo.standard;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tempo (Eccentric-Pause-Concentric-Pause)',
          style: TextStyle(
            color: AppColors.textPrimaryDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        // Preset tempos
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TempoChip(
              label: 'Standard',
              tempo: Tempo.standard,
              isSelected: _tempo == Tempo.standard,
              onTap: () => _selectTempo(Tempo.standard),
            ),
            _TempoChip(
              label: 'Slow',
              tempo: Tempo.slow,
              isSelected: _tempo == Tempo.slow,
              onTap: () => _selectTempo(Tempo.slow),
            ),
            _TempoChip(
              label: 'Explosive',
              tempo: Tempo.explosive,
              isSelected: _tempo == Tempo.explosive,
              onTap: () => _selectTempo(Tempo.explosive),
            ),
            _TempoChip(
              label: 'Pause',
              tempo: Tempo.pause,
              isSelected: _tempo == Tempo.pause,
              onTap: () => _selectTempo(Tempo.pause),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Custom tempo sliders
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _TempoSlider(
                label: 'Eccentric (down)',
                value: _tempo.eccentric,
                onChanged: (v) => _updateTempo(_tempo.copyWith(eccentric: v)),
              ),
              _TempoSlider(
                label: 'Pause (bottom)',
                value: _tempo.pauseBottom,
                onChanged: (v) => _updateTempo(_tempo.copyWith(pauseBottom: v)),
              ),
              _TempoSlider(
                label: 'Concentric (up)',
                value: _tempo.concentric,
                onChanged: (v) => _updateTempo(_tempo.copyWith(concentric: v)),
              ),
              _TempoSlider(
                label: 'Pause (top)',
                value: _tempo.pauseTop,
                onChanged: (v) => _updateTempo(_tempo.copyWith(pauseTop: v)),
              ),
              Divider(height: 24, color: AppColors.borderDark),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tempo: ${_tempo.notation}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
                      '${_tempo.tutPerRep}s/rep',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectTempo(Tempo tempo) {
    HapticFeedback.selectionClick();
    setState(() => _tempo = tempo);
    widget.onChanged?.call(tempo);
    ref
        .read(extendedSetDataNotifierProvider.notifier)
        .updateTempo(widget.setId, tempo);
  }

  void _updateTempo(Tempo tempo) {
    setState(() => _tempo = tempo);
    widget.onChanged?.call(tempo);
    ref
        .read(extendedSetDataNotifierProvider.notifier)
        .updateTempo(widget.setId, tempo);
  }
}

class _TempoChip extends StatelessWidget {
  final String label;
  final Tempo tempo;
  final bool isSelected;
  final VoidCallback onTap;

  const _TempoChip({
    required this.label,
    required this.tempo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDark,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              tempo.notation,
              style: const TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TempoSlider extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;

  const _TempoSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondaryDark),
            ),
          ),
          Expanded(
            child: Slider(
              value: value.toDouble(),
              min: 0,
              max: 6,
              divisions: 6,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.backgroundDark,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              '${value}s',
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact RPE display for set cards.
class RPEBadge extends StatelessWidget {
  final RPE rpe;

  const RPEBadge({super.key, required this.rpe});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse('FF${rpe.colorHex}', radix: 16));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'RPE ${rpe.value}',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

/// Compact tempo display for set cards.
class TempoBadge extends StatelessWidget {
  final Tempo tempo;

  const TempoBadge({super.key, required this.tempo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tempo.notation,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}
