import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/notes_provider.dart';

/// Beautiful exercise form tips sheet.
class ExerciseFormTipsSheet extends ConsumerWidget {
  final String exerciseId;
  final String exerciseName;

  const ExerciseFormTipsSheet({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(exerciseNotesProvider(exerciseId));

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      AppColors.surfaceDark,
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textTertiaryDark,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exerciseName,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Form Guide & Tips',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textSecondaryDark,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            ref
                                .read(exerciseNotesNotifierProvider.notifier)
                                .toggleFavorite(exerciseId);
                          },
                          icon: Icon(
                            notes?.isFavorite == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: notes?.isFavorite == true
                                ? Colors.red
                                : AppColors.textTertiaryDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: notes == null
                    ? _NoTipsView(exerciseName: exerciseName)
                    : SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Form Cues
                            if (notes.formCues.isNotEmpty) ...[
                              _SectionTitle(
                                icon: Icons.check_circle_outline,
                                title: 'Form Cues',
                                color: const Color(0xFF10B981),
                              ),
                              const SizedBox(height: 12),
                              ...notes.formCues.asMap().entries.map((entry) {
                                return _FormCueCard(
                                  index: entry.key + 1,
                                  cue: entry.value,
                                );
                              }),
                              const SizedBox(height: 24),
                            ],

                            // Common Mistakes
                            if (notes.commonMistakes.isNotEmpty) ...[
                              _SectionTitle(
                                icon: Icons.warning_amber_rounded,
                                title: 'Common Mistakes',
                                color: const Color(0xFFEF4444),
                              ),
                              const SizedBox(height: 12),
                              ...notes.commonMistakes.map((mistake) {
                                return _MistakeCard(mistake: mistake);
                              }),
                              const SizedBox(height: 24),
                            ],

                            // Breathing & Tempo
                            if (notes.breathingPattern != null ||
                                notes.tempoRecommendation != null) ...[
                              _SectionTitle(
                                icon: Icons.air,
                                title: 'Breathing & Tempo',
                                color: const Color(0xFF8B5CF6),
                              ),
                              const SizedBox(height: 12),
                              _BreathingTempoCard(
                                breathing: notes.breathingPattern,
                                tempo: notes.tempoRecommendation,
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Muscle Focus
                            if (notes.muscleFocusTips.isNotEmpty) ...[
                              _SectionTitle(
                                icon: Icons.gps_fixed,
                                title: 'Muscle Focus',
                                color: const Color(0xFFF59E0B),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFF59E0B,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFF59E0B,
                                    ).withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  notes.muscleFocusTips,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Variations
                            if (notes.variations.isNotEmpty) ...[
                              _SectionTitle(
                                icon: Icons.swap_horiz,
                                title: 'Variations',
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: notes.variations.map((variation) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundDark,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      variation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: AppColors.primary),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Personal Notes
                            _SectionTitle(
                              icon: Icons.edit_note,
                              title: 'My Notes',
                              color: AppColors.textSecondaryDark,
                            ),
                            const SizedBox(height: 12),
                            _PersonalNotesCard(
                              notes: notes.personalNotes,
                              exerciseId: exerciseId,
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _FormCueCard extends StatelessWidget {
  final int index;
  final String cue;

  const _FormCueCard({required this.index, required this.cue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF10B981),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(cue, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _MistakeCard extends StatelessWidget {
  final String mistake;

  const _MistakeCard({required this.mistake});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.close, color: Color(0xFFEF4444), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(mistake, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _BreathingTempoCard extends StatelessWidget {
  final String? breathing;
  final String? tempo;

  const _BreathingTempoCard({this.breathing, this.tempo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (breathing != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.air, color: Color(0xFF8B5CF6), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    breathing!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            if (tempo != null) const SizedBox(height: 12),
          ],
          if (tempo != null) ...[
            Row(
              children: [
                const Icon(Icons.speed, color: Color(0xFF8B5CF6), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Tempo: ',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                _TempoDisplay(tempo: tempo!),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TempoDisplay extends StatelessWidget {
  final String tempo;

  const _TempoDisplay({required this.tempo});

  @override
  Widget build(BuildContext context) {
    final parts = tempo.split('-');
    if (parts.length != 3) {
      return Text(tempo);
    }

    final labels = ['Eccentric', 'Pause', 'Concentric'];
    return Row(
      children: List.generate(3, (index) {
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(
                    '${parts[index]}s',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8B5CF6),
                    ),
                  ),
                  Text(
                    labels[index],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 8,
                      color: AppColors.textTertiaryDark,
                    ),
                  ),
                ],
              ),
            ),
            if (index < 2)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('-'),
              ),
          ],
        );
      }),
    );
  }
}

class _PersonalNotesCard extends ConsumerStatefulWidget {
  final String notes;
  final String exerciseId;

  const _PersonalNotesCard({required this.notes, required this.exerciseId});

  @override
  ConsumerState<_PersonalNotesCard> createState() => _PersonalNotesCardState();
}

class _PersonalNotesCardState extends ConsumerState<_PersonalNotesCard> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notes);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textTertiaryDark.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isEditing) ...[
            TextField(
              controller: _controller,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Add your personal notes here...',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _controller.text = widget.notes;
                      _isEditing = false;
                    });
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(exerciseNotesNotifierProvider.notifier)
                        .updatePersonalNotes(
                          widget.exerciseId,
                          _controller.text,
                        );
                    setState(() => _isEditing = false);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ] else ...[
            if (widget.notes.isEmpty)
              Text(
                'Tap to add your personal notes...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiaryDark,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              Text(widget.notes, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isEditing = true);
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NoTipsView extends StatelessWidget {
  final String exerciseName;

  const _NoTipsView({required this.exerciseName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: AppColors.textTertiaryDark,
            ),
            const SizedBox(height: 16),
            Text(
              'No tips available yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Form tips for $exerciseName haven\'t been added yet. Add your own notes!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiaryDark,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                // Could open note editor
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Notes'),
            ),
          ],
        ),
      ),
    );
  }
}
