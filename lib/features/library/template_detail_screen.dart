import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/brand_title.dart';
import '../../domain/models/exercise_entry.dart';
import '../../domain/models/template.dart';
import '../../l10n/translations.dart';
import '../../state/active_session_controller.dart';
import '../../state/template_repository_provider.dart';
import 'template_editor_screen.dart';

class TemplateDetailScreen extends ConsumerWidget {
  const TemplateDetailScreen({super.key, required this.template});

  final WorkoutTemplate template;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = tr(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.libraryDeleteTemplatePrompt(template.name)),
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
    if (confirmed == true) {
      final repo = await ref.read(templateRepositoryProvider.future);
      await repo.delete(template.id);
      ref.invalidate(templatesProvider);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  void _start(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final controller = ref.read(activeSessionProvider.notifier);
    if (ref.read(activeSessionProvider) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.activeWorkoutAlreadyActive)),
      );
      return;
    }
    final entries = template.exercises
        .map(
          (e) => ExerciseEntry(
            id: '${DateTime.now().microsecondsSinceEpoch}-${e.id}',
            exercise: e,
          ),
        )
        .toList();
    controller.startSession(seedEntries: entries);
    // Switch to Log tab.
    GoRouter.of(context).go('/log');
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    return Scaffold(
      appBar: AppBar(
        title: BrandTitle(subtitle: template.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: l.actionEdit,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TemplateEditorScreen(existing: template),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l.actionDelete,
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l.libraryExerciseCount(template.exercises.length),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 12),
          ...template.exercises.asMap().entries.map(
                (kv) => Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${kv.key + 1}')),
                    title: Text(kv.value.name),
                    subtitle: Text(l.muscleLabel(kv.value.primaryMuscle)),
                  ),
                ),
              ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _start(context, ref),
        icon: const Icon(Icons.play_arrow),
        label: Text(l.actionStartWorkout),
      ),
    );
  }
}
