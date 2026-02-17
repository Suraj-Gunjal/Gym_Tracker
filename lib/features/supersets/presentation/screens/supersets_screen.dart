import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/superset.dart';
import '../providers/superset_provider.dart';

/// Screen for managing supersets and circuits.
class SupersetsScreen extends ConsumerStatefulWidget {
  const SupersetsScreen({super.key});

  @override
  ConsumerState<SupersetsScreen> createState() => _SupersetsScreenState();
}

class _SupersetsScreenState extends ConsumerState<SupersetsScreen>
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
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            flexibleSpace: FlexibleSpaceBar(background: _buildHeader()),
            title: innerBoxIsScrolled
                ? const Text('Supersets & Circuits')
                : null,
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondaryDark,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Templates'),
                Tab(text: 'Create'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildActiveTab(),
            _buildTemplatesTab(),
            _buildCreateTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Group'),
      ),
    );
  }

  Widget _buildHeader() {
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
            const Color(0xFFF97316).withValues(alpha: 0.2),
            AppColors.backgroundDark,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.repeat, color: Color(0xFFF97316), size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supersets & Circuits',
                      style: TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Group exercises for intensity',
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTab() {
    final groups = ref.watch(exerciseGroupsNotifierProvider);

    if (groups.isEmpty) {
      return _buildEmptyState(
        icon: Icons.fitness_center,
        title: 'No Active Groups',
        subtitle: 'Create a superset or circuit to get started',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return _GroupCard(
          group: group,
          onTap: () => _showGroupDetail(context, group),
          onStart: () => _startGroup(group),
          onDelete: () => ref
              .read(exerciseGroupsNotifierProvider.notifier)
              .deleteGroup(group.id),
        );
      },
    );
  }

  Widget _buildTemplatesTab() {
    final templates = ref.watch(groupTemplatesNotifierProvider);

    if (templates.isEmpty) {
      return _buildEmptyState(
        icon: Icons.bookmark_border,
        title: 'No Templates',
        subtitle: 'Save your favorite groups as templates',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return _TemplateCard(
          template: template,
          onTap: () => _loadTemplate(template),
          onFavorite: () => ref
              .read(groupTemplatesNotifierProvider.notifier)
              .toggleFavorite(template.id),
        );
      },
    );
  }

  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Group Types',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...GroupType.values.map(
            (type) => _GroupTypeCard(
              type: type,
              onTap: () => _createGroupOfType(type),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textSecondaryDark),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textSecondaryDark),
          ),
        ],
      ),
    );
  }

  void _showCreateGroupSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CreateGroupSheet(
        onCreated: (group) {
          ref.read(exerciseGroupsNotifierProvider.notifier).addGroup(group);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showGroupDetail(BuildContext context, ExerciseGroup group) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) =>
            _GroupDetailSheet(group: group, scrollController: scrollController),
      ),
    );
  }

  void _startGroup(ExerciseGroup group) {
    HapticFeedback.mediumImpact();
    ref.read(activeGroupNotifierProvider.notifier).startGroup(group);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Started ${group.name}'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _loadTemplate(GroupTemplate template) {
    HapticFeedback.lightImpact();
    // Convert template to active group
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded ${template.name}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _createGroupOfType(GroupType type) {
    HapticFeedback.lightImpact();
    _showCreateGroupSheet(context);
  }
}

class _GroupCard extends StatelessWidget {
  final ExerciseGroup group;
  final VoidCallback onTap;
  final VoidCallback onStart;
  final VoidCallback onDelete;

  const _GroupCard({
    required this.group,
    required this.onTap,
    required this.onStart,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(group.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        group.typeEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            group.name,
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${group.typeLabel} • ${group.exerciseCount} exercises',
                            style: const TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onStart,
                      icon: const Icon(Icons.play_circle_fill),
                      color: AppColors.primary,
                      iconSize: 36,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: group.exercises
                      .map(
                        (e) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundDark,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            e.exerciseName,
                            style: const TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.repeat,
                      label: '${group.totalRounds} rounds',
                    ),
                    const SizedBox(width: 12),
                    _InfoChip(
                      icon: Icons.timer,
                      label: '${group.restBetweenRounds}s rest',
                    ),
                    const SizedBox(width: 12),
                    _InfoChip(
                      icon: Icons.schedule,
                      label: '~${group.estimatedDuration} min',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final GroupTemplate template;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const _TemplateCard({
    required this.template,
    required this.onTap,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  template.type.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${template.type.label} • ${template.exerciseIds.length} exercises • Used ${template.usageCount}x',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  template.isFavorite ? Icons.star : Icons.star_border,
                  color: template.isFavorite
                      ? const Color(0xFFF59E0B)
                      : AppColors.textSecondaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupTypeCard extends StatelessWidget {
  final GroupType type;
  final VoidCallback onTap;

  const _GroupTypeCard({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(type.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type.label,
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      type.description,
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondaryDark,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondaryDark),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _CreateGroupSheet extends StatefulWidget {
  final Function(ExerciseGroup) onCreated;

  const _CreateGroupSheet({required this.onCreated});

  @override
  State<_CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<_CreateGroupSheet> {
  final _nameController = TextEditingController();
  GroupType _selectedType = GroupType.superset;
  int _rounds = 3;
  int _restTime = 90;

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
          const Text(
            'Create Exercise Group',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: AppColors.textPrimaryDark),
            decoration: InputDecoration(
              labelText: 'Group Name',
              labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
              filled: true,
              fillColor: AppColors.backgroundDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<GroupType>(
            value: _selectedType,
            dropdownColor: AppColors.surfaceDark,
            style: const TextStyle(color: AppColors.textPrimaryDark),
            decoration: InputDecoration(
              labelText: 'Group Type',
              labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
              filled: true,
              fillColor: AppColors.backgroundDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: GroupType.values
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text('${type.emoji} ${type.label}'),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedType = value!),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rounds',
                      style: TextStyle(color: AppColors.textSecondaryDark),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _rounds > 1
                              ? () => setState(() => _rounds--)
                              : null,
                          icon: const Icon(Icons.remove_circle),
                          color: AppColors.primary,
                        ),
                        Text(
                          '$_rounds',
                          style: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _rounds++),
                          icon: const Icon(Icons.add_circle),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rest (seconds)',
                      style: TextStyle(color: AppColors.textSecondaryDark),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _restTime > 0
                              ? () => setState(() => _restTime -= 15)
                              : null,
                          icon: const Icon(Icons.remove_circle),
                          color: AppColors.primary,
                        ),
                        Text(
                          '$_restTime',
                          style: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _restTime += 15),
                          icon: const Icon(Icons.add_circle),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty) return;
                final group = ExerciseGroup(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _nameController.text,
                  type: _selectedType,
                  exercises: [],
                  restBetweenRounds: _restTime,
                  totalRounds: _rounds,
                  createdAt: DateTime.now(),
                );
                widget.onCreated(group);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Create Group',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupDetailSheet extends StatelessWidget {
  final ExerciseGroup group;
  final ScrollController scrollController;

  const _GroupDetailSheet({
    required this.group,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Row(
            children: [
              Text(group.typeEmoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      group.typeLabel,
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: group.exercises.length,
            itemBuilder: (context, index) {
              final exercise = group.exercises[index];
              return Card(
                color: AppColors.backgroundDark,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    exercise.exerciseName,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${exercise.targetSets} sets × ${exercise.targetReps} reps${exercise.targetWeight != null ? ' @ ${exercise.targetWeight}kg' : ''}',
                    style: const TextStyle(color: AppColors.textSecondaryDark),
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
