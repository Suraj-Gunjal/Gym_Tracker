/// Enum representing all supported muscle groups for exercise tagging.
enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  biceps('Biceps'),
  triceps('Triceps'),
  forearms('Forearms'),
  quadriceps('Quadriceps'),
  hamstrings('Hamstrings'),
  glutes('Glutes'),
  calves('Calves'),
  abs('Abs'),
  obliques('Obliques'),
  traps('Traps'),
  lats('Lats'),
  lowerBack('Lower Back'),
  fullBody('Full Body'),
  cardio('Cardio'),
  other('Other');

  final String displayName;
  const MuscleGroup(this.displayName);
}
