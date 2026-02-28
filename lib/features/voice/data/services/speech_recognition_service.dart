import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Speech recognition service using platform speech-to-text.
class SpeechRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  String? _currentLocaleId;
  List<LocaleName> _locales = [];

  /// Check if speech recognition is initialized.
  bool get isInitialized => _isInitialized;

  /// Get available locales.
  List<LocaleName> get locales => _locales;

  /// Get current locale ID.
  String? get currentLocale => _currentLocaleId;

  /// Initialize the speech recognition service.
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _isInitialized = await _speechToText.initialize(
        onStatus: _onStatus,
        onError: _onError,
        debugLogging: false,
      );

      if (_isInitialized) {
        _locales = await _speechToText.locales();
        final systemLocale = await _speechToText.systemLocale();
        _currentLocaleId = systemLocale?.localeId;
      }

      return _isInitialized;
    } catch (e) {
      _isInitialized = false;
      return false;
    }
  }

  /// Start listening for speech.
  Future<void> startListening({
    required void Function(SpeechRecognitionResult result) onResult,
    String? localeId,
    Duration? listenFor,
    Duration? pauseFor,
    bool partialResults = true,
  }) async {
    if (!_isInitialized) {
      final success = await initialize();
      if (!success) {
        throw Exception('Speech recognition not available');
      }
    }

    await _speechToText.listen(
      onResult: onResult,
      localeId: localeId ?? _currentLocaleId,
      listenFor: listenFor ?? const Duration(seconds: 30),
      pauseFor: pauseFor ?? const Duration(seconds: 3),
      partialResults: partialResults,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  /// Stop listening for speech.
  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  /// Cancel listening.
  Future<void> cancel() async {
    await _speechToText.cancel();
  }

  /// Check if currently listening.
  bool get isListening => _speechToText.isListening;

  /// Check if speech recognition is available.
  bool get isAvailable => _speechToText.isAvailable;

  /// Set the locale for speech recognition.
  void setLocale(String localeId) {
    if (_locales.any((l) => l.localeId == localeId)) {
      _currentLocaleId = localeId;
    }
  }

  void _onStatus(String status) {
    // Status updates: listening, notListening, done
  }

  void _onError(SpeechRecognitionError error) {
    // Error handling
  }
}

/// Provider for speech recognition service.
final speechRecognitionServiceProvider = Provider<SpeechRecognitionService>((
  ref,
) {
  return SpeechRecognitionService();
});
