import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../services/supabase_service.dart';
import '../../../features/workout/presentation/providers/workout_provider.dart';
import '../../../features/calendar/presentation/providers/calendar_provider.dart';
import '../../../features/pr/presentation/providers/pr_provider.dart';
import '../../../features/sync/presentation/providers/supabase_sync_provider.dart';
import '../../../features/sync/presentation/screens/cloud_sync_screen.dart';
import '../../../features/settings/presentation/screens/settings_screen.dart';

/// More screen with real-time data and essential features.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.backgroundDark,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your fitness hub',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Real Stats Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _RealStatsCard(),
            ),
          ),

          // Cloud Sync Status
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _CloudSyncBanner(),
            ),
          ),

          // Main Features Grid
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate([
                _FeatureCard(
                  icon: Icons.bookmark_border,
                  title: 'Templates',
                  subtitle: 'Save & load routines',
                  gradient: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToTemplates();
                  },
                ),
                _FeatureCard(
                  icon: Icons.emoji_events,
                  title: 'Achievements',
                  subtitle: 'Unlock badges',
                  gradient: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToAchievements();
                  },
                ),
                _FeatureCard(
                  icon: Icons.calendar_month,
                  title: 'Calendar',
                  subtitle: 'Workout history',
                  gradient: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToCalendar();
                  },
                ),
                _FeatureCard(
                  icon: Icons.straighten,
                  title: 'Body Stats',
                  subtitle: 'Track measurements',
                  gradient: [const Color(0xFF10B981), const Color(0xFF059669)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToBody();
                  },
                ),
              ]),
            ),
          ),

          // AI Feature Section (NEW!)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(title: 'AI Powered'),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate([
                _FeatureCard(
                  icon: Icons.camera_alt,
                  title: 'AI Form Coach',
                  subtitle: 'Real-time form analysis',
                  gradient: [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToFormCoach();
                  },
                ),
                _FeatureCard(
                  icon: Icons.auto_awesome,
                  title: 'Smart Suggestions',
                  subtitle: 'AI workout recommendations',
                  gradient: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToSmartSuggestions();
                  },
                ),
                _FeatureCard(
                  icon: Icons.mic,
                  title: 'Quick Log',
                  subtitle: 'Natural language logging',
                  gradient: [const Color(0xFF10B981), const Color(0xFF059669)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToNaturalLog();
                  },
                ),
                _FeatureCard(
                  icon: Icons.insights,
                  title: 'Weekly Insights',
                  subtitle: 'AI training analysis',
                  gradient: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToWeeklyInsights();
                  },
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Tools Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(child: _SectionHeader(title: 'Tools')),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildListDelegate([
                _FeatureCard(
                  icon: Icons.calculate,
                  title: '1RM Calculator',
                  subtitle: 'Estimate max lifts',
                  gradient: [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToOneRmCalculator();
                  },
                ),
                _FeatureCard(
                  icon: Icons.fitness_center,
                  title: 'Plate Calculator',
                  subtitle: 'Load your barbell',
                  gradient: [const Color(0xFF14B8A6), const Color(0xFF0D9488)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToPlateCalculator();
                  },
                ),
                _FeatureCard(
                  icon: Icons.timer,
                  title: 'Rest Timer',
                  subtitle: 'Custom intervals',
                  gradient: [const Color(0xFFEC4899), const Color(0xFFDB2777)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _showRestTimerSettings(context);
                  },
                ),
                _FeatureCard(
                  icon: Icons.accessibility_new,
                  title: 'Muscle Map',
                  subtitle: 'Recovery tracking',
                  gradient: [const Color(0xFFF97316), const Color(0xFFEA580C)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToMuscleHeatmap();
                  },
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Settings Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionHeader(title: 'Settings & Data'),
                _OptionTile(
                  icon: Icons.cloud_sync,
                  title: 'Cloud Sync',
                  subtitle: SupabaseService.isAuthenticated
                      ? 'Connected'
                      : 'Not connected',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CloudSyncScreen()),
                  ),
                ),
                _OptionTile(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'App preferences',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  ),
                ),
                _OptionTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () => _showAboutDialog(context),
                ),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showRestTimerSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _RestTimerSettingsSheet(),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Gym Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.fitness_center, color: Colors.white, size: 32),
      ),
      children: [
        const Text(
          'Your personal fitness companion for tracking workouts, progress, and achievements.',
        ),
      ],
    );
  }
}

class _RealStatsCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutsAsync = ref.watch(allWorkoutsProvider);
    final streakData = ref.watch(currentStreakProvider);
    final prsAsync = ref.watch(allPRsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceDark,
            AppColors.surfaceDark.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickStat(
            value: '${streakData.currentStreak}',
            label: 'Day Streak',
            icon: Icons.local_fire_department,
            color: const Color(0xFFEF4444),
          ),
          workoutsAsync.when(
            data: (workouts) => _QuickStat(
              value: '${workouts.length}',
              label: 'Workouts',
              icon: Icons.fitness_center,
              color: AppColors.primary,
            ),
            loading: () => _QuickStat(
              value: '-',
              label: 'Workouts',
              icon: Icons.fitness_center,
              color: AppColors.primary,
            ),
            error: (_, __) => _QuickStat(
              value: '0',
              label: 'Workouts',
              icon: Icons.fitness_center,
              color: AppColors.primary,
            ),
          ),
          prsAsync.when(
            data: (prs) => _QuickStat(
              value: '${prs.length}',
              label: 'PRs',
              icon: Icons.emoji_events,
              color: const Color(0xFFF59E0B),
            ),
            loading: () => _QuickStat(
              value: '-',
              label: 'PRs',
              icon: Icons.emoji_events,
              color: const Color(0xFFF59E0B),
            ),
            error: (_, __) => _QuickStat(
              value: '0',
              label: 'PRs',
              icon: Icons.emoji_events,
              color: const Color(0xFFF59E0B),
            ),
          ),
        ],
      ),
    );
  }
}

class _CloudSyncBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(supabaseSyncProvider);
    final isAvailable = SupabaseService.isAvailable;
    final isAuthenticated = SupabaseService.isAuthenticated;

    if (!isAvailable) {
      return const SizedBox.shrink();
    }

    Color color;
    IconData icon;
    String message;

    if (!isAuthenticated) {
      color = Colors.orange;
      icon = Icons.cloud_off;
      message = 'Sign in to backup your data';
    } else if (syncState.isSyncing) {
      color = AppColors.primary;
      icon = Icons.sync;
      message = 'Syncing...';
    } else if (syncState.hasError) {
      color = AppColors.error;
      icon = Icons.error_outline;
      message = 'Sync failed - tap to retry';
    } else {
      color = AppColors.success;
      icon = Icons.cloud_done;
      message = syncState.lastSyncAt != null
          ? 'Last synced ${_formatTime(syncState.lastSyncAt!)}'
          : 'Connected to cloud';
    }

    return GestureDetector(
      onTap: () {
        if (!isAuthenticated) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CloudSyncScreen()),
          );
        } else if (syncState.hasError || !syncState.isSyncing) {
          ref.read(supabaseSyncProvider.notifier).sync();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            syncState.isSyncing
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: color, fontWeight: FontWeight.w500),
              ),
            ),
            if (!isAuthenticated)
              Icon(Icons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _QuickStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textTertiaryDark),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradient,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.first.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  widget.icon,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 24),
                    ),
                    const Spacer(),
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textTertiaryDark,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20),
      ),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: AppColors.textTertiaryDark, fontSize: 12),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textTertiaryDark,
      ),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}

class _RestTimerSettingsSheet extends StatefulWidget {
  const _RestTimerSettingsSheet();

  @override
  State<_RestTimerSettingsSheet> createState() =>
      _RestTimerSettingsSheetState();
}

class _RestTimerSettingsSheetState extends State<_RestTimerSettingsSheet> {
  int _selectedDuration = 90;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  final List<int> _presetDurations = [30, 60, 90, 120, 180, 300];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            'Rest Timer Settings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            'Default Rest Duration',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryDark,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetDurations.map((duration) {
              final isSelected = _selectedDuration == duration;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedDuration = duration);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textTertiaryDark.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _formatDuration(duration),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondaryDark,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sound'),
            subtitle: const Text('Play sound when timer ends'),
            value: _soundEnabled,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() => _soundEnabled = value);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Vibration'),
            subtitle: const Text('Vibrate when timer ends'),
            value: _vibrationEnabled,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              setState(() => _vibrationEnabled = value);
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.pop(context);
              },
              child: const Text('Save Settings'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (remainingSeconds == 0) return '${minutes}m';
    return '${minutes}m ${remainingSeconds}s';
  }
}
