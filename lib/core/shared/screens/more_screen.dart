import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../router/app_router.dart';
import '../../theme/app_colors.dart';

/// More screen with additional features and settings.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Header
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
                    AppColors.primary.withOpacity(0.15),
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
                    'Unlock your full potential',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Stats Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: _QuickStatsCard(),
            ),
          ),

          // Feature Grid
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
                    AppColors.primary.withOpacity(0.7),
                  ],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToTemplates();
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
                  icon: Icons.flag,
                  title: 'Challenges',
                  subtitle: 'Compete & earn XP',
                  gradient: [const Color(0xFF06B6D4), const Color(0xFF0891B2)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToChallenges();
                  },
                ),
                _FeatureCard(
                  icon: Icons.people,
                  title: 'Social',
                  subtitle: 'Connect & share',
                  gradient: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToSocial();
                  },
                ),
                _FeatureCard(
                  icon: Icons.cloud_sync,
                  title: 'Data',
                  subtitle: 'Export & backup',
                  gradient: [const Color(0xFF64748B), const Color(0xFF475569)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToDataManagement();
                  },
                ),
              ]),
            ),
          ),

          // Premium Features Section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _SectionHeader(title: 'Premium Tools'),
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
                  icon: Icons.accessibility_new,
                  title: 'Muscle Heatmap',
                  subtitle: 'Recovery tracking',
                  gradient: [const Color(0xFFF97316), const Color(0xFFEA580C)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToMuscleHeatmap();
                  },
                ),
                _FeatureCard(
                  icon: Icons.list_alt,
                  title: 'Programs',
                  subtitle: 'PPL, 5x5, PHUL...',
                  gradient: [const Color(0xFFA855F7), const Color(0xFF9333EA)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToWorkoutPrograms();
                  },
                ),
                _FeatureCard(
                  icon: Icons.psychology,
                  title: 'AI Coach',
                  subtitle: 'Smart suggestions',
                  gradient: [const Color(0xFF22D3EE), const Color(0xFF06B6D4)],
                  isPremium: true,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToAiCoach();
                  },
                ),
                _FeatureCard(
                  icon: Icons.straighten_rounded,
                  title: 'Measurements',
                  subtitle: 'Track body stats',
                  gradient: [const Color(0xFF84CC16), const Color(0xFF65A30D)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToMeasurements();
                  },
                ),
                _FeatureCard(
                  icon: Icons.photo_library,
                  title: 'Progress Photos',
                  subtitle: 'Visual journey',
                  gradient: [const Color(0xFFE879F9), const Color(0xFFD946EF)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToProgressPhotos();
                  },
                ),
                _FeatureCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'App preferences',
                  gradient: [const Color(0xFF78716C), const Color(0xFF57534E)],
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.goToSettings();
                  },
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Additional Options
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SectionHeader(title: 'Settings'),
                _OptionTile(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () => context.goToProfile(),
                ),
                _OptionTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () {},
                ),
                _OptionTile(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  onTap: () {},
                ),
                _OptionTile(
                  icon: Icons.backup_outlined,
                  title: 'Backup & Sync',
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _SectionHeader(title: 'About'),
                _OptionTile(
                  icon: Icons.info_outline,
                  title: 'About Gym Tracker',
                  onTap: () {},
                ),
                _OptionTile(
                  icon: Icons.star_outline,
                  title: 'Rate App',
                  onTap: () {},
                ),
                _OptionTile(
                  icon: Icons.feedback_outlined,
                  title: 'Send Feedback',
                  onTap: () {},
                ),
                const SizedBox(height: 100), // Bottom padding for FAB
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
}

class _QuickStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceDark,
            AppColors.surfaceDark.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _QuickStat(
            value: '12',
            label: 'Week Streak',
            icon: Icons.local_fire_department,
            color: const Color(0xFFEF4444),
          ),
          _QuickStat(
            value: '24',
            label: 'Badges',
            icon: Icons.military_tech,
            color: const Color(0xFFF59E0B),
          ),
          _QuickStat(
            value: 'Lvl 15',
            label: 'Rank',
            icon: Icons.trending_up,
            color: AppColors.primary,
          ),
        ],
      ),
    );
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
            color: color.withOpacity(0.15),
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
  final bool isPremium;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
    this.isPremium = false,
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
                color: widget.gradient.first.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative pattern
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  widget.icon,
                  size: 100,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              // Premium badge
              if (widget.isPremium)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 10, color: Colors.black),
                        SizedBox(width: 2),
                        Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
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
                        color: Colors.white.withOpacity(0.8),
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
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
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
                          : AppColors.textTertiaryDark.withOpacity(0.3),
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
