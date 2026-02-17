/// Gym finder entities for discovering nearby gyms.

/// Gym type/category.
enum GymType {
  commercial('Commercial', '🏢'),
  boutique('Boutique', '✨'),
  crossfit('CrossFit Box', '🏋️'),
  powerlifting('Powerlifting', '💪'),
  bodybuilding('Bodybuilding', '🔱'),
  twentyFourHour('24 Hour', '🌙'),
  universitiy('University', '🎓'),
  hotel('Hotel', '🏨'),
  outdoor('Outdoor', '🌳'),
  home('Home Gym', '🏠');

  final String label;
  final String emoji;

  const GymType(this.label, this.emoji);
}

/// Gym amenities.
enum GymAmenity {
  freeWeights('Free Weights', '🏋️'),
  machines('Machines', '⚙️'),
  cardio('Cardio', '🏃'),
  sauna('Sauna', '🧖'),
  pool('Pool', '🏊'),
  showers('Showers', '🚿'),
  lockers('Lockers', '🔐'),
  personalTraining('Personal Training', '👨‍🏫'),
  classes('Group Classes', '👥'),
  parking('Parking', '🅿️'),
  towels('Towels', '🧺'),
  wifi('WiFi', '📶'),
  cafe('Cafe/Bar', '☕'),
  childcare('Childcare', '👶'),
  smoothieBar('Smoothie Bar', '🥤');

  final String label;
  final String emoji;

  const GymAmenity(this.label, this.emoji);
}

/// A gym location.
class Gym {
  final String id;
  final String name;
  final GymType type;
  final double latitude;
  final double longitude;
  final String address;
  final String? phone;
  final String? website;
  final double rating; // 0-5
  final int reviewCount;
  final List<GymAmenity> amenities;
  final Map<String, String> hours; // 'monday': '6:00 AM - 10:00 PM'
  final List<String> photoUrls;
  final double? monthlyPrice;
  final double? dayPassPrice;
  final bool is24Hours;
  final double distance; // in km/miles from user

  const Gym({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.phone,
    this.website,
    required this.rating,
    required this.reviewCount,
    required this.amenities,
    required this.hours,
    required this.photoUrls,
    this.monthlyPrice,
    this.dayPassPrice,
    this.is24Hours = false,
    required this.distance,
  });

  String get ratingDisplay => '${rating.toStringAsFixed(1)} ⭐';
  String get distanceDisplay => '${distance.toStringAsFixed(1)} km';
  bool get hasPool => amenities.contains(GymAmenity.pool);
  bool get hasSauna => amenities.contains(GymAmenity.sauna);
}

/// User's gym check-in record.
class GymCheckIn {
  final String id;
  final String gymId;
  final String gymName;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String? workoutId;

  const GymCheckIn({
    required this.id,
    required this.gymId,
    required this.gymName,
    required this.checkInTime,
    this.checkOutTime,
    this.workoutId,
  });

  Duration? get duration =>
      checkOutTime != null ? checkOutTime!.difference(checkInTime) : null;
}

/// Saved/favorite gym.
class SavedGym {
  final String gymId;
  final Gym gym;
  final DateTime savedAt;
  final bool isHomeGym;
  final String? nickname;

  const SavedGym({
    required this.gymId,
    required this.gym,
    required this.savedAt,
    this.isHomeGym = false,
    this.nickname,
  });
}

/// Gym search filters.
class GymSearchFilters {
  final double maxDistance;
  final List<GymType>? types;
  final List<GymAmenity>? requiredAmenities;
  final double minRating;
  final bool onlyOpen;
  final bool only24Hours;
  final double? maxMonthlyPrice;

  const GymSearchFilters({
    this.maxDistance = 10.0,
    this.types,
    this.requiredAmenities,
    this.minRating = 0,
    this.onlyOpen = false,
    this.only24Hours = false,
    this.maxMonthlyPrice,
  });

  GymSearchFilters copyWith({
    double? maxDistance,
    List<GymType>? types,
    List<GymAmenity>? requiredAmenities,
    double? minRating,
    bool? onlyOpen,
    bool? only24Hours,
    double? maxMonthlyPrice,
  }) {
    return GymSearchFilters(
      maxDistance: maxDistance ?? this.maxDistance,
      types: types ?? this.types,
      requiredAmenities: requiredAmenities ?? this.requiredAmenities,
      minRating: minRating ?? this.minRating,
      onlyOpen: onlyOpen ?? this.onlyOpen,
      only24Hours: only24Hours ?? this.only24Hours,
      maxMonthlyPrice: maxMonthlyPrice ?? this.maxMonthlyPrice,
    );
  }
}
