import 'package:flutter/material.dart';

/// Standard barbell plates in kg.
class BarPlate {
  final double weight;
  final Color color;
  final double widthFactor; // Relative width for visualization

  const BarPlate({
    required this.weight,
    required this.color,
    required this.widthFactor,
  });

  static const List<BarPlate> standardPlates = [
    BarPlate(weight: 25, color: Color(0xFFEF4444), widthFactor: 1.0), // Red
    BarPlate(weight: 20, color: Color(0xFF3B82F6), widthFactor: 0.95), // Blue
    BarPlate(weight: 15, color: Color(0xFFF59E0B), widthFactor: 0.90), // Yellow
    BarPlate(weight: 10, color: Color(0xFF22C55E), widthFactor: 0.85), // Green
    BarPlate(weight: 5, color: Color(0xFFFFFFFF), widthFactor: 0.75), // White
    BarPlate(
      weight: 2.5,
      color: Color(0xFFEF4444),
      widthFactor: 0.65,
    ), // Red (small)
    BarPlate(
      weight: 2,
      color: Color(0xFF3B82F6),
      widthFactor: 0.60,
    ), // Blue (small)
    BarPlate(
      weight: 1.25,
      color: Color(0xFFF59E0B),
      widthFactor: 0.55,
    ), // Yellow (small)
    BarPlate(
      weight: 1,
      color: Color(0xFF22C55E),
      widthFactor: 0.50,
    ), // Green (small)
    BarPlate(
      weight: 0.5,
      color: Color(0xFFFFFFFF),
      widthFactor: 0.45,
    ), // White (small)
  ];

  static const List<BarPlate> lbsPlates = [
    BarPlate(weight: 45, color: Color(0xFFEF4444), widthFactor: 1.0), // Red
    BarPlate(weight: 35, color: Color(0xFF3B82F6), widthFactor: 0.95), // Blue
    BarPlate(weight: 25, color: Color(0xFF22C55E), widthFactor: 0.85), // Green
    BarPlate(weight: 10, color: Color(0xFFF59E0B), widthFactor: 0.75), // Yellow
    BarPlate(weight: 5, color: Color(0xFFFFFFFF), widthFactor: 0.65), // White
    BarPlate(weight: 2.5, color: Color(0xFF94A3B8), widthFactor: 0.55), // Gray
  ];
}

/// Barbell types with their weights.
enum BarbellType {
  olympic(20, 'Olympic Bar'),
  womens(15, "Women's Bar"),
  ezCurl(10, 'EZ Curl Bar'),
  trap(25, 'Trap Bar'),
  safety(25, 'Safety Squat Bar');

  final double weight;
  final String label;

  const BarbellType(this.weight, this.label);
}

/// Plate calculation result.
class PlateCalculation {
  final double targetWeight;
  final double barWeight;
  final double achievedWeight;
  final List<double> platesPerSide;
  final bool isExact;
  final double difference;

  const PlateCalculation({
    required this.targetWeight,
    required this.barWeight,
    required this.achievedWeight,
    required this.platesPerSide,
    required this.isExact,
    required this.difference,
  });

  double get totalPlateWeight =>
      platesPerSide.fold(0.0, (sum, p) => sum + p) * 2;
}

/// Plate calculator utility.
class PlateCalculator {
  /// Calculate plates needed for target weight.
  static PlateCalculation calculate({
    required double targetWeight,
    required double barWeight,
    required List<double> availablePlates,
  }) {
    if (targetWeight <= barWeight) {
      return PlateCalculation(
        targetWeight: targetWeight,
        barWeight: barWeight,
        achievedWeight: barWeight,
        platesPerSide: [],
        isExact: targetWeight == barWeight,
        difference: barWeight - targetWeight,
      );
    }

    final weightPerSide = (targetWeight - barWeight) / 2;
    final platesPerSide = <double>[];
    var remaining = weightPerSide;

    // Sort plates in descending order
    final sortedPlates = List<double>.from(availablePlates)
      ..sort((a, b) => b.compareTo(a));

    // Greedy algorithm to find plates
    for (final plate in sortedPlates) {
      while (remaining >= plate - 0.001) {
        platesPerSide.add(plate);
        remaining -= plate;
      }
    }

    final achievedWeight =
        barWeight + platesPerSide.fold(0.0, (sum, p) => sum + p) * 2;

    return PlateCalculation(
      targetWeight: targetWeight,
      barWeight: barWeight,
      achievedWeight: achievedWeight,
      platesPerSide: platesPerSide,
      isExact: (achievedWeight - targetWeight).abs() < 0.001,
      difference: targetWeight - achievedWeight,
    );
  }

  /// Get standard plate colors for visualization.
  static Color getPlateColor(double weight, bool isKg) {
    if (isKg) {
      if (weight >= 25) return const Color(0xFFEF4444);
      if (weight >= 20) return const Color(0xFF3B82F6);
      if (weight >= 15) return const Color(0xFFF59E0B);
      if (weight >= 10) return const Color(0xFF22C55E);
      if (weight >= 5) return Colors.white;
      return const Color(0xFF94A3B8);
    } else {
      if (weight >= 45) return const Color(0xFFEF4444);
      if (weight >= 35) return const Color(0xFF3B82F6);
      if (weight >= 25) return const Color(0xFF22C55E);
      if (weight >= 10) return const Color(0xFFF59E0B);
      if (weight >= 5) return Colors.white;
      return const Color(0xFF94A3B8);
    }
  }

  /// Get plate size factor for visualization.
  static double getPlateSizeFactor(double weight, bool isKg) {
    if (isKg) {
      if (weight >= 25) return 1.0;
      if (weight >= 20) return 0.95;
      if (weight >= 15) return 0.90;
      if (weight >= 10) return 0.85;
      if (weight >= 5) return 0.75;
      if (weight >= 2.5) return 0.65;
      return 0.50;
    } else {
      if (weight >= 45) return 1.0;
      if (weight >= 35) return 0.95;
      if (weight >= 25) return 0.85;
      if (weight >= 10) return 0.75;
      if (weight >= 5) return 0.65;
      return 0.50;
    }
  }
}

/// Warm-up set calculator.
class WarmUpCalculator {
  /// Generate warm-up sets for a working weight.
  static List<WarmUpSet> calculateWarmUp({
    required double workingWeight,
    required double barWeight,
  }) {
    if (workingWeight <= barWeight) {
      return [WarmUpSet(weight: barWeight, reps: 10, percentage: 100)];
    }

    final sets = <WarmUpSet>[];

    // Always start with empty bar
    sets.add(WarmUpSet(weight: barWeight, reps: 10, percentage: 0));

    // Progressive warm-up percentages
    final percentages = [40, 60, 75, 90];

    for (final pct in percentages) {
      final weight = workingWeight * pct / 100;
      if (weight > barWeight) {
        final reps = pct < 70 ? 8 : (pct < 85 ? 5 : 3);
        sets.add(
          WarmUpSet(
            weight: _roundToPlate(weight, barWeight),
            reps: reps,
            percentage: pct,
          ),
        );
      }
    }

    return sets;
  }

  static double _roundToPlate(double weight, double barWeight) {
    final plateWeight = (weight - barWeight) / 2;
    final roundedPlate = (plateWeight / 2.5).round() * 2.5;
    return barWeight + roundedPlate * 2;
  }
}

/// Warm-up set data.
class WarmUpSet {
  final double weight;
  final int reps;
  final int percentage;

  const WarmUpSet({
    required this.weight,
    required this.reps,
    required this.percentage,
  });
}
