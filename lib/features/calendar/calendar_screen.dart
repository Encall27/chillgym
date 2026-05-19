import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/brand_title.dart';
import '../../app/drawer.dart';
import '../../domain/day_part.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/session.dart';
import '../../domain/models/workout_set.dart';
import '../../domain/progress_stats.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/preferences_provider.dart';
import '../../state/session_repository_provider.dart';
import '../../theme/brand_tokens.dart';
import '../history/session_detail_screen.dart';
import '../shared/design_primitives.dart';
import 'all_sessions_screen.dart';
import 'month_calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

enum _CalendarMode { monthly, yearly }

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _viewMonth;
  DateTime? _selectedDay;
  _CalendarMode _mode = _CalendarMode.monthly;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewMonth = DateTime(now.year, now.month, 1);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  void _shiftMonth(int delta) {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + delta, 1);
      _selectedDay = null;
    });
  }

  void _shiftYear(int delta) {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year + delta, _viewMonth.month, 1);
      _selectedDay = null;
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _viewMonth = DateTime(now.year, now.month, 1);
      _selectedDay = DateTime(now.year, now.month, now.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final asyncSessions = ref.watch(pastSessionsProvider);
    final now = DateTime.now();
    final isCurrentSpan = _mode == _CalendarMode.monthly
        ? (_viewMonth.year == now.year && _viewMonth.month == now.month)
        : _viewMonth.year == now.year;

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const BrandTitle(),
        centerTitle: true,
        actions: [
          if (!isCurrentSpan)
            TextButton.icon(
              onPressed: _goToToday,
              icon: const Icon(Icons.today, size: 18),
              label: Text(l.calendarToday),
            ),
        ],
      ),
      body: asyncSessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.loadFailed(e.toString()))),
        data: (sessions) {
          // Bucket sessions by day-only date once.
          final dayParts = <DateTime, List<DayPart>>{};
          final daySessions = <DateTime, List<Session>>{};
          final dayVolumes = <DateTime, double>{};
          for (final s in sessions) {
            final k = _dateOnly(s.startedAt);
            (daySessions[k] ??= []).add(s);
            dayVolumes[k] = (dayVolumes[k] ?? 0) + s.totalVolumeKg;
          }
          for (final entry in daySessions.entries) {
            final times = [...entry.value]..sort(
                (a, b) => a.startedAt.compareTo(b.startedAt),
              );
            dayParts[entry.key] =
                times.map((s) => dayPartOf(s.startedAt)).toList();
          }
          final monthStart = DateTime(_viewMonth.year, _viewMonth.month, 1);
          final monthEnd =
              DateTime(_viewMonth.year, _viewMonth.month + 1, 0, 23, 59, 59);
          final monthSessions = sessions
              .where((s) =>
                  !s.startedAt.isBefore(monthStart) &&
                  !s.startedAt.isAfter(monthEnd))
              .toList();
          final trainedDayKeys = <DateTime>{};
          for (final s in monthSessions) {
            trainedDayKeys.add(_dateOnly(s.startedAt));
          }

          // sessions/week — based on the calendar month's days, not strict week math.
          final weeksInView = (DateTime(_viewMonth.year, _viewMonth.month + 1, 0)
                      .day /
                  7)
              .ceilToDouble();
          final perWeek = weeksInView <= 0
              ? '0'
              : (monthSessions.length / weeksInView).toStringAsFixed(1);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              SegmentedButton<_CalendarMode>(
                segments: [
                  ButtonSegment(
                    value: _CalendarMode.monthly,
                    label: Text(l.calendarViewMonthly),
                    icon: const Icon(Icons.calendar_view_month),
                  ),
                  ButtonSegment(
                    value: _CalendarMode.yearly,
                    label: Text(l.calendarViewYearly),
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
              const SizedBox(height: 12),
              if (_mode == _CalendarMode.monthly) ...[
                _MonthHeader(
                  month: _viewMonth,
                  onPrev: () => _shiftMonth(-1),
                  onNext: () => _shiftMonth(1),
                  trainedDays: trainedDayKeys.length,
                  perWeek: perWeek,
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        MonthCalendar(
                          month: _viewMonth,
                          dayParts: dayParts,
                          dayVolumes: dayVolumes,
                          selectedDay: _selectedDay,
                          onTap: (day) {
                            setState(() => _selectedDay = day);
                            final list =
                                daySessions[day] ?? const <Session>[];
                            if (list.isNotEmpty) {
                              _openDayDialog(day, list, sessions, unit);
                            } else {
                              _showEmptyDayDialog(day);
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                        _HeatmapLegend(),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                _YearHeader(
                  year: _viewMonth.year,
                  onPrev: () => _shiftYear(-1),
                  onNext: () => _shiftYear(1),
                  sessions: sessions,
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _YearGrid(
                      year: _viewMonth.year,
                      sessions: sessions,
                      onMonthTap: (m) => setState(() {
                        _viewMonth = DateTime(_viewMonth.year, m, 1);
                        _mode = _CalendarMode.monthly;
                      }),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _pickSessionsScope(sessions.length),
                icon: const Icon(Icons.list),
                label: Text(l.actionViewAllSessions(sessions.length)),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickSessionsScope(int totalCount) async {
    final l = tr(context);
    final scope = await showDialog<SessionsScope>(
      context: context,
      builder: (dialogCtx) => SimpleDialog(
        title: Text(l.calendarScopeChooserTitle),
        children: [
          for (final s in SessionsScope.values)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogCtx).pop(s),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(s.icon, size: 20),
                    const SizedBox(width: 12),
                    Text(_scopeLabel(s, l)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
    if (scope == null || !mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AllSessionsScreen(scope: scope, anchor: _viewMonth),
      ),
    );
  }

  String _scopeLabel(SessionsScope s, AppLocalizations l) => switch (s) {
        SessionsScope.currentMonth => l.calendarScopeCurrentMonth,
        SessionsScope.currentYear => l.calendarScopeCurrentYear,
        SessionsScope.allTime => l.calendarScopeAllTime,
      };

  void _openDayDialog(
    DateTime day,
    List<Session> sessionsOnDay,
    List<Session> allSessions,
    WeightUnit unit,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              child: _DayDetailCard(
                date: day,
                sessions: sessionsOnDay,
                unit: unit,
                allSessions: allSessions,
                onClose: () => Navigator.of(dialogCtx).pop(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEmptyDayDialog(DateTime day) {
    final l = tr(context);
    final fmt = DateFormat.yMMMMd(Localizations.localeOf(context).toString());
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.calendarNoSessionTitle),
        content: Text('${l.calendarNoSessionBody}\n${fmt.format(day)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l.actionClose),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrev,
    required this.onNext,
    required this.trainedDays,
    required this.perWeek,
  });

  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final int trainedDays;
  final String perWeek;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final monthFmt =
        DateFormat.yMMMM(Localizations.localeOf(context).toString());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          tooltip: l.calendarPrevMonth,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  monthFmt.format(month).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.calendarMonthSummary(trainedDays, perWeek),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          tooltip: l.calendarNextMonth,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class _HeatmapLegend extends StatelessWidget {
  const _HeatmapLegend();

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    Widget swatch(double alpha) {
      return Container(
        width: 14,
        height: 14,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: alpha == 0
              ? scheme.surfaceContainer
              : scheme.primary.withValues(alpha: alpha),
          border: Border.all(color: scheme.outlineVariant),
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l.calendarHeatmapLess,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(width: 8),
        swatch(0),
        swatch(0.35),
        swatch(0.7),
        swatch(1.0),
        const SizedBox(width: 8),
        Text(
          l.calendarHeatmapMore,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
        ),
      ],
    );
  }
}

class _DayDetailCard extends StatelessWidget {
  const _DayDetailCard({
    required this.date,
    required this.sessions,
    required this.unit,
    required this.allSessions,
    this.onClose,
  });

  final DateTime date;
  final List<Session> sessions;
  final WeightUnit unit;
  final List<Session> allSessions;
  final VoidCallback? onClose;

  /// Look across all of `allSessions` and return any exercise + top set on
  /// `date` that ties or exceeds the all-time best top-set weight for that
  /// exercise. Used to flag a "★ NEW PR" callout.
  ({Exercise exercise, WorkoutSet set})? _findPrOnDay() {
    final progress = buildExerciseProgress(allSessions);
    for (final session in sessions) {
      for (final entry in session.entries) {
        if (entry.exercise.kind == ExerciseKind.cardio) continue;
        final top = entry.topSet;
        if (top == null || top.weightKg == null || top.reps == null) continue;
        final ep = progress.firstWhere(
          (p) => p.exercise.id == entry.exercise.id,
          orElse: () => ExerciseProgress(
            exercise: entry.exercise,
            points: const [],
          ),
        );
        final best = ep.bestTopSet;
        if (best?.weightKg == null) continue;
        if (top.weightKg! >= best!.weightKg!) {
          return (exercise: entry.exercise, set: top);
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    // Combine if there were multiple sessions on the same day.
    final totalSets = sessions.fold<int>(0, (a, s) => a + s.totalSets);
    final totalVolume =
        sessions.fold<double>(0, (a, s) => a + s.totalVolumeKg);
    double maxWeightKg = 0;
    for (final s in sessions) {
      for (final e in s.entries) {
        for (final st in e.sets) {
          if (st.weightKg != null && st.weightKg! > maxWeightKg) {
            maxWeightKg = st.weightKg!;
          }
        }
      }
    }
    final dateFmt = DateFormat('MM.dd · EEEE',
        Localizations.localeOf(context).toString());
    // Headline order: explicit user name > place > most-trained muscle.
    final first = sessions.first;
    final headline = (first.name != null && first.name!.isNotEmpty)
        ? first.name!
        : first.place ??
            (first.entries.isEmpty
                ? l.activeTitle
                : l.muscleLabel(first.entries.first.exercise.primaryMuscle));
    final duration = sessions.fold<Duration>(
      Duration.zero,
      (a, s) => a + s.duration,
    );
    final pr = _findPrOnDay();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: eyebrow date on the left, X close on the right.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: EyebrowLabel(
                      dateFmt.format(date).toUpperCase(),
                      color: brand.amberDeep,
                      dot: true,
                    ),
                  ),
                ),
                if (onClose != null)
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                    tooltip: l.actionClose,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              headline,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              [
                if (first.place != null) first.place,
                '${duration.inMinutes} min',
              ].whereType<String>().join(' · '),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: l.calendarStatSets,
                    value: '$totalSets',
                    color: brand.positive,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    label: l.calendarStatVolume,
                    value: formatVolumeFromKg(totalVolume, unit),
                    color: brand.amberDeep,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    label: l.calendarStatMax,
                    value: maxWeightKg <= 0
                        ? '—'
                        : formatWeightFromKg(maxWeightKg, unit),
                    color: brand.info,
                  ),
                ),
              ],
            ),
            if (pr != null) ...[
              const SizedBox(height: 14),
              AccentCallout(
                eyebrow: l.calendarPrCallout,
                body: Text(
                  l.calendarPrLine(
                    pr.exercise.name,
                    formatWeightFromKg(pr.set.weightKg!, unit),
                    pr.set.reps!,
                  ),
                  style: brand.useGlow
                      ? Theme.of(context).textTheme.bodyMedium
                      : brand.displayItalic.copyWith(
                          fontSize: 15,
                          color: scheme.onSurface,
                        ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                if (onClose != null) onClose!();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SessionDetailScreen(session: first),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: Text(l.calendarOpenSession),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// Yearly view: 4×3 grid of months with sessions / volume summary.
// =====================================================================

class _YearHeader extends StatelessWidget {
  const _YearHeader({
    required this.year,
    required this.onPrev,
    required this.onNext,
    required this.sessions,
  });

  final int year;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final List<Session> sessions;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final yearStart = DateTime(year, 1, 1);
    final yearEnd = DateTime(year + 1, 1, 1);
    final yearSessions = sessions
        .where((s) =>
            !s.startedAt.isBefore(yearStart) && s.startedAt.isBefore(yearEnd))
        .toList();
    final trainedDays = <DateTime>{};
    for (final s in yearSessions) {
      trainedDays.add(DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left),
          tooltip: l.calendarPrevMonth,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$year',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        letterSpacing: 1.2,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  l.calendarYearSummary(
                    trainedDays.length,
                    yearSessions.length,
                  ),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          tooltip: l.calendarNextMonth,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class _YearGrid extends StatelessWidget {
  const _YearGrid({
    required this.year,
    required this.sessions,
    required this.onMonthTap,
  });

  final int year;
  final List<Session> sessions;
  final void Function(int month) onMonthTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final localeName = Localizations.localeOf(context).toString();
    final monthFmt = DateFormat.MMM(localeName);

    // Per-month aggregates: trained-day set, total volume, weekday histogram,
    // place histogram, friend histogram.
    final dayKeysByMonth = List.generate(12, (_) => <DateTime>{});
    final volumeByMonth = List.filled(12, 0.0);
    final sessionsByMonth = List.filled(12, 0);
    final weekdayByMonth =
        List.generate(12, (_) => <int, int>{}); // weekday(1..7) → count
    final placeByMonth = List.generate(12, (_) => <String, int>{});
    final friendByMonth = List.generate(12, (_) => <String, int>{});
    for (final s in sessions) {
      if (s.startedAt.year != year) continue;
      final m = s.startedAt.month - 1;
      dayKeysByMonth[m].add(
        DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day),
      );
      volumeByMonth[m] += s.totalVolumeKg;
      sessionsByMonth[m] += 1;
      weekdayByMonth[m][s.startedAt.weekday] =
          (weekdayByMonth[m][s.startedAt.weekday] ?? 0) + 1;
      if (s.place != null && s.place!.isNotEmpty) {
        placeByMonth[m][s.place!] = (placeByMonth[m][s.place!] ?? 0) + 1;
      }
      for (final f in s.friends) {
        friendByMonth[m][f] = (friendByMonth[m][f] ?? 0) + 1;
      }
    }
    final maxVolume = volumeByMonth.fold<double>(0, (a, v) => v > a ? v : a);
    final now = DateTime.now();

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 0.78,
      children: [
        for (var m = 0; m < 12; m++)
          _YearMonthTile(
            label: monthFmt.format(DateTime(year, m + 1, 1)),
            trainedDays: dayKeysByMonth[m].length,
            sessions: sessionsByMonth[m],
            topWeekday: _topKey(weekdayByMonth[m]),
            topPlace: _topKey(placeByMonth[m]),
            topFriend: _topKeyValue(friendByMonth[m]),
            intensity: maxVolume <= 0
                ? 0
                : (volumeByMonth[m] / maxVolume).clamp(0, 1.0).toDouble(),
            isCurrent: now.year == year && now.month == m + 1,
            scheme: scheme,
            brand: brand,
            onTap: () => onMonthTap(m + 1),
          ),
      ],
    );
  }

  /// Most-frequent key, or null if the map is empty.
  static K? _topKey<K>(Map<K, int> counts) {
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  /// Most-frequent (key, count) tuple, or null if empty.
  static MapEntry<K, int>? _topKeyValue<K>(Map<K, int> counts) {
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b);
  }
}

class _YearMonthTile extends StatelessWidget {
  const _YearMonthTile({
    required this.label,
    required this.trainedDays,
    required this.sessions,
    required this.topWeekday,
    required this.topPlace,
    required this.topFriend,
    required this.intensity,
    required this.isCurrent,
    required this.scheme,
    required this.brand,
    required this.onTap,
  });

  final String label;
  final int trainedDays;
  final int sessions;
  final int? topWeekday; // 1=Mon … 7=Sun
  final String? topPlace;
  final MapEntry<String, int>? topFriend;
  final double intensity;
  final bool isCurrent;
  final ColorScheme scheme;
  final BrandTokens brand;
  final VoidCallback onTap;

  String _weekdayShort(int w, BuildContext context) {
    final base = DateTime(2024, 1, 1);
    // 2024-01-01 is a Monday → offset = w - 1.
    final d = base.add(Duration(days: w - 1));
    return DateFormat.E(Localizations.localeOf(context).toString()).format(d);
  }

  @override
  Widget build(BuildContext context) {
    final hasData = trainedDays > 0;
    final bg = hasData
        ? Color.lerp(
            scheme.primaryContainer.withValues(alpha: 0.35),
            scheme.primary,
            intensity * 0.5,
          )
        : scheme.surfaceContainer;
    final fg = hasData && intensity > 0.6
        ? scheme.onPrimary
        : scheme.onSurface;
    final mutedFg = fg.withValues(alpha: 0.7);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isCurrent ? scheme.primary : scheme.outlineVariant,
            width: isCurrent ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                    color: mutedFg,
                  ),
                ),
                const Spacer(),
                Text(
                  '$trainedDays',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: fg,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            if (!hasData)
              Text(
                '—',
                style: TextStyle(
                  fontSize: 10,
                  color: mutedFg,
                ),
              )
            else ...[
              Text(
                '$sessions sess',
                style: TextStyle(
                  fontSize: 9,
                  color: mutedFg,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (topWeekday != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(Icons.event, size: 10, color: mutedFg),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          _weekdayShort(topWeekday!, context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            color: mutedFg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (topPlace != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(Icons.place_outlined, size: 10, color: mutedFg),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          topPlace!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            color: mutedFg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (topFriend != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Row(
                    children: [
                      Icon(Icons.people_outline, size: 10, color: mutedFg),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          '${topFriend!.key} ×${topFriend!.value}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            color: mutedFg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EyebrowLabel(label, color: color),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
