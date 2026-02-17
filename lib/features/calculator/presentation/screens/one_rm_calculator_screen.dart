import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/strength_calculator.dart';

/// 1RM Calculator Screen with strength standards comparison.
class OneRMCalculatorScreen extends ConsumerStatefulWidget {
  const OneRMCalculatorScreen({super.key});

  @override
  ConsumerState<OneRMCalculatorScreen> createState() =>
      _OneRMCalculatorScreenState();
}

class _OneRMCalculatorScreenState extends ConsumerState<OneRMCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _weightController = TextEditingController(text: '100');
  final _repsController = TextEditingController(text: '5');
  final _bodyWeightController = TextEditingController(text: '75');

  Gender _selectedGender = Gender.male;
  String _selectedExercise = 'Bench Press';
  OneRMFormula _selectedFormula = OneRMFormula.epley;

  double? _calculated1RM;
  StrengthAssessment? _assessment;

  final _exercises = [
    'Bench Press',
    'Squat',
    'Deadlift',
    'Overhead Press',
    'Barbell Row',
    'Pull-up',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _calculate();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    _repsController.dispose();
    _bodyWeightController.dispose();
    super.dispose();
  }

  void _calculate() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final reps = int.tryParse(_repsController.text) ?? 0;
    final bodyWeight = double.tryParse(_bodyWeightController.text) ?? 75;

    if (weight > 0 && reps > 0) {
      final oneRM = StrengthCalculator.calculateAverage1RM(
        weight: weight,
        reps: reps,
      );
      final level = StrengthCalculator.getStrengthLevel(
        exercise: _selectedExercise,
        oneRM: oneRM,
        bodyWeight: bodyWeight,
        gender: _selectedGender,
      );
      final standards = StrengthCalculator.getAllStrengthStandards(
        exercise: _selectedExercise,
        bodyWeight: bodyWeight,
        gender: _selectedGender,
      );

      setState(() {
        _calculated1RM = oneRM;
        _assessment = StrengthAssessment(
          exercise: _selectedExercise,
          oneRM: oneRM,
          bodyWeight: bodyWeight,
          gender: _selectedGender,
          level: level,
          ratio: oneRM / bodyWeight,
          standards: standards,
          percentileEstimate: _estimatePercentile(level),
        );
      });
    }
  }

  double _estimatePercentile(StrengthLevel level) {
    switch (level) {
      case StrengthLevel.beginner:
        return 5;
      case StrengthLevel.novice:
        return 20;
      case StrengthLevel.intermediate:
        return 50;
      case StrengthLevel.advanced:
        return 80;
      case StrengthLevel.elite:
        return 95;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Strength Calculator'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '1RM Calculator'),
            Tab(text: 'Strength Standards'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCalculatorTab(), _buildStandardsTab()],
      ),
    );
  }

  Widget _buildCalculatorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Card
          _buildInputCard(),

          const SizedBox(height: 20),

          // Result Card
          if (_calculated1RM != null) ...[
            _build1RMResultCard(),
            const SizedBox(height: 16),
            _buildRepMaxTable(),
          ],
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Your Lift',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Exercise selector
          DropdownButtonFormField<String>(
            value: _selectedExercise,
            decoration: InputDecoration(
              labelText: 'Exercise',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surfaceLight,
            ),
            items: _exercises
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedExercise = value!);
              _calculate();
            },
          ),

          const SizedBox(height: 16),

          // Weight and Reps row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _repsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Reps',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLight,
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Formula selector
          DropdownButtonFormField<OneRMFormula>(
            value: _selectedFormula,
            decoration: InputDecoration(
              labelText: 'Formula',
              helperText: _selectedFormula.formula,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surfaceLight,
            ),
            items: OneRMFormula.values
                .map((f) => DropdownMenuItem(value: f, child: Text(f.label)))
                .toList(),
            onChanged: (value) {
              setState(() => _selectedFormula = value!);
              _calculate();
            },
          ),
        ],
      ),
    );
  }

  Widget _build1RMResultCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary.withValues(alpha: 0.2), AppColors.surface],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text(
            'Estimated One Rep Max',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _calculated1RM!.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  ' kg',
                  style: TextStyle(fontSize: 20, color: AppColors.primary),
                ),
              ),
            ],
          ),
          if (_assessment != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _assessment!.level.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 18,
                    color: _assessment!.level.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _assessment!.level.label,
                    style: TextStyle(
                      color: _assessment!.level.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_assessment!.ratio.toStringAsFixed(2)}x body weight',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRepMaxTable() {
    final percentages = StrengthCalculator.getRepPercentages(_calculated1RM!);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rep Max Table',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...percentages.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${entry.key} RM',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: entry.value / _calculated1RM!,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation(
                        AppColors.primary.withValues(alpha: 0.7),
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 70,
                    child: Text(
                      '${entry.value.toStringAsFixed(1)} kg',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile settings
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Profile',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _bodyWeightController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Body Weight (kg)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceLight,
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<Gender>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppColors.surfaceLight,
                        ),
                        items: Gender.values
                            .map(
                              (g) => DropdownMenuItem(
                                value: g,
                                child: Text(g.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedGender = value!);
                          _calculate();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Standards for each exercise
          ..._exercises.map((exercise) => _buildExerciseStandardCard(exercise)),
        ],
      ),
    );
  }

  Widget _buildExerciseStandardCard(String exercise) {
    final bodyWeight = double.tryParse(_bodyWeightController.text) ?? 75;
    final standards = StrengthCalculator.getAllStrengthStandards(
      exercise: exercise,
      bodyWeight: bodyWeight,
      gender: _selectedGender,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                exercise,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...StrengthLevel.values.map((level) {
            final weight = standards[level]!;
            final ratio = weight / bodyWeight;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: level.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: Text(
                      level.label,
                      style: TextStyle(
                        color: level.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${weight.toStringAsFixed(1)} kg',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${ratio.toStringAsFixed(2)}x BW',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
