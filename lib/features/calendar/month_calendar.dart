import 'package:flutter/material.dart';

import '../../domain/day_part.dart';

/// Month-grid calendar. 7 columns (Sun..Sat), variable rows (4-6 weeks).
/// Trained days fill with primary colour scaled by volume; today gets a ring;
/// the selected day gets a thicker border. Below the day number we render a
/// small row of day-part icons — one per session — so the user can see at a
/// glance whether they trained AM / PM / EVE / NIGHT.
class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    required this.dayParts,
    required this.dayVolumes,
    required this.onTap,
    this.selectedDay,
  });

  /// Any date in the desired month — only year + month are read.
  final DateTime month;

  /// Date-only key → list of DayPart for each session on that day, in start
  /// order. Empty list / missing key = no sessions.
  final Map<DateTime, List<DayPart>> dayParts;

  /// Date-only key → total volume kg on that day. Drives intensity colour.
  final Map<DateTime, double> dayVolumes;

  final DateTime? selectedDay;
  final void Function(DateTime day) onTap;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
  static const _weekdayHeaders = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final today = _dateOnly(DateTime.now());
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // Dart weekday: Mon=1..Sun=7 → convert to Sun=0..Sat=6
    final leadingBlanks = firstOfMonth.weekday % 7;
    final maxVolume = dayVolumes.values.fold<double>(
      0,
      (m, v) => v > m ? v : m,
    );

    // Build cell widgets in display order: leadingBlanks, then days.
    final cells = <Widget>[];
    for (var i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final parts = dayParts[date] ?? const <DayPart>[];
      final volume = dayVolumes[date] ?? 0;
      final isToday = date == today;
      final isSelected = selectedDay != null && date == selectedDay;

      Color? bg;
      Color? fg;
      if (parts.isNotEmpty) {
        final intensity =
            maxVolume == 0 ? 0.5 : (volume / maxVolume).clamp(0.3, 1.0);
        bg = Color.lerp(scheme.primaryContainer, scheme.primary, intensity);
        fg = scheme.onPrimary;
      }

      cells.add(
        InkResponse(
          onTap: () => onTap(date),
          radius: 28,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: bg,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: scheme.primary, width: 2.5)
                        : isToday
                            ? Border.all(color: scheme.outline, width: 1.5)
                            : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: fg ?? scheme.onSurface,
                          fontWeight:
                              isToday || isSelected ? FontWeight.w700 : null,
                        ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  height: 12,
                  child: parts.isEmpty
                      ? const SizedBox.shrink()
                      : _DayPartRow(parts: parts),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Pad the trailing of the last row to a full 7 cells so the row paints
    // evenly when it's the highlighted current week.
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }

    final headerRow = Row(
      children: [
        for (final h in _weekdayHeaders)
          Expanded(
            child: Center(
              child: Text(
                h,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
      ],
    );

    // Determine which week-row contains today (for current-month views).
    int? currentWeekIndex;
    if (today.year == month.year && today.month == month.month) {
      final idx = leadingBlanks + (today.day - 1);
      currentWeekIndex = idx ~/ 7;
    }

    final weekRows = <Widget>[];
    for (var w = 0; w * 7 < cells.length; w++) {
      final rowCells = cells.sublist(w * 7, (w * 7) + 7);
      final isCurrentWeek = currentWeekIndex == w;
      weekRows.add(
        DecoratedBox(
          decoration: BoxDecoration(
            color: isCurrentWeek
                ? scheme.primary.withValues(alpha: 0.08)
                : null,
            borderRadius: BorderRadius.circular(10),
            border: isCurrentWeek
                ? Border.all(
                    color: scheme.primary.withValues(alpha: 0.35),
                    width: 1,
                  )
                : null,
          ),
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                for (final c in rowCells) Expanded(child: c),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(height: 24, child: headerRow),
        const SizedBox(height: 4),
        ...weekRows,
      ],
    );
  }
}

/// Row of up to 3 day-part icons, with a "+N" tail when more sessions exist.
class _DayPartRow extends StatelessWidget {
  const _DayPartRow({required this.parts});

  final List<DayPart> parts;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visible = parts.take(3).toList();
    final extra = parts.length - visible.length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final p in visible)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Icon(p.icon, size: 10, color: scheme.onSurfaceVariant),
          ),
        if (extra > 0)
          Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              '+$extra',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: scheme.onSurfaceVariant,
                height: 1,
              ),
            ),
          ),
      ],
    );
  }
}
