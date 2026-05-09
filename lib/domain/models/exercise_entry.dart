import 'exercise.dart';
import 'workout_set.dart';

class ExerciseEntry {
  const ExerciseEntry({
    required this.id,
    required this.exercise,
    this.sets = const [],
    this.photoRefs = const [],
    this.isFinished = false,
  });

  final String id;
  final Exercise exercise;
  final List<WorkoutSet> sets;

  /// Stable references to attached photos. On web these are `data:image/...;base64,...`
  /// strings; on mobile they are absolute file paths under app documents.
  final List<String> photoRefs;

  /// User-marked "I'm done with this exercise". Finished entries are pinned to
  /// the bottom of the active session so the in-progress / next exercise stays
  /// at the top.
  final bool isFinished;

  ExerciseEntry copyWith({
    List<WorkoutSet>? sets,
    List<String>? photoRefs,
    bool? isFinished,
  }) {
    return ExerciseEntry(
      id: id,
      exercise: exercise,
      sets: sets ?? this.sets,
      photoRefs: photoRefs ?? this.photoRefs,
      isFinished: isFinished ?? this.isFinished,
    );
  }

  double get totalVolumeKg {
    var sum = 0.0;
    for (final s in sets) {
      if (s.weightKg != null && s.reps != null) {
        sum += s.weightKg! * s.reps!;
      }
    }
    return sum;
  }

  /// Top set = heaviest set with at least one rep. Used for progress charts.
  WorkoutSet? get topSet {
    WorkoutSet? best;
    for (final s in sets) {
      if (s.weightKg == null || s.reps == null || s.reps! < 1) continue;
      if (best == null || s.weightKg! > best.weightKg!) best = s;
    }
    return best;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exercise': exercise.toJson(),
        'sets': sets.map((s) => s.toJson()).toList(),
        'photoRefs': photoRefs,
        if (isFinished) 'isFinished': true,
      };

  factory ExerciseEntry.fromJson(Map<String, dynamic> json) => ExerciseEntry(
        id: json['id'] as String,
        exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
        sets: (json['sets'] as List<dynamic>? ?? [])
            .map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>))
            .toList(),
        photoRefs: (json['photoRefs'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(),
        isFinished: json['isFinished'] as bool? ?? false,
      );
}
