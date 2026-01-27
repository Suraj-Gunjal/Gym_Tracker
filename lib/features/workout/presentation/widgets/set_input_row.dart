import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise_set.dart';

/// Widget for displaying and editing a set in a workout.
class SetInputRow extends StatefulWidget {
  final ExerciseSet set;
  final Function(ExerciseSet) onUpdate;
  final VoidCallback onDelete;

  const SetInputRow({
    super.key,
    required this.set,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<SetInputRow> createState() => _SetInputRowState();
}

class _SetInputRowState extends State<SetInputRow> {
  late TextEditingController _weightController;
  late TextEditingController _repsController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(
      text: widget.set.weight.toStringAsFixed(1),
    );
    _repsController = TextEditingController(text: widget.set.reps.toString());
  }

  @override
  void didUpdateWidget(SetInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.set != widget.set && !_isEditing) {
      _weightController.text = widget.set.weight.toStringAsFixed(1);
      _repsController.text = widget.set.reps.toString();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Set number
          SizedBox(
            width: 40,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.set.completed
                    ? AppColors.secondary.withValues(alpha: 0.2)
                    : AppColors.cardDark,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${widget.set.setNumber}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.set.completed
                      ? AppColors.secondary
                      : AppColors.textPrimaryDark,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Previous (placeholder for now)
          const Expanded(
            child: Text(
              '-',
              style: TextStyle(color: AppColors.textTertiaryDark),
            ),
          ),

          // Weight
          Expanded(
            child: TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              onTap: () => setState(() => _isEditing = true),
              onEditingComplete: _saveChanges,
              onTapOutside: (_) => _saveChanges(),
            ),
          ),
          const SizedBox(width: 8),

          // Reps
          Expanded(
            child: TextField(
              controller: _repsController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
              ),
              onTap: () => setState(() => _isEditing = true),
              onEditingComplete: _saveChanges,
              onTapOutside: (_) => _saveChanges(),
            ),
          ),
          const SizedBox(width: 8),

          // Actions
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.remove_circle_outline),
              color: AppColors.error,
              iconSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    setState(() => _isEditing = false);

    final newWeight = double.tryParse(_weightController.text);
    final newReps = int.tryParse(_repsController.text);

    if (newWeight != null && newReps != null) {
      if (newWeight != widget.set.weight || newReps != widget.set.reps) {
        widget.onUpdate(
          widget.set.copyWith(
            weight: newWeight,
            reps: newReps,
            updatedAt: DateTime.now(),
          ),
        );
      }
    }
  }
}
