/// Enum representing the types of Personal Records tracked.
enum PRType {
  /// Heaviest weight lifted for any rep count
  maxWeight('Max Weight', '🏋️'),

  /// Most reps performed at the same weight
  maxReps('Max Reps', '💪'),

  /// Highest total volume in a single workout for an exercise
  maxVolume('Max Volume', '📊');

  final String displayName;
  final String emoji;
  const PRType(this.displayName, this.emoji);
}
