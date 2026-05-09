import 'muscle_group.dart';

enum ExerciseKind { strength, cardio }

/// What you grip / sit on. Kept loose on purpose — the user only needs to
/// know "is this free weight or a machine" so the plate calculator and
/// progression suggestions can adapt. `bodyweight` is its own bucket because
/// it short-circuits weight prompts; `cable` and `other` are catch-alls.
enum Equipment {
  barbell,
  dumbbell,
  machine,
  cable,
  bodyweight,
  other;

  static Equipment fromName(String? name) {
    if (name == null) return Equipment.other;
    for (final e in Equipment.values) {
      if (e.name == name) return e;
    }
    return Equipment.other;
  }
}

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    this.secondaryMuscles = const [],
    this.kind = ExerciseKind.strength,
    this.equipment = Equipment.other,
    this.isCustom = false,
  });

  final String id;
  final String name;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;
  final ExerciseKind kind;
  final Equipment equipment;
  final bool isCustom;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'primaryMuscle': primaryMuscle.name,
        'secondaryMuscles': secondaryMuscles.map((m) => m.name).toList(),
        'kind': kind.name,
        'equipment': equipment.name,
        'isCustom': isCustom,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] as String,
        name: json['name'] as String,
        primaryMuscle: MuscleGroup.fromName(json['primaryMuscle'] as String),
        secondaryMuscles: (json['secondaryMuscles'] as List<dynamic>? ?? [])
            .map((n) => MuscleGroup.fromName(n as String))
            .toList(),
        kind: (json['kind'] as String?) == 'cardio'
            ? ExerciseKind.cardio
            : ExerciseKind.strength,
        equipment: Equipment.fromName(json['equipment'] as String?),
        isCustom: json['isCustom'] as bool? ?? false,
      );
}
