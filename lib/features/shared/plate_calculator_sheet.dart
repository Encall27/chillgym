import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../domain/plate_math.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';

/// Bottom sheet plate calculator. Pops with the chosen total weight (in the
/// user's preferred unit) or null on cancel — the caller is responsible for
/// any further conversion.
class PlateCalculatorSheet extends StatefulWidget {
  const PlateCalculatorSheet({
    super.key,
    required this.unit,
    this.initialTotal,
  });

  final WeightUnit unit;

  /// Pre-filled total in [unit], or null for the default.
  final double? initialTotal;

  @override
  State<PlateCalculatorSheet> createState() => _PlateCalculatorSheetState();
}

class _PlateCalculatorSheetState extends State<PlateCalculatorSheet> {
  late final TextEditingController _totalCtrl;
  late final TextEditingController _barCtrl;

  double get _defaultBar =>
      widget.unit == WeightUnit.kg ? kDefaultBarKg : kDefaultBarLb;

  List<double> get _plates => widget.unit == WeightUnit.kg
      ? kStandardPlatesKg
      : kStandardPlatesLb;

  String get _suffix => widget.unit.suffix;

  @override
  void initState() {
    super.initState();
    final fallback = widget.unit == WeightUnit.kg ? '60' : '135';
    _totalCtrl = TextEditingController(
      text: widget.initialTotal != null
          ? _trim(widget.initialTotal!)
          : fallback,
    );
    _barCtrl = TextEditingController(text: _trim(_defaultBar));
  }

  @override
  void dispose() {
    _totalCtrl.dispose();
    _barCtrl.dispose();
    super.dispose();
  }

  String _trim(double v) =>
      v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final viewInsets = MediaQuery.of(context).viewInsets;
    final scheme = Theme.of(context).colorScheme;
    final total = double.tryParse(_totalCtrl.text.trim()) ?? 0;
    final bar = double.tryParse(_barCtrl.text.trim()) ?? _defaultBar;
    final breakdown = calculatePlates(
      target: total,
      bar: bar,
      availablePlates: _plates,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 24 + viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.plateCalcTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _totalCtrl,
                  autofocus: widget.initialTotal == null,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    labelText: l.plateCalcTotal(_suffix),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 110,
                child: TextField(
                  controller: _barCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    labelText: l.plateCalcBar(_suffix),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l.plateCalcPerSide,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          if (breakdown.platesPerSide.isEmpty)
            Text(
              total <= bar ? l.plateCalcJustBar : l.plateCalcNoPlates,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: breakdown.platesPerSide
                  .map((p) => Chip(
                        label: Text('${_trim(p)} $_suffix'),
                        backgroundColor: scheme.primaryContainer,
                      ))
                  .toList(),
            ),
          const SizedBox(height: 12),
          if (!breakdown.exact)
            Text(
              l.plateCalcUnaccounted(_trim(breakdown.unaccounted), _suffix),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.error,
                  ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.actionClose),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: total > 0
                    ? () => Navigator.of(context).pop(total)
                    : null,
                icon: const Icon(Icons.check),
                label: Text(l.actionUseThisWeight),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
