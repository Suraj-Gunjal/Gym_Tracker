/// Nutrition tracking entities.

/// Macronutrient types.
enum Macro {
  protein('Protein', 'g', 4, 0xFF22C55E),
  carbs('Carbs', 'g', 4, 0xFF3B82F6),
  fat('Fat', 'g', 9, 0xFFF59E0B),
  fiber('Fiber', 'g', 0, 0xFF8B5CF6);

  final String label;
  final String unit;
  final int caloriesPerGram;
  final int colorValue;

  const Macro(this.label, this.unit, this.caloriesPerGram, this.colorValue);
}

/// A single food item.
class FoodItem {
  final String id;
  final String name;
  final double servingSize;
  final String servingUnit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double? fiber;
  final bool isFavorite;
  final String? barcode;

  const FoodItem({
    required this.id,
    required this.name,
    required this.servingSize,
    required this.servingUnit,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber,
    this.isFavorite = false,
    this.barcode,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    double? servingSize,
    String? servingUnit,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    bool? isFavorite,
    String? barcode,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      isFavorite: isFavorite ?? this.isFavorite,
      barcode: barcode ?? this.barcode,
    );
  }
}

/// Meal types.
enum MealType {
  breakfast('Breakfast', '🌅', 0xFF22C55E),
  lunch('Lunch', '☀️', 0xFF3B82F6),
  dinner('Dinner', '🌙', 0xFF8B5CF6),
  snack('Snack', '🍎', 0xFFF59E0B);

  final String label;
  final String emoji;
  final int colorValue;

  const MealType(this.label, this.emoji, this.colorValue);
}

/// A logged food entry.
class FoodEntry {
  final String id;
  final FoodItem food;
  final double servings;
  final MealType mealType;
  final DateTime loggedAt;
  final String? notes;

  const FoodEntry({
    required this.id,
    required this.food,
    required this.servings,
    required this.mealType,
    required this.loggedAt,
    this.notes,
  });

  int get totalCalories => (food.calories * servings).round();
  double get totalProtein => food.protein * servings;
  double get totalCarbs => food.carbs * servings;
  double get totalFat => food.fat * servings;
}

/// Daily nutrition summary.
class DailyNutrition {
  final DateTime date;
  final List<FoodEntry> entries;
  final int targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;

  const DailyNutrition({
    required this.date,
    required this.entries,
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFat,
  });

  int get totalCalories =>
      entries.map((e) => e.totalCalories).fold(0, (a, b) => a + b);
  double get totalProtein =>
      entries.map((e) => e.totalProtein).fold(0.0, (a, b) => a + b);
  double get totalCarbs =>
      entries.map((e) => e.totalCarbs).fold(0.0, (a, b) => a + b);
  double get totalFat =>
      entries.map((e) => e.totalFat).fold(0.0, (a, b) => a + b);

  double get calorieProgress =>
      targetCalories > 0 ? totalCalories / targetCalories : 0;
  double get proteinProgress =>
      targetProtein > 0 ? totalProtein / targetProtein : 0;
  double get carbsProgress => targetCarbs > 0 ? totalCarbs / targetCarbs : 0;
  double get fatProgress => targetFat > 0 ? totalFat / targetFat : 0;

  int get remainingCalories => targetCalories - totalCalories;
}

/// Nutrition goals.
class NutritionGoals {
  final int dailyCalories;
  final double proteinPerKg; // grams per kg bodyweight
  final double carbPercent; // % of calories
  final double fatPercent; // % of calories
  final double bodyWeight; // kg

  const NutritionGoals({
    required this.dailyCalories,
    this.proteinPerKg = 1.8,
    this.carbPercent = 0.45,
    this.fatPercent = 0.25,
    this.bodyWeight = 75,
  });

  double get targetProtein => bodyWeight * proteinPerKg;
  double get targetCarbs => (dailyCalories * carbPercent) / 4;
  double get targetFat => (dailyCalories * fatPercent) / 9;
}

/// Water intake entry.
class WaterEntry {
  final String id;
  final int amount; // ml
  final DateTime loggedAt;

  const WaterEntry({
    required this.id,
    required this.amount,
    required this.loggedAt,
  });
}

/// Daily water tracking.
class DailyWater {
  final DateTime date;
  final List<WaterEntry> entries;
  final int targetMl;

  const DailyWater({
    required this.date,
    required this.entries,
    required this.targetMl,
  });

  int get totalMl => entries.map((e) => e.amount).fold(0, (a, b) => a + b);
  double get progress => targetMl > 0 ? totalMl / targetMl : 0;
  int get remaining => targetMl - totalMl;
  int get glassCount => (totalMl / 250).round(); // 250ml per glass
}

/// Supplement.
class Supplement {
  final String id;
  final String name;
  final String? dosage;
  final String? timing; // e.g., "Morning", "Pre-workout"
  final bool isDaily;
  final List<String> reminderTimes; // HH:mm format

  const Supplement({
    required this.id,
    required this.name,
    this.dosage,
    this.timing,
    this.isDaily = true,
    this.reminderTimes = const [],
  });
}

/// Supplement log entry.
class SupplementEntry {
  final String id;
  final Supplement supplement;
  final DateTime takenAt;
  final bool wasTaken;

  const SupplementEntry({
    required this.id,
    required this.supplement,
    required this.takenAt,
    required this.wasTaken,
  });
}
