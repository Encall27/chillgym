import 'exercise.dart';

class WorkoutTemplate {
  const WorkoutTemplate({
    required this.id,
    required this.name,
    this.exercises = const [],
  });

  final String id;
  final String name;
  final List<Exercise> exercises;

  WorkoutTemplate copyWith({String? name, List<Exercise>? exercises}) {
    return WorkoutTemplate(
      id: id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) =>
      WorkoutTemplate(
        id: json['id'] as String,
        name: json['name'] as String,
        exercises: (json['exercises'] as List<dynamic>? ?? [])
            .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
