import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/brand_title.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/muscle_group.dart';
import '../../l10n/translations.dart';
import '../../state/exercise_catalog_provider.dart';

class CustomExerciseEditor extends ConsumerStatefulWidget {
  const CustomExerciseEditor({super.key, this.existing});

  final Exercise? existing;

  @override
  ConsumerState<CustomExerciseEditor> createState() =>
      _CustomExerciseEditorState();
}

class _CustomExerciseEditorState extends ConsumerState<CustomExerciseEditor> {
  late final TextEditingController _name;
  late ExerciseKind _kind;
  late Equipment _equipment;
  late MuscleGroup _primary;
  late Set<MuscleGroup> _secondary;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _name = TextEditingController(text: e?.name ?? '');
    _kind = e?.kind ?? ExerciseKind.strength;
    _equipment = e?.equipment ?? Equipment.other;
    _primary = e?.primaryMuscle ?? MuscleGroup.chest;
    _secondary = {...?e?.secondaryMuscles};
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  String _newId() =>
      'custom-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';

  Future<void> _save() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final repo =
        await ref.read(customExerciseRepositoryProvider.future);
    final exercise = Exercise(
      id: widget.existing?.id ?? _newId(),
      name: name,
      primaryMuscle:
          _kind == ExerciseKind.cardio ? MuscleGroup.cardio : _primary,
      secondaryMuscles: _kind == ExerciseKind.cardio
          ? const []
          : _secondary.toList(),
      kind: _kind,
      equipment: _kind == ExerciseKind.cardio ? Equipment.other : _equipment,
      isCustom: true,
    );
    await repo.save(exercise);
    ref.invalidate(customExercisesProvider);
    if (mounted) Navigator.of(context).pop(exercise);
  }

  Future<void> _delete() async {
    final l = tr(context);
    final existing = widget.existing;
    if (existing == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.libraryDeleteExercisePrompt),
        content: Text(l.libraryDeleteExerciseHelp),
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
    final repo = await ref.read(customExerciseRepositoryProvider.future);
    await repo.delete(existing.id);
    ref.invalidate(customExercisesProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final isCardio = _kind == ExerciseKind.cardio;
    return Scaffold(
      appBar: AppBar(
        title: BrandTitle(
          subtitle: widget.existing == null
              ? l.libraryNewExercise
              : l.libraryEditExercise,
        ),
        centerTitle: true,
        actions: [
          if (widget.existing != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l.actionDelete,
              onPressed: _delete,
            ),
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: Text(l.actionSave),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l.libraryExerciseName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.libraryExerciseType,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 4),
          SegmentedButton<ExerciseKind>(
            segments: [
              ButtonSegment(
                value: ExerciseKind.strength,
                label: Text(l.kindStrength),
                icon: const Icon(Icons.fitness_center),
              ),
              ButtonSegment(
                value: ExerciseKind.cardio,
                label: Text(l.kindCardio),
                icon: const Icon(Icons.directions_run),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
          if (!isCardio) ...[
            const SizedBox(height: 16),
            Text(
              l.equipmentLabel,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final eq in Equipment.values)
                  ChoiceChip(
                    label: Text(l.equipmentLabelOf(eq)),
                    selected: _equipment == eq,
                    onSelected: (_) => setState(() => _equipment = eq),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l.libraryPrimaryMuscle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final g in MuscleGroup.values)
                  if (g != MuscleGroup.cardio)
                    ChoiceChip(
                      label: Text(l.muscleLabel(g)),
                      selected: _primary == g,
                      onSelected: (_) => setState(() {
                        _primary = g;
                        _secondary.remove(g);
                      }),
                    ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l.librarySecondaryMuscles,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                for (final g in MuscleGroup.values)
                  if (g != MuscleGroup.cardio && g != _primary)
                    FilterChip(
                      label: Text(l.muscleLabel(g)),
                      selected: _secondary.contains(g),
                      onSelected: (sel) => setState(() {
                        if (sel) {
                          _secondary.add(g);
                        } else {
                          _secondary.remove(g);
                        }
                      }),
                    ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
