import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/gym.dart';
import '../providers/gym_finder_provider.dart';

/// Screen for finding nearby gyms.
class GymFinderScreen extends ConsumerStatefulWidget {
  const GymFinderScreen({super.key});

  @override
  ConsumerState<GymFinderScreen> createState() => _GymFinderScreenState();
}

class _GymFinderScreenState extends ConsumerState<GymFinderScreen> {
  bool _showMap = false;

  @override
  Widget build(BuildContext context) {
    final gyms = ref.watch(filteredGymsProvider);
    final currentCheckIn = ref.watch(currentCheckInProvider);
    final filters = ref.watch(gymFiltersNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Find a Gym'),
        actions: [
          IconButton(
            icon: Icon(_showMap ? Icons.list : Icons.map),
            onPressed: () => setState(() => _showMap = !_showMap),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Current check-in banner
          if (currentCheckIn != null) _buildCheckInBanner(currentCheckIn),

          // Active filters
          if (_hasActiveFilters(filters)) _buildActiveFilters(filters),

          // Content
          Expanded(child: _showMap ? _buildMapView() : _buildListView(gyms)),
        ],
      ),
    );
  }

  bool _hasActiveFilters(GymSearchFilters filters) {
    return filters.types != null && filters.types!.isNotEmpty ||
        filters.requiredAmenities != null &&
            filters.requiredAmenities!.isNotEmpty ||
        filters.minRating > 0 ||
        filters.only24Hours ||
        filters.maxMonthlyPrice != null;
  }

  Widget _buildCheckInBanner(GymCheckIn checkIn) {
    final duration = DateTime.now().difference(checkIn.checkInTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkIn.gymName,
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${hours}h ${minutes}m at gym',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(gymCheckInsNotifierProvider.notifier).checkOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Check Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters(GymSearchFilters filters) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (filters.types != null)
            ...filters.types!.map(
              (t) => _FilterChip(
                label: t.emoji,
                onRemove: () {
                  ref.read(gymFiltersNotifierProvider.notifier).toggleType(t);
                },
              ),
            ),
          if (filters.requiredAmenities != null)
            ...filters.requiredAmenities!.map(
              (a) => _FilterChip(
                label: a.emoji,
                onRemove: () {
                  ref
                      .read(gymFiltersNotifierProvider.notifier)
                      .toggleAmenity(a);
                },
              ),
            ),
          if (filters.only24Hours)
            _FilterChip(
              label: '24h',
              onRemove: () {
                ref
                    .read(gymFiltersNotifierProvider.notifier)
                    .toggle24Hours(false);
              },
            ),
          if (filters.minRating > 0)
            _FilterChip(
              label: '${filters.minRating}+ ⭐',
              onRemove: () {
                ref.read(gymFiltersNotifierProvider.notifier).setMinRating(0);
              },
            ),
          _FilterChip(
            label: 'Clear All',
            isAction: true,
            onRemove: () {
              ref.read(gymFiltersNotifierProvider.notifier).clearFilters();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    // Placeholder for map - would integrate with google_maps_flutter
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 80,
              color: AppColors.textSecondaryDark.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Map View',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Integrate with Google Maps\nto show nearby gyms',
              style: TextStyle(color: AppColors.textSecondaryDark),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<Gym> gyms) {
    if (gyms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondaryDark.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No gyms found',
              style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try adjusting your filters',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: gyms.length,
      itemBuilder: (context, index) {
        final gym = gyms[index];
        return _GymCard(gym: gym, onTap: () => _showGymDetail(context, gym));
      },
    );
  }

  void _showFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _FiltersSheet(),
    );
  }

  void _showGymDetail(BuildContext context, Gym gym) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _GymDetailSheet(gym: gym),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  final bool isAction;

  const _FilterChip({
    required this.label,
    required this.onRemove,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onRemove,
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isAction ? AppColors.error : AppColors.textPrimaryDark,
              fontSize: 12,
            ),
          ),
          backgroundColor: isAction
              ? AppColors.error.withValues(alpha: 0.2)
              : AppColors.surfaceDark,
          deleteIcon: isAction
              ? null
              : const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.textSecondaryDark,
                ),
          onDeleted: isAction ? null : onRemove,
        ),
      ),
    );
  }
}

class _GymCard extends ConsumerWidget {
  final Gym gym;
  final VoidCallback onTap;

  const _GymCard({required this.gym, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(isGymSavedProvider(gym.id));

    return Card(
      color: AppColors.surfaceDark,
      margin: const EdgeInsets.only(bottom: 12),
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      gym.type.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                gym.name,
                                style: const TextStyle(
                                  color: AppColors.textPrimaryDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (gym.is24Hours)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '24h',
                                  style: TextStyle(
                                    color: Color(0xFF6366F1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          gym.type.label,
                          style: const TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved
                          ? AppColors.primary
                          : AppColors.textSecondaryDark,
                    ),
                    onPressed: () {
                      if (isSaved) {
                        ref
                            .read(savedGymsNotifierProvider.notifier)
                            .removeGym(gym.id);
                      } else {
                        ref
                            .read(savedGymsNotifierProvider.notifier)
                            .saveGym(gym);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    gym.ratingDisplay,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${gym.reviewCount})',
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.location_on,
                    color: AppColors.textSecondaryDark,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    gym.distanceDisplay,
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: gym.amenities
                    .take(5)
                    .map(
                      (a) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundDark,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          a.emoji,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
              if (gym.monthlyPrice != null) ...[
                const SizedBox(height: 8),
                Text(
                  '\$${gym.monthlyPrice!.toStringAsFixed(0)}/month',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FiltersSheet extends ConsumerWidget {
  const _FiltersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(gymFiltersNotifierProvider);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(gymFiltersNotifierProvider.notifier)
                        .clearFilters();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Distance slider
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
                    value: filters.maxDistance,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      ref
                          .read(gymFiltersNotifierProvider.notifier)
                          .setMaxDistance(value);
                    },
                  ),
                ),
                Text(
                  '${filters.maxDistance.toStringAsFixed(0)} km',
                  style: const TextStyle(color: AppColors.textPrimaryDark),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Gym types
            const Text(
              'Gym Type',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GymType.values.map((type) {
                final selected = filters.types?.contains(type) ?? false;
                return FilterChip(
                  label: Text('${type.emoji} ${type.label}'),
                  selected: selected,
                  onSelected: (_) {
                    ref
                        .read(gymFiltersNotifierProvider.notifier)
                        .toggleType(type);
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

            const SizedBox(height: 16),

            // Amenities
            const Text(
              'Required Amenities',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: GymAmenity.values.map((amenity) {
                final selected =
                    filters.requiredAmenities?.contains(amenity) ?? false;
                return FilterChip(
                  label: Text('${amenity.emoji} ${amenity.label}'),
                  selected: selected,
                  onSelected: (_) {
                    ref
                        .read(gymFiltersNotifierProvider.notifier)
                        .toggleAmenity(amenity);
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

            const SizedBox(height: 16),

            // Min rating
            const Text(
              'Minimum Rating',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: filters.minRating,
                    min: 0,
                    max: 5,
                    divisions: 5,
                    activeColor: Colors.amber,
                    onChanged: (value) {
                      ref
                          .read(gymFiltersNotifierProvider.notifier)
                          .setMinRating(value);
                    },
                  ),
                ),
                Row(
                  children: [
                    Text(
                      filters.minRating.toStringAsFixed(0),
                      style: const TextStyle(color: AppColors.textPrimaryDark),
                    ),
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 24 hours toggle
            SwitchListTile(
              title: const Text(
                'Only 24 Hour Gyms',
                style: TextStyle(color: AppColors.textPrimaryDark),
              ),
              value: filters.only24Hours,
              onChanged: (value) {
                ref
                    .read(gymFiltersNotifierProvider.notifier)
                    .toggle24Hours(value);
              },
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
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
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GymDetailSheet extends ConsumerWidget {
  final Gym gym;

  const _GymDetailSheet({required this.gym});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(isGymSavedProvider(gym.id));
    final currentCheckIn = ref.watch(currentCheckInProvider);

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
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    gym.type.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gym.name,
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        gym.type.label,
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${gym.ratingDisplay} (${gym.reviewCount} reviews)',
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: currentCheckIn == null
                        ? () {
                            ref
                                .read(gymCheckInsNotifierProvider.notifier)
                                .checkIn(gym.id, gym.name);
                            Navigator.pop(context);
                          }
                        : null,
                    icon: const Icon(Icons.location_on),
                    label: const Text('Check In'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    if (isSaved) {
                      ref
                          .read(savedGymsNotifierProvider.notifier)
                          .removeGym(gym.id);
                    } else {
                      ref.read(savedGymsNotifierProvider.notifier).saveGym(gym);
                    }
                  },
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved
                        ? AppColors.primary
                        : AppColors.textSecondaryDark,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Info
            _DetailRow(icon: Icons.location_on, label: gym.address),
            if (gym.phone != null)
              _DetailRow(icon: Icons.phone, label: gym.phone!),
            _DetailRow(icon: Icons.directions_walk, label: gym.distanceDisplay),
            if (gym.monthlyPrice != null)
              _DetailRow(
                icon: Icons.attach_money,
                label: '\$${gym.monthlyPrice!.toStringAsFixed(0)}/month',
              ),
            if (gym.dayPassPrice != null)
              _DetailRow(
                icon: Icons.calendar_today,
                label: '\$${gym.dayPassPrice!.toStringAsFixed(0)} day pass',
              ),

            const SizedBox(height: 24),

            // Amenities
            const Text(
              'Amenities',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: gym.amenities.map((a) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(a.emoji),
                      const SizedBox(width: 6),
                      Text(
                        a.label,
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Hours
            const Text(
              'Hours',
              style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (gym.is24Hours)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.access_time, color: Color(0xFF6366F1)),
                    SizedBox(width: 8),
                    Text(
                      'Open 24 Hours',
                      style: TextStyle(
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...gym.hours.entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.key.substring(0, 1).toUpperCase() +
                            e.key.substring(1),
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      Text(
                        e.value,
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondaryDark, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textPrimaryDark),
            ),
          ),
        ],
      ),
    );
  }
}
