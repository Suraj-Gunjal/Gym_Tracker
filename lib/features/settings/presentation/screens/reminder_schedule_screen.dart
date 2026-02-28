import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';

/// Screen for managing workout reminder schedules.
class ReminderScheduleScreen extends ConsumerWidget {
  const ReminderScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final reminders = settings.reminderTimes;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Workout Reminders')),
      body: reminders.isEmpty
          ? _buildEmptyState(context, ref)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reminders.length + 1, // +1 for add button
              itemBuilder: (context, index) {
                if (index == reminders.length) {
                  return _buildAddReminderButton(context, ref);
                }
                return _ReminderTile(reminder: reminders[index], index: index);
              },
            ),
      floatingActionButton: reminders.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showAddReminderSheet(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: AppColors.textTertiaryDark,
            ),
            const SizedBox(height: 24),
            Text(
              'No Reminders Set',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Set up workout reminders to stay on track with your fitness goals.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showAddReminderSheet(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReminderButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: OutlinedButton.icon(
        onPressed: () => _showAddReminderSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Another Reminder'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showAddReminderSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddReminderSheet(
        onAdd: (reminder) {
          ref.read(settingsNotifierProvider.notifier).addReminderTime(reminder);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _ReminderTile extends ConsumerWidget {
  final ReminderTime reminder;
  final int index;

  const _ReminderTile({required this.reminder, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: reminder.enabled
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.alarm,
                color: reminder.enabled
                    ? AppColors.primary
                    : AppColors.textTertiaryDark,
              ),
            ),
            title: Text(
              reminder.formattedTime,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: reminder.enabled ? null : AppColors.textTertiaryDark,
              ),
            ),
            subtitle: Text(
              reminder.formattedDays,
              style: TextStyle(
                color: reminder.enabled
                    ? AppColors.textSecondaryDark
                    : AppColors.textTertiaryDark,
              ),
            ),
            trailing: Switch(
              value: reminder.enabled,
              onChanged: (value) {
                ref
                    .read(settingsNotifierProvider.notifier)
                    .updateReminderTime(
                      index,
                      reminder.copyWith(enabled: value),
                    );
              },
              activeColor: AppColors.primary,
            ),
          ),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => _editReminder(context, ref),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit'),
              ),
              TextButton.icon(
                onPressed: () => _deleteReminder(context, ref),
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editReminder(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddReminderSheet(
        initialReminder: reminder,
        onAdd: (updated) {
          ref
              .read(settingsNotifierProvider.notifier)
              .updateReminderTime(index, updated);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteReminder(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Reminder?'),
        content: Text('Delete ${reminder.formattedTime} reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(settingsNotifierProvider.notifier)
                  .removeReminderTime(index);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AddReminderSheet extends StatefulWidget {
  final ReminderTime? initialReminder;
  final Function(ReminderTime) onAdd;

  const _AddReminderSheet({this.initialReminder, required this.onAdd});

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  late TimeOfDay _selectedTime;
  late Set<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    if (widget.initialReminder != null) {
      _selectedTime = TimeOfDay(
        hour: widget.initialReminder!.hour,
        minute: widget.initialReminder!.minute,
      );
      _selectedDays = widget.initialReminder!.daysOfWeek.toSet();
    } else {
      _selectedTime = const TimeOfDay(hour: 9, minute: 0);
      _selectedDays = {1, 2, 3, 4, 5}; // Weekdays
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.initialReminder != null ? 'Edit Reminder' : 'Add Reminder',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // Time picker
          GestureDetector(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (time != null) {
                setState(() => _selectedTime = time);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 32),
                  const SizedBox(width: 16),
                  Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Day selector
          const Text('Repeat', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDayChip('M', 1),
              _buildDayChip('T', 2),
              _buildDayChip('W', 3),
              _buildDayChip('T', 4),
              _buildDayChip('F', 5),
              _buildDayChip('S', 6),
              _buildDayChip('S', 7),
            ],
          ),
          const SizedBox(height: 12),

          // Quick select buttons
          Wrap(
            spacing: 8,
            children: [
              ActionChip(
                label: const Text('Weekdays'),
                onPressed: () {
                  setState(() => _selectedDays = {1, 2, 3, 4, 5});
                },
              ),
              ActionChip(
                label: const Text('Weekends'),
                onPressed: () {
                  setState(() => _selectedDays = {6, 7});
                },
              ),
              ActionChip(
                label: const Text('Every day'),
                onPressed: () {
                  setState(() => _selectedDays = {1, 2, 3, 4, 5, 6, 7});
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Save button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _selectedDays.isEmpty
                  ? null
                  : () {
                      widget.onAdd(
                        ReminderTime(
                          hour: _selectedTime.hour,
                          minute: _selectedTime.minute,
                          daysOfWeek: _selectedDays.toList()..sort(),
                          enabled: true,
                        ),
                      );
                    },
              child: Text(
                widget.initialReminder != null ? 'Save' : 'Add Reminder',
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildDayChip(String label, int day) {
    final isSelected = _selectedDays.contains(day);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDays.remove(day);
          } else {
            _selectedDays.add(day);
          }
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceLight,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textSecondaryDark,
            ),
          ),
        ),
      ),
    );
  }
}
