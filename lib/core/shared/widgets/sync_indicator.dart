import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/presentation/providers/remote_auth_provider.dart';
import '../../../features/sync/presentation/providers/sync_provider.dart';
import '../../theme/app_colors.dart';

/// A widget that shows sync status and allows manual sync.
class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(remoteAuthProvider);
    final syncState = ref.watch(syncProvider);

    // Don't show if not authenticated
    if (!authState.isAuthenticated) {
      return const SizedBox.shrink();
    }

    return IconButton(
      onPressed: syncState.isSyncing
          ? null
          : () => ref.read(syncProvider.notifier).sync(),
      tooltip: _getTooltip(authState, syncState),
      icon: _buildIcon(authState, syncState),
    );
  }

  Widget _buildIcon(RemoteAuthState authState, SyncState syncState) {
    if (syncState.isSyncing) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (!authState.isOnline) {
      return Icon(Icons.cloud_off, color: AppColors.textTertiaryDark);
    }

    if (syncState.hasError) {
      return Icon(Icons.sync_problem, color: AppColors.error);
    }

    return Icon(Icons.cloud_done, color: AppColors.success);
  }

  String _getTooltip(RemoteAuthState authState, SyncState syncState) {
    if (syncState.isSyncing) {
      return 'Syncing...';
    }

    if (!authState.isOnline) {
      return 'Offline - tap to retry';
    }

    if (syncState.hasError) {
      return 'Sync failed - tap to retry';
    }

    if (syncState.lastSyncAt != null) {
      return 'Last synced: ${_formatTime(syncState.lastSyncAt!)}';
    }

    return 'Tap to sync';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

/// A widget that shows user avatar/profile button.
class ProfileButton extends ConsumerWidget {
  final VoidCallback onTap;

  const ProfileButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(remoteAuthProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: authState.user?.avatarUrl != null
            ? ClipOval(
                child: Image.network(
                  authState.user!.avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholder(authState),
                ),
              )
            : _buildPlaceholder(authState),
      ),
    );
  }

  Widget _buildPlaceholder(RemoteAuthState authState) {
    return Center(
      child: authState.isAuthenticated && authState.user != null
          ? Text(
              _getInitials(
                authState.user!.displayName ?? authState.user!.email,
              ),
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            )
          : Icon(Icons.person, size: 18, color: AppColors.primary),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}
