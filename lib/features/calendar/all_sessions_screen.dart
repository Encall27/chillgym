import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/brand_title.dart';
import '../../domain/day_part.dart';
import '../../domain/models/session.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/preferences_provider.dart';
import '../../state/session_repository_provider.dart';
import '../history/session_detail_screen.dart';

/// Filter passed in from the calendar's "View all sessions" picker. Defaults
/// to [allTime] for backwards compat when called without a scope.
enum SessionsScope {
  currentMonth(Icons.calendar_view_month),
  currentYear(Icons.calendar_today),
  allTime(Icons.all_inclusive);

  const SessionsScope(this.icon);
  final IconData icon;
}

/// Full chronological list of finished sessions, grouped by month and
/// optionally filtered by [scope]. Reachable from the calendar.
class AllSessionsScreen extends ConsumerWidget {
  const AllSessionsScreen({
    super.key,
    this.scope = SessionsScope.allTime,
    DateTime? anchor,
  }) : _anchor = anchor;

  final SessionsScope scope;
  final DateTime? _anchor;

  bool _matches(Session s, DateTime now) {
    final anchor = _anchor ?? now;
    return switch (scope) {
      SessionsScope.allTime => true,
      SessionsScope.currentYear => s.startedAt.year == anchor.year,
      SessionsScope.currentMonth =>
        s.startedAt.year == anchor.year && s.startedAt.month == anchor.month,
    };
  }

  String _scopeSubtitle(BuildContext context) {
    final l = tr(context);
    return switch (scope) {
      SessionsScope.currentMonth => l.calendarScopeCurrentMonth,
      SessionsScope.currentYear => l.calendarScopeCurrentYear,
      SessionsScope.allTime => l.calendarScopeAllTime,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final asyncSessions = ref.watch(pastSessionsProvider);
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    return Scaffold(
      appBar: AppBar(
        title: BrandTitle(
          subtitle: '${l.allSessionsTitle} · ${_scopeSubtitle(context)}',
        ),
        centerTitle: true,
      ),
      body: asyncSessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.loadFailed(e.toString()))),
        data: (allSessions) {
          final now = DateTime.now();
          final sessions =
              allSessions.where((s) => _matches(s, now)).toList();
          if (sessions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l.allSessionsEmpty,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            );
          }
          // sessions are newest-first; build month headers as we go.
          final widgets = <Widget>[];
          DateTime? lastMonth;
          final monthFmt = DateFormat.yMMMM(
            Localizations.localeOf(context).toString(),
          );
          for (final s in sessions) {
            final m = DateTime(s.startedAt.year, s.startedAt.month, 1);
            if (lastMonth == null || m != lastMonth) {
              widgets.add(
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    monthFmt.format(m).toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          letterSpacing: 1.1,
                        ),
                  ),
                ),
              );
              lastMonth = m;
            }
            widgets.add(_AllSessionsTile(session: s, unit: unit));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(pastSessionsProvider),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: widgets,
            ),
          );
        },
      ),
    );
  }
}

class _AllSessionsTile extends ConsumerWidget {
  const _AllSessionsTile({required this.session, required this.unit});

  final Session session;
  final WeightUnit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final localeName = Localizations.localeOf(context).toString();
    final dateFmt = DateFormat.MMMEd(localeName);
    final timeFmt = DateFormat.jm(localeName);
    final part = dayPartOf(session.startedAt);
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
        child: Icon(part.icon),
      ),
      title: Text(dateFmt.format(session.startedAt)),
      subtitle: Text(
        [
          timeFmt.format(session.startedAt),
          if (session.place != null) session.place!,
          l.libraryExerciseCount(session.entries.length),
          '${session.totalSets} ${l.statSets.toLowerCase()}',
          formatVolumeFromKg(session.totalVolumeKg, unit),
        ].join(' · '),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: scheme.outline),
        tooltip: l.deleteSessionTooltip,
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialogCtx) => AlertDialog(
              title: Text(l.deleteSessionTitle),
              content: Text(l.deleteSessionHelp),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx, false),
                  child: Text(l.actionCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogCtx, true),
                  child: Text(l.actionDelete),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            final repo = await ref.read(sessionRepositoryProvider.future);
            await repo.delete(session.id);
            ref.invalidate(pastSessionsProvider);
          }
        },
      ),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SessionDetailScreen(session: session),
        ),
      ),
    );
  }
}
