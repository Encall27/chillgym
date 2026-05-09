import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/brand_title.dart';
import '../../app/drawer.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/muscle_group.dart';
import '../../l10n/translations.dart';
import '../../state/exercise_catalog_provider.dart';
import '../../state/template_repository_provider.dart';
import 'custom_exercise_editor.dart';
import 'template_detail_screen.dart';
import 'template_editor_screen.dart';

enum _LibrarySegment { exercises, templates }

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  _LibrarySegment _segment = _LibrarySegment.exercises;
  String _query = '';
  MuscleGroup? _filter;

  List<Exercise> _filtered(List<Exercise> all) {
    final q = _query.trim().toLowerCase();
    return all.where((e) {
      // Filter chips match the *primary* muscle only — putting an exercise
      // under every secondary group it touches makes the back/shoulders
      // filters unusable (face pull would show under both).
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
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const BrandTitle(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SegmentedButton<_LibrarySegment>(
              segments: [
                ButtonSegment(
                  value: _LibrarySegment.exercises,
                  label: Text(l.libraryExercises),
                  icon: const Icon(Icons.fitness_center),
                ),
                ButtonSegment(
                  value: _LibrarySegment.templates,
                  label: Text(l.libraryTemplates),
                  icon: const Icon(Icons.list_alt),
                ),
              ],
              selected: {_segment},
              onSelectionChanged: (s) =>
                  setState(() => _segment = s.first),
            ),
          ),
          Expanded(
            child: _segment == _LibrarySegment.exercises
                ? _buildExercises()
                : const _TemplatesView(),
          ),
        ],
      ),
      floatingActionButton: _segment == _LibrarySegment.templates
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const TemplateEditorScreen(),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text(l.libraryNewTemplate),
            )
          : FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CustomExerciseEditor(),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text(l.libraryNewExercise),
            ),
    );
  }

  Widget _buildExercises() {
    final l = tr(context);
    final catalog = ref.watch(exerciseCatalogProvider);
    final results = _filtered(catalog);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
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
              _FilterChipBox(
                label: l.libraryFilterAll,
                selected: _filter == null,
                onSelected: () => setState(() => _filter = null),
              ),
              ...MuscleGroup.values.map(
                (g) => _FilterChipBox(
                  label: l.muscleLabel(g),
                  selected: _filter == g,
                  onSelected: () => setState(() => _filter = g),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Text(
                    l.libraryNoMatch,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) => _ExerciseRow(exercise: results[i]),
                ),
        ),
      ],
    );
  }
}

class _FilterChipBox extends StatelessWidget {
  const _FilterChipBox({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final isCardio = exercise.kind == ExerciseKind.cardio;
    return ListTile(
      leading: CircleAvatar(
        child: Icon(isCardio ? Icons.directions_run : Icons.fitness_center),
      ),
      title: Text(exercise.name),
      subtitle: Text(l.muscleLabel(exercise.primaryMuscle)),
      trailing: exercise.isCustom
          ? const Icon(Icons.edit_outlined)
          : null,
      onTap: exercise.isCustom
          ? () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CustomExerciseEditor(existing: exercise),
                ),
              )
          : null,
    );
  }
}

class _TemplatesView extends ConsumerWidget {
  const _TemplatesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final asyncTemplates = ref.watch(templatesProvider);
    return asyncTemplates.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l.loadFailed(e.toString()))),
      data: (templates) {
        if (templates.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.list_alt,
                    size: 56,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.libraryNoTemplatesYet,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.libraryCreateOne,
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.separated(
          itemCount: templates.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final t = templates[i];
            return ListTile(
              leading: const CircleAvatar(child: Icon(Icons.list_alt)),
              title: Text(t.name),
              subtitle: Text(l.libraryExerciseCount(t.exercises.length)),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TemplateDetailScreen(template: t),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
