import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../exercise/domain/entities/exercise.dart';
import '../../data/services/natural_language_parser.dart';
import '../../domain/models/parsed_workout.dart';

/// State for natural language input screen.
class NaturalLogState {
  final String inputText;
  final ParsedWorkout? parsedResult;
  final bool isParsing;
  final List<Exercise> suggestions;
  final bool showConfirmation;

  const NaturalLogState({
    this.inputText = '',
    this.parsedResult,
    this.isParsing = false,
    this.suggestions = const [],
    this.showConfirmation = false,
  });

  NaturalLogState copyWith({
    String? inputText,
    ParsedWorkout? parsedResult,
    bool? isParsing,
    List<Exercise>? suggestions,
    bool? showConfirmation,
  }) {
    return NaturalLogState(
      inputText: inputText ?? this.inputText,
      parsedResult: parsedResult ?? this.parsedResult,
      isParsing: isParsing ?? this.isParsing,
      suggestions: suggestions ?? this.suggestions,
      showConfirmation: showConfirmation ?? this.showConfirmation,
    );
  }

  bool get hasInput => inputText.trim().isNotEmpty;
  bool get hasParsedResult => parsedResult != null;
  bool get isReady =>
      hasParsedResult &&
      parsedResult!.exercises.isNotEmpty &&
      parsedResult!.overallConfidence != ParseConfidence.low;
}

/// Notifier for natural language logging state.
class NaturalLogNotifier extends StateNotifier<NaturalLogState> {
  final NaturalLanguageParserService _parser;

  NaturalLogNotifier(this._parser) : super(const NaturalLogState());

  /// Update input text and get suggestions.
  Future<void> updateInput(String text) async {
    state = state.copyWith(inputText: text);

    if (text.isEmpty) {
      state = state.copyWith(suggestions: []);
      return;
    }

    // Get exercise suggestions as user types
    final lastWord = _getLastWord(text);
    if (lastWord.isNotEmpty) {
      final suggestions = await _parser.suggestExercises(lastWord);
      state = state.copyWith(suggestions: suggestions);
    }
  }

  /// Parse the current input.
  Future<void> parseInput() async {
    if (state.inputText.trim().isEmpty) return;

    state = state.copyWith(isParsing: true);

    try {
      final result = await _parser.parseWorkout(state.inputText);
      state = state.copyWith(parsedResult: result, isParsing: false);
    } catch (e) {
      state = state.copyWith(isParsing: false);
    }
  }

  /// Apply a suggestion to the input.
  void applySuggestion(Exercise exercise) {
    final text = state.inputText;
    final lastWordStart = _getLastWordStart(text);

    final newText = text.substring(0, lastWordStart) + exercise.name;
    state = state.copyWith(inputText: newText, suggestions: []);
  }

  /// Update a specific parsed exercise (e.g., change the matched exercise).
  void updateParsedExercise(int index, ParsedExercise updated) {
    if (state.parsedResult == null) return;

    final exercises = List<ParsedExercise>.from(state.parsedResult!.exercises);
    exercises[index] = updated;

    state = state.copyWith(
      parsedResult: ParsedWorkout(
        originalText: state.parsedResult!.originalText,
        exercises: exercises,
        workoutName: state.parsedResult!.workoutName,
        suggestedDate: state.parsedResult!.suggestedDate,
        estimatedDuration: state.parsedResult!.estimatedDuration,
        issues: state.parsedResult!.issues,
        overallConfidence: state.parsedResult!.overallConfidence,
      ),
    );
  }

  /// Update a specific set in a parsed exercise.
  void updateParsedSet(int exerciseIndex, int setIndex, ParsedSet updated) {
    if (state.parsedResult == null) return;

    final exercises = List<ParsedExercise>.from(state.parsedResult!.exercises);
    final exercise = exercises[exerciseIndex];

    final sets = List<ParsedSet>.from(exercise.sets);
    sets[setIndex] = updated;

    exercises[exerciseIndex] = exercise.copyWith(sets: sets);

    state = state.copyWith(
      parsedResult: ParsedWorkout(
        originalText: state.parsedResult!.originalText,
        exercises: exercises,
        workoutName: state.parsedResult!.workoutName,
        suggestedDate: state.parsedResult!.suggestedDate,
        estimatedDuration: state.parsedResult!.estimatedDuration,
        issues: state.parsedResult!.issues,
        overallConfidence: state.parsedResult!.overallConfidence,
      ),
    );
  }

  /// Show confirmation dialog.
  void showConfirmation() {
    state = state.copyWith(showConfirmation: true);
  }

  /// Hide confirmation dialog.
  void hideConfirmation() {
    state = state.copyWith(showConfirmation: false);
  }

  /// Clear all state.
  void clear() {
    state = const NaturalLogState();
  }

  /// Get the last word being typed.
  String _getLastWord(String text) {
    final words = text.split(RegExp(r'[\s,;]+'));
    return words.isEmpty ? '' : words.last.toLowerCase();
  }

  /// Get the start position of the last word.
  int _getLastWordStart(String text) {
    for (int i = text.length - 1; i >= 0; i--) {
      if (RegExp(r'[\s,;]').hasMatch(text[i])) {
        return i + 1;
      }
    }
    return 0;
  }
}

/// Provider for natural log state.
final naturalLogStateProvider =
    StateNotifierProvider<NaturalLogNotifier, NaturalLogState>((ref) {
      final parser = ref.watch(naturalLanguageParserProvider);
      return NaturalLogNotifier(parser);
    });

/// Example phrases provider for UI hints.
final examplePhrasesProvider = Provider<List<String>>((ref) {
  return [
    'Bench press 3x8 at 100kg',
    'Did 4 sets of 10 squats with 80kg',
    'Deadlift 5x5 @ 140kg',
    '3 sets bench 100kg 8 reps then 3 sets rows 70kg',
    'Push day: bench 3x10 at 80kg, ohp 3x8 at 40kg',
    'Leg day - squats 4x8 100kg, leg press 3x12 150kg',
  ];
});
