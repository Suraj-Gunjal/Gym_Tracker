import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../workout/presentation/providers/workout_provider.dart';
import '../../domain/entities/workout_template.dart';
import '../providers/template_provider.dart';
import '../widgets/template_card.dart';
import '../widgets/create_template_sheet.dart';

/// Screen displaying workout templates.
class TemplatesScreen extends ConsumerWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(filteredTemplatesProvider);
    final currentFilter = ref.watch(templateFilterNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Workout Templates',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showCreateTemplate(context),
              ),
            ],
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: TemplateFilter.values.map((filter) {
                  final isSelected = currentFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_getFilterLabel(filter)),
                      selected: isSelected,
                      onSelected: (_) {
                        HapticFeedback.selectionClick();
                        ref
                            .read(templateFilterNotifierProvider.notifier)
                            .setFilter(filter);
                      },
                      backgroundColor: AppColors.cardDark,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondaryDark,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Templates grid
          if (templates.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(
                onCreateTemplate: () => _showCreateTemplate(context),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final template = templates[index];
                    return TemplateCard(
                      template: template,
                      onTap: () => _onTemplateTap(context, ref, template),
                      onLongPress: () =>
                          _showTemplateOptions(context, ref, template),
                    );
                  },
                  childCount: templates.length,
                ),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTemplate(context),
        icon: const Icon(Icons.add),
        label: const Text('New Template'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  String _getFilterLabel(TemplateFilter filter) {
    switch (filter) {
      case TemplateFilter.all:
        return 'All';
      case TemplateFilter.recent:
        return 'Recent';
      case TemplateFilter.custom:
        return 'My Templates';
      case TemplateFilter.predefined:
        return 'Predefined';
    }
  }

  void _showCreateTemplate(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const CreateTemplateSheet(),
    );
  }

  void _onTemplateTap(
      BuildContext context, WidgetRef ref, WorkoutTemplate template) {
    HapticFeedback.mediumImpact();
    ref.read(templatesNotifierProvider.notifier).incrementUsage(template.id);
    
    // Show template detail or start workout
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _TemplateDetailSheet(template: template),
    );
  }

  void _showTemplateOptions(
      BuildContext context, WidgetRef ref, WorkoutTemplate template) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _TemplateOptionsSheet(template: template),
    );
  }
}

/// Empty state widget
class _EmptyState extends StatelessWidget {
  final VoidCallback onCreateTemplate;

  const _EmptyState({required this.onCreateTemplate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.folder_open_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No templates yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a template to save your favorite workout routines',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onCreateTemplate,
              icon: const Icon(Icons.add),
              label: const Text('Create Template'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Template detail bottom sheet
class _TemplateDetailSheet extends ConsumerWidget {
  final WorkoutTemplate template;

  const _TemplateDetailSheet({required this.template});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
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

          // Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: template.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  template.icon,
                  color: template.color,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryDark,
                          ),
                    ),
                    if (template.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        template.description!,
                        style: TextStyle(color: AppColors.textSecondaryDark),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats
          Row(
            children: [
              _StatItem(
                icon: Icons.timer_outlined,
                value: '${template.estimatedMinutes ?? 60}',
                label: 'minutes',
              ),
              const SizedBox(width: 16),
              _StatItem(
                icon: Icons.fitness_center,
                value: '${template.exercises.length}',
                label: 'exercises',
              ),
              const SizedBox(width: 16),
              _StatItem(
                icon: Icons.repeat,
                value: '${template.usageCount}',
                label: 'times used',
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Start workout button
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              // Get exercise IDs from template
              final exerciseIds = template.exercises
                  .where((e) => e.exercise != null)
                  .map((e) => e.exercise!.id)
                  .toList();
              
              // Start workout from template
              await ref.read(activeWorkoutProvider.notifier).startWorkoutFromTemplate(
                templateName: template.name,
                exerciseIds: exerciseIds,
              );
              
              // Navigate to active workout
              if (context.mounted) {
                context.goToActiveWorkout();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: template.color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow),
                SizedBox(width: 8),
                Text(
                  'Start Workout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Stat item widget
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textSecondaryDark, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryDark,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textTertiaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Template options bottom sheet
class _TemplateOptionsSheet extends ConsumerWidget {
  final WorkoutTemplate template;

  const _TemplateOptionsSheet({required this.template});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textTertiaryDark,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          _OptionTile(
            icon: Icons.edit_outlined,
            label: 'Edit Template',
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: AppColors.surfaceDark,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => CreateTemplateSheet(templateToEdit: template),
              );
            },
          ),
          _OptionTile(
            icon: Icons.copy_outlined,
            label: 'Duplicate Template',
            onTap: () {
              Navigator.pop(context);
              // Create a copy of the template with new ID and "(Copy)" suffix
              final duplicate = template.copyWith(
                name: '${template.name} (Copy)',
                isPredefined: false,
                usageCount: 0,
                lastUsedAt: null,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              ref.read(templatesNotifierProvider.notifier).addTemplate(
                WorkoutTemplate(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: duplicate.name,
                  description: duplicate.description,
                  color: duplicate.color,
                  icon: duplicate.icon,
                  estimatedMinutes: duplicate.estimatedMinutes,
                  exercises: duplicate.exercises,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Template duplicated')),
              );
            },
          ),
          if (!template.isPredefined)
            _OptionTile(
              icon: Icons.delete_outline,
              label: 'Delete Template',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                ref
                    .read(templatesNotifierProvider.notifier)
                    .deleteTemplate(template.id);
              },
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Option tile widget
class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.textPrimaryDark;
    return ListTile(
      leading: Icon(icon, color: tileColor),
      title: Text(
        label,
        style: TextStyle(color: tileColor),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
