import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/gym.dart';

part 'gym_finder_provider.g.dart';

/// Provider for nearby gyms.
@riverpod
class NearbyGymsNotifier extends _$NearbyGymsNotifier {
  @override
  List<Gym> build() {
    return _generateMockGyms();
  }

  List<Gym> _generateMockGyms() {
    final random = Random(42);
    final names = [
      'Iron Paradise',
      'FitLife 24',
      'CrossFit Forge',
      'Gold\'s Gym',
      'Planet Fitness',
      'Anytime Fitness',
      'Equinox',
      'LA Fitness',
      'Powerhouse Gym',
      'Snap Fitness',
    ];
    final types = [
      GymType.commercial,
      GymType.twentyFourHour,
      GymType.crossfit,
      GymType.bodybuilding,
      GymType.commercial,
      GymType.twentyFourHour,
      GymType.boutique,
      GymType.commercial,
      GymType.powerlifting,
      GymType.twentyFourHour,
    ];

    return List.generate(10, (i) {
      final allAmenities = GymAmenity.values.toList()..shuffle(random);
      return Gym(
        id: 'gym_$i',
        name: names[i],
        type: types[i],
        latitude: 37.7749 + (random.nextDouble() - 0.5) * 0.1,
        longitude: -122.4194 + (random.nextDouble() - 0.5) * 0.1,
        address: '${100 + random.nextInt(900)} Main St',
        phone:
            '(555) ${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}',
        website:
            'https://${names[i].toLowerCase().replaceAll(' ', '').replaceAll("'", '')}.com',
        rating: 3.0 + random.nextDouble() * 2,
        reviewCount: random.nextInt(500) + 10,
        amenities: allAmenities.take(5 + random.nextInt(5)).toList(),
        hours: {
          'monday': '6:00 AM - 10:00 PM',
          'tuesday': '6:00 AM - 10:00 PM',
          'wednesday': '6:00 AM - 10:00 PM',
          'thursday': '6:00 AM - 10:00 PM',
          'friday': '6:00 AM - 9:00 PM',
          'saturday': '8:00 AM - 6:00 PM',
          'sunday': '8:00 AM - 4:00 PM',
        },
        photoUrls: [],
        monthlyPrice: (20.0 + random.nextInt(80)).toDouble(),
        dayPassPrice: (10.0 + random.nextInt(15)).toDouble(),
        is24Hours: types[i] == GymType.twentyFourHour,
        distance: 0.5 + random.nextDouble() * 9.5,
      );
    })..sort((a, b) => a.distance.compareTo(b.distance));
  }

  void refresh() {
    state = _generateMockGyms();
  }
}

/// Provider for gym search filters.
@riverpod
class GymFiltersNotifier extends _$GymFiltersNotifier {
  @override
  GymSearchFilters build() {
    return const GymSearchFilters();
  }

  void updateFilters(GymSearchFilters filters) {
    state = filters;
  }

  void setMaxDistance(double distance) {
    state = state.copyWith(maxDistance: distance);
  }

  void toggleType(GymType type) {
    final current = state.types ?? [];
    if (current.contains(type)) {
      state = state.copyWith(types: current.where((t) => t != type).toList());
    } else {
      state = state.copyWith(types: [...current, type]);
    }
  }

  void toggleAmenity(GymAmenity amenity) {
    final current = state.requiredAmenities ?? [];
    if (current.contains(amenity)) {
      state = state.copyWith(
        requiredAmenities: current.where((a) => a != amenity).toList(),
      );
    } else {
      state = state.copyWith(requiredAmenities: [...current, amenity]);
    }
  }

  void setMinRating(double rating) {
    state = state.copyWith(minRating: rating);
  }

  void toggle24Hours(bool value) {
    state = state.copyWith(only24Hours: value);
  }

  void clearFilters() {
    state = const GymSearchFilters();
  }
}

/// Provider for filtered gyms.
@riverpod
List<Gym> filteredGyms(ref) {
  final allGyms = ref.watch(nearbyGymsNotifierProvider);
  final filters = ref.watch(gymFiltersNotifierProvider);

  return allGyms.where((gym) {
    if (gym.distance > filters.maxDistance) return false;
    if (filters.types != null &&
        filters.types!.isNotEmpty &&
        !filters.types!.contains(gym.type))
      return false;
    if (filters.requiredAmenities != null &&
        filters.requiredAmenities!.isNotEmpty) {
      for (final amenity in filters.requiredAmenities!) {
        if (!gym.amenities.contains(amenity)) return false;
      }
    }
    if (gym.rating < filters.minRating) return false;
    if (filters.only24Hours && !gym.is24Hours) return false;
    if (filters.maxMonthlyPrice != null &&
        gym.monthlyPrice != null &&
        gym.monthlyPrice! > filters.maxMonthlyPrice!)
      return false;
    return true;
  }).toList();
}

/// Provider for saved/favorite gyms.
@riverpod
class SavedGymsNotifier extends _$SavedGymsNotifier {
  @override
  List<SavedGym> build() {
    return [];
  }

  void saveGym(Gym gym, {bool asHomeGym = false}) {
    if (state.any((s) => s.gymId == gym.id)) return;

    state = [
      ...state,
      SavedGym(
        gymId: gym.id,
        gym: gym,
        savedAt: DateTime.now(),
        isHomeGym: asHomeGym,
      ),
    ];
  }

  void removeGym(String gymId) {
    state = state.where((s) => s.gymId != gymId).toList();
  }

  void setHomeGym(String gymId) {
    state = state.map((s) {
      return SavedGym(
        gymId: s.gymId,
        gym: s.gym,
        savedAt: s.savedAt,
        isHomeGym: s.gymId == gymId,
        nickname: s.nickname,
      );
    }).toList();
  }
}

/// Provider for gym check-ins.
@riverpod
class GymCheckInsNotifier extends _$GymCheckInsNotifier {
  @override
  List<GymCheckIn> build() {
    return [];
  }

  void checkIn(String gymId, String gymName) {
    state = [
      GymCheckIn(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        gymId: gymId,
        gymName: gymName,
        checkInTime: DateTime.now(),
      ),
      ...state,
    ];
  }

  void checkOut() {
    if (state.isEmpty) return;
    final current = state.first;
    if (current.checkOutTime != null) return;

    state = [
      GymCheckIn(
        id: current.id,
        gymId: current.gymId,
        gymName: current.gymName,
        checkInTime: current.checkInTime,
        checkOutTime: DateTime.now(),
        workoutId: current.workoutId,
      ),
      ...state.skip(1),
    ];
  }
}

/// Provider for current check-in status.
@riverpod
GymCheckIn? currentCheckIn(ref) {
  final checkIns = ref.watch(gymCheckInsNotifierProvider);
  if (checkIns.isEmpty) return null;
  final latest = checkIns.first;
  return latest.checkOutTime == null ? latest : null;
}

/// Provider to check if gym is saved.
@riverpod
bool isGymSaved(ref, String gymId) {
  final saved = ref.watch(savedGymsNotifierProvider);
  return saved.any((s) => s.gymId == gymId);
}
