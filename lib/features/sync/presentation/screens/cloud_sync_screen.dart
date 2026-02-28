import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/supabase_sync_provider.dart';

/// Cloud sync settings screen.
class CloudSyncScreen extends ConsumerStatefulWidget {
  const CloudSyncScreen({super.key});

  @override
  ConsumerState<CloudSyncScreen> createState() => _CloudSyncScreenState();
}

class _CloudSyncScreenState extends ConsumerState<CloudSyncScreen> {
  @override
  Widget build(BuildContext context) {
    final syncState = ref.watch(supabaseSyncProvider);
    final isAuthenticated = SupabaseService.isAuthenticated;
    final isAvailable = SupabaseService.isAvailable;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Cloud Sync'),
        actions: [
          if (isAuthenticated && isAvailable)
            IconButton(
              onPressed: syncState.isSyncing
                  ? null
                  : () => ref.read(supabaseSyncProvider.notifier).sync(),
              icon: syncState.isSyncing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.sync),
              tooltip: 'Sync Now',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status card
          _buildStatusCard(isAvailable, isAuthenticated, syncState),
          const SizedBox(height: 24),

          // Sync info
          if (isAuthenticated && isAvailable) ...[
            _buildSyncInfoSection(syncState),
            const SizedBox(height: 24),

            // Sync settings
            _buildSettingsSection(syncState),
            const SizedBox(height: 24),

            // Backup/Restore
            _buildBackupRestoreSection(syncState),
          ] else if (!isAvailable) ...[
            _buildSetupSection(),
          ] else ...[
            _buildSignInSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    bool isAvailable,
    bool isAuthenticated,
    SyncState syncState,
  ) {
    IconData icon;
    Color color;
    String title;
    String subtitle;

    if (!isAvailable) {
      icon = Icons.cloud_off;
      color = Colors.grey;
      title = 'Cloud Not Configured';
      subtitle = 'Set up Supabase to enable cloud sync';
    } else if (!isAuthenticated) {
      icon = Icons.person_off_outlined;
      color = Colors.orange;
      title = 'Not Signed In';
      subtitle = 'Sign in to sync your data across devices';
    } else if (syncState.isSyncing) {
      icon = Icons.sync;
      color = AppColors.primary;
      title = 'Syncing...';
      subtitle = 'Please wait while your data syncs';
    } else if (syncState.hasError) {
      icon = Icons.error_outline;
      color = AppColors.error;
      title = 'Sync Error';
      subtitle = syncState.error ?? 'An error occurred during sync';
    } else if (syncState.status == SyncStatus.success) {
      icon = Icons.cloud_done;
      color = AppColors.success;
      title = 'Synced';
      subtitle = syncState.lastSyncAt != null
          ? 'Last synced ${_formatDateTime(syncState.lastSyncAt!)}'
          : 'All data is up to date';
    } else {
      icon = Icons.cloud_queue;
      color = AppColors.primary;
      title = 'Ready to Sync';
      subtitle = syncState.lastSyncAt != null
          ? 'Last synced ${_formatDateTime(syncState.lastSyncAt!)}'
          : 'Tap sync to start';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: syncState.isSyncing
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncInfoSection(SyncState syncState) {
    final user = SupabaseService.currentUser;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  (user?.email?.substring(0, 1) ?? 'U').toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Syncing to Supabase Cloud',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showSignOutDialog(),
                icon: Icon(Icons.logout, color: AppColors.textSecondary),
                tooltip: 'Sign Out',
              ),
            ],
          ),
        ),

        // Last sync stats
        if (syncState.itemsPushed > 0 || syncState.itemsPulled > 0) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.cloud_upload,
                  label: 'Pushed',
                  value: '${syncState.itemsPushed}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.cloud_download,
                  label: 'Pulled',
                  value: '${syncState.itemsPulled}',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(SyncState syncState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sync Settings',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text(
                  'Auto Sync',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Automatically sync every 5 minutes',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                value: syncState.isEnabled,
                onChanged: (value) {
                  ref.read(supabaseSyncProvider.notifier).setEnabled(value);
                },
                activeColor: AppColors.primary,
              ),
              Divider(color: AppColors.borderDark, height: 1),
              ListTile(
                title: const Text(
                  'Sync Now',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Manually sync your data',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                trailing: syncState.isSyncing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.sync, color: AppColors.primary),
                onTap: syncState.isSyncing
                    ? null
                    : () => ref.read(supabaseSyncProvider.notifier).sync(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackupRestoreSection(SyncState syncState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Backup & Restore',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.backup, color: AppColors.primary),
                title: const Text(
                  'Force Backup',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Upload all local data to cloud',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                onTap: syncState.isSyncing ? null : () => _showBackupDialog(),
              ),
              Divider(color: AppColors.borderDark, height: 1),
              ListTile(
                leading: Icon(Icons.restore, color: Colors.orange),
                title: const Text(
                  'Restore from Cloud',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Download all cloud data to this device',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                onTap: syncState.isSyncing ? null : () => _showRestoreDialog(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Note: Force backup will overwrite cloud data. Restore will overwrite local data.',
          style: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSetupSection() {
    return Column(
      children: [
        Icon(
          Icons.cloud_off,
          size: 64,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'Supabase Not Configured',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'To enable cloud sync, you need to set up Supabase.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Setup Instructions:',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildSetupStep(
                '1',
                'Create a free Supabase project at supabase.com',
              ),
              _buildSetupStep(
                '2',
                'Run the SQL migration from supabase/migrations/',
              ),
              _buildSetupStep(
                '3',
                'Add your Supabase URL and anon key to environment',
              ),
              _buildSetupStep(
                '4',
                'Rebuild the app with the environment variables',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetupStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInSection() {
    return Column(
      children: [
        Icon(
          Icons.person_outline,
          size: 64,
          color: AppColors.textSecondary.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sign In Required',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to sync your workout data across all your devices.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () {
            // Navigate to sign in
            Navigator.of(context).pop();
            context.go(AppRoutes.login);
          },
          icon: const Icon(Icons.login),
          label: const Text('Sign In'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(dateTime);
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to sign out? Your local data will be preserved.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await SupabaseService.signOut();
              if (mounted) {
                setState(() {});
              }
            },
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Force Backup',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'This will upload all your local data to the cloud, overwriting any existing cloud data. Continue?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(supabaseSyncProvider.notifier)
                  .forceBackup();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Backup completed successfully!'
                          : 'Backup failed. Please try again.',
                    ),
                    backgroundColor: success
                        ? AppColors.success
                        : AppColors.error,
                  ),
                );
              }
            },
            child: Text('Backup', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text(
          'Restore from Cloud',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'This will download all cloud data to this device. Local data may be overwritten. Continue?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(supabaseSyncProvider.notifier)
                  .forceRestore();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Restore completed successfully!'
                          : 'Restore failed. Please try again.',
                    ),
                    backgroundColor: success
                        ? AppColors.success
                        : AppColors.error,
                  ),
                );
              }
            },
            child: const Text(
              'Restore',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
