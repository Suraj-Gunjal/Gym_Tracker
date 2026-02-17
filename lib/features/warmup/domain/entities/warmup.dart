/// Warm-up set types.
enum WarmupSetType {
  empty('Empty Bar', 0, 'Start light to practice form'),
  light('Light', 0.4, '40% of working weight'),
  moderate('Moderate', 0.6, '60% of working weight'),
  heavy('Heavy', 0.8, '80% of working weight'),
  activation('Activation', 0, 'Mobility/activation work');

  final String label;
  final double percentage;
  final String description;

  const WarmupSetType(this.label, this.percentage, this.description);
}

/// A single warm-up set.
class WarmupSet {
  final WarmupSetType type;
  final double weight;
  final int reps;
  final int restSeconds;
  final bool isCompleted;

  const WarmupSet({
    required this.type,
    required this.weight,
    required this.reps,
    this.restSeconds = 60,
    this.isCompleted = false,
  });

  WarmupSet copyWith({
    WarmupSetType? type,
    double? weight,
    int? reps,
    int? restSeconds,
    bool? isCompleted,
  }) {
    return WarmupSet(
      type: type ?? this.type,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      restSeconds: restSeconds ?? this.restSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Generated warm-up routine.
class WarmupRoutine {
  final String exerciseName;
  final double workingWeight;
  final List<WarmupSet> sets;
  final int totalDuration; // Estimated minutes
  final DateTime generatedAt;

  const WarmupRoutine({
    required this.exerciseName,
    required this.workingWeight,
    required this.sets,
    required this.totalDuration,
    required this.generatedAt,
  });

  int get completedSets => sets.where((s) => s.isCompleted).length;
  bool get isComplete => completedSets == sets.length;
  double get progress => sets.isEmpty ? 0 : completedSets / sets.length;
}

/// Warm-up protocol templates.
enum WarmupProtocol {
  standard('Standard', 'Progressive weight increase', [
    (WarmupSetType.empty, 10),
    (WarmupSetType.light, 8),
    (WarmupSetType.moderate, 5),
    (WarmupSetType.heavy, 3),
  ]),
  quick('Quick', 'Fewer sets for time efficiency', [
    (WarmupSetType.light, 8),
    (WarmupSetType.moderate, 5),
  ]),
  thorough('Thorough', 'Extra sets for heavy lifts', [
    (WarmupSetType.empty, 15),
    (WarmupSetType.light, 10),
    (WarmupSetType.moderate, 8),
    (WarmupSetType.moderate, 5),
    (WarmupSetType.heavy, 3),
    (WarmupSetType.heavy, 2),
  ]),
  competition('Competition', 'Powerlifting style warm-up', [
    (WarmupSetType.empty, 10),
    (WarmupSetType.light, 5),
    (WarmupSetType.light, 5),
    (WarmupSetType.moderate, 3),
    (WarmupSetType.moderate, 3),
    (WarmupSetType.heavy, 2),
    (WarmupSetType.heavy, 1),
  ]);

  final String name;
  final String description;
  final List<(WarmupSetType, int)> template;

  const WarmupProtocol(this.name, this.description, this.template);
}

/// Warm-up generator settings.
class WarmupSettings {
  final WarmupProtocol defaultProtocol;
  final double barWeight; // kg
  final bool useMetric;
  final bool includeActivation;
  final int minRestSeconds;

  const WarmupSettings({
    this.defaultProtocol = WarmupProtocol.standard,
    this.barWeight = 20,
    this.useMetric = true,
    this.includeActivation = true,
    this.minRestSeconds = 60,
  });

  WarmupSettings copyWith({
    WarmupProtocol? defaultProtocol,
    double? barWeight,
    bool? useMetric,
    bool? includeActivation,
    int? minRestSeconds,
  }) {
    return WarmupSettings(
      defaultProtocol: defaultProtocol ?? this.defaultProtocol,
      barWeight: barWeight ?? this.barWeight,
      useMetric: useMetric ?? this.useMetric,
      includeActivation: includeActivation ?? this.includeActivation,
      minRestSeconds: minRestSeconds ?? this.minRestSeconds,
    );
  }
}
