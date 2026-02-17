import 'package:flutter/material.dart';

/// Gender for strength standards calculation.
enum Gender {
  male,
  female;

  String get label => name[0].toUpperCase() + name.substring(1);
}

/// Strength level categories.
enum StrengthLevel {
  beginner,
  novice,
  intermediate,
  advanced,
  elite;

  String get label => name[0].toUpperCase() + name.substring(1);

  Color get color {
    switch (this) {
      case StrengthLevel.beginner:
        return const Color(0xFF94A3B8);
      case StrengthLevel.novice:
        return const Color(0xFF22C55E);
      case StrengthLevel.intermediate:
        return const Color(0xFF3B82F6);
      case StrengthLevel.advanced:
        return const Color(0xFFA855F7);
      case StrengthLevel.elite:
        return const Color(0xFFF59E0B);
    }
  }

  String get description {
    switch (this) {
      case StrengthLevel.beginner:
        return 'Stronger than 5% of lifters';
      case StrengthLevel.novice:
        return 'Stronger than 20% of lifters';
      case StrengthLevel.intermediate:
        return 'Stronger than 50% of lifters';
      case StrengthLevel.advanced:
        return 'Stronger than 80% of lifters';
      case StrengthLevel.elite:
        return 'Stronger than 95% of lifters';
    }
  }
}

/// One Rep Max calculation formulas.
enum OneRMFormula {
  epley,
  brzycki,
  lander,
  lombardi,
  oconner;

  String get label {
    switch (this) {
      case OneRMFormula.epley:
        return 'Epley';
      case OneRMFormula.brzycki:
        return 'Brzycki';
      case OneRMFormula.lander:
        return 'Lander';
      case OneRMFormula.lombardi:
        return 'Lombardi';
      case OneRMFormula.oconner:
        return "O'Conner";
    }
  }

  String get formula {
    switch (this) {
      case OneRMFormula.epley:
        return '1RM = w × (1 + r/30)';
      case OneRMFormula.brzycki:
        return '1RM = w × (36 / (37 - r))';
      case OneRMFormula.lander:
        return '1RM = w × 100 / (101.3 - 2.67r)';
      case OneRMFormula.lombardi:
        return '1RM = w × r^0.1';
      case OneRMFormula.oconner:
        return '1RM = w × (1 + r/40)';
    }
  }
}

/// Strength calculator for 1RM and standards.
class StrengthCalculator {
  /// Calculate 1RM using specified formula.
  static double calculate1RM({
    required double weight,
    required int reps,
    OneRMFormula formula = OneRMFormula.epley,
  }) {
    if (reps <= 0) return weight;
    if (reps == 1) return weight;

    switch (formula) {
      case OneRMFormula.epley:
        return weight * (1 + reps / 30);
      case OneRMFormula.brzycki:
        return weight * (36 / (37 - reps));
      case OneRMFormula.lander:
        return weight * 100 / (101.3 - 2.67 * reps);
      case OneRMFormula.lombardi:
        return weight * _pow(reps.toDouble(), 0.1);
      case OneRMFormula.oconner:
        return weight * (1 + reps / 40);
    }
  }

  /// Calculate average 1RM across all formulas.
  static double calculateAverage1RM({
    required double weight,
    required int reps,
  }) {
    if (reps <= 0) return weight;
    if (reps == 1) return weight;

    double sum = 0;
    for (final formula in OneRMFormula.values) {
      sum += calculate1RM(weight: weight, reps: reps, formula: formula);
    }
    return sum / OneRMFormula.values.length;
  }

  /// Calculate weight for target reps based on 1RM.
  static double calculateWeightForReps({
    required double oneRM,
    required int targetReps,
  }) {
    if (targetReps <= 0) return oneRM;
    if (targetReps == 1) return oneRM;

    // Using Epley formula reversed
    return oneRM / (1 + targetReps / 30);
  }

  /// Get rep percentage table.
  static Map<int, double> getRepPercentages(double oneRM) {
    return {
      1: 1.00,
      2: 0.97,
      3: 0.94,
      4: 0.92,
      5: 0.89,
      6: 0.86,
      7: 0.83,
      8: 0.81,
      9: 0.78,
      10: 0.75,
      12: 0.70,
      15: 0.65,
      20: 0.58,
    }.map((reps, pct) => MapEntry(reps, oneRM * pct));
  }

  /// Get strength level based on body weight ratio.
  static StrengthLevel getStrengthLevel({
    required String exercise,
    required double oneRM,
    required double bodyWeight,
    required Gender gender,
  }) {
    final ratio = oneRM / bodyWeight;
    final standards = _getStrengthStandards(exercise, gender);

    if (ratio >= standards['elite']!) return StrengthLevel.elite;
    if (ratio >= standards['advanced']!) return StrengthLevel.advanced;
    if (ratio >= standards['intermediate']!) return StrengthLevel.intermediate;
    if (ratio >= standards['novice']!) return StrengthLevel.novice;
    return StrengthLevel.beginner;
  }

  /// Get all strength standards for an exercise.
  static Map<StrengthLevel, double> getAllStrengthStandards({
    required String exercise,
    required double bodyWeight,
    required Gender gender,
  }) {
    final ratios = _getStrengthStandards(exercise, gender);
    return {
      StrengthLevel.beginner: ratios['beginner']! * bodyWeight,
      StrengthLevel.novice: ratios['novice']! * bodyWeight,
      StrengthLevel.intermediate: ratios['intermediate']! * bodyWeight,
      StrengthLevel.advanced: ratios['advanced']! * bodyWeight,
      StrengthLevel.elite: ratios['elite']! * bodyWeight,
    };
  }

  /// Get strength standards as body weight ratios.
  static Map<String, double> _getStrengthStandards(
    String exercise,
    Gender gender,
  ) {
    final lowerExercise = exercise.toLowerCase();

    // Male standards (body weight ratios)
    final maleStandards = {
      'bench press': {
        'beginner': 0.50,
        'novice': 0.75,
        'intermediate': 1.00,
        'advanced': 1.50,
        'elite': 2.00,
      },
      'squat': {
        'beginner': 0.75,
        'novice': 1.00,
        'intermediate': 1.50,
        'advanced': 2.00,
        'elite': 2.50,
      },
      'deadlift': {
        'beginner': 1.00,
        'novice': 1.25,
        'intermediate': 1.75,
        'advanced': 2.25,
        'elite': 3.00,
      },
      'overhead press': {
        'beginner': 0.35,
        'novice': 0.50,
        'intermediate': 0.75,
        'advanced': 1.00,
        'elite': 1.35,
      },
      'barbell row': {
        'beginner': 0.50,
        'novice': 0.75,
        'intermediate': 1.00,
        'advanced': 1.25,
        'elite': 1.50,
      },
      'pull-up': {
        'beginner': 0.50,
        'novice': 0.75,
        'intermediate': 1.00,
        'advanced': 1.25,
        'elite': 1.50,
      },
    };

    // Female standards (body weight ratios) - approximately 60-70% of male
    final femaleStandards = {
      'bench press': {
        'beginner': 0.25,
        'novice': 0.50,
        'intermediate': 0.75,
        'advanced': 1.00,
        'elite': 1.25,
      },
      'squat': {
        'beginner': 0.50,
        'novice': 0.75,
        'intermediate': 1.00,
        'advanced': 1.50,
        'elite': 2.00,
      },
      'deadlift': {
        'beginner': 0.75,
        'novice': 1.00,
        'intermediate': 1.25,
        'advanced': 1.75,
        'elite': 2.25,
      },
      'overhead press': {
        'beginner': 0.20,
        'novice': 0.35,
        'intermediate': 0.50,
        'advanced': 0.75,
        'elite': 1.00,
      },
      'barbell row': {
        'beginner': 0.35,
        'novice': 0.50,
        'intermediate': 0.75,
        'advanced': 1.00,
        'elite': 1.25,
      },
      'pull-up': {
        'beginner': 0.25,
        'novice': 0.50,
        'intermediate': 0.75,
        'advanced': 1.00,
        'elite': 1.25,
      },
    };

    final standards = gender == Gender.male ? maleStandards : femaleStandards;

    // Find matching exercise or return default
    for (final entry in standards.entries) {
      if (lowerExercise.contains(entry.key) ||
          entry.key.contains(lowerExercise)) {
        return entry.value;
      }
    }

    // Default standards for unknown exercises
    return gender == Gender.male
        ? {
            'beginner': 0.50,
            'novice': 0.75,
            'intermediate': 1.00,
            'advanced': 1.50,
            'elite': 2.00,
          }
        : {
            'beginner': 0.35,
            'novice': 0.50,
            'intermediate': 0.75,
            'advanced': 1.00,
            'elite': 1.25,
          };
  }

  static double _pow(double base, double exponent) {
    return base <= 0 ? 0 : _exp(exponent * _log(base));
  }

  static double _exp(double x) {
    double sum = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 100; i++) {
      term *= x / i;
      sum += term;
      if (term.abs() < 1e-10) break;
    }
    return sum;
  }

  static double _log(double x) {
    if (x <= 0) return double.negativeInfinity;
    double y = (x - 1) / (x + 1);
    double y2 = y * y;
    double sum = y;
    double term = y;
    for (int i = 1; i <= 100; i++) {
      term *= y2;
      sum += term / (2 * i + 1);
      if (term.abs() < 1e-10) break;
    }
    return 2 * sum;
  }
}

/// Result of 1RM calculation.
class OneRMResult {
  final double weight;
  final int reps;
  final double estimated1RM;
  final Map<OneRMFormula, double> formulaResults;
  final Map<int, double> repMaxTable;

  const OneRMResult({
    required this.weight,
    required this.reps,
    required this.estimated1RM,
    required this.formulaResults,
    required this.repMaxTable,
  });
}

/// Strength assessment result.
class StrengthAssessment {
  final String exercise;
  final double oneRM;
  final double bodyWeight;
  final Gender gender;
  final StrengthLevel level;
  final double ratio;
  final Map<StrengthLevel, double> standards;
  final double percentileEstimate;

  const StrengthAssessment({
    required this.exercise,
    required this.oneRM,
    required this.bodyWeight,
    required this.gender,
    required this.level,
    required this.ratio,
    required this.standards,
    required this.percentileEstimate,
  });
}
