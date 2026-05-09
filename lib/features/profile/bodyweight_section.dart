import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/bodyweight_entry.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/bodyweight_repository_provider.dart';
import '../../state/preferences_provider.dart';

/// Opens the bodyweight log sheet. Call sites (currently Progress → Day
/// Changes "+ Log weight") use this entry point. Profile no longer hosts a
/// bodyweight section — bodyweight lives entirely on Progress now.
Future<void> showBodyweightLogSheet(
  BuildContext context, {
  BodyweightEntry? existing,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _BodyweightSheet(existing: existing),
  );
}

class _BodyweightSheet extends ConsumerStatefulWidget {
  const _BodyweightSheet({this.existing});
  final BodyweightEntry? existing;

  @override
  ConsumerState<_BodyweightSheet> createState() => _BodyweightSheetState();
}

class _BodyweightSheetState extends ConsumerState<_BodyweightSheet> {
  final _weightCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  late DateTime _date;
  late final WeightUnit _unit;

  @override
  void initState() {
    super.initState();
    _unit = ref.read(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final e = widget.existing;
    final now = DateTime.now();
    _date = e?.date ?? DateTime(now.year, now.month, now.day);
    if (e != null) {
      final v = _unit.fromKg(e.weightKg);
      _weightCtrl.text =
          v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
      if (e.note != null) _noteCtrl.text = e.note!;
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final input = double.tryParse(_weightCtrl.text.trim());
    if (input == null) return;
    final repo = await ref.read(bodyweightRepositoryProvider.future);
    final note = _noteCtrl.text.trim();
    await repo.save(BodyweightEntry(
      date: _date,
      weightKg: _unit.toKg(input),
      note: note.isEmpty ? null : note,
    ));
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final existing = widget.existing;
    if (existing == null) return;
    final repo = await ref.read(bodyweightRepositoryProvider.future);
    await repo.delete(existing.date);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final viewInsets = MediaQuery.of(context).viewInsets;
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
            widget.existing == null
                ? l.bodyweightLogTitle
                : l.bodyweightEditTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightCtrl,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            decoration: InputDecoration(
              labelText: l.bodyweightInputLabel(_unit.suffix),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(
              DateFormat.yMMMEd(
                Localizations.localeOf(context).toString(),
              ).format(_date),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: l.fieldNote,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.existing != null)
                TextButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l.actionDelete),
                ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.actionCancel),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(
                    widget.existing == null ? l.actionSave : l.actionUpdate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
