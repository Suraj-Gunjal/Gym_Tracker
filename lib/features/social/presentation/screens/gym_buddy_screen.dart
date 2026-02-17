import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/sharing.dart';
import '../providers/buddy_provider.dart';

/// Screen for finding gym buddies and social features.
class GymBuddyScreen extends ConsumerStatefulWidget {
  const GymBuddyScreen({super.key});

  @override
  ConsumerState<GymBuddyScreen> createState() => _GymBuddyScreenState();
}

class _GymBuddyScreenState extends ConsumerState<GymBuddyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = ref.watch(pendingRequestCountProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Gym Buddies'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          isScrollable: true,
          tabs: [
            const Tab(text: 'Find'),
            Tab(
              child: Row(
                children: [
                  const Text('Requests'),
                  if (pendingCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$pendingCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Buddies'),
            const Tab(text: 'Live'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFindTab(),
          _buildRequestsTab(),
          _buildBuddiesTab(),
          _buildLiveTab(),
        ],
      ),
    );
  }

  Widget _buildFindTab() {
    final buddies = ref.watch(nearbyBuddiesNotifierProvider);
    // ignore: unused_local_variable
    final preferences = ref.watch(buddyPreferencesNotifierProvider);

    return Column(
      children: [
        // Filter bar
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${buddies.length} potential buddies nearby',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _showPreferencesSheet(context),
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Filters'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: buddies.length,
            itemBuilder: (context, index) {
              final buddy = buddies[index];
              return _BuddyCard(
                buddy: buddy,
                onConnect: () => _showConnectSheet(context, buddy),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsTab() {
    final requests = ref.watch(buddyRequestsNotifierProvider);
    final incoming = requests
        .where(
          (r) =>
              r.toUserId == 'user_1' && r.status == BuddyRequestStatus.pending,
        )
        .toList();
    final outgoing = requests.where((r) => r.fromUserId == 'user_1').toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (incoming.isNotEmpty) ...[
          const _SectionHeader(title: '📨 Incoming'),
          ...incoming.map((r) => _RequestCard(request: r, isIncoming: true)),
          const SizedBox(height: 16),
        ],
        if (outgoing.isNotEmpty) ...[
          const _SectionHeader(title: '📤 Sent'),
          ...outgoing.map((r) => _RequestCard(request: r, isIncoming: false)),
        ],
        if (incoming.isEmpty && outgoing.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 64,
                    color: AppColors.textSecondaryDark.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No requests yet',
                    style: TextStyle(color: AppColors.textSecondaryDark),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBuddiesTab() {
    final buddies = ref.watch(connectedBuddiesNotifierProvider);

    if (buddies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecondaryDark.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No gym buddies yet',
              style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Find workout partners in the Find tab',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(0),
              icon: const Icon(Icons.search),
              label: const Text('Find Buddies'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: buddies.length,
      itemBuilder: (context, index) {
        final buddy = buddies[index];
        return _ConnectedBuddyCard(buddy: buddy);
      },
    );
  }

  Widget _buildLiveTab() {
    final sessions = ref.watch(liveSessionsNotifierProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Start live session card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.3),
                AppColors.surfaceDark,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.videocam, color: AppColors.primary, size: 40),
              const SizedBox(height: 12),
              const Text(
                'Start a Live Workout',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Let your buddies follow along',
                style: TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _showStartLiveSheet(context),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Go Live'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        if (sessions.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionHeader(title: '🔴 Live Now'),
          ...sessions.map((s) => _LiveSessionCard(session: s)),
        ],
      ],
    );
  }

  void _showPreferencesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _PreferencesSheet(),
    );
  }

  void _showConnectSheet(BuildContext context, GymBuddy buddy) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ConnectSheet(buddy: buddy),
    );
  }

  void _showStartLiveSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _StartLiveSheet(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _BuddyCard extends StatelessWidget {
  final GymBuddy buddy;
  final VoidCallback onConnect;

  const _BuddyCard({required this.buddy, required this.onConnect});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      child: Text(
                        buddy.name[0],
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    if (buddy.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surfaceDark,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            buddy.name,
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Lv ${buddy.level}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${buddy.homeGym} • ${buddy.distance.toStringAsFixed(1)} km',
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Compatibility score
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getCompatibilityColor(
                      buddy.compatibility,
                    ).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${buddy.compatibility.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: _getCompatibilityColor(buddy.compatibility),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Training styles
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: buddy.trainingStyles.map((style) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    style,
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 11,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (buddy.bio != null) ...[
              const SizedBox(height: 8),
              Text(
                buddy.bio!,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Connect'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCompatibilityColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.textSecondaryDark;
  }
}

class _RequestCard extends ConsumerWidget {
  final BuddyRequest request;
  final bool isIncoming;

  const _RequestCard({required this.request, required this.isIncoming});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = Color(request.status.colorValue);

    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    request.fromUserName[0],
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.fromUserName,
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _timeAgo(request.createdAt),
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    request.status.label,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (request.message != null) ...[
              const SizedBox(height: 8),
              Text(
                '"${request.message}"',
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (isIncoming && request.status == BuddyRequestStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref
                            .read(buddyRequestsNotifierProvider.notifier)
                            .declineRequest(request.id);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ref
                            .read(buddyRequestsNotifierProvider.notifier)
                            .acceptRequest(request.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _ConnectedBuddyCard extends StatelessWidget {
  final GymBuddy buddy;

  const _ConnectedBuddyCard({required this.buddy});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Text(
                buddy.name[0],
                style: const TextStyle(color: AppColors.primary),
              ),
            ),
            if (buddy.isOnline)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surfaceDark, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          buddy.name,
          style: const TextStyle(color: AppColors.textPrimaryDark),
        ),
        subtitle: Text(
          buddy.homeGym,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 12,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          color: AppColors.primary,
          onPressed: () {
            // Open chat
          },
        ),
      ),
    );
  }
}

class _LiveSessionCard extends StatelessWidget {
  final LiveWorkoutSession session;

  const _LiveSessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.error.withValues(alpha: 0.2),
                  child: Text(
                    session.userName[0],
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '●',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.userName,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    session.workoutName,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${session.currentExercise} • Set ${session.currentSet}/${session.totalSets}',
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.visibility,
                      color: AppColors.textSecondaryDark,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${session.viewerCount}',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Join session
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Watch'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PreferencesSheet extends ConsumerWidget {
  const _PreferencesSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(buddyPreferencesNotifierProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          controller: scrollController,
          children: [
            const Text(
              'Buddy Preferences',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Training Styles',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TrainingStyle.values.map((style) {
                final selected = prefs.preferredStyles.contains(style);
                return FilterChip(
                  label: Text('${style.emoji} ${style.label}'),
                  selected: selected,
                  onSelected: (_) {
                    ref
                        .read(buddyPreferencesNotifierProvider.notifier)
                        .toggleStyle(style);
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.3),
                  backgroundColor: AppColors.backgroundDark,
                  labelStyle: TextStyle(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            const Text(
              'Preferred Times',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: WorkoutTime.values.map((time) {
                final selected = prefs.preferredTimes.contains(time);
                return FilterChip(
                  label: Text('${time.emoji} ${time.label}'),
                  selected: selected,
                  onSelected: (_) {
                    ref
                        .read(buddyPreferencesNotifierProvider.notifier)
                        .toggleTime(time);
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.3),
                  backgroundColor: AppColors.backgroundDark,
                  labelStyle: TextStyle(
                    color: selected
                        ? AppColors.primary
                        : AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            const Text(
              'Max Distance',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: prefs.maxDistance.toDouble(),
                    min: 1,
                    max: 50,
                    divisions: 49,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      ref
                          .read(buddyPreferencesNotifierProvider.notifier)
                          .setMaxDistance(value.round());
                    },
                  ),
                ),
                Text(
                  '${prefs.maxDistance} km',
                  style: const TextStyle(color: AppColors.textPrimaryDark),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectSheet extends ConsumerStatefulWidget {
  final GymBuddy buddy;

  const _ConnectSheet({required this.buddy});

  @override
  ConsumerState<_ConnectSheet> createState() => _ConnectSheetState();
}

class _ConnectSheetState extends ConsumerState<_ConnectSheet> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
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
            'Connect with ${widget.buddy.name}',
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Add a message (optional)',
              filled: true,
              fillColor: AppColors.backgroundDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: AppColors.textPrimaryDark),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                ref
                    .read(buddyRequestsNotifierProvider.notifier)
                    .sendRequest(
                      widget.buddy.id,
                      message: _messageController.text.isNotEmpty
                          ? _messageController.text
                          : null,
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Request sent to ${widget.buddy.name}'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Send Request'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StartLiveSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_StartLiveSheet> createState() => _StartLiveSheetState();
}

class _StartLiveSheetState extends ConsumerState<_StartLiveSheet> {
  final _nameController = TextEditingController(text: 'Push Day');
  bool _isPublic = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
          const Text(
            'Start Live Session',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Workout Name',
              filled: true,
              fillColor: AppColors.backgroundDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: AppColors.textPrimaryDark),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Public Session',
              style: TextStyle(color: AppColors.textPrimaryDark),
            ),
            subtitle: const Text(
              'Anyone can watch',
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 12,
              ),
            ),
            value: _isPublic,
            onChanged: (value) => setState(() => _isPublic = value),
            activeColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.heavyImpact();
                ref
                    .read(liveSessionsNotifierProvider.notifier)
                    .startSession(
                      workoutName: _nameController.text,
                      isPublic: _isPublic,
                    );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.videocam),
              label: const Text('Go Live'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
