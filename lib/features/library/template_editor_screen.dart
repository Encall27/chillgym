import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/brand_title.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/template.dart';
import '../../l10n/translations.dart';
import '../../state/template_repository_provider.dart';
import '../log/exercise_picker_screen.dart';

/// Create or edit a template. Pass `existing` to edit; null to create new.
class TemplateEditorScreen extends ConsumerStatefulWidget {
  const TemplateEditorScreen({super.key, this.existing});

  final WorkoutTemplate? existing;

  @override
  ConsumerState<TemplateEditorScreen> createState() =>
      _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends ConsumerState<TemplateEditorScreen> {
  late final TextEditingController _nameCtrl;
  late List<Exercise> _exercises;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _exercises = [...?widget.existing?.exercises];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _addExercise() async {
    final picked = await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (picked != null) {
      setState(() => _exercises.add(picked));
    }
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty || _exercises.isEmpty) return;
    final id = widget.existing?.id ??
        DateTime.now().microsecondsSinceEpoch.toString();
    final template =
        WorkoutTemplate(id: id, name: name, exercises: _exercises);
    final repo = await ref.read(templateRepositoryProvider.future);
    await repo.save(template);
    ref.invalidate(templatesProvider);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final canSave =
        _nameCtrl.text.trim().isNotEmpty && _exercises.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: BrandTitle(
          subtitle: widget.existing == null
              ? l.libraryNewTemplate
              : l.libraryEditTemplate,
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: canSave ? _save : null,
            icon: const Icon(Icons.check),
            label: Text(l.actionSave),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: l.libraryTemplateName,
                hintText: l.libraryTemplateNameHint,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text(
              l.libraryTemplateExercises,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _exercises.isEmpty
                  ? Center(
                      child: Text(
                        l.libraryNoExercisesYet,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    )
                  : ReorderableListView.builder(
                      itemCount: _exercises.length,
                      onReorder: (oldI, newI) {
                        setState(() {
                          if (newI > oldI) newI -= 1;
                          final item = _exercises.removeAt(oldI);
                          _exercises.insert(newI, item);
                        });
                      },
                      itemBuilder: (_, i) {
                        final e = _exercises[i];
                        return ListTile(
                          key: ValueKey('${e.id}-$i'),
                          leading: const Icon(Icons.drag_handle),
                          title: Text(e.name),
                          subtitle: Text(l.muscleLabel(e.primaryMuscle)),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                setState(() => _exercises.removeAt(i)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExercise,
        icon: const Icon(Icons.add),
        label: Text(l.actionAddExercise),
      ),
    );
  }
}
