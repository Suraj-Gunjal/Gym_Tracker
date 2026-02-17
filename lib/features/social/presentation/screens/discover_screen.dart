import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/social_entity.dart';
import '../providers/social_provider.dart';
import '../widgets/user_list_tile.dart';

/// Discover users screen.
class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoverUsersAsync = ref.watch(discoverUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                style: const TextStyle(fontSize: 16),
              )
            : const Text('Discover'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Suggested'),
            Tab(text: 'Popular'),
            Tab(text: 'Nearby'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Suggested tab
          discoverUsersAsync.when(
            data: (users) => _buildUserList(users, 'suggested'),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          // Popular tab
          discoverUsersAsync.when(
            data: (users) => _buildUserList(
              users
                ..sort((a, b) => b.followersCount.compareTo(a.followersCount)),
              'popular',
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          // Nearby tab
          _buildNearbyTab(),
        ],
      ),
    );
  }

  Widget _buildUserList(List<SocialProfile> users, String type) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserListTile(
          user: user,
          onFollow: () {
            ref.read(discoverUsersProvider.notifier).toggleFollow(user.userId);
          },
          onTap: () => _openProfile(user),
          showStats: type == 'popular',
        );
      },
    );
  }

  Widget _buildNearbyTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.location_off, size: 48, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          Text(
            'Location access required',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enable location to find gym buddies\nnear you',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // Request location permission
            },
            icon: const Icon(Icons.location_on),
            label: const Text('Enable Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _openProfile(SocialProfile user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${user.displayName}\'s profile...')),
    );
  }
}
