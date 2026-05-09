import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/exercise.dart';
import '../../domain/models/exercise_entry.dart';
import '../../domain/models/session.dart';
import '../../domain/models/workout_set.dart';
import '../../domain/units.dart';

/// Visual card for sharing — fixed 1080×1080 logical size so captures land at a
/// predictable, social-friendly aspect ratio. Wrap in a RepaintBoundary for
/// capture.
class ShareCard extends StatelessWidget {
  const ShareCard({
    super.key,
    required this.session,
    required this.unit,
  });

  final Session session;
  final WeightUnit unit;

  static const double size = 1080;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dateFmt = DateFormat('EEEE, MMM d');
    final highlights = _highlights(session);

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: scheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'gymwhenyouready',
                style: TextStyle(
                  color: scheme.onPrimaryContainer.withValues(alpha: 0.7),
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                dateFmt.format(session.startedAt),
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 48),
              Row(
                children: [
                  _Stat(
                    label: 'Exercises',
                    value: '${session.entries.length}',
                  ),
                  const SizedBox(width: 48),
                  _Stat(label: 'Sets', value: '${session.totalSets}'),
                  const SizedBox(width: 48),
                  _Stat(
                    label: 'Volume',
                    value: formatVolumeFromKg(session.totalVolumeKg, unit),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 32),
              Text(
                'Top sets',
                style: TextStyle(
                  color: scheme.onPrimaryContainer.withValues(alpha: 0.7),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: highlights.length.clamp(0, 6),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _HighlightLine(line: highlights[i]),
                ),
              ),
              if (session.place != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        color: scheme.onPrimaryContainer,
                        size: 32,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        session.place!,
                        style: TextStyle(
                          color: scheme.onPrimaryContainer,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Pull a one-line summary per exercise. Top set first, falls back to set
  /// count for cardio or empty entries.
  List<String> _highlights(Session s) {
    final lines = <String>[];
    for (final e in s.entries) {
      if (e.exercise.kind == ExerciseKind.cardio) {
        final cardio = _bestCardio(e);
        if (cardio != null) lines.add('${e.exercise.name} — $cardio');
        continue;
      }
      final top = e.topSet;
      if (top == null) {
        lines.add('${e.exercise.name} — ${e.sets.length} sets');
      } else {
        final w = formatWeightFromKg(top.weightKg!, unit);
        lines.add('${e.exercise.name} — $w × ${top.reps}');
      }
    }
    return lines;
  }

  String? _bestCardio(ExerciseEntry e) {
    WorkoutSet? best;
    for (final s in e.sets) {
      if ((s.distanceMeters ?? 0) > (best?.distanceMeters ?? 0)) best = s;
    }
    if (best == null) return null;
    final parts = <String>[];
    if (best.distanceMeters != null) {
      parts.add('${(best.distanceMeters! / 1000).toStringAsFixed(2)} km');
    }
    if (best.durationSeconds != null) {
      final m = best.durationSeconds! ~/ 60;
      final ss = best.durationSeconds! % 60;
      parts.add('${m}m ${ss.toString().padLeft(2, '0')}s');
    }
    return parts.isEmpty ? null : parts.join(' · ');
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: scheme.onPrimaryContainer.withValues(alpha: 0.7),
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: scheme.onPrimaryContainer,
            fontSize: 56,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HighlightLine extends StatelessWidget {
  const _HighlightLine({required this.line});
  final String line;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      line,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: scheme.onPrimaryContainer,
        fontSize: 32,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
