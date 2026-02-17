import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/voice.dart';
import '../providers/voice_provider.dart';

/// Screen for voice commands settings and testing.
class VoiceCommandsScreen extends ConsumerWidget {
  const VoiceCommandsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(voiceSettingsNotifierProvider);
    final recognition = ref.watch(voiceRecognitionNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Voice Commands'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Voice recognition test area
          _VoiceTestCard(
            isListening: recognition.isListening,
            recognizedText: recognition.recognizedText,
            matchedCommand: recognition.matchedCommand,
          ),
          const SizedBox(height: 24),

          // Master toggle
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.surfaceDark,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic,
                    color: settings.voiceCommandsEnabled
                        ? AppColors.primary
                        : Colors.grey,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Voice Commands',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Control your workout hands-free',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: settings.voiceCommandsEnabled,
                  onChanged: (v) {
                    HapticFeedback.lightImpact();
                    ref
                        .read(voiceSettingsNotifierProvider.notifier)
                        .toggleVoiceCommands(v);
                  },
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Settings sections
          if (settings.voiceCommandsEnabled) ...[
            _SettingsSection(
              title: 'Voice Feedback',
              children: [
                _SettingsTile(
                  title: 'Voice Feedback',
                  subtitle: 'Speak confirmations and announcements',
                  trailing: Switch(
                    value: settings.voiceFeedback,
                    onChanged: (v) {
                      ref
                          .read(voiceSettingsNotifierProvider.notifier)
                          .toggleVoiceFeedback(v);
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                _SettingsTile(
                  title: 'Announce Exercises',
                  subtitle: 'Read exercise names when moving to next',
                  trailing: Switch(
                    value: settings.announceExercises,
                    onChanged: (v) {
                      ref
                          .read(voiceSettingsNotifierProvider.notifier)
                          .toggleAnnounceExercises(v);
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                _SettingsTile(
                  title: 'Announce Reps',
                  subtitle: 'Confirm logged reps and weight',
                  trailing: Switch(
                    value: settings.announceReps,
                    onChanged: (v) {
                      ref
                          .read(voiceSettingsNotifierProvider.notifier)
                          .toggleAnnounceReps(v);
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                _SettingsTile(
                  title: 'Rest Timer Alerts',
                  subtitle: 'Announce when rest period ends',
                  trailing: Switch(
                    value: settings.announceRestEnd,
                    onChanged: (v) {
                      ref
                          .read(voiceSettingsNotifierProvider.notifier)
                          .toggleAnnounceRestEnd(v);
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _SettingsSection(
              title: 'Wake Word',
              children: [
                _SettingsTile(
                  title: 'Wake Word Activation',
                  subtitle: 'Say "${settings.wakeWord}" to activate',
                  trailing: Switch(
                    value: settings.wakeWordEnabled,
                    onChanged: (v) {
                      ref
                          .read(voiceSettingsNotifierProvider.notifier)
                          .toggleWakeWord(v);
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                _SettingsTile(
                  title: 'Sensitivity',
                  subtitle: 'Adjust recognition sensitivity',
                  trailing: SizedBox(
                    width: 120,
                    child: Slider(
                      value: settings.sensitivity,
                      onChanged: (v) {
                        ref
                            .read(voiceSettingsNotifierProvider.notifier)
                            .setSensitivity(v);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ),
                ),
                _SettingsTile(
                  title: 'Noise Cancellation',
                  subtitle: 'Filter background gym noise',
                  trailing: Switch(
                    value: settings.noiseCancellation,
                    onChanged: (v) {
                      ref
                          .read(voiceSettingsNotifierProvider.notifier)
                          .toggleNoiseCancellation(v);
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Available commands
            const Text(
              'Available Commands',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...VoiceCommandCategory.values.map((category) {
              final commands = VoiceCommand.availableCommands
                  .where((c) => c.category == category)
                  .toList();
              if (commands.isEmpty) return const SizedBox.shrink();
              return _CommandCategorySection(
                category: category,
                commands: commands,
              );
            }),
          ],
        ],
      ),
    );
  }
}

/// Card for testing voice recognition.
class _VoiceTestCard extends ConsumerWidget {
  final bool isListening;
  final String? recognizedText;
  final VoiceCommand? matchedCommand;

  const _VoiceTestCard({
    required this.isListening,
    this.recognizedText,
    this.matchedCommand,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Microphone button
          GestureDetector(
            onTapDown: (_) {
              HapticFeedback.heavyImpact();
              ref
                  .read(voiceRecognitionNotifierProvider.notifier)
                  .startListening();
            },
            onTapUp: (_) {
              ref
                  .read(voiceRecognitionNotifierProvider.notifier)
                  .stopListening();
            },
            onTapCancel: () {
              ref
                  .read(voiceRecognitionNotifierProvider.notifier)
                  .stopListening();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isListening ? 100 : 80,
              height: isListening ? 100 : 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isListening
                    ? AppColors.primary
                    : AppColors.backgroundDark,
                boxShadow: isListening
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: isListening ? 48 : 40,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            isListening ? 'Listening...' : 'Hold to speak',
            style: TextStyle(
              color: isListening
                  ? AppColors.primary
                  : AppColors.textSecondaryDark,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          if (recognizedText != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.format_quote,
                    color: AppColors.textSecondaryDark,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '"$recognizedText"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (matchedCommand != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    matchedCommand!.command,
                    style: TextStyle(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Settings section container.
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

/// Settings tile widget.
class _SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

/// Section showing commands for a category.
class _CommandCategorySection extends StatelessWidget {
  final VoiceCommandCategory category;
  final List<VoiceCommand> commands;

  const _CommandCategorySection({
    required this.category,
    required this.commands,
  });

  @override
  Widget build(BuildContext context) {
    final icon = switch (category) {
      VoiceCommandCategory.workout => Icons.fitness_center,
      VoiceCommandCategory.timer => Icons.timer,
      VoiceCommandCategory.navigation => Icons.navigation,
      VoiceCommandCategory.tracking => Icons.edit_note,
      VoiceCommandCategory.music => Icons.music_note,
      VoiceCommandCategory.general => Icons.settings_voice,
    };

    final color = switch (category) {
      VoiceCommandCategory.workout => AppColors.primary,
      VoiceCommandCategory.timer => Colors.orange,
      VoiceCommandCategory.navigation => Colors.blue,
      VoiceCommandCategory.tracking => Colors.purple,
      VoiceCommandCategory.music => Colors.pink,
      VoiceCommandCategory.general => Colors.teal,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          category.label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${commands.length} commands',
          style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12),
        ),
        iconColor: Colors.white,
        collapsedIconColor: Colors.grey,
        children: commands
            .map((command) => _CommandTile(command: command))
            .toList(),
      ),
    );
  }
}

/// Tile showing a voice command.
class _CommandTile extends StatelessWidget {
  final VoiceCommand command;

  const _CommandTile({required this.command});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mic, color: Colors.grey, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${command.command}"',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  command.description,
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
                if (command.aliases.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: command.aliases.take(3).map((alias) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          alias,
                          style: TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
