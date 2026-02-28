import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../exercise/domain/repositories/exercise_repository.dart';
import '../../../exercise/domain/entities/exercise.dart';
import '../../../exercise/presentation/providers/exercise_provider.dart';
import '../../domain/models/parsed_workout.dart';

/// Service for parsing natural language workout logs.
class NaturalLanguageParserService {
  final ExerciseRepository _exerciseRepository;
  List<Exercise>? _cachedExercises;

  NaturalLanguageParserService(this._exerciseRepository);

  /// Parse a natural language workout description.
  Future<ParsedWorkout> parseWorkout(String input) async {
    if (input.trim().isEmpty) {
      return ParsedWorkout(
        originalText: input,
        exercises: [],
        overallConfidence: ParseConfidence.low,
        issues: [
          const ParseIssue(
            message: 'Empty input',
            type: ParseIssueType.grammarUnclear,
          ),
        ],
      );
    }

    // Get exercises for matching
    _cachedExercises ??= await _exerciseRepository.getAllExercises();

    // Split input into lines/sentences for multi-exercise parsing
    final lines = _splitIntoExerciseLines(input);

    final List<ParsedExercise> exercises = [];
    final List<ParseIssue> issues = [];

    for (final line in lines) {
      final result = await _parseSingleExercise(line);
      if (result != null) {
        exercises.add(result.exercise);
        issues.addAll(result.issues);
      }
    }

    // Calculate overall confidence
    final overallConfidence = _calculateOverallConfidence(exercises, issues);

    // Try to extract workout name
    final workoutName = _extractWorkoutName(input);

    return ParsedWorkout(
      originalText: input,
      exercises: exercises,
      workoutName: workoutName,
      suggestedDate: DateTime.now(),
      estimatedDuration: _estimateDuration(exercises),
      issues: issues,
      overallConfidence: overallConfidence,
    );
  }

  /// Quick parse for autocomplete suggestions.
  Future<List<Exercise>> suggestExercises(String partial) async {
    _cachedExercises ??= await _exerciseRepository.getAllExercises();

    final normalizedInput = partial.toLowerCase().trim();
    if (normalizedInput.isEmpty) return [];

    // Check aliases first
    final List<Exercise> suggestions = [];

    for (final entry in NLPatterns.exerciseAliases.entries) {
      for (final alias in entry.value) {
        if (alias.contains(normalizedInput) ||
            normalizedInput.contains(alias)) {
          // Find the actual exercise
          final match = _cachedExercises!
              .where((e) => e.name.toLowerCase().contains(entry.key))
              .firstOrNull;
          if (match != null && !suggestions.contains(match)) {
            suggestions.add(match);
          }
        }
      }
    }

    // Also check direct name matches
    for (final exercise in _cachedExercises!) {
      if (exercise.name.toLowerCase().contains(normalizedInput) &&
          !suggestions.contains(exercise)) {
        suggestions.add(exercise);
      }
    }

    return suggestions.take(5).toList();
  }

  /// Parse a single line/phrase for one exercise.
  Future<_ParseResult?> _parseSingleExercise(String line) async {
    final issues = <ParseIssue>[];

    // Skip empty or too short lines
    if (line.trim().length < 3) return null;

    // Try to extract exercise name and sets/reps/weight
    final extractedName = _extractExerciseName(line);
    if (extractedName == null) return null;

    // Match to known exercise
    final matchResult = _matchExercise(extractedName);

    if (matchResult == null) {
      issues.add(
        ParseIssue(
          message: 'Could not find exercise: "$extractedName"',
          type: ParseIssueType.unknownExercise,
          suggestion: 'Try using a common exercise name',
        ),
      );
    }

    // Parse sets
    final sets = _parseSets(line);

    if (sets.isEmpty) {
      issues.add(
        const ParseIssue(
          message: 'Could not parse sets/reps',
          type: ParseIssueType.missingReps,
          suggestion: 'Format: "3x8 at 100kg" or "3 sets of 8 reps"',
        ),
      );
    }

    // Check for weight
    final hasWeight = sets.any((s) => s.weight > 0);
    if (!hasWeight && sets.isNotEmpty) {
      issues.add(
        const ParseIssue(
          message: 'No weight specified',
          type: ParseIssueType.missingWeight,
          suggestion: 'Add weight like "at 100kg" or "@225lbs"',
        ),
      );
    }

    // Determine confidence
    final confidence = _determineConfidence(
      matchResult?.exercise != null,
      sets.isNotEmpty,
      hasWeight,
    );

    return _ParseResult(
      exercise: ParsedExercise(
        rawName: extractedName,
        matchedExercise: matchResult?.exercise,
        sets: sets,
        confidence: confidence,
        alternatives: matchResult?.alternatives ?? [],
      ),
      issues: issues,
    );
  }

  /// Split input into separate exercise lines.
  List<String> _splitIntoExerciseLines(String input) {
    // Split by newlines, "then", "and then", semicolons
    final lines = input
        .split(
          RegExp(
            r'[\n;]|(?:\s+then\s+)|(?:\s+and\s+then\s+)',
            caseSensitive: false,
          ),
        )
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // If only one line, try to split by "and" for multiple exercises
    if (lines.length == 1 && lines.first.contains(' and ')) {
      final parts = lines.first.split(
        RegExp(r'\s+and\s+', caseSensitive: false),
      );
      // Only split if both parts look like they contain exercise info
      if (parts.length == 2 && parts.every((p) => _looksLikeExercise(p))) {
        return parts.map((p) => p.trim()).toList();
      }
    }

    return lines;
  }

  /// Check if a string looks like it describes an exercise.
  bool _looksLikeExercise(String text) {
    // Has numbers (likely sets/reps/weight)
    return RegExp(r'\d').hasMatch(text) && text.length > 5;
  }

  /// Extract exercise name from a line.
  String? _extractExerciseName(String line) {
    // Remove sets/reps patterns
    var cleaned = line
        .replaceAll(NLPatterns.setRepsPattern, '')
        .replaceAll(NLPatterns.atWeightPattern, '')
        .replaceAll(NLPatterns.weightPattern, '')
        .replaceAll(NLPatterns.warmupPattern, '')
        .replaceAll(
          RegExp(
            r'(?:did|done|finished|completed|performed)\s*',
            caseSensitive: false,
          ),
          '',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // Remove trailing "for", "at", "with"
    cleaned = cleaned
        .replaceAll(RegExp(r'\s*(for|at|with|@)$', caseSensitive: false), '')
        .trim();

    return cleaned.isEmpty ? null : cleaned;
  }

  /// Match extracted name to a known exercise.
  _MatchResult? _matchExercise(String name) {
    final normalizedName = name.toLowerCase().trim();

    // Direct match
    for (final exercise in _cachedExercises!) {
      if (exercise.name.toLowerCase() == normalizedName) {
        return _MatchResult(exercise: exercise, alternatives: []);
      }
    }

    // Alias match
    for (final entry in NLPatterns.exerciseAliases.entries) {
      if (entry.value.any((alias) => alias == normalizedName)) {
        // Find the canonical exercise
        final match = _cachedExercises!
            .where((e) => e.name.toLowerCase().contains(entry.key))
            .firstOrNull;
        if (match != null) {
          return _MatchResult(exercise: match, alternatives: []);
        }
      }
    }

    // Partial match
    final partialMatches = _cachedExercises!
        .where(
          (e) =>
              e.name.toLowerCase().contains(normalizedName) ||
              normalizedName.contains(e.name.toLowerCase()),
        )
        .toList();

    if (partialMatches.isNotEmpty) {
      return _MatchResult(
        exercise: partialMatches.first,
        alternatives: partialMatches
            .skip(1)
            .take(3)
            .map((e) => e.name)
            .toList(),
      );
    }

    // Fuzzy match using word overlap
    final inputWords = normalizedName.split(' ').toSet();
    Exercise? bestMatch;
    int bestScore = 0;
    final alternatives = <String>[];

    for (final exercise in _cachedExercises!) {
      final exerciseWords = exercise.name.toLowerCase().split(' ').toSet();
      final overlap = inputWords.intersection(exerciseWords).length;

      if (overlap > bestScore) {
        if (bestMatch != null) alternatives.add(bestMatch.name);
        bestScore = overlap;
        bestMatch = exercise;
      } else if (overlap > 0 && alternatives.length < 3) {
        alternatives.add(exercise.name);
      }
    }

    if (bestMatch != null && bestScore > 0) {
      return _MatchResult(exercise: bestMatch, alternatives: alternatives);
    }

    return null;
  }

  /// Parse sets from a line.
  List<ParsedSet> _parseSets(String line) {
    final sets = <ParsedSet>[];
    final isWarmup = NLPatterns.warmupPattern.hasMatch(line);

    // Try "3x8 at 100kg" pattern
    final setRepsMatch = NLPatterns.setRepsPattern.firstMatch(line);
    final weightMatch =
        NLPatterns.atWeightPattern.firstMatch(line) ??
        NLPatterns.weightPattern.firstMatch(line);

    if (setRepsMatch != null) {
      final numSets = int.tryParse(setRepsMatch.group(1) ?? '') ?? 1;
      final reps = int.tryParse(setRepsMatch.group(2) ?? '') ?? 0;
      final weight = _parseWeight(weightMatch);

      for (int i = 0; i < numSets; i++) {
        sets.add(ParsedSet(reps: reps, weight: weight, isWarmup: isWarmup));
      }
      return sets;
    }

    // Try "8 reps at 100kg" pattern
    final repsAtMatch = NLPatterns.repsAtWeightPattern.firstMatch(line);
    if (repsAtMatch != null) {
      final reps = int.tryParse(repsAtMatch.group(1) ?? '') ?? 0;
      final weight = double.tryParse(repsAtMatch.group(2) ?? '') ?? 0;
      final unit = repsAtMatch.group(3)?.toLowerCase() ?? 'kg';
      final weightKg = _convertToKg(weight, unit);

      sets.add(ParsedSet(reps: reps, weight: weightKg, isWarmup: isWarmup));
      return sets;
    }

    // Try just reps ("did 8 reps")
    final justRepsMatch = RegExp(
      r'(\d+)\s*reps?',
      caseSensitive: false,
    ).firstMatch(line);
    if (justRepsMatch != null) {
      final reps = int.tryParse(justRepsMatch.group(1) ?? '') ?? 0;
      sets.add(ParsedSet(reps: reps, weight: 0, isWarmup: isWarmup));
      return sets;
    }

    return sets;
  }

  /// Parse weight from regex match.
  double _parseWeight(RegExpMatch? match) {
    if (match == null) return 0;

    final value = double.tryParse(match.group(1) ?? '') ?? 0;
    final unit = match.group(2)?.toLowerCase() ?? 'kg';

    return _convertToKg(value, unit);
  }

  /// Convert weight to kg.
  double _convertToKg(double value, String unit) {
    if (unit.contains('lb') || unit.contains('pound')) {
      return value * 0.453592; // lbs to kg
    }
    return value;
  }

  /// Determine parse confidence.
  ParseConfidence _determineConfidence(
    bool matched,
    bool hasSets,
    bool hasWeight,
  ) {
    if (matched && hasSets && hasWeight) return ParseConfidence.high;
    if (matched && hasSets) return ParseConfidence.medium;
    if (hasSets || matched) return ParseConfidence.low;
    return ParseConfidence.low;
  }

  /// Calculate overall workout confidence.
  ParseConfidence _calculateOverallConfidence(
    List<ParsedExercise> exercises,
    List<ParseIssue> issues,
  ) {
    if (exercises.isEmpty) return ParseConfidence.low;

    final highConfCount = exercises
        .where((e) => e.confidence == ParseConfidence.high)
        .length;
    final totalCount = exercises.length;

    if (issues.any((i) => i.type == ParseIssueType.unknownExercise)) {
      return ParseConfidence.low;
    }

    if (highConfCount == totalCount) return ParseConfidence.high;
    if (highConfCount > totalCount / 2) return ParseConfidence.medium;
    return ParseConfidence.low;
  }

  /// Try to extract a workout name from input.
  String? _extractWorkoutName(String input) {
    // Check for "leg day", "push day", "chest day" etc
    final dayMatch = RegExp(
      r'(\w+)\s*day',
      caseSensitive: false,
    ).firstMatch(input);

    if (dayMatch != null) {
      final type = dayMatch.group(1)!.toLowerCase();
      if ([
        'leg',
        'push',
        'pull',
        'chest',
        'back',
        'arm',
        'shoulder',
      ].contains(type)) {
        return '${type[0].toUpperCase()}${type.substring(1)} Day';
      }
    }

    return null;
  }

  /// Estimate workout duration based on exercises and sets.
  Duration _estimateDuration(List<ParsedExercise> exercises) {
    // Rough estimate: 3 min per set
    final totalSets = exercises.fold(0, (sum, e) => sum + e.totalSets);
    return Duration(minutes: totalSets * 3);
  }
}

// Helper classes
class _ParseResult {
  final ParsedExercise exercise;
  final List<ParseIssue> issues;

  _ParseResult({required this.exercise, required this.issues});
}

class _MatchResult {
  final Exercise exercise;
  final List<String> alternatives;

  _MatchResult({required this.exercise, required this.alternatives});
}

/// Provider for NL parser service.
final naturalLanguageParserProvider = Provider<NaturalLanguageParserService>((
  ref,
) {
  final exerciseRepo = ref.watch(exerciseRepositoryProvider);
  return NaturalLanguageParserService(exerciseRepo);
});
