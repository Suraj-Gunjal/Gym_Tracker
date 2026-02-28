import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../data_management/presentation/screens/data_management_screen.dart';
import '../../../sync/presentation/screens/cloud_sync_screen.dart';
import '../providers/settings_provider.dart';
import 'edit_profile_screen.dart';
import 'reminder_schedule_screen.dart';

/// Settings screen with premium features.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _privacyPolicyUrl = 'https://gymtracker.app/privacy';
  static const _termsUrl = 'https://gymtracker.app/terms';
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.gymtracker.app';
  static const _appStoreUrl =
      'https://apps.apple.com/app/gym-tracker/id123456789';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Premium banner
          if (!settings.isPremium) _buildPremiumBanner(context, ref),

          // Profile section
          _buildSectionHeader('Profile'),
          _buildSettingsTile(
            context: context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Name, photo, goals',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfileScreen()),
            ),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.fitness_center,
            title: 'Body Measurements',
            subtitle: 'Track your body metrics',
            onTap: () => context.push('/body'),
          ),
          const SizedBox(height: 16),

          // Units & Defaults
          _buildSectionHeader('Units & Defaults'),
          _buildSwitchTile(
            icon: Icons.straighten,
            title: 'Use Metric (kg)',
            subtitle: settings.useMetricUnits
                ? 'Using kilograms'
                : 'Using pounds',
            value: settings.useMetricUnits,
            onChanged: (value) => settingsNotifier.setUseMetricUnits(value),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.timer_outlined,
            title: 'Default Rest Time',
            subtitle: _formatRestTime(settings.defaultRestTimeSeconds),
            onTap: () => _showRestTimePicker(
              context,
              ref,
              settings.defaultRestTimeSeconds,
            ),
          ),
          _buildSwitchTile(
            icon: Icons.play_circle_outline,
            title: 'Auto-Start Timer',
            subtitle: 'Start rest timer after logging set',
            value: settings.autoStartTimer,
            onChanged: (value) => settingsNotifier.setAutoStartTimer(value),
          ),
          const SizedBox(height: 16),

          // Workout Settings
          _buildSectionHeader('Workout'),
          _buildSwitchTile(
            icon: Icons.screen_lock_portrait,
            title: 'Keep Screen On',
            subtitle: 'Prevent screen from sleeping during workout',
            value: settings.keepScreenOn,
            onChanged: (value) => settingsNotifier.setKeepScreenOn(value),
          ),
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: 'Sound Effects',
            subtitle: 'Play sounds for timer and PRs',
            value: settings.enableSounds,
            onChanged: (value) => settingsNotifier.setEnableSounds(value),
          ),
          const SizedBox(height: 16),

          // Notifications
          _buildSectionHeader('Notifications'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Workout reminders and updates',
            value: settings.enableNotifications,
            onChanged: (value) =>
                settingsNotifier.setEnableNotifications(value),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.schedule,
            title: 'Reminder Schedule',
            subtitle: settings.reminderTimes.isEmpty
                ? 'No reminders set'
                : '${settings.reminderTimes.length} reminder(s) active',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReminderScheduleScreen()),
            ),
            enabled: settings.enableNotifications,
          ),
          const SizedBox(height: 16),

          // Data & Privacy
          _buildSectionHeader('Data & Privacy'),
          _buildSettingsTile(
            context: context,
            icon: Icons.cloud_upload_outlined,
            title: 'Backup & Sync',
            subtitle: 'Cloud backup settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CloudSyncScreen()),
            ),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.download_outlined,
            title: 'Export Data',
            subtitle: 'Download your workout data',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DataManagementScreen()),
            ),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.delete_outline,
            title: 'Clear Data',
            subtitle: 'Delete all workout data',
            onTap: () => _showClearDataDialog(context),
            isDestructive: true,
          ),
          const SizedBox(height: 16),

          // About
          _buildSectionHeader('About'),
          _buildSettingsTile(
            context: context,
            icon: Icons.info_outline,
            title: 'About Gym Tracker',
            subtitle: 'Version 1.0.0',
            onTap: () => _showAboutDialog(context),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.star_outline,
            title: 'Rate App',
            subtitle: 'Love the app? Leave a review!',
            onTap: () => _launchRateApp(),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.mail_outline,
            title: 'Contact Support',
            subtitle: 'Get help or send feedback',
            onTap: () => _launchEmail(),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.description_outlined,
            title: 'Privacy Policy',
            subtitle: 'View our privacy policy',
            onTap: () => _launchUrl(_privacyPolicyUrl),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.article_outlined,
            title: 'Terms of Service',
            subtitle: 'View terms and conditions',
            onTap: () => _launchUrl(_termsUrl),
          ),
          const SizedBox(height: 32),

          // Version info
          Center(
            child: Text(
              'Gym Tracker v1.0.0\nMade with ❤️ for fitness enthusiasts',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.orange.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPremiumSheet(context, ref),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Upgrade to Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Unlock all features & cloud sync',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool enabled = true,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: enabled ? onTap : null,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.1)
                : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isDestructive
                ? Colors.red
                : enabled
                ? Colors.white
                : Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: enabled ? null : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: enabled ? Colors.grey : Colors.grey[800],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _formatRestTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0 && secs > 0) {
      return '${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes} minute${minutes > 1 ? 's' : ''}';
    } else {
      return '${secs} seconds';
    }
  }

  void _showRestTimePicker(
    BuildContext context,
    WidgetRef ref,
    int currentRestTime,
  ) {
    final restTimes = [30, 45, 60, 90, 120, 150, 180, 240, 300];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Default Rest Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: restTimes.map((time) {
                final isSelected = time == currentRestTime;
                final minutes = time ~/ 60;
                final seconds = time % 60;
                final label = minutes > 0
                    ? seconds > 0
                          ? '${minutes}m ${seconds}s'
                          : '${minutes}m'
                    : '${seconds}s';

                return GestureDetector(
                  onTap: () {
                    ref
                        .read(settingsNotifierProvider.notifier)
                        .setDefaultRestTime(time);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : null,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all your workouts, exercises, and progress data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data cleared'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showPremiumSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _PremiumSheet(
        onPurchase: () {
          ref.read(settingsNotifierProvider.notifier).setIsPremium(true);
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Welcome to Premium! 🎉'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Gym Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.fitness_center, color: Colors.white),
      ),
      children: [
        const Text(
          'Your personal fitness companion for tracking workouts, monitoring progress, and achieving your goals.',
        ),
      ],
    );
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:support@gymtracker.app');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchRateApp() async {
    // Try Play Store first, then App Store
    final playStoreUri = Uri.parse(_playStoreUrl);
    final appStoreUri = Uri.parse(_appStoreUrl);

    if (await canLaunchUrl(playStoreUri)) {
      await launchUrl(playStoreUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(appStoreUri)) {
      await launchUrl(appStoreUri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Premium subscription sheet.
class _PremiumSheet extends StatelessWidget {
  final VoidCallback onPurchase;

  const _PremiumSheet({required this.onPurchase});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade700, Colors.orange.shade800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.workspace_premium,
                  size: 60,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Gym Tracker Premium',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock your full potential',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Features
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _featureRow(Icons.cloud_sync, 'Cloud Backup & Sync'),
                _featureRow(Icons.psychology, 'AI Workout Recommendations'),
                _featureRow(Icons.analytics, 'Advanced Analytics'),
                _featureRow(Icons.fitness_center, 'Unlimited Workout Programs'),
                _featureRow(Icons.photo_library, 'Progress Photo Storage'),
                _featureRow(Icons.block, 'Ad-Free Experience'),
              ],
            ),
          ),

          // Pricing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Monthly
                _pricingOption(
                  'Monthly',
                  '\$4.99',
                  '/month',
                  false,
                  onPurchase,
                ),
                const SizedBox(height: 12),
                // Yearly
                _pricingOption(
                  'Yearly',
                  '\$29.99',
                  '/year',
                  true,
                  onPurchase,
                  savings: 'Save 50%',
                ),
              ],
            ),
          ),

          // Restore
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextButton(
              onPressed: () {},
              child: const Text('Restore Purchases'),
            ),
          ),

          // Terms
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              'Subscription auto-renews. Cancel anytime.',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _pricingOption(
    String title,
    String price,
    String period,
    bool isRecommended,
    VoidCallback onTap, {
    String? savings,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRecommended
              ? Colors.amber.withValues(alpha: 0.15)
              : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRecommended ? Colors.amber : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (isRecommended) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'BEST VALUE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (savings != null)
                    Text(
                      savings,
                      style: const TextStyle(color: Colors.green, fontSize: 12),
                    ),
                ],
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isRecommended ? Colors.amber : null,
              ),
            ),
            Text(
              period,
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
