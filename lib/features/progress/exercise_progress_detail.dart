import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/brand_title.dart';
import '../../domain/models/exercise.dart';
import '../../domain/progress_stats.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';

class ExerciseProgressDetail extends StatelessWidget {
  const ExerciseProgressDetail({
    super.key,
    required this.progress,
    required this.unit,
  });

  final ExerciseProgress progress;
  final WeightUnit unit;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final isCardio = progress.exercise.kind == ExerciseKind.cardio;
    final scheme = Theme.of(context).colorScheme;

    final topSetSpots = <FlSpot>[];
    final volumeSpots = <FlSpot>[];
    for (var i = 0; i < progress.points.length; i++) {
      final p = progress.points[i];
      if (p.topSet?.weightKg != null) {
        topSetSpots.add(FlSpot(i.toDouble(), unit.fromKg(p.topSet!.weightKg!)));
      }
      volumeSpots.add(FlSpot(i.toDouble(), unit.fromKg(p.totalVolumeKg)));
    }

    return Scaffold(
      appBar: AppBar(
        title: BrandTitle(subtitle: progress.exercise.name),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PrCards(progress: progress, isCardio: isCardio, unit: unit),
          const SizedBox(height: 24),
          if (!isCardio && topSetSpots.length >= 2) ...[
            Text(
              l.topSetWeightTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              l.topSetWeightSubtitle(unit.suffix),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: _LineChart(
                spots: topSetSpots,
                color: scheme.primary,
                points: progress.points,
              ),
            ),
            const SizedBox(height: 24),
          ],
          if (volumeSpots.length >= 2) ...[
            Text(
              l.totalVolumeTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              isCardio
                  ? l.totalVolumeCardio
                  : l.totalVolumeSubtitle(unit.suffix),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: _LineChart(
                spots: volumeSpots,
                color: scheme.tertiary,
                points: progress.points,
              ),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            l.statSessions,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ...progress.points.reversed.map((p) {
            final df = DateFormat.yMMMd(
              Localizations.localeOf(context).toString(),
            );
            final top = p.topSet;
            final line = isCardio
                ? l.volumeCardioLine(formatVolumeFromKg(p.totalVolumeKg, unit))
                : top != null && top.weightKg != null && top.reps != null
                    ? l.perSessionLine(
                        formatWeightFromKg(top.weightKg!, unit),
                        top.reps!,
                        formatVolumeFromKg(p.totalVolumeKg, unit),
                      )
                    : l.noSetData;
            return ListTile(
              dense: true,
              leading: Text(df.format(p.date)),
              title: Text(line),
            );
          }),
        ],
      ),
    );
  }
}

class _PrCards extends StatelessWidget {
  const _PrCards({
    required this.progress,
    required this.isCardio,
    required this.unit,
  });
  final ExerciseProgress progress;
  final bool isCardio;
  final WeightUnit unit;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final best = progress.bestTopSet;
    final est1rm = progress.bestEstOneRm;
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCardio ? l.statSessions : l.statBestTopSet,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCardio
                        ? '${progress.points.length}'
                        : best != null &&
                                best.weightKg != null &&
                                best.reps != null
                            ? '${formatWeightFromKg(best.weightKg!, unit)} × ${best.reps}'
                            : '—',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCardio ? l.statBestVolume : l.statEst1RM,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isCardio
                        ? formatVolumeFromKg(progress.bestTotalVolume, unit)
                        : est1rm != null
                            ? formatVolumeFromKg(est1rm, unit)
                            : '—',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.spots,
    required this.color,
    required this.points,
  });

  final List<FlSpot> spots;
  final Color color;
  final List<ExerciseSessionPoint> points;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LineChart(
      LineChartData(
        minY: 0,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(
            color: scheme.outlineVariant,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (v, _) => Text(
                v.toStringAsFixed(0),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              interval: spots.length > 6 ? (spots.length / 6).ceilToDouble() : 1,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= points.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat('M/d').format(points[i].date),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.2,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, bar, index) =>
                  FlDotCirclePainter(
                radius: 3,
                color: color,
                strokeColor: scheme.surface,
                strokeWidth: 2,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: color.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}
