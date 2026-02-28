import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../sync/presentation/providers/sync_provider.dart';
import '../providers/remote_auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(remoteAuthProvider);
    final syncState = ref.watch(syncProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: authState.user?.avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              authState.user!.avatarUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.primary,
                          ),
                  ),
                  const SizedBox(height: 16),
                  if (authState.isAuthenticated && authState.user != null) ...[
                    Text(
                      authState.user!.displayName ?? 'Athlete',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      authState.user!.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'Guest User',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sign in to sync your data',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sync status card
          if (authState.isAuthenticated) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          authState.isOnline
                              ? Icons.cloud_done
                              : Icons.cloud_off,
                          color: authState.isOnline
                              ? AppColors.success
                              : AppColors.textTertiaryDark,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sync Status',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Last synced:',
                          style: TextStyle(color: AppColors.textSecondaryDark),
                        ),
                        Text(
                          syncState.lastSyncAt != null
                              ? _formatDate(syncState.lastSyncAt!)
                              : 'Never',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: syncState.isSyncing
                            ? null
                            : () => ref.read(syncProvider.notifier).sync(),
                        icon: syncState.isSyncing
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sync),
                        label: Text(
                          syncState.isSyncing ? 'Syncing...' : 'Sync Now',
                        ),
                      ),
                    ),
                    if (syncState.hasError && syncState.error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        syncState.error!,
                        style: TextStyle(color: AppColors.error, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Actions
          Card(
            child: Column(
              children: [
                if (!authState.isAuthenticated) ...[
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Sign In'),
                    subtitle: const Text('Sync your data across devices'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/login'),
                  ),
                  const Divider(height: 1),
                ],
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings-screen'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Gym Tracker',
                      applicationVersion: '1.0.0',
                      applicationIcon: Icon(
                        Icons.fitness_center,
                        size: 48,
                        color: AppColors.primary,
                      ),
                      children: [
                        const Text(
                          'A personal gym exercise & performance tracker.\n\n'
                          'Open source and self-hostable.',
                        ),
                      ],
                    );
                  },
                ),
                if (authState.isAuthenticated) ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.logout, color: AppColors.error),
                    title: Text(
                      'Sign Out',
                      style: TextStyle(color: AppColors.error),
                    ),
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Sign Out'),
                          content: const Text(
                            'Are you sure you want to sign out? '
                            'Your local data will be preserved.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Sign Out'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await ref.read(remoteAuthProvider.notifier).logout();
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
