import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/models/body_photo_entry.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../state/body_photo_repository_provider.dart';
import '../../state/preferences_provider.dart';
import '../shared/entry_photos.dart';

/// Modal sheet for adding or editing the metadata around a body photo. The
/// `existing` argument carries the (already-persisted) photoRef on add and the
/// full entry on edit. Returns true on save / delete so the caller can refresh.
class BodyPhotoSheet extends ConsumerStatefulWidget {
  const BodyPhotoSheet({
    super.key,
    this.existing,
    this.newPhotoRef,
  }) : assert(existing != null || newPhotoRef != null,
            'Either an existing entry or a freshly picked photoRef is required');

  final BodyPhotoEntry? existing;
  final String? newPhotoRef;

  @override
  ConsumerState<BodyPhotoSheet> createState() => _BodyPhotoSheetState();
}

class _BodyPhotoSheetState extends ConsumerState<BodyPhotoSheet> {
  final _noteCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final now = DateTime.now();
    _date = e?.date ?? DateTime(now.year, now.month, now.day);
    if (e?.note != null) _noteCtrl.text = e!.note!;
    final unit = ref.read(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    if (e?.weightKg != null) {
      final v = unit.fromKg(e!.weightKg!);
      _weightCtrl.text = v % 1 == 0
          ? v.toStringAsFixed(0)
          : v.toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final l = tr(context);
    final messenger = ScaffoldMessenger.of(context);
    final unit = ref.read(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final repo = await ref.read(bodyPhotoRepositoryProvider.future);
    final note = _noteCtrl.text.trim();
    final wInput = double.tryParse(_weightCtrl.text.trim());
    final weightKg = wInput == null ? null : unit.toKg(wInput);
    final entry = BodyPhotoEntry(
      id: widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      date: _date,
      photoRef: widget.existing?.photoRef ?? widget.newPhotoRef!,
      weightKg: weightKg,
      note: note.isEmpty ? null : note,
    );
    try {
      await repo.save(entry);
    } catch (e) {
      // localStorage on web caps at ~5MB per origin. When we blow it, give
      // the user a real explanation instead of a stack trace from
      // shared_preferences.
      final msg = _isQuotaError(e)
          ? l.bodyPhotosQuotaError
          : l.genericFailed(e.toString());
      messenger.showSnackBar(SnackBar(content: Text(msg)));
      return;
    }
    ref.invalidate(bodyPhotosProvider);
    if (mounted) Navigator.of(context).pop(true);
  }

  bool _isQuotaError(Object e) {
    final s = e.toString().toLowerCase();
    return s.contains('quota') || s.contains('exceeded');
  }

  Future<void> _delete() async {
    final l = tr(context);
    final id = widget.existing?.id;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.bodyPhotosDeletePrompt),
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
    if (ok != true) return;
    final repo = await ref.read(bodyPhotoRepositoryProvider.future);
    await repo.delete(id);
    ref.invalidate(bodyPhotosProvider);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final viewInsets = MediaQuery.of(context).viewInsets;
    final dateFmt = DateFormat.yMMMEd(
      Localizations.localeOf(context).toString(),
    );
    final photoRef = widget.existing?.photoRef ?? widget.newPhotoRef!;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 24 + viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing == null
                  ? l.bodyPhotosAddTitle
                  : l.bodyPhotosEditTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 220,
                  child: PhotoRefImage(
                    ref: photoRef,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text('${l.bodyPhotosDate}: ${dateFmt.format(_date)}'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _weightCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: l.bodyPhotosWeightOptional(unit.suffix),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteCtrl,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: l.bodyPhotosNoteHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                if (widget.existing != null)
                  TextButton.icon(
                    onPressed: _delete,
                    icon: const Icon(Icons.delete_outline),
                    label: Text(l.actionDelete),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
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
      ),
    );
  }
}
