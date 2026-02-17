import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/nutrition.dart';
import '../providers/nutrition_provider.dart';

/// Screen for tracking nutrition and macros.
class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nutrition = ref.watch(dailyNutritionNotifierProvider);
    final water = ref.watch(dailyWaterNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(nutrition, water),
            ),
            title: innerBoxIsScrolled ? const Text('Nutrition') : null,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondaryDark,
              tabs: const [
                Tab(text: 'Food Log'),
                Tab(text: 'Water'),
                Tab(text: 'Supplements'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFoodLogTab(nutrition),
            _buildWaterTab(water),
            _buildSupplementsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFoodSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Log Food'),
      ),
    );
  }

  Widget _buildHeader(DailyNutrition nutrition, DailyWater water) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 56,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF22C55E).withValues(alpha: 0.2),
            AppColors.backgroundDark,
          ],
        ),
      ),
      child: Column(
        children: [
          // Calorie ring
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: nutrition.calorieProgress.clamp(0, 1),
                        strokeWidth: 8,
                        backgroundColor: AppColors.surfaceDark,
                        valueColor: AlwaysStoppedAnimation(
                          nutrition.calorieProgress > 1
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${nutrition.totalCalories}',
                          style: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/ ${nutrition.targetCalories}',
                          style: const TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nutrition.remainingCalories > 0
                          ? '${nutrition.remainingCalories} cal remaining'
                          : '${-nutrition.remainingCalories} cal over',
                      style: TextStyle(
                        color: nutrition.remainingCalories > 0
                            ? AppColors.textPrimaryDark
                            : AppColors.error,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _MiniProgress(
                          label: 'Water',
                          value: water.progress.clamp(0, 1),
                          color: const Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${water.glassCount} glasses',
                          style: const TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Macro bars
          Row(
            children: [
              Expanded(
                child: _MacroBar(
                  macro: Macro.protein,
                  current: nutrition.totalProtein,
                  target: nutrition.targetProtein,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MacroBar(
                  macro: Macro.carbs,
                  current: nutrition.totalCarbs,
                  target: nutrition.targetCarbs,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MacroBar(
                  macro: Macro.fat,
                  current: nutrition.totalFat,
                  target: nutrition.targetFat,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodLogTab(DailyNutrition nutrition) {
    // Group by meal type
    final grouped = <MealType, List<FoodEntry>>{};
    for (final entry in nutrition.entries) {
      grouped.putIfAbsent(entry.mealType, () => []).add(entry);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final mealType in MealType.values)
          if (grouped[mealType]?.isNotEmpty ?? false) ...[
            _MealSection(
              mealType: mealType,
              entries: grouped[mealType]!,
              onRemove: (id) => ref
                  .read(dailyNutritionNotifierProvider.notifier)
                  .removeEntry(id),
            ),
            const SizedBox(height: 16),
          ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildWaterTab(DailyWater water) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Water progress
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: water.progress.clamp(0, 1),
                          strokeWidth: 12,
                          backgroundColor: AppColors.backgroundDark,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.water_drop,
                            color: Color(0xFF3B82F6),
                            size: 32,
                          ),
                          Text(
                            '${water.totalMl}',
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/ ${water.targetMl} ml',
                            style: const TextStyle(
                              color: AppColors.textSecondaryDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  water.remaining > 0
                      ? '${water.remaining} ml to go!'
                      : 'Goal reached! 🎉',
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Quick add buttons
          const Text(
            'Quick Add',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [200, 250, 300, 500].map((ml) {
              return ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  ref.read(dailyWaterNotifierProvider.notifier).addWater(ml);
                },
                icon: const Icon(Icons.add),
                label: Text('$ml ml'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF3B82F6,
                  ).withValues(alpha: 0.2),
                  foregroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Recent entries
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Log',
                  style: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...water.entries.reversed
                    .take(5)
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.water_drop,
                              color: Color(0xFF3B82F6),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${entry.amount} ml',
                              style: const TextStyle(
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${entry.loggedAt.hour}:${entry.loggedAt.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                color: AppColors.textSecondaryDark,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplementsTab() {
    final supplements = ref.watch(supplementsNotifierProvider);
    final log = ref.watch(supplementLogNotifierProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: supplements.length,
      itemBuilder: (context, index) {
        final supplement = supplements[index];
        final entry = log.firstWhere(
          (e) => e.supplement.id == supplement.id,
          orElse: () => SupplementEntry(
            id: '',
            supplement: supplement,
            takenAt: DateTime.now(),
            wasTaken: false,
          ),
        );

        return Card(
          color: AppColors.surfaceDark,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: entry.wasTaken
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                entry.wasTaken ? Icons.check : Icons.medication,
                color: entry.wasTaken ? AppColors.success : AppColors.primary,
              ),
            ),
            title: Text(
              supplement.name,
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
                decoration: entry.wasTaken ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              '${supplement.dosage ?? ''} • ${supplement.timing ?? 'Any time'}',
              style: const TextStyle(color: AppColors.textSecondaryDark),
            ),
            trailing: entry.wasTaken
                ? const Icon(Icons.check_circle, color: AppColors.success)
                : TextButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      ref
                          .read(supplementLogNotifierProvider.notifier)
                          .markTaken(supplement.id);
                    },
                    child: const Text('Take'),
                  ),
          ),
        );
      },
    );
  }

  void _showAddFoodSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) =>
            _AddFoodSheet(scrollController: scrollController),
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  final Macro macro;
  final double current;
  final double target;

  const _MacroBar({
    required this.macro,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final color = Color(macro.colorValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              macro.label,
              style: const TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 12,
              ),
            ),
            Text(
              '${current.toStringAsFixed(0)}/${target.toStringAsFixed(0)}g',
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.backgroundDark,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _MiniProgress extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MiniProgress({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.surfaceDark,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final MealType mealType;
  final List<FoodEntry> entries;
  final Function(String) onRemove;

  const _MealSection({
    required this.mealType,
    required this.entries,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final totalCal = entries
        .map((e) => e.totalCalories)
        .fold(0, (a, b) => a + b);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(mealType.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mealType.label,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  '$totalCal cal',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.borderDark),
          ...entries.map(
            (entry) => Dismissible(
              key: Key(entry.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => onRemove(entry.id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: AppColors.error,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ListTile(
                title: Text(
                  entry.food.name,
                  style: const TextStyle(color: AppColors.textPrimaryDark),
                ),
                subtitle: Text(
                  '${entry.servings} × ${entry.food.servingSize}${entry.food.servingUnit}',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${entry.totalCalories} cal',
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'P:${entry.totalProtein.toStringAsFixed(0)} C:${entry.totalCarbs.toStringAsFixed(0)} F:${entry.totalFat.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddFoodSheet extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const _AddFoodSheet({required this.scrollController});

  @override
  ConsumerState<_AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends ConsumerState<_AddFoodSheet> {
  final _searchController = TextEditingController();
  MealType _selectedMeal = MealType.lunch;

  @override
  Widget build(BuildContext context) {
    final foods = ref.watch(foodSearchNotifierProvider);

    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.textSecondaryDark,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Food',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                style: const TextStyle(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  hintText: 'Search foods...',
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondaryDark,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondaryDark,
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  ref.read(foodSearchNotifierProvider.notifier).search(value);
                },
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: MealType.values.map((meal) {
                    final isSelected = _selectedMeal == meal;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${meal.emoji} ${meal.label}'),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedMeal = meal),
                        selectedColor: Color(meal.colorValue),
                        backgroundColor: AppColors.backgroundDark,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondaryDark,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return Card(
                color: AppColors.backgroundDark,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    food.name,
                    style: const TextStyle(color: AppColors.textPrimaryDark),
                  ),
                  subtitle: Text(
                    '${food.servingSize}${food.servingUnit} • ${food.calories} cal',
                    style: const TextStyle(color: AppColors.textSecondaryDark),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      final entry = FoodEntry(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        food: food,
                        servings: 1,
                        mealType: _selectedMeal,
                        loggedAt: DateTime.now(),
                      );
                      ref
                          .read(dailyNutritionNotifierProvider.notifier)
                          .addEntry(entry);
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
