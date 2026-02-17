import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/voice.dart';

part 'voice_provider.g.dart';

/// Provider for voice recognition state.
@riverpod
class VoiceRecognitionNotifier extends _$VoiceRecognitionNotifier {
  @override
  VoiceRecognitionState build() {
    return const VoiceRecognitionState();
  }

  void startListening() {
    state = state.copyWith(
      isListening: true,
      recognizedText: null,
      matchedCommand: null,
      error: null,
    );
    // In real app, start speech recognition here
  }

  void stopListening() {
    state = state.copyWith(isListening: false);
  }

  void processText(String text) {
    state = state.copyWith(isProcessing: true, recognizedText: text);

    // Match command
    final command = _matchCommand(text);

    state = state.copyWith(
      isProcessing: false,
      matchedCommand: command,
      lastCommandTime: DateTime.now(),
    );
  }

  VoiceCommand? _matchCommand(String text) {
    final lowerText = text.toLowerCase();

    for (final command in VoiceCommand.availableCommands) {
      // Check main command
      if (lowerText.contains(command.command.toLowerCase())) {
        return command;
      }

      // Check aliases
      for (final alias in command.aliases) {
        if (lowerText.contains(alias.toLowerCase())) {
          return command;
        }
      }
    }

    return null;
  }

  void executeCommand(VoiceCommand command) {
    // Execute the command action
    // This would integrate with other providers in real app
    state = state.copyWith(lastCommandTime: DateTime.now());
  }

  void setError(String error) {
    state = state.copyWith(
      error: error,
      isListening: false,
      isProcessing: false,
    );
  }

  void clear() {
    state = const VoiceRecognitionState();
  }
}

/// Provider for voice settings.
@riverpod
class VoiceSettingsNotifier extends _$VoiceSettingsNotifier {
  @override
  VoiceSettings build() {
    return const VoiceSettings();
  }

  void toggleVoiceCommands(bool enabled) {
    state = state.copyWith(voiceCommandsEnabled: enabled);
  }

  void toggleVoiceFeedback(bool enabled) {
    state = state.copyWith(voiceFeedback: enabled);
  }

  void toggleAnnounceExercises(bool enabled) {
    state = state.copyWith(announceExercises: enabled);
  }

  void toggleAnnounceReps(bool enabled) {
    state = state.copyWith(announceReps: enabled);
  }

  void toggleAnnounceRestEnd(bool enabled) {
    state = state.copyWith(announceRestEnd: enabled);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void toggleWakeWord(bool enabled) {
    state = state.copyWith(wakeWordEnabled: enabled);
  }

  void setWakeWord(String wakeWord) {
    state = state.copyWith(wakeWord: wakeWord);
  }

  void setSensitivity(double sensitivity) {
    state = state.copyWith(sensitivity: sensitivity.clamp(0, 1));
  }

  void toggleNoiseCancellation(bool enabled) {
    state = state.copyWith(noiseCancellation: enabled);
  }
}

/// Provider for voice command history.
@riverpod
class VoiceCommandHistoryNotifier extends _$VoiceCommandHistoryNotifier {
  @override
  List<VoiceCommandHistory> build() {
    return [];
  }

  void addEntry({
    required String recognizedText,
    VoiceCommand? matchedCommand,
    required bool wasSuccessful,
    String? errorMessage,
  }) {
    final entry = VoiceCommandHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      recognizedText: recognizedText,
      matchedCommand: matchedCommand,
      wasSuccessful: wasSuccessful,
      timestamp: DateTime.now(),
      errorMessage: errorMessage,
    );
    state = [entry, ...state].take(50).toList(); // Keep last 50
  }

  void clear() {
    state = [];
  }
}

/// Provider for available commands by category.
@riverpod
Map<VoiceCommandCategory, List<VoiceCommand>> commandsByCategory(ref) {
  final commands = VoiceCommand.availableCommands;
  final result = <VoiceCommandCategory, List<VoiceCommand>>{};

  for (final category in VoiceCommandCategory.values) {
    result[category] = commands.where((c) => c.category == category).toList();
  }

  return result;
}

/// Provider for checking if voice is enabled.
@riverpod
bool isVoiceEnabled(ref) {
  final settings = ref.watch(voiceSettingsNotifierProvider);
  return settings.voiceCommandsEnabled;
}
