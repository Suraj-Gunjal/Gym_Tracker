/// Utilities and timer entities for gym equipment.

/// Timer type.
enum TimerType {
  restTimer('Rest Timer', '⏱️', 0xFF3B82F6),
  setTimer('Set Timer', '🎯', 0xFF22C55E),
  equipmentTimer('Equipment Timer', '🏋️', 0xFFF59E0B),
  amrap('AMRAP', '🔥', 0xFFEF4444),
  emom('EMOM', '⚡', 0xFF8B5CF6),
  tabata('Tabata', '💪', 0xFFEC4899);

  final String label;
  final String emoji;
  final int colorValue;

  const TimerType(this.label, this.emoji, this.colorValue);
}

/// Timer preset.
class TimerPreset {
  final String id;
  final String name;
  final TimerType type;
  final int seconds;
  final int? rounds;
  final int? workSeconds;
  final int? restSeconds;

  const TimerPreset({
    required this.id,
    required this.name,
    required this.type,
    required this.seconds,
    this.rounds,
    this.workSeconds,
    this.restSeconds,
  });
}

/// Active timer state.
class TimerState {
  final TimerType type;
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isPaused;
  final int? currentRound;
  final int? totalRounds;
  final bool isWorkPhase; // For intervals

  const TimerState({
    required this.type,
    required this.totalSeconds,
    required this.remainingSeconds,
    this.isRunning = false,
    this.isPaused = false,
    this.currentRound,
    this.totalRounds,
    this.isWorkPhase = true,
  });

  double get progress =>
      totalSeconds > 0 ? (totalSeconds - remainingSeconds) / totalSeconds : 0.0;

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isComplete => remainingSeconds <= 0;

  TimerState copyWith({
    TimerType? type,
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    bool? isPaused,
    int? currentRound,
    int? totalRounds,
    bool? isWorkPhase,
  }) {
    return TimerState(
      type: type ?? this.type,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      isWorkPhase: isWorkPhase ?? this.isWorkPhase,
    );
  }
}

/// Equipment being timed.
class EquipmentUsage {
  final String id;
  final String name;
  final String emoji;
  final DateTime startTime;
  final int? targetMinutes;

  const EquipmentUsage({
    required this.id,
    required this.name,
    required this.emoji,
    required this.startTime,
    this.targetMinutes,
  });

  Duration get elapsed => DateTime.now().difference(startTime);
  int get elapsedMinutes => elapsed.inMinutes;
  bool get isOvertime =>
      targetMinutes != null && elapsedMinutes > targetMinutes!;
}

/// Common gym equipment.
enum GymEquipment {
  sqautRack('Squat Rack', '🏋️'),
  bench('Flat Bench', '🛋️'),
  inclineBench('Incline Bench', '📐'),
  cableMachine('Cable Machine', '🔌'),
  legPress('Leg Press', '🦵'),
  smithMachine('Smith Machine', '⚙️'),
  deadliftPlatform('Deadlift Platform', '🎯'),
  pullupBar('Pull-up Bar', '💪'),
  dipStation('Dip Station', '🔻'),
  treadmill('Treadmill', '🏃'),
  rowingMachine('Rowing Machine', '🚣'),
  stairMaster('StairMaster', '🪜'),
  dumbbellRack('Dumbbell Area', '🔱'),
  preacherCurl('Preacher Curl', '💪'),
  latPulldown('Lat Pulldown', '⬇️'),
  chestPress('Chest Press', '📦');

  final String label;
  final String emoji;

  const GymEquipment(this.label, this.emoji);
}

/// Tabata/HIIT configuration.
class IntervalConfig {
  final int rounds;
  final int workSeconds;
  final int restSeconds;
  final int warmupSeconds;
  final int cooldownSeconds;

  const IntervalConfig({
    required this.rounds,
    required this.workSeconds,
    required this.restSeconds,
    this.warmupSeconds = 0,
    this.cooldownSeconds = 0,
  });

  int get totalSeconds =>
      warmupSeconds + (rounds * (workSeconds + restSeconds)) + cooldownSeconds;

  // Standard Tabata
  static const tabata = IntervalConfig(
    rounds: 8,
    workSeconds: 20,
    restSeconds: 10,
  );

  // Standard EMOM (every minute on the minute)
  static const emom = IntervalConfig(
    rounds: 10,
    workSeconds: 40,
    restSeconds: 20,
  );
}
