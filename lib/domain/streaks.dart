import 'models/session.dart';

class StreakStats {
  const StreakStats({
    required this.current,
    required this.longest,
    required this.thisMonth,
  });

  final int current;
  final int longest;
  final int thisMonth;
}

/// Reduce a list of sessions to a set of unique calendar dates (date-only).
Set<DateTime> trainingDates(List<Session> sessions) {
  return sessions
      .map((s) =>
          DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day))
      .toSet();
}

/// Compute streak stats. A streak counts consecutive calendar days with at
/// least one session. The "current" streak is anchored to today; if the user
/// hasn't trained today but did yesterday, current is still counted from
/// yesterday backwards (i.e. a one-day gap doesn't immediately zero the
/// counter until today ends).
StreakStats computeStreakStats(List<Session> sessions, {DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());
  final dates = trainingDates(sessions);
  if (dates.isEmpty) {
    return const StreakStats(current: 0, longest: 0, thisMonth: 0);
  }

  // Current streak: walk back from today. If today isn't in the set, start
  // from yesterday so an unfinished today still preserves a streak.
  var anchor = today;
  if (!dates.contains(anchor)) {
    anchor = anchor.subtract(const Duration(days: 1));
  }
  var current = 0;
  while (dates.contains(anchor)) {
    current++;
    anchor = anchor.subtract(const Duration(days: 1));
  }

  // Longest streak: scan sorted dates.
  final sorted = dates.toList()..sort();
  var longest = 0;
  var run = 0;
  DateTime? prev;
  for (final d in sorted) {
    if (prev == null || d.difference(prev).inDays != 1) {
      run = 1;
    } else {
      run++;
    }
    if (run > longest) longest = run;
    prev = d;
  }

  final thisMonth = dates
      .where((d) => d.year == today.year && d.month == today.month)
      .length;

  return StreakStats(
    current: current,
    longest: longest,
    thisMonth: thisMonth,
  );
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
