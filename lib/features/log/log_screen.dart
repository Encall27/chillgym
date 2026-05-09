import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/brand_title.dart';
import '../../app/drawer.dart';
import '../../domain/models/exercise_entry.dart';
import '../../domain/models/session.dart';
import '../../domain/models/template.dart';
import '../../l10n/translations.dart';
import '../../state/active_session_controller.dart';
import '../../state/session_repository_provider.dart';
import '../../state/template_repository_provider.dart';
import '../../theme/brand_tokens.dart';
import '../shared/design_primitives.dart';
import 'active_session_screen.dart';

class LogScreen extends ConsumerWidget {
  const LogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider);
    if (session != null) {
      return const ActiveSessionScreen();
    }
    return const _StartSessionView();
  }
}

class _StartSessionView extends ConsumerWidget {
  const _StartSessionView();

  void _startFromTemplate(WidgetRef ref, WorkoutTemplate template) {
    final entries = template.exercises
        .map(
          (e) => ExerciseEntry(
            id: '${DateTime.now().microsecondsSinceEpoch}-${e.id}',
            exercise: e,
          ),
        )
        .toList();
    ref
        .read(activeSessionProvider.notifier)
        .startSession(seedEntries: entries);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = tr(context);
    final asyncTemplates = ref.watch(templatesProvider);
    final asyncSessions = ref.watch(pastSessionsProvider);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const BrandTitle(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const SizedBox(height: 4),
            _StartFreshHero(
              onStart: () =>
                  ref.read(activeSessionProvider.notifier).startSession(),
            ),
            const SizedBox(height: 24),
            EyebrowLabel(l.logTemplatesEyebrow),
            const SizedBox(height: 8),
            asyncTemplates.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text(l.genericFailed(e.toString())),
              data: (templates) {
                if (templates.isEmpty) return const _NoTemplatesPanel();
                return _TemplateList(
                  templates: templates,
                  onStart: (t) => _startFromTemplate(ref, t),
                );
              },
            ),
            const SizedBox(height: 24),
            asyncSessions.maybeWhen(
              data: (sessions) {
                if (sessions.isEmpty) return const SizedBox.shrink();
                return _LastSessionRecap(latest: sessions.first);
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Big top card: Eyebrow + headline + helper + primary CTA. Replaces the old
/// sparse Icon + 2-button column.
class _StartFreshHero extends StatelessWidget {
  const _StartFreshHero({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? scheme.primary : brand.amberDeep;
    final fg = isDark ? const Color(0xFF000000) : scheme.onPrimary;
    final eyebrowColor = fg.withValues(alpha: 0.75);
    final ctaBg = isDark ? const Color(0xFF000000) : scheme.surface;
    final ctaFg = isDark ? scheme.primary : brand.amberDeep;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: brand.useGlow
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.20),
                    blurRadius: 20,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EyebrowLabel(l.logHeroEyebrow, color: eyebrowColor),
            const SizedBox(height: 8),
            Text(
              l.logReadyToTrain,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: fg,
                    fontStyle: brand.useGlow
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              l.logStartHelp,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: fg.withValues(alpha: 0.8),
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onStart,
                    style: FilledButton.styleFrom(
                      backgroundColor: ctaBg,
                      foregroundColor: ctaFg,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      l.actionStartWorkout,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty-state panel for when the user has no templates yet. Points them at
/// the Library tab where templates are created.
class _NoTemplatesPanel extends StatelessWidget {
  const _NoTemplatesPanel();

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.list_alt_outlined,
              color: scheme.onSurfaceVariant, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.logNoTemplatesTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  l.logNoTemplatesHelp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () => context.go('/library'),
            child: Text(l.logCreateTemplate),
          ),
        ],
      ),
    );
  }
}

/// Vertical stack of template cards. Each card shows the template name + count
/// and starts the session on tap.
class _TemplateList extends StatelessWidget {
  const _TemplateList({required this.templates, required this.onStart});

  final List<WorkoutTemplate> templates;
  final void Function(WorkoutTemplate) onStart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final t in templates)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _TemplateCard(template: t, onStart: () => onStart(t)),
          ),
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template, required this.onStart});

  final WorkoutTemplate template;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onStart,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outlineVariant),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.list_alt, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l.libraryExerciseCount(template.exercises.length),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.play_arrow, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small-print recap of the most-recent finished session as a soft secondary
/// CTA — a way back into history without leaving Log.
class _LastSessionRecap extends StatelessWidget {
  const _LastSessionRecap({required this.latest});

  final Session latest;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final daysAgo = DateTime.now().difference(latest.startedAt).inDays;
    final recap = daysAgo == 0
        ? l.logRecapToday
        : daysAgo == 1
            ? l.logRecapYesterday
            : l.logRecapDaysAgo(daysAgo);
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.history, size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              recap,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
