/// Photo pose types for progress tracking.
enum PhotoPose {
  front('Front', '🧍'),
  back('Back', '🧍‍♂️'),
  sideLeft('Left Side', '👈'),
  sideRight('Right Side', '👉'),
  flexFront('Front Flex', '💪'),
  flexBack('Back Flex', '🔙');

  final String label;
  final String emoji;

  const PhotoPose(this.label, this.emoji);
}

/// A progress photo entry.
class ProgressPhoto {
  final String id;
  final String imagePath;
  final PhotoPose pose;
  final DateTime takenAt;
  final double? weight;
  final double? bodyFat;
  final String? note;
  final bool isPrivate;

  const ProgressPhoto({
    required this.id,
    required this.imagePath,
    required this.pose,
    required this.takenAt,
    this.weight,
    this.bodyFat,
    this.note,
    this.isPrivate = true,
  });

  ProgressPhoto copyWith({
    String? id,
    String? imagePath,
    PhotoPose? pose,
    DateTime? takenAt,
    double? weight,
    double? bodyFat,
    String? note,
    bool? isPrivate,
  }) {
    return ProgressPhoto(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      pose: pose ?? this.pose,
      takenAt: takenAt ?? this.takenAt,
      weight: weight ?? this.weight,
      bodyFat: bodyFat ?? this.bodyFat,
      note: note ?? this.note,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }
}

/// A comparison pair of photos.
class PhotoComparison {
  final ProgressPhoto before;
  final ProgressPhoto after;
  final Duration timeDifference;
  final double? weightChange;
  final double? bodyFatChange;

  const PhotoComparison({
    required this.before,
    required this.after,
    required this.timeDifference,
    this.weightChange,
    this.bodyFatChange,
  });

  String get timeSpanText {
    final days = timeDifference.inDays;
    if (days >= 365) {
      final years = (days / 365).floor();
      return '$years year${years > 1 ? 's' : ''}';
    } else if (days >= 30) {
      final months = (days / 30).floor();
      return '$months month${months > 1 ? 's' : ''}';
    } else if (days >= 7) {
      final weeks = (days / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''}';
    } else {
      return '$days day${days > 1 ? 's' : ''}';
    }
  }
}

/// Photo gallery state.
class PhotoGalleryState {
  final List<ProgressPhoto> photos;
  final bool isLoading;
  final String? error;
  final PhotoPose? filterPose;

  const PhotoGalleryState({
    this.photos = const [],
    this.isLoading = false,
    this.error,
    this.filterPose,
  });

  PhotoGalleryState copyWith({
    List<ProgressPhoto>? photos,
    bool? isLoading,
    String? error,
    PhotoPose? filterPose,
  }) {
    return PhotoGalleryState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filterPose: filterPose,
    );
  }

  /// Get photos grouped by month.
  Map<String, List<ProgressPhoto>> get photosByMonth {
    final grouped = <String, List<ProgressPhoto>>{};
    final sorted = [...photos]..sort((a, b) => b.takenAt.compareTo(a.takenAt));

    for (final photo in sorted) {
      final key =
          '${photo.takenAt.year}-${photo.takenAt.month.toString().padLeft(2, '0')}';
      grouped.putIfAbsent(key, () => []).add(photo);
    }
    return grouped;
  }

  /// Get photos by pose.
  Map<PhotoPose, List<ProgressPhoto>> get photosByPose {
    final grouped = <PhotoPose, List<ProgressPhoto>>{};
    for (final photo in photos) {
      grouped.putIfAbsent(photo.pose, () => []).add(photo);
    }
    return grouped;
  }
}
