/// Enum for wearable device types.
enum WearableType {
  appleWatch('Apple Watch', 'apple_watch'),
  wearOS('Wear OS', 'wear_os'),
  fitbit('Fitbit', 'fitbit'),
  garmin('Garmin', 'garmin'),
  samsung('Samsung Watch', 'samsung'),
  whoop('WHOOP', 'whoop'),
  oura('Oura Ring', 'oura');

  const WearableType(this.label, this.value);
  final String label;
  final String value;
}

/// Enum for connection status.
enum WearableConnectionStatus {
  connected('Connected', 'connected'),
  disconnected('Disconnected', 'disconnected'),
  connecting('Connecting', 'connecting'),
  pairing('Pairing', 'pairing'),
  error('Error', 'error');

  const WearableConnectionStatus(this.label, this.value);
  final String label;
  final String value;
}

/// Enum for sync data types.
enum SyncDataType {
  heartRate('Heart Rate', 'heart_rate'),
  steps('Steps', 'steps'),
  calories('Calories', 'calories'),
  sleep('Sleep', 'sleep'),
  recovery('Recovery', 'recovery'),
  hrv('HRV', 'hrv'),
  workout('Workout', 'workout'),
  bloodOxygen('Blood Oxygen', 'blood_oxygen'),
  stress('Stress', 'stress');

  const SyncDataType(this.label, this.value);
  final String label;
  final String value;
}

/// Model representing a connected wearable device.
class WearableDevice {
  final String id;
  final String name;
  final WearableType type;
  final WearableConnectionStatus status;
  final int? batteryLevel;
  final DateTime? lastSynced;
  final List<SyncDataType> supportedData;
  final List<SyncDataType> enabledData;
  final String? firmwareVersion;

  const WearableDevice({
    required this.id,
    required this.name,
    required this.type,
    this.status = WearableConnectionStatus.disconnected,
    this.batteryLevel,
    this.lastSynced,
    this.supportedData = const [],
    this.enabledData = const [],
    this.firmwareVersion,
  });

  bool get isConnected => status == WearableConnectionStatus.connected;

  WearableDevice copyWith({
    String? id,
    String? name,
    WearableType? type,
    WearableConnectionStatus? status,
    int? batteryLevel,
    DateTime? lastSynced,
    List<SyncDataType>? supportedData,
    List<SyncDataType>? enabledData,
    String? firmwareVersion,
  }) {
    return WearableDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      lastSynced: lastSynced ?? this.lastSynced,
      supportedData: supportedData ?? this.supportedData,
      enabledData: enabledData ?? this.enabledData,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
    );
  }
}

/// Model for real-time health data from wearable.
class WearableHealthData {
  final int? heartRate;
  final int? heartRateZone; // 1-5
  final int? steps;
  final int? caloriesBurned;
  final int? hrv;
  final int? bloodOxygen;
  final int? stressLevel; // 0-100
  final DateTime timestamp;

  const WearableHealthData({
    this.heartRate,
    this.heartRateZone,
    this.steps,
    this.caloriesBurned,
    this.hrv,
    this.bloodOxygen,
    this.stressLevel,
    required this.timestamp,
  });

  String get heartRateZoneName {
    return switch (heartRateZone) {
      1 => 'Recovery',
      2 => 'Fat Burn',
      3 => 'Cardio',
      4 => 'Peak',
      5 => 'Max',
      _ => 'Unknown',
    };
  }

  WearableHealthData copyWith({
    int? heartRate,
    int? heartRateZone,
    int? steps,
    int? caloriesBurned,
    int? hrv,
    int? bloodOxygen,
    int? stressLevel,
    DateTime? timestamp,
  }) {
    return WearableHealthData(
      heartRate: heartRate ?? this.heartRate,
      heartRateZone: heartRateZone ?? this.heartRateZone,
      steps: steps ?? this.steps,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      hrv: hrv ?? this.hrv,
      bloodOxygen: bloodOxygen ?? this.bloodOxygen,
      stressLevel: stressLevel ?? this.stressLevel,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Model for wearable workout sync.
class WearableWorkoutSync {
  final String workoutId;
  final String wearableId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<int> heartRates;
  final int averageHeartRate;
  final int maxHeartRate;
  final int caloriesBurned;
  final Duration duration;
  final bool syncComplete;

  const WearableWorkoutSync({
    required this.workoutId,
    required this.wearableId,
    required this.startTime,
    this.endTime,
    this.heartRates = const [],
    this.averageHeartRate = 0,
    this.maxHeartRate = 0,
    this.caloriesBurned = 0,
    this.duration = Duration.zero,
    this.syncComplete = false,
  });

  WearableWorkoutSync copyWith({
    String? workoutId,
    String? wearableId,
    DateTime? startTime,
    DateTime? endTime,
    List<int>? heartRates,
    int? averageHeartRate,
    int? maxHeartRate,
    int? caloriesBurned,
    Duration? duration,
    bool? syncComplete,
  }) {
    return WearableWorkoutSync(
      workoutId: workoutId ?? this.workoutId,
      wearableId: wearableId ?? this.wearableId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      heartRates: heartRates ?? this.heartRates,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      duration: duration ?? this.duration,
      syncComplete: syncComplete ?? this.syncComplete,
    );
  }
}

/// Model for wearable settings.
class WearableSettings {
  final bool autoSync;
  final bool realTimeHeartRate;
  final bool showOnWearable;
  final bool hapticFeedback;
  final bool showRestTimer;
  final bool showCurrentExercise;
  final bool showSetCounter;
  final int syncIntervalSeconds;

  const WearableSettings({
    this.autoSync = true,
    this.realTimeHeartRate = true,
    this.showOnWearable = true,
    this.hapticFeedback = true,
    this.showRestTimer = true,
    this.showCurrentExercise = true,
    this.showSetCounter = true,
    this.syncIntervalSeconds = 30,
  });

  WearableSettings copyWith({
    bool? autoSync,
    bool? realTimeHeartRate,
    bool? showOnWearable,
    bool? hapticFeedback,
    bool? showRestTimer,
    bool? showCurrentExercise,
    bool? showSetCounter,
    int? syncIntervalSeconds,
  }) {
    return WearableSettings(
      autoSync: autoSync ?? this.autoSync,
      realTimeHeartRate: realTimeHeartRate ?? this.realTimeHeartRate,
      showOnWearable: showOnWearable ?? this.showOnWearable,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      showRestTimer: showRestTimer ?? this.showRestTimer,
      showCurrentExercise: showCurrentExercise ?? this.showCurrentExercise,
      showSetCounter: showSetCounter ?? this.showSetCounter,
      syncIntervalSeconds: syncIntervalSeconds ?? this.syncIntervalSeconds,
    );
  }
}

/// Model for sleep data from wearable.
class WearableSleepData {
  final DateTime date;
  final Duration totalSleep;
  final Duration deepSleep;
  final Duration remSleep;
  final Duration lightSleep;
  final Duration awake;
  final int sleepScore; // 0-100
  final int averageHrv;
  final int restingHeartRate;

  const WearableSleepData({
    required this.date,
    required this.totalSleep,
    required this.deepSleep,
    required this.remSleep,
    required this.lightSleep,
    required this.awake,
    required this.sleepScore,
    required this.averageHrv,
    required this.restingHeartRate,
  });

  String get sleepQuality {
    if (sleepScore >= 85) return 'Excellent';
    if (sleepScore >= 70) return 'Good';
    if (sleepScore >= 50) return 'Fair';
    return 'Poor';
  }
}

/// Model for recovery score from wearable.
class RecoveryScore {
  final DateTime date;
  final int score; // 0-100
  final int hrv;
  final int restingHeartRate;
  final int sleepScore;
  final String readiness;
  final String recommendation;

  const RecoveryScore({
    required this.date,
    required this.score,
    required this.hrv,
    required this.restingHeartRate,
    required this.sleepScore,
    required this.readiness,
    required this.recommendation,
  });

  bool get canTrainHard => score >= 70;
  bool get needsRest => score < 40;
}
