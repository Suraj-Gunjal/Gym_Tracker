import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/body_measurement_provider.dart';

/// Bottom sheet for adding a new body measurement.
class AddMeasurementSheet extends ConsumerStatefulWidget {
  const AddMeasurementSheet({super.key});

  @override
  ConsumerState<AddMeasurementSheet> createState() =>
      _AddMeasurementSheetState();
}

class _AddMeasurementSheetState extends ConsumerState<AddMeasurementSheet> {
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _chestController = TextEditingController();
  final _leftBicepController = TextEditingController();
  final _rightBicepController = TextEditingController();
  final _waistController = TextEditingController();
  final _hipsController = TextEditingController();
  final _leftThighController = TextEditingController();
  final _rightThighController = TextEditingController();
  final _notesController = TextEditingController();

  int _currentStep = 0;

  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _chestController.dispose();
    _leftBicepController.dispose();
    _rightBicepController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _leftThighController.dispose();
    _rightThighController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiaryDark,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.straighten,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log Measurement',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      Text(
                        'Track your body progress',
                        style: TextStyle(color: AppColors.textSecondaryDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Step indicator
            _StepIndicator(
              currentStep: _currentStep,
              totalSteps: 3,
              labels: const ['Basics', 'Upper Body', 'Lower Body'],
              onStepTap: (step) {
                HapticFeedback.selectionClick();
                setState(() => _currentStep = step);
              },
            ),
            const SizedBox(height: 24),

            // Step content
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildStepContent(),
            ),
            const SizedBox(height: 24),

            // Navigation buttons
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        setState(() => _currentStep--);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  flex: _currentStep > 0 ? 2 : 1,
                  child: ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      if (_currentStep < 2) {
                        setState(() => _currentStep++);
                      } else {
                        _saveMeasurement();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _currentStep < 2 ? 'Next' : 'Save Measurement',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _BasicMeasurements(
          key: const ValueKey('basics'),
          weightController: _weightController,
          bodyFatController: _bodyFatController,
          notesController: _notesController,
        );
      case 1:
        return _UpperBodyMeasurements(
          key: const ValueKey('upper'),
          chestController: _chestController,
          leftBicepController: _leftBicepController,
          rightBicepController: _rightBicepController,
        );
      case 2:
        return _LowerBodyMeasurements(
          key: const ValueKey('lower'),
          waistController: _waistController,
          hipsController: _hipsController,
          leftThighController: _leftThighController,
          rightThighController: _rightThighController,
        );
      default:
        return const SizedBox();
    }
  }

  void _saveMeasurement() {
    ref
        .read(bodyMeasurementsNotifierProvider.notifier)
        .createMeasurement(
          weightKg: double.tryParse(_weightController.text),
          bodyFatPercent: double.tryParse(_bodyFatController.text),
          chestCm: double.tryParse(_chestController.text),
          leftBicepCm: double.tryParse(_leftBicepController.text),
          rightBicepCm: double.tryParse(_rightBicepController.text),
          waistCm: double.tryParse(_waistController.text),
          hipsCm: double.tryParse(_hipsController.text),
          leftThighCm: double.tryParse(_leftThighController.text),
          rightThighCm: double.tryParse(_rightThighController.text),
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
    Navigator.pop(context);
  }
}

/// Step indicator
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;
  final Function(int) onStepTap;

  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
    required this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        final isCurrent = index == currentStep;
        return Expanded(
          child: GestureDetector(
            onTap: () => onStepTap(index),
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index <= currentStep
                              ? AppColors.primary
                              : AppColors.cardDark,
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isCurrent ? 32 : 24,
                      height: isCurrent ? 32 : 24,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.cardDark,
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(
                                color: AppColors.primaryLight,
                                width: 3,
                              )
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isActive
                                ? Colors.white
                                : AppColors.textTertiaryDark,
                            fontSize: isCurrent ? 14 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (index < totalSteps - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: index < currentStep
                              ? AppColors.primary
                              : AppColors.cardDark,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: isActive
                        ? AppColors.primary
                        : AppColors.textTertiaryDark,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

/// Basic measurements form
class _BasicMeasurements extends StatelessWidget {
  final TextEditingController weightController;
  final TextEditingController bodyFatController;
  final TextEditingController notesController;

  const _BasicMeasurements({
    super.key,
    required this.weightController,
    required this.bodyFatController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MeasurementField(
          controller: weightController,
          label: 'Weight',
          unit: 'kg',
          icon: Icons.monitor_weight_outlined,
        ),
        const SizedBox(height: 16),
        _MeasurementField(
          controller: bodyFatController,
          label: 'Body Fat',
          unit: '%',
          icon: Icons.pie_chart_outline,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: notesController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Notes (optional)',
            prefixIcon: const Icon(Icons.note_outlined),
            filled: true,
            fillColor: AppColors.cardDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

/// Upper body measurements form
class _UpperBodyMeasurements extends StatelessWidget {
  final TextEditingController chestController;
  final TextEditingController leftBicepController;
  final TextEditingController rightBicepController;

  const _UpperBodyMeasurements({
    super.key,
    required this.chestController,
    required this.leftBicepController,
    required this.rightBicepController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MeasurementField(
          controller: chestController,
          label: 'Chest',
          unit: 'cm',
          icon: Icons.accessibility_new,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MeasurementField(
                controller: leftBicepController,
                label: 'Left Bicep',
                unit: 'cm',
                icon: Icons.fitness_center,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MeasurementField(
                controller: rightBicepController,
                label: 'Right Bicep',
                unit: 'cm',
                icon: Icons.fitness_center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Lower body measurements form
class _LowerBodyMeasurements extends StatelessWidget {
  final TextEditingController waistController;
  final TextEditingController hipsController;
  final TextEditingController leftThighController;
  final TextEditingController rightThighController;

  const _LowerBodyMeasurements({
    super.key,
    required this.waistController,
    required this.hipsController,
    required this.leftThighController,
    required this.rightThighController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MeasurementField(
                controller: waistController,
                label: 'Waist',
                unit: 'cm',
                icon: Icons.straighten,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MeasurementField(
                controller: hipsController,
                label: 'Hips',
                unit: 'cm',
                icon: Icons.straighten,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _MeasurementField(
                controller: leftThighController,
                label: 'Left Thigh',
                unit: 'cm',
                icon: Icons.straighten,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MeasurementField(
                controller: rightThighController,
                label: 'Right Thigh',
                unit: 'cm',
                icon: Icons.straighten,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Measurement input field
class _MeasurementField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;
  final IconData icon;

  const _MeasurementField({
    required this.controller,
    required this.label,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: unit,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
