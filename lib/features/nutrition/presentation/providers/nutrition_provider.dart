import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/nutrition.dart';

part 'nutrition_provider.g.dart';

/// Provider for nutrition goals.
@riverpod
class NutritionGoalsNotifier extends _$NutritionGoalsNotifier {
  @override
  NutritionGoals build() => const NutritionGoals(
    dailyCalories: 2500,
    proteinPerKg: 2.0,
    carbPercent: 0.45,
    fatPercent: 0.25,
    bodyWeight: 80,
  );

  void updateCalories(int calories) {
    state = NutritionGoals(
      dailyCalories: calories,
      proteinPerKg: state.proteinPerKg,
      carbPercent: state.carbPercent,
      fatPercent: state.fatPercent,
      bodyWeight: state.bodyWeight,
    );
  }

  void updateBodyWeight(double weight) {
    state = NutritionGoals(
      dailyCalories: state.dailyCalories,
      proteinPerKg: state.proteinPerKg,
      carbPercent: state.carbPercent,
      fatPercent: state.fatPercent,
      bodyWeight: weight,
    );
  }

  void updateMacroSplit(double protein, double carbs, double fat) {
    state = NutritionGoals(
      dailyCalories: state.dailyCalories,
      proteinPerKg: protein,
      carbPercent: carbs,
      fatPercent: fat,
      bodyWeight: state.bodyWeight,
    );
  }
}

/// Provider for daily nutrition tracking.
@riverpod
class DailyNutritionNotifier extends _$DailyNutritionNotifier {
  @override
  DailyNutrition build() {
    final goals = ref.watch(nutritionGoalsNotifierProvider);
    return DailyNutrition(
      date: DateTime.now(),
      entries: _generateMockEntries(),
      targetCalories: goals.dailyCalories,
      targetProtein: goals.targetProtein,
      targetCarbs: goals.targetCarbs,
      targetFat: goals.targetFat,
    );
  }

  List<FoodEntry> _generateMockEntries() {
    return [
      FoodEntry(
        id: '1',
        food: const FoodItem(
          id: 'f1',
          name: 'Scrambled Eggs',
          servingSize: 2,
          servingUnit: 'eggs',
          calories: 180,
          protein: 12,
          carbs: 2,
          fat: 14,
        ),
        servings: 1,
        mealType: MealType.breakfast,
        loggedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FoodEntry(
        id: '2',
        food: const FoodItem(
          id: 'f2',
          name: 'Oatmeal with Banana',
          servingSize: 1,
          servingUnit: 'bowl',
          calories: 350,
          protein: 10,
          carbs: 60,
          fat: 8,
        ),
        servings: 1,
        mealType: MealType.breakfast,
        loggedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      FoodEntry(
        id: '3',
        food: const FoodItem(
          id: 'f3',
          name: 'Grilled Chicken Breast',
          servingSize: 150,
          servingUnit: 'g',
          calories: 250,
          protein: 45,
          carbs: 0,
          fat: 6,
        ),
        servings: 1,
        mealType: MealType.lunch,
        loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FoodEntry(
        id: '4',
        food: const FoodItem(
          id: 'f4',
          name: 'Brown Rice',
          servingSize: 150,
          servingUnit: 'g',
          calories: 180,
          protein: 4,
          carbs: 40,
          fat: 1,
        ),
        servings: 1,
        mealType: MealType.lunch,
        loggedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      FoodEntry(
        id: '5',
        food: const FoodItem(
          id: 'f5',
          name: 'Protein Shake',
          servingSize: 1,
          servingUnit: 'scoop',
          calories: 120,
          protein: 25,
          carbs: 3,
          fat: 1,
        ),
        servings: 1,
        mealType: MealType.snack,
        loggedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }

  void addEntry(FoodEntry entry) {
    state = DailyNutrition(
      date: state.date,
      entries: [...state.entries, entry],
      targetCalories: state.targetCalories,
      targetProtein: state.targetProtein,
      targetCarbs: state.targetCarbs,
      targetFat: state.targetFat,
    );
  }

  void removeEntry(String id) {
    state = DailyNutrition(
      date: state.date,
      entries: state.entries.where((e) => e.id != id).toList(),
      targetCalories: state.targetCalories,
      targetProtein: state.targetProtein,
      targetCarbs: state.targetCarbs,
      targetFat: state.targetFat,
    );
  }
}

/// Provider for water tracking.
@riverpod
class DailyWaterNotifier extends _$DailyWaterNotifier {
  @override
  DailyWater build() {
    return DailyWater(
      date: DateTime.now(),
      entries: _generateMockWater(),
      targetMl: 3000,
    );
  }

  List<WaterEntry> _generateMockWater() {
    final random = Random(42);
    final now = DateTime.now();
    return List.generate(
      random.nextInt(8) + 2,
      (i) => WaterEntry(
        id: 'w$i',
        amount: [200, 250, 300, 350, 500][random.nextInt(5)],
        loggedAt: now.subtract(Duration(hours: random.nextInt(12))),
      ),
    );
  }

  void addWater(int ml) {
    state = DailyWater(
      date: state.date,
      entries: [
        ...state.entries,
        WaterEntry(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amount: ml,
          loggedAt: DateTime.now(),
        ),
      ],
      targetMl: state.targetMl,
    );
  }

  void updateTarget(int ml) {
    state = DailyWater(date: state.date, entries: state.entries, targetMl: ml);
  }
}

/// Provider for supplements.
@riverpod
class SupplementsNotifier extends _$SupplementsNotifier {
  @override
  List<Supplement> build() {
    return const [
      Supplement(
        id: 's1',
        name: 'Creatine',
        dosage: '5g',
        timing: 'Post-workout',
        reminderTimes: ['08:00', '18:00'],
      ),
      Supplement(
        id: 's2',
        name: 'Vitamin D3',
        dosage: '4000 IU',
        timing: 'Morning',
        reminderTimes: ['08:00'],
      ),
      Supplement(
        id: 's3',
        name: 'Fish Oil',
        dosage: '2g',
        timing: 'With meals',
        reminderTimes: ['08:00', '13:00', '19:00'],
      ),
      Supplement(
        id: 's4',
        name: 'Magnesium',
        dosage: '400mg',
        timing: 'Before bed',
        reminderTimes: ['21:00'],
      ),
    ];
  }

  void addSupplement(Supplement supplement) {
    state = [...state, supplement];
  }

  void removeSupplement(String id) {
    state = state.where((s) => s.id != id).toList();
  }
}

/// Provider for supplement logs.
@riverpod
class SupplementLogNotifier extends _$SupplementLogNotifier {
  @override
  List<SupplementEntry> build() {
    final supplements = ref.watch(supplementsNotifierProvider);
    final now = DateTime.now();

    // Generate today's entries
    return supplements
        .map(
          (s) => SupplementEntry(
            id: '${s.id}_${now.day}',
            supplement: s,
            takenAt: now,
            wasTaken: false,
          ),
        )
        .toList();
  }

  void markTaken(String supplementId) {
    state = state.map((e) {
      if (e.supplement.id == supplementId) {
        return SupplementEntry(
          id: e.id,
          supplement: e.supplement,
          takenAt: DateTime.now(),
          wasTaken: true,
        );
      }
      return e;
    }).toList();
  }
}

/// Provider for food search.
@riverpod
class FoodSearchNotifier extends _$FoodSearchNotifier {
  @override
  List<FoodItem> build() {
    return const [
      FoodItem(
        id: 'search1',
        name: 'Chicken Breast (raw)',
        servingSize: 100,
        servingUnit: 'g',
        calories: 165,
        protein: 31,
        carbs: 0,
        fat: 3.6,
      ),
      FoodItem(
        id: 'search2',
        name: 'White Rice (cooked)',
        servingSize: 100,
        servingUnit: 'g',
        calories: 130,
        protein: 2.7,
        carbs: 28,
        fat: 0.3,
      ),
      FoodItem(
        id: 'search3',
        name: 'Banana',
        servingSize: 1,
        servingUnit: 'medium',
        calories: 105,
        protein: 1.3,
        carbs: 27,
        fat: 0.4,
      ),
      FoodItem(
        id: 'search4',
        name: 'Egg (whole)',
        servingSize: 1,
        servingUnit: 'large',
        calories: 78,
        protein: 6,
        carbs: 0.6,
        fat: 5,
      ),
      FoodItem(
        id: 'search5',
        name: 'Greek Yogurt',
        servingSize: 100,
        servingUnit: 'g',
        calories: 97,
        protein: 9,
        carbs: 3.6,
        fat: 5,
      ),
    ];
  }

  void search(String query) {
    // In real app, would search database/API
    if (query.isEmpty) {
      state = build();
      return;
    }
    state = build()
        .where((f) => f.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
