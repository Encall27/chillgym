import 'models/exercise.dart';
import 'models/session.dart';
import 'models/workout_set.dart';

class ExerciseSessionPoint {
  const ExerciseSessionPoint({
    required this.date,
    required this.topSet,
    required this.totalVolumeKg,
    required this.estOneRm,
  });

  final DateTime date;
  final WorkoutSet? topSet;
  final double totalVolumeKg;
  final double? estOneRm;
}

class ExerciseProgress {
  const ExerciseProgress({
    required this.exercise,
    required this.points,
  });

  final Exercise exercise;
  final List<ExerciseSessionPoint> points;

  WorkoutSet? get bestTopSet {
    WorkoutSet? best;
    for (final p in points) {
      final s = p.topSet;
      if (s == null || s.weightKg == null) continue;
      if (best == null || s.weightKg! > best.weightKg!) best = s;
    }
    return best;
  }

  double? get bestEstOneRm {
    double? best;
    for (final p in points) {
      final v = p.estOneRm;
      if (v == null) continue;
      if (best == null || v > best) best = v;
    }
    return best;
  }

  double get bestTotalVolume {
    var best = 0.0;
    for (final p in points) {
      if (p.totalVolumeKg > best) best = p.totalVolumeKg;
    }
    return best;
  }
}

/// Epley estimated 1RM. Returns null if reps unusable (<1 or >12 — beyond 12
/// the estimation is too noisy to display).
double? estOneRm(double weightKg, int reps) {
  if (reps < 1 || reps > 12) return null;
  if (reps == 1) return weightKg;
  return weightKg * (1 + reps / 30);
}

/// Build per-exercise timelines across the full session history.
List<ExerciseProgress> buildExerciseProgress(List<Session> sessions) {
  // Map exerciseId → exercise + list of points
  final byId = <String, ExerciseProgress>{};
  // Sort sessions oldest first so the list of points is chronological.
  final ordered = [...sessions]
    ..sort((a, b) => a.startedAt.compareTo(b.startedAt));

  for (final session in ordered) {
    for (final entry in session.entries) {
      if (entry.sets.isEmpty) continue;
      // Only strength entries get a top set / 1RM. Cardio still tracks volume
      // as 0 (we just won't render those for cardio in the UI).
      final top = entry.topSet;
      double? oneRm;
      if (top != null && top.weightKg != null && top.reps != null) {
        oneRm = estOneRm(top.weightKg!, top.reps!);
      }
      final point = ExerciseSessionPoint(
        date: session.startedAt,
        topSet: top,
        totalVolumeKg: entry.totalVolumeKg,
        estOneRm: oneRm,
      );
      final existing = byId[entry.exercise.id];
      if (existing == null) {
        byId[entry.exercise.id] = ExerciseProgress(
          exercise: entry.exercise,
          points: [point],
        );
      } else {
        byId[entry.exercise.id] = ExerciseProgress(
          exercise: existing.exercise,
          points: [...existing.points, point],
        );
      }
    }
  }

  final result = byId.values.toList()
    ..sort(
        (a, b) => a.exercise.name.toLowerCase().compareTo(b.exercise.name.toLowerCase()));
  return result;
}
