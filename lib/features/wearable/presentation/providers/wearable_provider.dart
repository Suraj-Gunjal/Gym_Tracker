import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/wearable.dart';

part 'wearable_provider.g.dart';

/// Provider for connected wearable device.
@riverpod
class ConnectedDeviceNotifier extends _$ConnectedDeviceNotifier {
  @override
  WearableDevice? build() {
    return null;
  }

  Future<void> connect(WearableDevice device) async {
    state = device.copyWith(status: WearableConnectionStatus.connecting);

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    state = device.copyWith(
      status: WearableConnectionStatus.connected,
      batteryLevel: 75 + Random().nextInt(25),
      lastSynced: DateTime.now(),
    );
  }

  void disconnect() {
    if (state != null) {
      state = state!.copyWith(status: WearableConnectionStatus.disconnected);
    }
  }

  void updateBatteryLevel(int level) {
    if (state != null) {
      state = state!.copyWith(batteryLevel: level);
    }
  }

  void toggleDataType(SyncDataType dataType) {
    if (state == null) return;

    final enabled = List<SyncDataType>.from(state!.enabledData);
    if (enabled.contains(dataType)) {
      enabled.remove(dataType);
    } else {
      enabled.add(dataType);
    }
    state = state!.copyWith(enabledData: enabled);
  }

  void sync() {
    if (state != null) {
      state = state!.copyWith(lastSynced: DateTime.now());
    }
  }
}

/// Provider for available wearable devices.
@riverpod
class AvailableDevicesNotifier extends _$AvailableDevicesNotifier {
  @override
  List<WearableDevice> build() {
    return [];
  }

  Future<void> scan() async {
    state = [];
    await Future.delayed(const Duration(seconds: 2));

    // Mock discovered devices
    state = [
      const WearableDevice(
        id: 'apple_1',
        name: 'Apple Watch Series 9',
        type: WearableType.appleWatch,
        supportedData: [
          SyncDataType.heartRate,
          SyncDataType.steps,
          SyncDataType.calories,
          SyncDataType.workout,
          SyncDataType.hrv,
          SyncDataType.bloodOxygen,
        ],
        enabledData: [SyncDataType.heartRate, SyncDataType.workout],
      ),
      const WearableDevice(
        id: 'garmin_1',
        name: 'Garmin Fenix 7',
        type: WearableType.garmin,
        supportedData: [
          SyncDataType.heartRate,
          SyncDataType.steps,
          SyncDataType.calories,
          SyncDataType.workout,
          SyncDataType.hrv,
          SyncDataType.recovery,
          SyncDataType.stress,
        ],
        enabledData: [SyncDataType.heartRate],
      ),
      const WearableDevice(
        id: 'whoop_1',
        name: 'WHOOP 4.0',
        type: WearableType.whoop,
        supportedData: [
          SyncDataType.heartRate,
          SyncDataType.hrv,
          SyncDataType.recovery,
          SyncDataType.sleep,
          SyncDataType.stress,
        ],
        enabledData: [SyncDataType.heartRate, SyncDataType.recovery],
      ),
    ];
  }

  void stopScan() {
    // Stop scanning
  }
}

/// Provider for real-time health data.
@riverpod
class LiveHealthDataNotifier extends _$LiveHealthDataNotifier {
  @override
  WearableHealthData build() {
    return WearableHealthData(
      heartRate: 72,
      heartRateZone: 1,
      steps: 3450,
      caloriesBurned: 245,
      hrv: 55,
      bloodOxygen: 98,
      stressLevel: 25,
      timestamp: DateTime.now(),
    );
  }

  void updateHeartRate(int hr) {
    final zone = _calculateZone(hr);
    state = state.copyWith(
      heartRate: hr,
      heartRateZone: zone,
      timestamp: DateTime.now(),
    );
  }

  int _calculateZone(int hr) {
    if (hr < 100) return 1;
    if (hr < 120) return 2;
    if (hr < 140) return 3;
    if (hr < 160) return 4;
    return 5;
  }

  void updateSteps(int steps) {
    state = state.copyWith(steps: steps, timestamp: DateTime.now());
  }

  void updateCalories(int calories) {
    state = state.copyWith(caloriesBurned: calories, timestamp: DateTime.now());
  }

  void simulateWorkout() {
    // Simulate heart rate increase
    final random = Random();
    final baseHr = 120 + random.nextInt(40);
    updateHeartRate(baseHr);
  }
}

/// Provider for wearable settings.
@riverpod
class WearableSettingsNotifier extends _$WearableSettingsNotifier {
  @override
  WearableSettings build() {
    return const WearableSettings();
  }

  void toggleAutoSync(bool value) {
    state = state.copyWith(autoSync: value);
  }

  void toggleRealTimeHeartRate(bool value) {
    state = state.copyWith(realTimeHeartRate: value);
  }

  void toggleShowOnWearable(bool value) {
    state = state.copyWith(showOnWearable: value);
  }

  void toggleHapticFeedback(bool value) {
    state = state.copyWith(hapticFeedback: value);
  }

  void toggleShowRestTimer(bool value) {
    state = state.copyWith(showRestTimer: value);
  }

  void toggleShowCurrentExercise(bool value) {
    state = state.copyWith(showCurrentExercise: value);
  }

  void toggleShowSetCounter(bool value) {
    state = state.copyWith(showSetCounter: value);
  }

  void setSyncInterval(int seconds) {
    state = state.copyWith(syncIntervalSeconds: seconds);
  }
}

/// Provider for workout sync history.
@riverpod
class WorkoutSyncsNotifier extends _$WorkoutSyncsNotifier {
  @override
  List<WearableWorkoutSync> build() {
    return [];
  }

  void startSync(String workoutId, String wearableId) {
    state = [
      WearableWorkoutSync(
        workoutId: workoutId,
        wearableId: wearableId,
        startTime: DateTime.now(),
      ),
      ...state,
    ];
  }

  void updateSync(String workoutId, int heartRate) {
    state = state.map((sync) {
      if (sync.workoutId == workoutId && !sync.syncComplete) {
        final hrs = [...sync.heartRates, heartRate];
        final avg = hrs.fold(0, (sum, hr) => sum + hr) ~/ hrs.length;
        final max = hrs.reduce((a, b) => a > b ? a : b);
        return sync.copyWith(
          heartRates: hrs,
          averageHeartRate: avg,
          maxHeartRate: max,
        );
      }
      return sync;
    }).toList();
  }

  void completeSync(String workoutId, int caloriesBurned) {
    state = state.map((sync) {
      if (sync.workoutId == workoutId && !sync.syncComplete) {
        return sync.copyWith(
          endTime: DateTime.now(),
          duration: DateTime.now().difference(sync.startTime),
          caloriesBurned: caloriesBurned,
          syncComplete: true,
        );
      }
      return sync;
    }).toList();
  }
}

/// Provider for recovery score.
@riverpod
class RecoveryScoreNotifier extends _$RecoveryScoreNotifier {
  @override
  RecoveryScore? build() {
    return RecoveryScore(
      date: DateTime.now(),
      score: 72,
      hrv: 55,
      restingHeartRate: 58,
      sleepScore: 78,
      readiness: 'Good',
      recommendation:
          'You\'re recovered well. Good day for a moderate to hard workout.',
    );
  }

  void update(RecoveryScore score) {
    state = score;
  }

  void refresh() {
    final random = Random();
    state = RecoveryScore(
      date: DateTime.now(),
      score: 50 + random.nextInt(50),
      hrv: 40 + random.nextInt(30),
      restingHeartRate: 50 + random.nextInt(20),
      sleepScore: 60 + random.nextInt(40),
      readiness: random.nextBool() ? 'Good' : 'Moderate',
      recommendation:
          'Based on your recovery, consider adjusting your workout intensity.',
    );
  }
}

/// Provider for sleep data.
@riverpod
class SleepDataNotifier extends _$SleepDataNotifier {
  @override
  List<WearableSleepData> build() {
    return _generateMockSleepData();
  }

  List<WearableSleepData> _generateMockSleepData() {
    final random = Random(42);
    return List.generate(7, (i) {
      final totalMinutes = 360 + random.nextInt(180);
      final deepMinutes = (totalMinutes * 0.2).toInt() + random.nextInt(30);
      final remMinutes = (totalMinutes * 0.25).toInt() + random.nextInt(30);
      final awakeMinutes = 10 + random.nextInt(30);
      final lightMinutes =
          totalMinutes - deepMinutes - remMinutes - awakeMinutes;

      return WearableSleepData(
        date: DateTime.now().subtract(Duration(days: i)),
        totalSleep: Duration(minutes: totalMinutes),
        deepSleep: Duration(minutes: deepMinutes),
        remSleep: Duration(minutes: remMinutes),
        lightSleep: Duration(minutes: lightMinutes),
        awake: Duration(minutes: awakeMinutes),
        sleepScore: 60 + random.nextInt(40),
        averageHrv: 40 + random.nextInt(30),
        restingHeartRate: 50 + random.nextInt(15),
      );
    });
  }

  void addEntry(WearableSleepData data) {
    state = [data, ...state].take(30).toList();
  }
}

/// Provider for checking if wearable is connected.
@riverpod
bool isWearableConnected(ref) {
  final device = ref.watch(connectedDeviceNotifierProvider);
  return device?.isConnected ?? false;
}
