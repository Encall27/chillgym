import 'models/exercise_entry.dart';
import 'models/session.dart';

/// Finds the most recent [ExerciseEntry] for a given exercise id across past
/// sessions. Returns null if the user has never logged that exercise.
ExerciseEntry? findLastEntryFor({
  required String exerciseId,
  required List<Session> sessions,
}) {
  // `sessions` is expected to come from `pastSessionsProvider` which sorts
  // newest-first; defensive iteration handles either ordering.
  Session? bestSession;
  ExerciseEntry? bestEntry;
  for (final s in sessions) {
    for (final e in s.entries) {
      if (e.exercise.id != exerciseId) continue;
      if (bestSession == null || s.startedAt.isAfter(bestSession.startedAt)) {
        bestSession = s;
        bestEntry = e;
      }
    }
  }
  return bestEntry;
}
