import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/progress_photo.dart';

part 'photos_provider.g.dart';

/// Provider for progress photos state.
@riverpod
class PhotoGalleryNotifier extends _$PhotoGalleryNotifier {
  final _uuid = const Uuid();

  @override
  PhotoGalleryState build() {
    _loadPhotos();
    return const PhotoGalleryState(isLoading: true);
  }

  Future<void> _loadPhotos() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In production, load from secure storage
    state = PhotoGalleryState(photos: _generateMockPhotos(), isLoading: false);
  }

  void addPhoto({
    required String imagePath,
    required PhotoPose pose,
    double? weight,
    String? note,
    double? bodyFat,
    bool isPrivate = true,
  }) {
    final photo = ProgressPhoto(
      id: _uuid.v4(),
      imagePath: imagePath,
      pose: pose,
      takenAt: DateTime.now(),
      weight: weight,
      bodyFat: bodyFat,
      note: note,
      isPrivate: isPrivate,
    );
    state = state.copyWith(photos: [photo, ...state.photos]);
  }

  void deletePhoto(String id) {
    state = state.copyWith(
      photos: state.photos.where((p) => p.id != id).toList(),
    );
  }

  void updatePhoto(String id, {String? note, bool? isPrivate}) {
    state = state.copyWith(
      photos: state.photos.map((p) {
        if (p.id == id) {
          return p.copyWith(note: note, isPrivate: isPrivate);
        }
        return p;
      }).toList(),
    );
  }

  void filterByPose(PhotoPose? pose) {
    state = state.copyWith(filterPose: pose);
  }

  List<ProgressPhoto> _generateMockPhotos() {
    final uuid = const Uuid();
    final photos = <ProgressPhoto>[];
    final now = DateTime.now();

    // Generate mock photos over 6 months
    for (var month = 0; month < 6; month++) {
      final date = now.subtract(Duration(days: month * 30));

      // Add various poses
      for (final pose in [
        PhotoPose.front,
        PhotoPose.sideLeft,
        PhotoPose.flexFront,
      ]) {
        photos.add(
          ProgressPhoto(
            id: uuid.v4(),
            imagePath: 'assets/images/placeholder_$month.jpg', // Mock path
            pose: pose,
            takenAt: date,
            weight: 85.0 - month * 0.8,
            bodyFat: 18.0 - month * 0.5,
            note: month == 0 ? 'Current progress' : null,
            isPrivate: true,
          ),
        );
      }
    }

    return photos;
  }
}

/// Provider for creating photo comparisons.
@riverpod
class PhotoComparisonNotifier extends _$PhotoComparisonNotifier {
  @override
  PhotoComparison? build() {
    return null;
  }

  void createComparison(ProgressPhoto before, ProgressPhoto after) {
    final timeDiff = after.takenAt.difference(before.takenAt);
    double? weightChange;
    double? bodyFatChange;

    if (before.weight != null && after.weight != null) {
      weightChange = after.weight! - before.weight!;
    }
    if (before.bodyFat != null && after.bodyFat != null) {
      bodyFatChange = after.bodyFat! - before.bodyFat!;
    }

    state = PhotoComparison(
      before: before,
      after: after,
      timeDifference: timeDiff,
      weightChange: weightChange,
      bodyFatChange: bodyFatChange,
    );
  }

  void clearComparison() {
    state = null;
  }
}

/// Provider for filtered photos.
@riverpod
List<ProgressPhoto> filteredPhotos(FilteredPhotosRef ref) {
  final galleryState = ref.watch(photoGalleryNotifierProvider);

  if (galleryState.filterPose == null) {
    return galleryState.photos;
  }

  return galleryState.photos
      .where((p) => p.pose == galleryState.filterPose)
      .toList();
}

/// Provider for timeline view of photos.
@riverpod
Map<String, List<ProgressPhoto>> photoTimeline(PhotoTimelineRef ref) {
  final galleryState = ref.watch(photoGalleryNotifierProvider);
  return galleryState.photosByMonth;
}
