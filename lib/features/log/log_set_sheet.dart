import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/exercise.dart';
import '../../domain/models/exercise_entry.dart';
import '../../domain/models/workout_set.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/preferences_provider.dart';
import '../shared/plate_calculator_sheet.dart';

/// Centered "Log set" dialog. Wraps [LogSetSheet] in a sized [Dialog] so the
/// form lives in the middle of the screen (instead of the older bottom-sheet
/// presentation). Returns the saved [WorkoutSet] or `null` on cancel.
Future<WorkoutSet?> showLogSetDialog(
  BuildContext context, {
  required ExerciseEntry entry,
  WorkoutSet? existing,
}) {
  return showDialog<WorkoutSet>(
    context: context,
    builder: (_) {
      final viewInsets = MediaQuery.of(context).viewInsets;
      return Dialog(
        insetPadding: EdgeInsets.fromLTRB(16, 24, 16, 24 + viewInsets.bottom),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 720),
          child: SingleChildScrollView(
            child: LogSetSheet(entry: entry, existing: existing),
          ),
        ),
      );
    },
  );
}

/// Form for logging or editing a single set. Designed to be hosted inside a
/// dialog (see [showLogSetDialog]) but is widget-only so callers can also drop
/// it into bottom sheets in tests.
///
/// Pops with a [WorkoutSet]:
///  - in *new* mode (no `existing`), the returned set has a fresh id and is
///    pre-filled from the previous set on the same entry to speed up logging
///  - in *edit* mode (`existing` non-null), the returned set keeps the same id
///    and the inputs start from `existing`'s values
///
/// Returns null if the user cancels.
class LogSetSheet extends ConsumerStatefulWidget {
  const LogSetSheet({
    super.key,
    required this.entry,
    this.existing,
  });

  final ExerciseEntry entry;
  final WorkoutSet? existing;

  @override
  ConsumerState<LogSetSheet> createState() => _LogSetSheetState();
}

class _LogSetSheetState extends ConsumerState<LogSetSheet> {
  final _weightCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  final _rirCtrl = TextEditingController();
  final _distanceKmCtrl = TextEditingController();
  final _durationCtrl = TextEditingController(); // mm:ss
  final _notesCtrl = TextEditingController();
  late final WeightUnit _unit;

  @override
  void initState() {
    super.initState();
    _unit = ref.read(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final source = widget.existing ??
        (widget.entry.sets.isNotEmpty ? widget.entry.sets.last : null);
    if (source != null) {
      if (source.weightKg != null) {
        _weightCtrl.text = _trimDouble(_unit.fromKg(source.weightKg!));
      }
      if (source.reps != null) _repsCtrl.text = '${source.reps}';
      if (widget.existing != null) {
        // Only pre-fill optional fields when *editing*; for "new set" we want
        // a clean slate beyond weight/reps.
        if (source.rir != null) _rirCtrl.text = '${source.rir}';
        if (source.distanceMeters != null) {
          _distanceKmCtrl.text = (source.distanceMeters! / 1000)
              .toStringAsFixed(2);
        }
        if (source.durationSeconds != null) {
          final m = source.durationSeconds! ~/ 60;
          final s = source.durationSeconds! % 60;
          _durationCtrl.text = '$m:${s.toString().padLeft(2, '0')}';
        }
        if (source.notes != null) _notesCtrl.text = source.notes!;
      }
    }
  }

  String _trimDouble(double v) =>
      v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);

  @override
  void dispose() {
    _weightCtrl.dispose();
    _repsCtrl.dispose();
    _rirCtrl.dispose();
    _distanceKmCtrl.dispose();
    _durationCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final isCardio = widget.entry.exercise.kind == ExerciseKind.cardio;
    final id = widget.existing?.id ??
        DateTime.now().microsecondsSinceEpoch.toString();
    final notes = _notesCtrl.text.trim();
    if (isCardio) {
      final km = double.tryParse(_distanceKmCtrl.text.trim());
      final dur = _parseDuration(_durationCtrl.text.trim());
      if (km == null && dur == null) return;
      Navigator.of(context).pop(
        WorkoutSet(
          id: id,
          distanceMeters: km != null ? km * 1000 : null,
          durationSeconds: dur,
          notes: notes.isEmpty ? null : notes,
        ),
      );
    } else {
      final wInput = double.tryParse(_weightCtrl.text.trim());
      final r = int.tryParse(_repsCtrl.text.trim());
      final rir = int.tryParse(_rirCtrl.text.trim());
      if (wInput == null || r == null) return;
      Navigator.of(context).pop(
        WorkoutSet(
          id: id,
          weightKg: _unit.toKg(wInput),
          reps: r,
          rir: rir,
          notes: notes.isEmpty ? null : notes,
        ),
      );
    }
  }

  int? _parseDuration(String text) {
    if (text.isEmpty) return null;
    if (text.contains(':')) {
      final parts = text.split(':');
      if (parts.length != 2) return null;
      final m = int.tryParse(parts[0]);
      final s = int.tryParse(parts[1]);
      if (m == null || s == null) return null;
      return m * 60 + s;
    }
    return int.tryParse(text);
  }

  Future<void> _openPlateCalc() async {
    final current = double.tryParse(_weightCtrl.text.trim());
    final picked = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PlateCalculatorSheet(
        unit: _unit,
        initialTotal: current,
      ),
    );
    if (picked != null) {
      setState(() {
        _weightCtrl.text = _trimDouble(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final isCardio = widget.entry.exercise.kind == ExerciseKind.cardio;
    final isEditing = widget.existing != null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.logSetHeader(
              isEditing ? l.editSetTitle : l.logSetTitle,
              widget.entry.exercise.name,
            ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (isCardio) ..._cardioFields() else ..._strengthFields(),
          const SizedBox(height: 12),
          TextField(
            controller: _notesCtrl,
            maxLines: 2,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              labelText: l.fieldNotes,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.actionCancel),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(isEditing ? l.actionUpdate : l.actionSaveSet),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _strengthFields() {
    final l = tr(context);
    final showRir = ref.watch(showRirProvider).maybeWhen(
          data: (v) => v,
          orElse: () => true,
        );
    return [
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _weightCtrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: l.fieldWeight(_unit.suffix),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calculate_outlined),
                  tooltip: l.plateCalcTitle,
                  onPressed: _openPlateCalc,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _repsCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: l.fieldReps,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      if (showRir) ...[
        const SizedBox(height: 12),
        TextField(
          controller: _rirCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: l.fieldRir,
            helperText: l.fieldRirHelper,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    ];
  }

  List<Widget> _cardioFields() {
    final l = tr(context);
    return [
      TextField(
        controller: _distanceKmCtrl,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        decoration: InputDecoration(
          labelText: l.fieldDistance,
          border: const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _durationCtrl,
        decoration: InputDecoration(
          labelText: l.fieldDuration,
          border: const OutlineInputBorder(),
        ),
      ),
    ];
  }
}
