import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/session.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../share/share_card_dialog.dart';

/// Pops after the user taps Finish on the active session. Shows the saved
/// session's headline stats and offers a one-tap path into the share-card
/// flow. Tapping outside dismisses (Done = no share).
class WorkoutFinishedDialog extends StatelessWidget {
  const WorkoutFinishedDialog({
    super.key,
    required this.session,
    required this.unit,
  });

  final Session session;
  final WeightUnit unit;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final dateFmt = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).toString(),
    );
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.celebration_outlined, color: scheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(l.finishedTitle)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateFmt.format(session.startedAt),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(
                label: l.statExercises,
                value: '${session.entries.length}',
              ),
              _Stat(label: l.statSets, value: '${session.totalSets}'),
              _Stat(
                label: l.statVolume,
                value: formatVolumeFromKg(session.totalVolumeKg, unit),
              ),
              _Stat(
                label: l.statDuration,
                value: '${session.duration.inMinutes}m',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l.finishedShareHint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.actionDone),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            showDialog<void>(
              context: context,
              builder: (_) => ShareCardDialog(session: session, unit: unit),
            );
          },
          icon: const Icon(Icons.ios_share),
          label: Text(l.actionShare),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
