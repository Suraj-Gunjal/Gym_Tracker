import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/export_entity.dart';
import '../providers/export_provider.dart';

/// Data management screen with export/import options.
class DataManagementScreen extends ConsumerWidget {
  const DataManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Management')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Export section
          _buildSectionHeader(
            context,
            icon: Icons.upload,
            title: 'Export Data',
            subtitle: 'Create a backup of your workout data',
          ),
          const SizedBox(height: 12),
          _ExportCard(
            format: ExportFormat.json,
            onTap: () => _showExportSheet(context, ref, ExportFormat.json),
          ),
          const SizedBox(height: 8),
          _ExportCard(
            format: ExportFormat.csv,
            onTap: () => _showExportSheet(context, ref, ExportFormat.csv),
          ),
          const SizedBox(height: 8),
          _ExportCard(
            format: ExportFormat.pdf,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF export coming soon!')),
              );
            },
          ),

          const SizedBox(height: 32),

          // Import section
          _buildSectionHeader(
            context,
            icon: Icons.download,
            title: 'Import Data',
            subtitle: 'Restore from a backup file',
          ),
          const SizedBox(height: 12),
          _ImportCard(onTap: () => _showImportSheet(context, ref)),

          const SizedBox(height: 32),

          // Cloud sync section
          _buildSectionHeader(
            context,
            icon: Icons.cloud_sync,
            title: 'Cloud Sync',
            subtitle: 'Sync your data across devices',
          ),
          const SizedBox(height: 12),
          _CloudSyncCard(),

          const SizedBox(height: 32),

          // Danger zone
          _buildSectionHeader(
            context,
            icon: Icons.warning,
            title: 'Danger Zone',
            subtitle: 'Irreversible actions',
            iconColor: AppColors.error,
          ),
          const SizedBox(height: 12),
          _DangerCard(
            title: 'Clear All Data',
            description: 'Delete all workouts, exercises, and settings',
            onTap: () => _showClearDataDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showExportSheet(
    BuildContext context,
    WidgetRef ref,
    ExportFormat format,
  ) {
    ref.read(exportNotifierProvider.notifier).setFormat(format);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ExportOptionsSheet(),
    );
  }

  void _showImportSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ImportSheet(),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This action cannot be undone. All your workouts, exercises, '
          'personal records, and settings will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('All data cleared')));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  final ExportFormat format;
  final VoidCallback onTap;

  const _ExportCard({required this.format, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(format.icon, color: AppColors.primary),
        ),
        title: Text(
          'Export as ${format.label}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          format.description,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _ImportCard extends StatelessWidget {
  final VoidCallback onTap;

  const _ImportCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[700]!,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Icon(
                  Icons.upload_file,
                  size: 32,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Backup File',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Supports JSON backup files',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloudSyncCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.cloud_done, color: AppColors.success),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Supabase Sync',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Free • Real-time sync',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Sign in with Supabase to sync your data across all devices. '
              'Your data is encrypted and secure.',
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.login),
                label: const Text('Sign In to Enable'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DangerCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const _DangerCard({
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.error.withValues(alpha: 0.1),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.delete_forever, color: AppColors.error),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.error),
      ),
    );
  }
}

class _ExportOptionsSheet extends ConsumerWidget {
  const _ExportOptionsSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exportNotifierProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Export as ${state.selectedFormat.label}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const Text(
                  'Select Data to Export',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => ref
                          .read(exportNotifierProvider.notifier)
                          .selectAllCategories(),
                      child: const Text('Select All'),
                    ),
                    TextButton(
                      onPressed: () => ref
                          .read(exportNotifierProvider.notifier)
                          .deselectAllCategories(),
                      child: const Text('Deselect All'),
                    ),
                  ],
                ),
                ...DataCategory.values.map(
                  (category) => CheckboxListTile(
                    value: state.selectedCategories.contains(category),
                    onChanged: (_) => ref
                        .read(exportNotifierProvider.notifier)
                        .toggleCategory(category),
                    title: Text(category.label),
                    secondary: Icon(category.icon, size: 20),
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                  ),
                ),
                const SizedBox(height: 24),
                if (state.error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error,
                          color: AppColors.error,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error!,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (state.lastJob?.status == ExportStatus.completed) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Export Complete!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => ref
                                .read(exportNotifierProvider.notifier)
                                .shareLastExport(),
                            icon: const Icon(Icons.share),
                            label: const Text('Share File'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isExporting
                    ? null
                    : () => ref
                          .read(exportNotifierProvider.notifier)
                          .startExport(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: state.isExporting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text('Export Now'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportSheet extends ConsumerWidget {
  const _ImportSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importNotifierProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Import Backup',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (state.result == null) ...[
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              size: 64,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implement file picker
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('File picker coming soon!'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.folder_open),
                              label: const Text('Select File'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: state.result!.success
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              state.result!.success
                                  ? Icons.check_circle
                                  : Icons.error,
                              color: state.result!.success
                                  ? AppColors.success
                                  : AppColors.error,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.result!.success
                                  ? 'Import Successful!'
                                  : 'Import Failed',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (state.result!.success) ...[
                              const SizedBox(height: 16),
                              Text(
                                '${state.result!.totalImported} items imported',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                            if (state.result!.errors.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              ...state.result!.errors.map(
                                (e) => Text(
                                  e,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
