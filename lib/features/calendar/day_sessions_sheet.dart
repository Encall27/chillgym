import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/day_part.dart';
import '../../domain/models/session.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/preferences_provider.dart';
import '../history/session_detail_screen.dart';

/// Centred dialog that lists every session on a tapped calendar day.
/// Tapping a session closes the dialog and pushes its detail screen.
class DaySessionsSheet extends ConsumerWidget {
  const DaySessionsSheet({
    super.key,
    required this.date,
    required this.sessions,
  });

  final DateTime date;
  final List<Session> sessions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final scheme = Theme.of(context).colorScheme;
    final dateFmt = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toString(),
    );
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                dateFmt.format(date),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                sessions.isEmpty
                    ? l.daySheetEmpty
                    : l.daySheetSessionsCount(sessions.length),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 12),
              if (sessions.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    l.daySheetEmptyHelp,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => _DaySessionTile(
                      session: sessions[i],
                      unit: unit,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l.actionClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DaySessionTile extends ConsumerWidget {
  const _DaySessionTile({required this.session, required this.unit});

  final Session session;
  final WeightUnit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final timeFmt = DateFormat.jm(Localizations.localeOf(context).toString());
    final part = dayPartOf(session.startedAt);
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Icon(part.icon),
        ),
        title: Text(
          l.daySheetTimeLine(
            l.dayPartShortLabel(part),
            timeFmt.format(session.startedAt),
          ),
        ),
        subtitle: Text(
          [
            if (session.place != null) session.place!,
            l.libraryExerciseCount(session.entries.length),
            '${session.totalSets} ${l.statSets.toLowerCase()}',
            formatVolumeFromKg(session.totalVolumeKg, unit),
          ].join(' · '),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SessionDetailScreen(session: session),
            ),
          );
        },
      ),
    );
  }
}
