import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/progress_photo.dart';
import '../providers/photos_provider.dart';

/// Screen for viewing and managing progress photos.
class ProgressPhotosScreen extends ConsumerStatefulWidget {
  const ProgressPhotosScreen({super.key});

  @override
  ConsumerState<ProgressPhotosScreen> createState() =>
      _ProgressPhotosScreenState();
}

class _ProgressPhotosScreenState extends ConsumerState<ProgressPhotosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PhotoPose? _selectedPose;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final galleryState = ref.watch(photoGalleryNotifierProvider);
    final comparison = ref.watch(photoComparisonNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        title: const Text('Progress Photos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_outline),
            tooltip: 'Photos are stored locally and encrypted',
            onPressed: () => _showPrivacyInfo(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: const [
            Tab(text: 'Gallery'),
            Tab(text: 'Timeline'),
            Tab(text: 'Compare'),
          ],
        ),
      ),
      body: galleryState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildGalleryTab(galleryState),
                _buildTimelineTab(galleryState),
                _buildCompareTab(galleryState, comparison),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPhotoSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Add Photo'),
      ),
    );
  }

  Widget _buildGalleryTab(PhotoGalleryState galleryState) {
    final filteredPhotos = ref.watch(filteredPhotosProvider);

    return Column(
      children: [
        // Pose filter
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _FilterChip(
                label: 'All',
                isSelected: _selectedPose == null,
                onTap: () {
                  setState(() => _selectedPose = null);
                  ref
                      .read(photoGalleryNotifierProvider.notifier)
                      .filterByPose(null);
                },
              ),
              const SizedBox(width: 8),
              ...PhotoPose.values.map(
                (pose) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _FilterChip(
                    label: '${pose.emoji} ${pose.label}',
                    isSelected: _selectedPose == pose,
                    onTap: () {
                      setState(() => _selectedPose = pose);
                      ref
                          .read(photoGalleryNotifierProvider.notifier)
                          .filterByPose(pose);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Photos grid
        Expanded(
          child: filteredPhotos.isEmpty
              ? _buildEmptyState()
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: filteredPhotos.length,
                  itemBuilder: (context, index) {
                    final photo = filteredPhotos[index];
                    return _PhotoThumbnail(
                      photo: photo,
                      onTap: () => _showPhotoDetail(context, photo),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTimelineTab(PhotoGalleryState galleryState) {
    final timeline = ref.watch(photoTimelineProvider);

    if (timeline.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: timeline.length,
      itemBuilder: (context, index) {
        final month = timeline.keys.elementAt(index);
        final photos = timeline[month]!;
        final date = DateTime.parse('$month-01');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(date),
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                itemBuilder: (context, i) {
                  final photo = photos[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _TimelinePhotoCard(
                      photo: photo,
                      onTap: () => _showPhotoDetail(context, photo),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildCompareTab(
    PhotoGalleryState galleryState,
    PhotoComparison? comparison,
  ) {
    if (galleryState.photos.length < 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare,
              size: 64,
              color: AppColors.textSecondaryDark.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Need at least 2 photos to compare',
              style: TextStyle(
                color: AppColors.textSecondaryDark,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comparison selector
          const Text(
            'Select photos to compare',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _PhotoSelector(
                  label: 'Before',
                  photos: galleryState.photos,
                  selectedPhoto: comparison?.before,
                  onSelect: (photo) {
                    if (comparison?.after != null) {
                      ref
                          .read(photoComparisonNotifierProvider.notifier)
                          .createComparison(photo, comparison!.after);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PhotoSelector(
                  label: 'After',
                  photos: galleryState.photos,
                  selectedPhoto: comparison?.after,
                  onSelect: (photo) {
                    if (comparison?.before != null) {
                      ref
                          .read(photoComparisonNotifierProvider.notifier)
                          .createComparison(comparison!.before, photo);
                    }
                  },
                ),
              ),
            ],
          ),

          if (comparison != null) ...[
            const SizedBox(height: 24),
            _ComparisonView(comparison: comparison),
          ],

          const SizedBox(height: 24),

          // Quick comparisons
          const Text(
            'Quick Comparisons',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),

          _QuickCompareButton(
            label: 'First vs Latest',
            onTap: () {
              final sorted = [...galleryState.photos]
                ..sort((a, b) => a.takenAt.compareTo(b.takenAt));
              if (sorted.length >= 2) {
                ref
                    .read(photoComparisonNotifierProvider.notifier)
                    .createComparison(sorted.first, sorted.last);
              }
            },
          ),
          const SizedBox(height: 8),
          _QuickCompareButton(
            label: '3 Months Progress',
            onTap: () => _createMonthComparison(galleryState.photos, 3),
          ),
          const SizedBox(height: 8),
          _QuickCompareButton(
            label: '6 Months Progress',
            onTap: () => _createMonthComparison(galleryState.photos, 6),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: AppColors.textSecondaryDark.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No photos yet',
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take your first progress photo',
            style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _createMonthComparison(List<ProgressPhoto> photos, int months) {
    final now = DateTime.now();
    final target = now.subtract(Duration(days: months * 30));

    final sorted = [...photos]..sort((a, b) => a.takenAt.compareTo(b.takenAt));

    // Find closest to target date
    ProgressPhoto? before;
    double closestDiff = double.infinity;
    for (final photo in sorted) {
      final diff = (photo.takenAt.difference(target).inDays).abs().toDouble();
      if (diff < closestDiff) {
        closestDiff = diff;
        before = photo;
      }
    }

    // Get latest photo
    final after = sorted.lastOrNull;

    if (before != null && after != null && before.id != after.id) {
      ref
          .read(photoComparisonNotifierProvider.notifier)
          .createComparison(before, after);
    }
  }

  void _showAddPhotoSheet(BuildContext context) {
    PhotoPose selectedPose = PhotoPose.front;
    final weightController = TextEditingController();
    final noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondaryDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Add Progress Photo',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),

              // Photo capture area
              InkWell(
                onTap: () {
                  // TODO: Implement camera/gallery picker
                  HapticFeedback.mediumImpact();
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 48,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Tap to take or select photo',
                          style: TextStyle(color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pose selection
              const Text(
                'Pose',
                style: TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PhotoPose.values.map((pose) {
                  final isSelected = selectedPose == pose;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedPose = pose),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : AppColors.cardDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        '${pose.emoji} ${pose.label}',
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimaryDark,
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Weight input
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  labelText: 'Current Weight (optional)',
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondaryDark,
                  ),
                  suffixText: 'kg',
                  suffixStyle: const TextStyle(
                    color: AppColors.textSecondaryDark,
                  ),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Note input
              TextField(
                controller: noteController,
                style: const TextStyle(color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  labelText: 'Note (optional)',
                  labelStyle: const TextStyle(
                    color: AppColors.textSecondaryDark,
                  ),
                  filled: true,
                  fillColor: AppColors.cardDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Save photo to storage
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Photo feature requires camera permissions',
                        ),
                        backgroundColor: AppColors.info,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Photo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPhotoDetail(BuildContext context, ProgressPhoto photo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondaryDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Photo placeholder
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          photo.pose.emoji,
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          photo.pose.label,
                          style: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Photo details
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM d, yyyy').format(photo.takenAt),
                          style: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            if (photo.weight != null)
                              _DetailChip(
                                icon: Icons.monitor_weight_outlined,
                                label: '${photo.weight!.toStringAsFixed(1)} kg',
                              ),
                            if (photo.bodyFat != null) ...[
                              const SizedBox(width: 8),
                              _DetailChip(
                                icon: Icons.percent,
                                label: '${photo.bodyFat!.toStringAsFixed(1)}%',
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    if (photo.note != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        photo.note!,
                        style: const TextStyle(
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ref
                                  .read(photoGalleryNotifierProvider.notifier)
                                  .deletePhoto(photo.id);
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Delete'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Use for comparison
                              Navigator.pop(context);
                              _tabController.animateTo(2);
                            },
                            icon: const Icon(Icons.compare),
                            label: const Text('Compare'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
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

  void _showPrivacyInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Row(
          children: [
            Icon(Icons.security, color: AppColors.success),
            SizedBox(width: 12),
            Text(
              'Privacy Protected',
              style: TextStyle(color: AppColors.textPrimaryDark),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PrivacyItem(
              icon: Icons.phone_android,
              text: 'Photos stored locally on your device',
            ),
            SizedBox(height: 12),
            _PrivacyItem(
              icon: Icons.lock,
              text: 'Encrypted with your device security',
            ),
            SizedBox(height: 12),
            _PrivacyItem(
              icon: Icons.cloud_off,
              text: 'Never uploaded to any server',
            ),
            SizedBox(height: 12),
            _PrivacyItem(
              icon: Icons.visibility_off,
              text: 'Hidden from gallery apps',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textPrimaryDark,
            fontWeight: isSelected ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  final ProgressPhoto photo;
  final VoidCallback onTap;

  const _PhotoThumbnail({required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                photo.pose.emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  DateFormat('MMM d').format(photo.takenAt),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelinePhotoCard extends StatelessWidget {
  final ProgressPhoto photo;
  final VoidCallback onTap;

  const _TimelinePhotoCard({required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  photo.pose.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.pose.label,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  if (photo.weight != null)
                    Text(
                      '${photo.weight!.toStringAsFixed(1)} kg',
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoSelector extends StatelessWidget {
  final String label;
  final List<ProgressPhoto> photos;
  final ProgressPhoto? selectedPhoto;
  final ValueChanged<ProgressPhoto> onSelect;

  const _PhotoSelector({
    required this.label,
    required this.photos,
    required this.selectedPhoto,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPhotoPickerSheet(context),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            child: selectedPhoto != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedPhoto!.pose.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat(
                            'MMM d, yyyy',
                          ).format(selectedPhoto!.takenAt),
                          style: const TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Select photo',
                          style: TextStyle(color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showPhotoPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select $label Photo',
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return GestureDetector(
                  onTap: () {
                    onSelect(photo);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        photo.pose.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ComparisonView extends StatelessWidget {
  final PhotoComparison comparison;

  const _ComparisonView({required this.comparison});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Time span
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${comparison.timeSpanText} transformation',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Side by side
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          comparison.before.pose.emoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat(
                        'MMM d, yyyy',
                      ).format(comparison.before.takenAt),
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                    if (comparison.before.weight != null)
                      Text(
                        '${comparison.before.weight!.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.arrow_forward, color: AppColors.primary),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          comparison.after.pose.emoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat(
                        'MMM d, yyyy',
                      ).format(comparison.after.takenAt),
                      style: const TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                    if (comparison.after.weight != null)
                      Text(
                        '${comparison.after.weight!.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Stats change
          if (comparison.weightChange != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ChangeChip(
                  label: 'Weight',
                  change: comparison.weightChange!,
                  unit: 'kg',
                  isPositiveGood: false,
                ),
                if (comparison.bodyFatChange != null) ...[
                  const SizedBox(width: 12),
                  _ChangeChip(
                    label: 'Body Fat',
                    change: comparison.bodyFatChange!,
                    unit: '%',
                    isPositiveGood: false,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickCompareButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickCompareButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.compare_arrows, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: AppColors.textSecondaryDark),
          ],
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondaryDark),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeChip extends StatelessWidget {
  final String label;
  final double change;
  final String unit;
  final bool isPositiveGood;

  const _ChangeChip({
    required this.label,
    required this.change,
    required this.unit,
    required this.isPositiveGood,
  });

  @override
  Widget build(BuildContext context) {
    final isGood = isPositiveGood ? change > 0 : change < 0;
    final sign = change >= 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isGood
            ? AppColors.success.withValues(alpha: 0.2)
            : AppColors.error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 12,
            ),
          ),
          Text(
            '$sign${change.toStringAsFixed(1)} $unit',
            style: TextStyle(
              color: isGood ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PrivacyItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.success, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.textPrimaryDark),
          ),
        ),
      ],
    );
  }
}
