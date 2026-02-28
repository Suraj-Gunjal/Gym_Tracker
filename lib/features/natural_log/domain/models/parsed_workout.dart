import '../../../exercise/domain/entities/exercise.dart';
import '../../../workout/domain/entities/exercise_set.dart';
import 'package:uuid/uuid.dart';

/// Confidence level of the parse result.
enum ParseConfidence {
  high, // Clearly understood
  medium, // Some assumptions made
  low; // Uncertain, needs confirmation

  String get label {
    switch (this) {
      case ParseConfidence.high:
        return 'Confident';
      case ParseConfidence.medium:
        return 'Likely';
      case ParseConfidence.low:
        return 'Uncertain';
    }
  }

  double get value {
    switch (this) {
      case ParseConfidence.high:
        return 1.0;
      case ParseConfidence.medium:
        return 0.7;
      case ParseConfidence.low:
        return 0.4;
    }
  }
}

/// A single parsed set from natural language.
class ParsedSet {
  final int reps;
  final double weight;
  final Duration? restTime;
  final String? notes;
  final bool isWarmup;

  const ParsedSet({
    required this.reps,
    required this.weight,
    this.restTime,
    this.notes,
    this.isWarmup = false,
  });

  ParsedSet copyWith({
    int? reps,
    double? weight,
    Duration? restTime,
    String? notes,
    bool? isWarmup,
  }) {
    return ParsedSet(
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      restTime: restTime ?? this.restTime,
      notes: notes ?? this.notes,
      isWarmup: isWarmup ?? this.isWarmup,
    );
  }

  /// Convert to domain ExerciseSet.
  ExerciseSet toExerciseSet(int setNumber, String workoutExerciseId) {
    return ExerciseSet(
      id: const Uuid().v4(),
      workoutExerciseId: workoutExerciseId,
      setNumber: setNumber,
      reps: reps,
      weight: weight,
      notes: notes,
      completed: true,
      updatedAt: DateTime.now(),
    );
  }
}

/// A parsed exercise with its sets.
class ParsedExercise {
  final String rawName;
  final Exercise? matchedExercise;
  final List<ParsedSet> sets;
  final ParseConfidence confidence;
  final List<String> alternatives; // Other possible exercise matches

  const ParsedExercise({
    required this.rawName,
    this.matchedExercise,
    required this.sets,
    required this.confidence,
    this.alternatives = const [],
  });

  bool get isMatched => matchedExercise != null;

  int get totalSets => sets.length;
  int get totalReps => sets.fold(0, (sum, s) => sum + s.reps);
  double get maxWeight => sets.isEmpty
      ? 0
      : sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);

  ParsedExercise copyWith({
    String? rawName,
    Exercise? matchedExercise,
    List<ParsedSet>? sets,
    ParseConfidence? confidence,
    List<String>? alternatives,
  }) {
    return ParsedExercise(
      rawName: rawName ?? this.rawName,
      matchedExercise: matchedExercise ?? this.matchedExercise,
      sets: sets ?? this.sets,
      confidence: confidence ?? this.confidence,
      alternatives: alternatives ?? this.alternatives,
    );
  }
}

/// Complete parsed workout from natural language input.
class ParsedWorkout {
  final String originalText;
  final List<ParsedExercise> exercises;
  final DateTime? suggestedDate;
  final Duration? estimatedDuration;
  final String? workoutName;
  final List<ParseIssue> issues;
  final ParseConfidence overallConfidence;

  const ParsedWorkout({
    required this.originalText,
    required this.exercises,
    this.suggestedDate,
    this.estimatedDuration,
    this.workoutName,
    this.issues = const [],
    required this.overallConfidence,
  });

  bool get hasIssues => issues.isNotEmpty;
  bool get hasUnmatchedExercises => exercises.any((e) => !e.isMatched);
  int get totalExercises => exercises.length;
  int get totalSets => exercises.fold(0, (sum, e) => sum + e.totalSets);
}

/// An issue or warning found during parsing.
class ParseIssue {
  final String message;
  final ParseIssueType type;
  final String? suggestion;

  const ParseIssue({
    required this.message,
    required this.type,
    this.suggestion,
  });
}

/// Types of parsing issues.
enum ParseIssueType {
  unknownExercise,
  ambiguousExercise,
  missingWeight,
  missingReps,
  unrealisticValue,
  grammarUnclear,
}

/// Natural language input patterns.
class NLPatterns {
  // Common exercise name variations
  static const Map<String, List<String>> exerciseAliases = {
    'bench press': ['bench', 'bp', 'flat bench', 'barbell bench'],
    'squat': ['squats', 'back squat', 'bb squat', 'barbell squat'],
    'deadlift': ['dl', 'deads', 'conventional deadlift'],
    'overhead press': ['ohp', 'shoulder press', 'military press', 'press'],
    'barbell row': ['bb row', 'bent over row', 'row', 'rows'],
    'pull-up': ['pullup', 'pull up', 'pullups', 'chin up', 'chinup'],
    'dip': ['dips', 'chest dip', 'tricep dip'],
    'bicep curl': ['curls', 'curl', 'biceps', 'dumbbell curl', 'db curl'],
    'tricep extension': ['tricep', 'triceps', 'skull crusher', 'skullcrusher'],
    'lat pulldown': ['pulldown', 'lat pull', 'cable pulldown'],
    'leg press': ['leg press machine', 'lp'],
    'lunges': ['lunge', 'walking lunge', 'split squat'],
    'romanian deadlift': ['rdl', 'stiff leg deadlift', 'sldl'],
    'leg curl': ['hamstring curl', 'lying leg curl'],
    'leg extension': ['quad extension', 'leg ext'],
    'calf raise': ['calf raises', 'calves', 'standing calf'],
  };

  // Set patterns: "3x8", "3 sets of 8", "3 sets x 8 reps"
  static final RegExp setRepsPattern = RegExp(
    r'(\d+)\s*(?:x|×|sets?\s*(?:of)?)\s*(\d+)(?:\s*reps?)?',
    caseSensitive: false,
  );

  // Weight patterns: "100kg", "225lbs", "100 kg"
  static final RegExp weightPattern = RegExp(
    r'(\d+(?:\.\d+)?)\s*(kg|kgs|lb|lbs|pounds|kilos)?',
    caseSensitive: false,
  );

  // At/with weight: "at 100kg", "with 225lbs", "@100kg"
  static final RegExp atWeightPattern = RegExp(
    r'(?:at|with|@|for)\s*(\d+(?:\.\d+)?)\s*(kg|kgs|lb|lbs|pounds|kilos)?',
    caseSensitive: false,
  );

  // Single set: "8 reps at 100kg"
  static final RegExp repsAtWeightPattern = RegExp(
    r'(\d+)\s*reps?\s*(?:at|with|@)?\s*(\d+(?:\.\d+)?)\s*(kg|kgs|lb|lbs)?',
    caseSensitive: false,
  );

  // Warmup indicator
  static final RegExp warmupPattern = RegExp(
    r'(?:warmup|warm-up|warm up|wu)',
    caseSensitive: false,
  );
}
