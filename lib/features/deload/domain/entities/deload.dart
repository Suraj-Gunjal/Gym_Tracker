/// Deload planner entities for managing recovery weeks.

/// Deload strategy types.
enum DeloadStrategy {
  volume(
    'Volume Reduction',
    'Reduce sets by 40-50%, maintain intensity',
    0xFF3B82F6,
  ),
  intensity(
    'Intensity Reduction',
    'Reduce weight by 40-50%, maintain volume',
    0xFF8B5CF6,
  ),
  frequency(
    'Frequency Reduction',
    'Reduce training days, maintain intensity',
    0xFFF59E0B,
  ),
  complete('Complete Rest', 'Take full week off from training', 0xFFEF4444),
  active(
    'Active Recovery',
    'Light cardio, mobility, stretching only',
    0xFF22C55E,
  );

  final String label;
  final String description;
  final int colorValue;

  const DeloadStrategy(this.label, this.description, this.colorValue);
}

/// Deload reason/trigger.
enum DeloadTrigger {
  scheduled('Scheduled', 'Every 4-6 weeks as planned'),
  fatigue('High Fatigue', 'Accumulated fatigue detected'),
  plateau('Plateau', 'Progress stalled for 2+ weeks'),
  overreaching('Overreaching', 'Signs of overtraining detected'),
  lifestyle('Lifestyle', 'Poor sleep, high stress, illness'),
  manual('Manual', 'User requested deload');

  final String label;
  final String description;

  const DeloadTrigger(this.label, this.description);
}

/// Fatigue indicators for deload detection.
class FatigueIndicators {
  final double sleepQuality; // 0-10
  final double motivation; // 0-10
  final double soreness; // 0-10
  final double performance; // relative to recent average
  final int missedWorkouts;
  final int consecutiveTrainingDays;
  final double averageRPE;

  const FatigueIndicators({
    required this.sleepQuality,
    required this.motivation,
    required this.soreness,
    required this.performance,
    required this.missedWorkouts,
    required this.consecutiveTrainingDays,
    required this.averageRPE,
  });

  /// Calculate overall fatigue score (0-100, higher = more fatigue).
  double get fatigueScore {
    // Weighted calculation
    final sleepFatigue = (10 - sleepQuality) * 15;
    final motivationFatigue = (10 - motivation) * 15;
    final sorenessFatigue = soreness * 10;
    final performanceFatigue = (1 - performance) * 20;
    final rpeFatigue = (averageRPE - 5) * 10;
    final trainingFatigue = (consecutiveTrainingDays > 4) ? 15 : 0;

    return (sleepFatigue +
            motivationFatigue +
            sorenessFatigue +
            performanceFatigue +
            rpeFatigue +
            trainingFatigue)
        .clamp(0, 100);
  }

  bool get shouldDeload => fatigueScore >= 70;
  bool get deloadRecommended => fatigueScore >= 50;
}

/// Deload week configuration.
class DeloadWeek {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final DeloadStrategy strategy;
  final DeloadTrigger trigger;
  final double volumeReduction; // 0.0-1.0 (e.g., 0.5 = 50% reduction)
  final double intensityReduction; // 0.0-1.0
  final String? notes;
  final bool isActive;
  final bool isCompleted;

  const DeloadWeek({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.strategy,
    required this.trigger,
    required this.volumeReduction,
    required this.intensityReduction,
    this.notes,
    this.isActive = false,
    this.isCompleted = false,
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;
  int get daysRemaining {
    final remaining = endDate.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining + 1 : 0;
  }

  DeloadWeek copyWith({
    String? id,
    DateTime? startDate,
    DateTime? endDate,
    DeloadStrategy? strategy,
    DeloadTrigger? trigger,
    double? volumeReduction,
    double? intensityReduction,
    String? notes,
    bool? isActive,
    bool? isCompleted,
  }) {
    return DeloadWeek(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      strategy: strategy ?? this.strategy,
      trigger: trigger ?? this.trigger,
      volumeReduction: volumeReduction ?? this.volumeReduction,
      intensityReduction: intensityReduction ?? this.intensityReduction,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Deload schedule settings.
class DeloadSettings {
  final int weeksBetweenDeloads; // 4-8 typically
  final DeloadStrategy preferredStrategy;
  final bool autoDetect; // Automatically suggest deload based on fatigue
  final double fatigueThreshold; // 0-100
  final bool notifyBeforeDeload;
  final int notifyDaysBefore;

  const DeloadSettings({
    this.weeksBetweenDeloads = 4,
    this.preferredStrategy = DeloadStrategy.volume,
    this.autoDetect = true,
    this.fatigueThreshold = 60,
    this.notifyBeforeDeload = true,
    this.notifyDaysBefore = 3,
  });

  DeloadSettings copyWith({
    int? weeksBetweenDeloads,
    DeloadStrategy? preferredStrategy,
    bool? autoDetect,
    double? fatigueThreshold,
    bool? notifyBeforeDeload,
    int? notifyDaysBefore,
  }) {
    return DeloadSettings(
      weeksBetweenDeloads: weeksBetweenDeloads ?? this.weeksBetweenDeloads,
      preferredStrategy: preferredStrategy ?? this.preferredStrategy,
      autoDetect: autoDetect ?? this.autoDetect,
      fatigueThreshold: fatigueThreshold ?? this.fatigueThreshold,
      notifyBeforeDeload: notifyBeforeDeload ?? this.notifyBeforeDeload,
      notifyDaysBefore: notifyDaysBefore ?? this.notifyDaysBefore,
    );
  }
}

/// Exercise modification during deload.
class DeloadModification {
  final String exerciseId;
  final String exerciseName;
  final double originalWeight;
  final double deloadWeight;
  final int originalSets;
  final int deloadSets;
  final int originalReps;
  final int deloadReps;

  const DeloadModification({
    required this.exerciseId,
    required this.exerciseName,
    required this.originalWeight,
    required this.deloadWeight,
    required this.originalSets,
    required this.deloadSets,
    required this.originalReps,
    required this.deloadReps,
  });

  double get weightReduction =>
      originalWeight > 0 ? (1 - deloadWeight / originalWeight) : 0;
  double get volumeReduction {
    final originalVolume = originalWeight * originalSets * originalReps;
    final deloadVolume = deloadWeight * deloadSets * deloadReps;
    return originalVolume > 0 ? (1 - deloadVolume / originalVolume) : 0;
  }
}

/// Sleep tracking for fatigue detection.
class SleepEntry {
  final String id;
  final DateTime date;
  final DateTime? bedTime;
  final DateTime? wakeTime;
  final Duration? totalSleep;
  final double quality; // 1-10
  final bool fromWearable;
  final String? notes;

  const SleepEntry({
    required this.id,
    required this.date,
    this.bedTime,
    this.wakeTime,
    this.totalSleep,
    required this.quality,
    this.fromWearable = false,
    this.notes,
  });

  bool get isGoodSleep => quality >= 7 && (totalSleep?.inHours ?? 0) >= 7;
}
