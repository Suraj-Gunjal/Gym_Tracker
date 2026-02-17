import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/plate_calculator.dart';

/// Visual plate calculator screen.
class PlateCalculatorScreen extends StatefulWidget {
  const PlateCalculatorScreen({super.key});

  @override
  State<PlateCalculatorScreen> createState() => _PlateCalculatorScreenState();
}

class _PlateCalculatorScreenState extends State<PlateCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final _weightController = TextEditingController(text: '100');
  BarbellType _selectedBarbell = BarbellType.olympic;
  bool _useKg = true;
  PlateCalculation? _calculation;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  final _availablePlatesKg = [25.0, 20.0, 15.0, 10.0, 5.0, 2.5, 1.25];
  final _availablePlatesLbs = [45.0, 35.0, 25.0, 10.0, 5.0, 2.5];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _calculate();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _calculate() {
    final target = double.tryParse(_weightController.text) ?? 0;
    if (target > 0) {
      setState(() {
        _calculation = PlateCalculator.calculate(
          targetWeight: target,
          barWeight: _selectedBarbell.weight,
          availablePlates: _useKg ? _availablePlatesKg : _availablePlatesLbs,
        );
      });
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Plate Calculator'),
        actions: [
          // Unit toggle
          TextButton.icon(
            onPressed: () {
              setState(() {
                _useKg = !_useKg;
                _calculate();
              });
            },
            icon: Icon(_useKg ? Icons.straighten : Icons.square_foot, size: 18),
            label: Text(_useKg ? 'kg' : 'lbs'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Input section
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                // Weight input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                        ],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          suffixText: _useKg ? 'kg' : 'lbs',
                          suffixStyle: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                        ),
                        textAlign: TextAlign.center,
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                  ],
                ),

                // Quick weight buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final weight
                          in _useKg
                              ? [60, 80, 100, 120, 140, 160, 180, 200]
                              : [135, 185, 225, 275, 315, 365, 405])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            label: Text('$weight'),
                            onPressed: () {
                              _weightController.text = weight.toString();
                              _calculate();
                            },
                            backgroundColor: AppColors.surfaceLight,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Barbell selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: BarbellType.values.map((bar) {
                      final isSelected = bar == _selectedBarbell;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            '${bar.label} (${bar.weight.toInt()}${_useKg ? 'kg' : 'lb'})',
                          ),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedBarbell = bar);
                            _calculate();
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Visual barbell representation
          Expanded(
            child: _calculation != null
                ? AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return _BarbellVisualization(
                        calculation: _calculation!,
                        useKg: _useKg,
                        animation: _slideAnimation.value,
                      );
                    },
                  )
                : const Center(child: Text('Enter a weight')),
          ),

          // Plates summary
          if (_calculation != null) _buildPlatesSummary(),
        ],
      ),
    );
  }

  Widget _buildPlatesSummary() {
    final plateCounts = <double, int>{};
    for (final plate in _calculation!.platesPerSide) {
      plateCounts[plate] = (plateCounts[plate] ?? 0) + 1;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Achieved weight
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_calculation!.isExact)
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.amber,
                  size: 20,
                ),
              const SizedBox(width: 8),
              Text(
                'Total: ${_calculation!.achievedWeight.toStringAsFixed(1)} ${_useKg ? 'kg' : 'lbs'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!_calculation!.isExact) ...[
                const SizedBox(width: 8),
                Text(
                  '(${_calculation!.difference > 0 ? '-' : '+'}${_calculation!.difference.abs().toStringAsFixed(2)})',
                  style: TextStyle(color: Colors.amber, fontSize: 14),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Plates per side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Per side: ', style: TextStyle(color: Colors.grey)),
              ...plateCounts.entries.map((entry) {
                final color = PlateCalculator.getPlateColor(entry.key, _useKg);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    '${entry.value}×${entry.key}',
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                );
              }),
            ],
          ),

          const SizedBox(height: 8),

          // Warm-up suggestion
          TextButton.icon(
            onPressed: () => _showWarmUpSheet(),
            icon: const Icon(Icons.fitness_center, size: 18),
            label: const Text('View Warm-Up Sets'),
          ),
        ],
      ),
    );
  }

  void _showWarmUpSheet() {
    final targetWeight = double.tryParse(_weightController.text) ?? 0;
    final warmUpSets = WarmUpCalculator.calculateWarmUp(
      workingWeight: targetWeight,
      barWeight: _selectedBarbell.weight,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Warm-Up Sets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'For working weight of ${targetWeight.toStringAsFixed(0)} ${_useKg ? 'kg' : 'lbs'}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            ...warmUpSets.asMap().entries.map((entry) {
              final index = entry.key;
              final set = entry.value;
              final isWorking = index == warmUpSets.length - 1;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isWorking
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: isWorking
                      ? Border.all(color: AppColors.primary)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isWorking ? AppColors.primary : Colors.grey[700],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${set.weight.toStringAsFixed(1)} ${_useKg ? 'kg' : 'lbs'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (set.percentage > 0)
                            Text(
                              '${set.percentage}% of working weight',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '${set.reps} reps',
                      style: TextStyle(
                        color: isWorking ? AppColors.primary : Colors.grey[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/// Visual barbell with plates.
class _BarbellVisualization extends StatelessWidget {
  final PlateCalculation calculation;
  final bool useKg;
  final double animation;

  const _BarbellVisualization({
    required this.calculation,
    required this.useKg,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barLength = constraints.maxWidth * 0.9;
        final barHeight = 12.0;
        final maxPlateHeight = constraints.maxHeight * 0.6;
        final plateWidth = 20.0;

        return Center(
          child: SizedBox(
            width: barLength,
            height: maxPlateHeight + 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Barbell bar
                Container(
                  width: barLength,
                  height: barHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey[600]!,
                        Colors.grey[400]!,
                        Colors.grey[600]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(barHeight / 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                // Center collar
                Container(
                  width: barLength * 0.3,
                  height: barHeight + 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                // Left plates
                ..._buildPlates(
                  calculation.platesPerSide,
                  barLength,
                  maxPlateHeight,
                  plateWidth,
                  isLeft: true,
                ),

                // Right plates
                ..._buildPlates(
                  calculation.platesPerSide,
                  barLength,
                  maxPlateHeight,
                  plateWidth,
                  isLeft: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildPlates(
    List<double> plates,
    double barLength,
    double maxPlateHeight,
    double plateWidth, {
    required bool isLeft,
  }) {
    final widgets = <Widget>[];
    final startX = isLeft ? barLength * 0.15 : barLength * 0.85;
    var currentX = startX;

    for (var i = 0; i < plates.length; i++) {
      final plate = plates[i];
      final color = PlateCalculator.getPlateColor(plate, useKg);
      final sizeFactor = PlateCalculator.getPlateSizeFactor(plate, useKg);
      final plateHeight = maxPlateHeight * sizeFactor;

      final slideOffset = (1 - animation) * (isLeft ? -50 : 50) * (i + 1);

      widgets.add(
        Positioned(
          left: isLeft ? currentX - plateWidth + slideOffset : null,
          right: isLeft
              ? null
              : (barLength - currentX - plateWidth) - slideOffset,
          child: Transform.scale(
            scale: animation,
            child: _PlateWidget(
              weight: plate,
              color: color,
              height: plateHeight,
              width: plateWidth,
              useKg: useKg,
            ),
          ),
        ),
      );

      if (isLeft) {
        currentX -= plateWidth + 2;
      } else {
        currentX += plateWidth + 2;
      }
    }

    return widgets;
  }
}

class _PlateWidget extends StatelessWidget {
  final double weight;
  final Color color;
  final double height;
  final double width;
  final bool useKg;

  const _PlateWidget({
    required this.weight,
    required this.color,
    required this.height,
    required this.width,
    required this.useKg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            weight % 1 == 0 ? weight.toInt().toString() : weight.toString(),
            style: TextStyle(
              color: color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
