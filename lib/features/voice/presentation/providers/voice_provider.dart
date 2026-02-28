import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/speech_recognition_service.dart';
import '../../domain/entities/voice.dart';

part 'voice_provider.g.dart';

/// Provider for voice recognition state.
@riverpod
class VoiceRecognitionNotifier extends _$VoiceRecognitionNotifier {
  SpeechRecognitionService? _speechService;

  @override
  VoiceRecognitionState build() {
    _speechService = ref.watch(speechRecognitionServiceProvider);
    return const VoiceRecognitionState();
  }

  /// Initialize speech recognition.
  Future<bool> initializeSpeech() async {
    if (_speechService == null) return false;

    final success = await _speechService!.initialize();
    if (!success) {
      state = state.copyWith(
        error: 'Speech recognition not available on this device',
      );
    }
    return success;
  }

  /// Start listening for voice commands.
  Future<void> startListening() async {
    if (_speechService == null) return;

    // Initialize if needed
    if (!_speechService!.isInitialized) {
      final success = await initializeSpeech();
      if (!success) return;
    }

    state = state.copyWith(
      isListening: true,
      recognizedText: null,
      matchedCommand: null,
      error: null,
    );

    try {
      await _speechService!.startListening(
        onResult: (result) {
          state = state.copyWith(
            recognizedText: result.recognizedWords,
            isProcessing: !result.finalResult,
          );

          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            processText(result.recognizedWords);
          }
        },
        partialResults: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to start listening: ${e.toString()}',
        isListening: false,
      );
    }
  }

  /// Stop listening for voice commands.
  Future<void> stopListening() async {
    if (_speechService != null) {
      await _speechService!.stopListening();
    }
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
