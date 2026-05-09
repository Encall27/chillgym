import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/brand_title.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/muscle_group.dart';
import '../../l10n/translations.dart';
import '../../state/exercise_catalog_provider.dart';

/// Modal screen for picking an exercise to add to the active session.
/// Pops with the chosen [Exercise] or null on cancel.
class ExercisePickerScreen extends ConsumerStatefulWidget {
  const ExercisePickerScreen({super.key});

  @override
  ConsumerState<ExercisePickerScreen> createState() =>
      _ExercisePickerScreenState();
}

class _ExercisePickerScreenState extends ConsumerState<ExercisePickerScreen> {
  String _query = '';
  MuscleGroup? _filter;

  List<Exercise> _filtered(List<Exercise> all) {
    final q = _query.trim().toLowerCase();
    return all.where((e) {
      // Match by primary muscle only — keep filter chips unambiguous.
      if (_filter != null && e.primaryMuscle != _filter) {
        return false;
      }
      if (q.isEmpty) return true;
      return e.name.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final catalog = ref.watch(exerciseCatalogProvider);
    final results = _filtered(catalog);

    return Scaffold(
      appBar: AppBar(
        title: BrandTitle(subtitle: l.libraryPickExercise),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: l.librarySearch,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(l.libraryFilterAll),
                    selected: _filter == null,
                    onSelected: (_) => setState(() => _filter = null),
                  ),
                ),
                ...MuscleGroup.values.map(
                  (g) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(l.muscleLabel(g)),
                      selected: _filter == g,
                      onSelected: (_) => setState(() => _filter = g),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: results.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final e = results[i];
                final isCardio = e.kind == ExerciseKind.cardio;
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(isCardio
                        ? Icons.directions_run
                        : Icons.fitness_center),
                  ),
                  title: Text(e.name),
                  subtitle: Text(l.muscleLabel(e.primaryMuscle)),
                  onTap: () => Navigator.of(context).pop(e),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
