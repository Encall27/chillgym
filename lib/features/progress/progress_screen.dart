import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/brand_title.dart';
import '../../app/drawer.dart';
import '../../domain/models/bodyweight_entry.dart';
import '../../domain/models/exercise.dart';
import '../../domain/progress_stats.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/body_photo_repository_provider.dart';
import '../../state/bodyweight_repository_provider.dart';
import '../../state/preferences_provider.dart';
import '../../state/session_repository_provider.dart';
import '../../theme/brand_tokens.dart';
import '../body/body_photo_sheet.dart';
import '../body/body_timeline_screen.dart';
import '../profile/bodyweight_section.dart';
import '../shared/design_primitives.dart';
import '../shared/entry_photos.dart';
import 'exercise_progress_detail.dart';

enum _ProgressMode { lifts, dayChanges }

enum _ChartRange { m1, m3, m6, y1, all }

extension on _ChartRange {
  Duration? get window => switch (this) {
        _ChartRange.m1 => const Duration(days: 30),
        _ChartRange.m3 => const Duration(days: 90),
        _ChartRange.m6 => const Duration(days: 180),
        _ChartRange.y1 => const Duration(days: 365),
        _ChartRange.all => null,
      };

  String label(AppLocalizations l) => switch (this) {
        _ChartRange.m1 => l.progressRange1M,
        _ChartRange.m3 => l.progressRange3M,
        _ChartRange.m6 => l.progressRange6M,
        _ChartRange.y1 => l.progressRange1Y,
        _ChartRange.all => l.progressRangeAll,
      };
}

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  _ProgressMode _mode = _ProgressMode.lifts;
  _ChartRange _range = _ChartRange.m3;
  String? _featuredId;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final asyncSessions = ref.watch(pastSessionsProvider);
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const BrandTitle(),
        centerTitle: true,
      ),
      body: asyncSessions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.loadFailed(e.toString()))),
        data: (sessions) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: SegmentedButton<_ProgressMode>(
                  segments: [
                    ButtonSegment(
                      value: _ProgressMode.lifts,
                      label: Text(l.progressLifts),
                      icon: const Icon(Icons.fitness_center),
                    ),
                    ButtonSegment(
                      value: _ProgressMode.dayChanges,
                      label: Text(l.progressDayChanges),
                      icon: const Icon(Icons.photo_library_outlined),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (s) =>
                      setState(() => _mode = s.first),
                ),
              ),
              Expanded(
                child: _mode == _ProgressMode.lifts
                    ? _liftsView(sessions, unit, l)
                    : const _DayChangesView(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _liftsView(List sessions, WeightUnit unit, AppLocalizations l) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final all = buildExerciseProgress(sessions.cast())
        .where((p) => p.exercise.kind == ExerciseKind.strength)
        .toList();
    if (all.isEmpty) {
      return _Empty(
        icon: Icons.show_chart,
        title: l.progressNothingYet,
        body: l.progressLogMore,
      );
    }
    all.sort((a, b) => b.bestTotalVolume.compareTo(a.bestTotalVolume));
    final featured = _featuredId == null
        ? all.first
        : all.firstWhere(
            (p) => p.exercise.id == _featuredId,
            orElse: () => all.first,
          );
    final pbs = [...all]
      ..sort((a, b) {
        final av = a.bestTopSet?.weightKg ?? 0;
        final bv = b.bestTopSet?.weightKg ?? 0;
        return bv.compareTo(av);
      });

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _HeroLiftCard(
          progress: featured,
          range: _range,
          unit: unit,
          brand: brand,
          scheme: scheme,
          onPickLift: () => _openLiftPicker(all),
          onOpenDetail: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  ExerciseProgressDetail(progress: featured, unit: unit),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _RangeChips(
          range: _range,
          onChange: (r) => setState(() => _range = r),
        ),
        const SizedBox(height: 18),
        EyebrowLabel(l.progressPersonalBests),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              for (var i = 0; i < pbs.take(6).length; i++) ...[
                _PrRow(
                  progress: pbs[i],
                  unit: unit,
                  markerColor: switch (i % 4) {
                    0 => brand.amberDeep,
                    1 => brand.positive,
                    2 => brand.info,
                    _ => brand.warning,
                  },
                ),
                if (i < pbs.take(6).length - 1)
                  Divider(
                    color: scheme.outlineVariant,
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _openLiftPicker(List<ExerciseProgress> all) async {
    final l = tr(context);
    final picked = await showDialog<String>(
      context: context,
      builder: (dialogCtx) => Dialog(
        insetPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 540),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 4),
                child: Row(
                  children: [
                    Expanded(child: EyebrowLabel(l.progressPickLift)),
                    IconButton(
                      onPressed: () => Navigator.of(dialogCtx).pop(),
                      icon: const Icon(Icons.close),
                      tooltip: l.actionClose,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: all.length,
                  itemBuilder: (_, i) {
                    final p = all[i];
                    return ListTile(
                      leading: const Icon(Icons.fitness_center),
                      title: Text(p.exercise.name),
                      subtitle: Text(l.muscleLabel(p.exercise.primaryMuscle)),
                      onTap: () =>
                          Navigator.of(dialogCtx).pop(p.exercise.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) setState(() => _featuredId = picked);
  }
}

// =====================================================================
// Lifts: hero, range chips, PRs, bodyweight card
// =====================================================================

class _HeroLiftCard extends StatelessWidget {
  const _HeroLiftCard({
    required this.progress,
    required this.range,
    required this.unit,
    required this.brand,
    required this.scheme,
    required this.onPickLift,
    required this.onOpenDetail,
  });

  final ExerciseProgress progress;
  final _ChartRange range;
  final WeightUnit unit;
  final BrandTokens brand;
  final ColorScheme scheme;
  final VoidCallback onPickLift;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final cutoff = range.window == null
        ? null
        : DateTime.now().subtract(range.window!);
    final pts = progress.points
        .where((p) => cutoff == null || p.date.isAfter(cutoff))
        .toList();
    double? bestInRange;
    for (final p in pts) {
      final v = p.estOneRm;
      if (v == null) continue;
      if (bestInRange == null || v > bestInRange) bestInRange = v;
    }
    bestInRange ??= progress.bestEstOneRm;

    double? delta;
    if (pts.length >= 2) {
      final firstWithRm = pts.firstWhere(
        (p) => p.estOneRm != null,
        orElse: () => pts.first,
      );
      final lastWithRm = pts.lastWhere(
        (p) => p.estOneRm != null,
        orElse: () => pts.last,
      );
      if (firstWithRm.estOneRm != null && lastWithRm.estOneRm != null) {
        delta = lastWithRm.estOneRm! - firstWithRm.estOneRm!;
      }
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < pts.length; i++) {
      final v = pts[i].estOneRm ?? pts[i].topSet?.weightKg;
      if (v == null) continue;
      spots.add(FlSpot(i.toDouble(), unit.fromKg(v)));
    }

    return InkWell(
      onTap: onOpenDetail,
      onLongPress: onPickLift,
      borderRadius: BorderRadius.circular(20),
      child: Card(
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: RadialGradient(
                    center: const Alignment(1.0, -1.0),
                    radius: 0.9,
                    colors: [
                      scheme.primary.withValues(alpha: 0.13),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EyebrowLabel(l.progressFeatured),
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: onPickLift,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            progress.exercise.name,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        bestInRange == null
                            ? '—'
                            : unit.fromKg(bestInRange).toStringAsFixed(0),
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        unit.suffix,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                      const Spacer(),
                      if (delta != null && delta.abs() > 0.5)
                        Text(
                          delta > 0
                              ? l.progressDeltaUp(
                                  '${unit.fromKg(delta).toStringAsFixed(0)} ${unit.suffix}',
                                )
                              : l.progressDeltaDown(
                                  '${unit.fromKg(delta.abs()).toStringAsFixed(0)} ${unit.suffix}',
                                ),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: delta > 0 ? brand.positive : scheme.error,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 110,
                    child: spots.length < 2
                        ? Center(
                            child: Text(
                              l.progressNoLiftYet,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          )
                        : LineChart(
                            LineChartData(
                              minY: 0,
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (_) => FlLine(
                                  color: scheme.outlineVariant,
                                  strokeWidth: 1,
                                  dashArray:
                                      brand.useGlow ? const [2, 4] : null,
                                ),
                              ),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: true,
                                  curveSmoothness: 0.18,
                                  color: brand.amberDeep,
                                  barWidth: 2.5,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    checkToShowDot: (s, b) =>
                                        s.x == spots.last.x,
                                    getDotPainter: (s, _, __, ___) =>
                                        FlDotCirclePainter(
                                      radius: 4,
                                      color: brand.amberDeep,
                                      strokeColor: scheme.surface,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        scheme.primary.withValues(alpha: 0.5),
                                        scheme.primary.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeChips extends StatelessWidget {
  const _RangeChips({required this.range, required this.onChange});

  final _ChartRange range;
  final void Function(_ChartRange) onChange;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    return Row(
      children: [
        for (final r in _ChartRange.values) ...[
          Expanded(
            child: InkWell(
              onTap: () => onChange(r),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: EdgeInsets.only(right: r == _ChartRange.all ? 0 : 6),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: r == range
                      ? brand.amberPale
                      : scheme.surfaceContainerHigh,
                  border: Border.all(
                    color: r == range
                        ? scheme.primary.withValues(alpha: 0.5)
                        : scheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  r.label(l),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: r == range
                        ? brand.amberDeep
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PrRow extends StatelessWidget {
  const _PrRow({
    required this.progress,
    required this.unit,
    required this.markerColor,
  });

  final ExerciseProgress progress;
  final WeightUnit unit;
  final Color markerColor;

  bool _isRecent() {
    final best = progress.bestTopSet;
    if (best == null) return false;
    final newestDate = progress.points
        .where((p) => p.topSet == best || p.topSet?.weightKg == best.weightKg)
        .map((p) => p.date)
        .fold<DateTime?>(
            null, (acc, d) => acc == null || d.isAfter(acc) ? d : acc);
    if (newestDate == null) return false;
    return DateTime.now().difference(newestDate) < const Duration(days: 30);
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final best = progress.bestTopSet;
    final subtitle = best == null || best.weightKg == null || best.reps == null
        ? l.sessionsLogged(progress.points.length)
        : '${formatWeightFromKg(best.weightKg!, unit)} × ${best.reps}';
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              ExerciseProgressDetail(progress: progress, unit: unit),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: markerColor,
                borderRadius: BorderRadius.circular(2),
                boxShadow: brand.useGlow
                    ? [
                        BoxShadow(
                          color: markerColor.withValues(alpha: 0.5),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progress.exercise.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                ],
              ),
            ),
            if (_isRecent())
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: brand.amberPale,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  l.progressPrNewBadge,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: brand.amberDeep,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Bodyweight trend card. Headline reading + delta vs 7d ago, then a chart
/// with weight-axis labels (e.g. kg), date-axis labels, a 7-day rolling
/// average overlay, and dashed min/max guide lines. A stat strip below the
/// chart surfaces MIN / MAX / AVG so users can read trend at a glance.
class _BodyweightCard extends ConsumerWidget {
  const _BodyweightCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final asyncEntries = ref.watch(bodyweightEntriesProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: asyncEntries.when(
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text(l.loadFailed(e.toString())),
          data: (entries) {
            if (entries.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l.progressBodyweightEmpty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              );
            }
            final asc = [...entries]
              ..sort((a, b) => a.date.compareTo(b.date));
            final latest = asc.last;
            final cutoff = DateTime.now().subtract(const Duration(days: 7));
            BodyweightEntry? weekAgo;
            for (final e in asc) {
              if (e.date.isBefore(cutoff)) weekAgo = e;
            }
            final delta = weekAgo == null
                ? null
                : latest.weightKg - weekAgo.weightKg;

            // Display series in the user's preferred unit.
            final values = asc.map((e) => unit.fromKg(e.weightKg)).toList();
            final spots = [
              for (var i = 0; i < values.length; i++)
                FlSpot(i.toDouble(), values[i]),
            ];
            final smooth = _rollingAvgSpots(values);

            final minV = values.reduce((a, b) => a < b ? a : b);
            final maxV = values.reduce((a, b) => a > b ? a : b);
            final avgV = values.reduce((a, b) => a + b) / values.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      formatWeightFromKg(latest.weightKg, unit)
                          .replaceAll(' ${unit.suffix}', ''),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      unit.suffix,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const Spacer(),
                    if (delta != null && delta.abs() > 0.05)
                      Text(
                        l.progressBodyweightDelta7(
                          (delta > 0 ? '+' : '') +
                              unit.fromKg(delta).toStringAsFixed(1),
                          unit.suffix,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: delta > 0 ? brand.warning : brand.positive,
                        ),
                      ),
                  ],
                ),
                Text(
                  DateFormat.MMMEd(
                    Localizations.localeOf(context).toString(),
                  ).format(latest.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
                if (spots.length >= 2) ...[
                  const SizedBox(height: 12),
                  Text(
                    _trendLine(context, l, asc, unit),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: _BodyweightChartBody(
                      asc: asc,
                      spots: spots,
                      smooth: smooth,
                      unit: unit,
                      minV: minV,
                      maxV: maxV,
                      avgV: avgV,
                      lineColor: brand.info,
                      smoothColor: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _StatStrip(
                    minV: minV,
                    maxV: maxV,
                    avgV: avgV,
                    unit: unit,
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  /// 7-day rolling average over the same x-axis as the raw points. Index
  /// matches `values` 1:1 so we can plot it as a second LineChartBarData.
  static List<FlSpot> _rollingAvgSpots(List<double> values) {
    const window = 7;
    final out = <FlSpot>[];
    for (var i = 0; i < values.length; i++) {
      final start = (i - window + 1).clamp(0, values.length);
      final slice = values.sublist(start, i + 1);
      final mean = slice.reduce((a, b) => a + b) / slice.length;
      out.add(FlSpot(i.toDouble(), mean));
    }
    return out;
  }

  String _trendLine(
    BuildContext context,
    AppLocalizations l,
    List<BodyweightEntry> asc,
    WeightUnit unit,
  ) {
    final first = asc.first;
    final last = asc.last;
    final days = last.date.difference(first.date).inDays;
    final diffKg = last.weightKg - first.weightKg;
    final diffDisplay = unit.fromKg(diffKg).abs();
    final amount = diffDisplay % 1 == 0
        ? diffDisplay.toStringAsFixed(0)
        : diffDisplay.toStringAsFixed(1);
    if (diffKg.abs() < 0.2) return l.bodyweightTrendFlat(days);
    if (diffKg > 0) return l.bodyweightTrendUp(amount, unit.suffix, days);
    return l.bodyweightTrendDown(amount, unit.suffix, days);
  }
}

class _BodyweightChartBody extends StatelessWidget {
  const _BodyweightChartBody({
    required this.asc,
    required this.spots,
    required this.smooth,
    required this.unit,
    required this.minV,
    required this.maxV,
    required this.avgV,
    required this.lineColor,
    required this.smoothColor,
  });

  final List<BodyweightEntry> asc;
  final List<FlSpot> spots;
  final List<FlSpot> smooth;
  final WeightUnit unit;
  final double minV;
  final double maxV;
  final double avgV;
  final Color lineColor;
  final Color smoothColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Y-axis padding so the line never touches the top/bottom edge.
    final pad = ((maxV - minV) * 0.15).clamp(0.5, double.infinity);
    final yMin = minV - pad;
    final yMax = maxV + pad;
    final ySpan = yMax - yMin;
    // Pick ~4 horizontal grid lines, rounded to a sensible step.
    final step = _niceStep(ySpan / 4);

    final xMax = (spots.length - 1).toDouble();
    final dateFmt = DateFormat.Md(Localizations.localeOf(context).toString());
    // Show ~3 date labels: first / mid / last. Computed by index.
    final labelIndices = <int>{
      0,
      if (spots.length > 2) spots.length ~/ 2,
      spots.length - 1,
    };

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: xMax,
        minY: yMin,
        maxY: yMax,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: step,
          getDrawingHorizontalLine: (_) => FlLine(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            axisNameWidget: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                unit.suffix.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
              ),
            ),
            axisNameSize: 16,
            sideTitles: SideTitles(
              showTitles: true,
              interval: step,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                if ((value - yMin).abs() < 0.001 ||
                    (value - yMax).abs() < 0.001) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    value.toStringAsFixed(value % 1 == 0 ? 0 : 1),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= asc.length) return const SizedBox.shrink();
                if (!labelIndices.contains(i)) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    dateFmt.format(asc[i].date),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                );
              },
            ),
          ),
        ),
        // Horizontal guides for min / max.
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: maxV,
              color: scheme.error.withValues(alpha: 0.45),
              strokeWidth: 1,
              dashArray: [4, 3],
            ),
            HorizontalLine(
              y: minV,
              color: smoothColor.withValues(alpha: 0.45),
              strokeWidth: 1,
              dashArray: [4, 3],
            ),
          ],
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) =>
                scheme.surfaceContainerHigh.withValues(alpha: 0.95),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((s) {
                final i = s.x.toInt();
                if (i < 0 || i >= asc.length) return null;
                final entry = asc[i];
                final v = unit.fromKg(entry.weightKg);
                final formatted =
                    v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
                return LineTooltipItem(
                  '$formatted ${unit.suffix}\n${dateFmt.format(entry.date)}',
                  Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ) ??
                      const TextStyle(),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          // Raw daily readings — thin grey line with small dots for context.
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: scheme.outlineVariant,
            barWidth: 1.2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                radius: 2,
                color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                strokeWidth: 0,
              ),
            ),
          ),
          // 7-day rolling average — emphasised line + soft area below.
          LineChartBarData(
            spots: smooth,
            isCurved: true,
            curveSmoothness: 0.22,
            color: lineColor,
            barWidth: 2.4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lineColor.withValues(alpha: 0.25),
                  lineColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Round a raw step (e.g. 1.37) to a user-friendly chart interval like 1, 2,
  /// 5, 10. Picked from a fixed list anchored at the magnitude of `raw`.
  static double _niceStep(double raw) {
    if (raw <= 0) return 1;
    final pow10 = _pow10(raw);
    final base = raw / pow10;
    final pick = base <= 1
        ? 1.0
        : base <= 2
            ? 2.0
            : base <= 5
                ? 5.0
                : 10.0;
    return pick * pow10;
  }

  static double _pow10(double v) {
    var p = 1.0;
    while (v >= 10) {
      v /= 10;
      p *= 10;
    }
    while (v < 1 && p > 0.001) {
      v *= 10;
      p /= 10;
    }
    return p;
  }
}

class _StatStrip extends StatelessWidget {
  const _StatStrip({
    required this.minV,
    required this.maxV,
    required this.avgV,
    required this.unit,
  });

  final double minV;
  final double maxV;
  final double avgV;
  final WeightUnit unit;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    String fmt(double v) =>
        v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
    final range = maxV - minV;
    Widget cell(String label, String value) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              '$value ${unit.suffix}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          cell(l.bodyweightStatMin, fmt(minV)),
          cell(l.bodyweightStatMax, fmt(maxV)),
          cell(l.bodyweightStatAvg, fmt(avgV)),
          cell(l.bodyweightStatRange, fmt(range)),
        ],
      ),
    );
  }
}

// =====================================================================
// Day Changes: body progress photos
// =====================================================================

class _DayChangesView extends ConsumerWidget {
  const _DayChangesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final asyncPhotos = ref.watch(bodyPhotosProvider);

    return asyncPhotos.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.loadFailed(e.toString()))),
      data: (photos) {
        final dateFmt =
            DateFormat.MMMd(Localizations.localeOf(context).toString());
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: EyebrowLabel(l.progressBodyweightTitle),
                    ),
                    TextButton.icon(
                      onPressed: () => showBodyweightLogSheet(context).then(
                        (_) => ref.invalidate(bodyweightEntriesProvider),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(l.actionLogWeight),
                      style: TextButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverToBoxAdapter(child: _BodyweightCard()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EyebrowLabel(l.bodyPhotosTitle.toUpperCase()),
                          const SizedBox(height: 2),
                          Text(
                            photos.isEmpty
                                ? l.bodyPhotosEmpty
                                : l.bodyPhotosCount(photos.length),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    if (photos.length >= 2)
                      FilledButton.tonalIcon(
                        onPressed: () {
                          final chrono = [...photos]
                            ..sort((a, b) => a.date.compareTo(b.date));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BodyTimelineScreen(
                                entries: chrono,
                                unit: unit,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: Text(l.bodyPhotosPlay),
                      ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              sliver: SliverToBoxAdapter(
                child: OutlinedButton.icon(
                  onPressed: () => _addPhoto(context),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: Text(l.bodyPhotosAdd),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ),
            ),
            if (photos.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _Empty(
                  icon: Icons.photo_library_outlined,
                  title: l.bodyPhotosEmpty,
                  body: l.bodyPhotosEmptyHelp,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final entry = photos[i];
                      return InkWell(
                        onTap: () => showModalBottomSheet<bool>(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => BodyPhotoSheet(existing: entry),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: PhotoRefImage(
                                  ref: entry.photoRef,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateFmt.format(entry.date),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            if (entry.weightKg != null)
                              Text(
                                formatWeightFromKg(entry.weightKg!, unit),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: photos.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _addPhoto(BuildContext context) async {
    final picked = await pickAndPersistPhoto(context, compact: true);
    if (picked == null || !context.mounted) return;
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BodyPhotoSheet(newPhotoRef: picked),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: scheme.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
