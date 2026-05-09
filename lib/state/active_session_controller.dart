import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/exercise.dart';
import '../domain/models/exercise_entry.dart';
import '../domain/models/session.dart';
import '../domain/models/workout_set.dart';
import '../services/health_service.dart';
import '../services/notification_service.dart';
import 'preferences_provider.dart';
import 'session_repository_provider.dart';

/// In-memory holder for the current in-progress session. Null when no session
/// is active. On finish, the session is persisted via `SessionRepository` and
/// `pastSessionsProvider` is invalidated so listeners re-fetch.
class ActiveSessionController extends StateNotifier<Session?> {
  ActiveSessionController(this._ref) : super(null);

  final Ref _ref;

  String _id() => DateTime.now().microsecondsSinceEpoch.toString();

  void startSession({List<ExerciseEntry> seedEntries = const []}) {
    if (state != null) return;
    state = Session(
      id: _id(),
      startedAt: DateTime.now(),
      entries: seedEntries,
    );
  }

  void cancelSession() {
    state = null;
  }

  Future<Session?> finishSession({
    String? inactivityTitle,
    String? inactivityBody,
  }) async {
    final current = state;
    if (current == null) return null;
    final finished = current.copyWith(endedAt: DateTime.now());
    final repo = await _ref.read(sessionRepositoryProvider.future);
    await repo.save(finished);
    _ref.invalidate(pastSessionsProvider);
    state = null;

    // Best-effort Health write. Never blocks the user-facing finish flow.
    final healthOn = await _ref.read(healthEnabledProvider.future);
    if (healthOn) {
      // Fire and forget; ignore failures.
      // ignore: unawaited_futures
      HealthService.instance.writeStrengthWorkout(
        start: finished.startedAt,
        end: finished.endedAt!,
      );
    }

    // Reschedule the inactivity nudge from the time the session ended. Cancels
    // any previously-scheduled nudge so we never accumulate stale ones.
    final notifsOn =
        await _ref.read(notificationsEnabledProvider.future);
    final days = await _ref.read(inactivityNudgeDaysProvider.future);
    if (notifsOn && days > 0) {
      // Fire and forget.
      // ignore: unawaited_futures
      NotificationService.instance.scheduleInactivityNudge(
        finished.endedAt!.add(Duration(days: days)),
        title: inactivityTitle,
        body: inactivityBody,
      );
    } else {
      // ignore: unawaited_futures
      NotificationService.instance.cancelInactivity();
    }

    return finished;
  }

  /// Adds a new exercise at the **top** of the entry list. Existing finished
  /// entries always sit below the in-progress ones; this preserves that order.
  void addExercise(Exercise exercise) {
    final current = state;
    if (current == null) return;
    final entry = ExerciseEntry(id: _id(), exercise: exercise);
    state = current.copyWith(
      entries: _sorted([entry, ...current.entries]),
    );
  }

  /// Toggles or sets the `isFinished` flag on an entry, then re-sorts so
  /// finished entries land at the bottom while preserving relative order
  /// inside each bucket.
  void setEntryFinished(String entryId, bool value) {
    final current = state;
    if (current == null) return;
    final updated = current.entries
        .map((e) => e.id == entryId ? e.copyWith(isFinished: value) : e)
        .toList();
    state = current.copyWith(entries: _sorted(updated));
  }

  /// Stable partition: unfinished entries first (in original order), finished
  /// entries last (in original order).
  List<ExerciseEntry> _sorted(List<ExerciseEntry> entries) {
    final active = <ExerciseEntry>[];
    final done = <ExerciseEntry>[];
    for (final e in entries) {
      (e.isFinished ? done : active).add(e);
    }
    return [...active, ...done];
  }

  /// Returns true iff there's at least one entry that isn't yet marked finished.
  bool get hasUnfinishedEntry =>
      state?.entries.any((e) => !e.isFinished) ?? false;

  void removeEntry(String entryId) {
    final current = state;
    if (current == null) return;
    state = current.copyWith(
      entries: current.entries.where((e) => e.id != entryId).toList(),
    );
  }

  void reorderEntries(int oldIndex, int newIndex) {
    final current = state;
    if (current == null) return;
    final entries = [...current.entries];
    if (oldIndex < 0 || oldIndex >= entries.length) return;
    var insertAt = newIndex;
    if (insertAt > oldIndex) insertAt -= 1;
    final item = entries.removeAt(oldIndex);
    insertAt = insertAt.clamp(0, entries.length);
    entries.insert(insertAt, item);
    state = current.copyWith(entries: entries);
  }

  void addSetToEntry(String entryId, WorkoutSet set) {
    final current = state;
    if (current == null) return;
    final updated = current.entries.map((e) {
      if (e.id != entryId) return e;
      return e.copyWith(sets: [...e.sets, set]);
    }).toList();
    state = current.copyWith(entries: updated);
  }

  void updateSetInEntry(String entryId, WorkoutSet set) {
    final current = state;
    if (current == null) return;
    final updated = current.entries.map((e) {
      if (e.id != entryId) return e;
      final newSets = e.sets.map((s) => s.id == set.id ? set : s).toList();
      return e.copyWith(sets: newSets);
    }).toList();
    state = current.copyWith(entries: updated);
  }

  void removeSet(String entryId, String setId) {
    final current = state;
    if (current == null) return;
    final updated = current.entries.map((e) {
      if (e.id != entryId) return e;
      return e.copyWith(sets: e.sets.where((s) => s.id != setId).toList());
    }).toList();
    state = current.copyWith(entries: updated);
  }

  void setSessionDetails({
    Object? name = _unset,
    Object? place = _unset,
    Object? mood = _unset,
    Object? notes = _unset,
    Object? weather = _unset,
    List<String>? friends,
  }) {
    final current = state;
    if (current == null) return;
    state = current.copyWith(
      name: identical(name, _unset) ? current.name : name,
      place: identical(place, _unset) ? current.place : place,
      mood: identical(mood, _unset) ? current.mood : mood,
      notes: identical(notes, _unset) ? current.notes : notes,
      weather: identical(weather, _unset) ? current.weather : weather,
      friends: friends ?? current.friends,
    );
  }

  static const _unset = Object();

  /// Replaces the entry's set list (used by "pre-fill from last session").
  void replaceSetsForEntry(String entryId, List<WorkoutSet> sets) {
    final current = state;
    if (current == null) return;
    final updated = current.entries.map((e) {
      if (e.id != entryId) return e;
      return e.copyWith(sets: sets);
    }).toList();
    state = current.copyWith(entries: updated);
  }

  void addPhotoToEntry(String entryId, String photoRef) {
    final current = state;
    if (current == null) return;
    final updated = current.entries.map((e) {
      if (e.id != entryId) return e;
      return e.copyWith(photoRefs: [...e.photoRefs, photoRef]);
    }).toList();
    state = current.copyWith(entries: updated);
  }

  void removePhotoFromEntry(String entryId, String photoRef) {
    final current = state;
    if (current == null) return;
    final updated = current.entries.map((e) {
      if (e.id != entryId) return e;
      return e.copyWith(
        photoRefs: e.photoRefs.where((p) => p != photoRef).toList(),
      );
    }).toList();
    state = current.copyWith(entries: updated);
  }
}

final activeSessionProvider =
    StateNotifierProvider<ActiveSessionController, Session?>((ref) {
  return ActiveSessionController(ref);
});

/// Timestamp of the last set added in the current session. Drives the rest
/// timer bar. Cleared when the user dismisses it or finishes the session.
final lastSetAtProvider = StateProvider<DateTime?>((_) => null);
