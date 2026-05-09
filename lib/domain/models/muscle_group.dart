enum MuscleGroup {
  chest('Chest'),
  back('Back'),
  shoulders('Shoulders'),
  biceps('Biceps'),
  triceps('Triceps'),
  forearms('Forearms'),
  core('Core'),
  quads('Quads'),
  hamstrings('Hamstrings'),
  glutes('Glutes'),
  calves('Calves'),
  fullBody('Full body'),
  cardio('Cardio');

  const MuscleGroup(this.label);
  final String label;

  static MuscleGroup fromName(String name) {
    return MuscleGroup.values.firstWhere(
      (g) => g.name == name,
      orElse: () => MuscleGroup.fullBody,
    );
  }
}
