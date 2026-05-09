/// A single completed set. Strength sets use weight + reps; cardio sets use
/// distance/duration. The parent exercise's kind decides which to render.
class WorkoutSet {
  const WorkoutSet({
    required this.id,
    this.weightKg,
    this.reps,
    this.rir,
    this.distanceMeters,
    this.durationSeconds,
    this.notes,
  });

  final String id;
  final double? weightKg;
  final int? reps;
  final int? rir;
  final double? distanceMeters;
  final int? durationSeconds;
  final String? notes;

  WorkoutSet copyWith({
    double? weightKg,
    int? reps,
    int? rir,
    double? distanceMeters,
    int? durationSeconds,
    String? notes,
  }) {
    return WorkoutSet(
      id: id,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rir: rir ?? this.rir,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (weightKg != null) 'weightKg': weightKg,
        if (reps != null) 'reps': reps,
        if (rir != null) 'rir': rir,
        if (distanceMeters != null) 'distanceMeters': distanceMeters,
        if (durationSeconds != null) 'durationSeconds': durationSeconds,
        if (notes != null) 'notes': notes,
      };

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => WorkoutSet(
        id: json['id'] as String,
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        reps: json['reps'] as int?,
        rir: json['rir'] as int?,
        distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
        durationSeconds: json['durationSeconds'] as int?,
        notes: json['notes'] as String?,
      );
}
