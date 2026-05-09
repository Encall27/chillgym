import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/brand_tokens.dart';

/// Tiny uppercase label with letter-spacing — the design's "eyebrow" element
/// that sits above titles ("● ON FIRE", "NEXT UP", "RESTING", etc.).
class EyebrowLabel extends StatelessWidget {
  const EyebrowLabel(
    this.text, {
    super.key,
    this.color,
    this.dot = false,
  });

  final String text;
  final Color? color;

  /// When true, renders a leading "● " bullet in the same colour. Used by
  /// stateful labels like "● ON FIRE" / "● THAT'S GOOD".
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = color ?? scheme.onSurfaceVariant;
    return Text(
      dot ? '●  $text' : text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: c,
      ),
    );
  }
}

/// Lightweight polyline sparkline — 7-day metric trend in the home grid.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    required this.color,
    this.height = 24,
    this.strokeWidth = 1.5,
  });

  final List<double> values;
  final Color color;
  final double height;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(values, color, strokeWidth),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values, this.color, this.strokeWidth);
  final List<double> values;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxV = values.reduce(math.max);
    final minV = values.reduce(math.min);
    final range = maxV - minV;
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = i / (values.length - 1) * size.width;
      // Normalised against actual range; flat data sits at the bottom edge.
      final y = range == 0
          ? size.height * 0.5
          : size.height - ((values[i] - minV) / range) * size.height;
      points.add(Offset(x, y));
    }
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color;
}

/// Circular streak ring — used in the home hero card. Draws a track ring
/// underneath and a foreground arc proportional to `progress` (0..1).
class StreakRing extends StatelessWidget {
  const StreakRing({
    super.key,
    required this.progress,
    required this.size,
    this.strokeWidth = 6,
    this.label,
    this.subLabel,
    this.useGlow = false,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Widget? label;
  final Widget? subLabel;
  final bool useGlow;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _RingPainter(
              progress: progress.clamp(0, 1),
              trackColor: scheme.outlineVariant,
              fillColor: scheme.primary,
              strokeWidth: strokeWidth,
              useGlow: useGlow,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.titleLarge!,
                  child: label!,
                ),
              if (subLabel != null)
                DefaultTextStyle.merge(
                  style: Theme.of(context).textTheme.labelSmall!,
                  child: subLabel!,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.fillColor,
    required this.strokeWidth,
    required this.useGlow,
  });

  final double progress;
  final Color trackColor;
  final Color fillColor;
  final double strokeWidth;
  final bool useGlow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final track = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, track);
    if (progress <= 0) return;

    final fill = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    if (useGlow) {
      fill.maskFilter = const MaskFilter.blur(BlurStyle.solid, 3);
    }
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, fill);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress ||
      old.fillColor != fillColor ||
      old.useGlow != useGlow;
}

/// 14-segment streak strip from the home hero card. Filled for the count of
/// consecutive trained days, empty for the rest.
class StreakStrip extends StatelessWidget {
  const StreakStrip({
    super.key,
    required this.filled,
    required this.total,
  });

  final int filled;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    return Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i < filled ? scheme.primary : scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
                boxShadow: brand.useGlow && i < filled
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.4),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
          if (i < total - 1) const SizedBox(width: 3),
        ],
      ],
    );
  }
}

/// Compact metric tile — eyebrow + big number + unit + sparkline.
/// Used in the Home 2×2 grid.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    this.sparkline = const [],
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final List<double> sparkline;

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            EyebrowLabel(label, color: color),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: brand.useGlow
                        ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            )
                        : Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            if (sparkline.isNotEmpty) ...[
              const SizedBox(height: 6),
              Sparkline(values: sparkline, color: color),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pill-shaped "+8 KG" badge used to highlight a suggested progression on
/// the Active workout exercise card.
class AccentPill extends StatelessWidget {
  const AccentPill({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: brand.amberPale,
        border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: brand.amberDeep,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

/// Small status dot (✓ when set is logged, ○ while pending) used in the
/// Active workout set table.
class SetStatusGlyph extends StatelessWidget {
  const SetStatusGlyph({super.key, required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    return Text(
      done ? '✓' : '○',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: done ? brand.positive : scheme.primary,
      ),
    );
  }
}

/// "AI nudge" callout — left-bordered amber-tinted card surfaced under the
/// active exercise. Wraps any child (typically the feedback rationale).
class AccentCallout extends StatelessWidget {
  const AccentCallout({
    super.key,
    required this.eyebrow,
    required this.body,
    this.color,
  });

  final String eyebrow;
  final Widget body;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final c = color ?? scheme.primary;
    // Flutter rejects a borderRadius on a non-uniform Border, so the colored
    // left edge is painted as a separate Container child instead of a thick
    // BorderSide. Outer Container keeps a uniform-color border + rounded
    // corners; inner Row glues the 3px stripe to the content.
    return Container(
      decoration: BoxDecoration(
        color: brand.amberPale,
        border: Border.all(color: c.withValues(alpha: 0.35)),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: c),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EyebrowLabel(eyebrow, color: brand.amberDeep, dot: true),
                    const SizedBox(height: 4),
                    DefaultTextStyle.merge(
                      style: Theme.of(context).textTheme.bodyMedium!,
                      child: body,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
