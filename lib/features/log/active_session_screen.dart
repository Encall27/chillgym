import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/brand_title.dart';
import '../../domain/feedback_engine.dart';
import '../../domain/last_session_lookup.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/exercise_entry.dart';
import '../../domain/models/session.dart';
import '../../domain/models/workout_set.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../services/image_service.dart';
import '../../services/notification_service.dart';
import '../../state/active_session_controller.dart';
import '../../state/preferences_provider.dart';
import '../../state/session_repository_provider.dart';
import '../shared/entry_photos.dart';
import '../shared/session_details_sheet.dart';
import '../../theme/brand_tokens.dart';
import '../shared/design_primitives.dart';
import 'exercise_picker_screen.dart';
import 'log_set_sheet.dart';
import 'workout_finished_dialog.dart';

class ActiveSessionScreen extends ConsumerWidget {
  const ActiveSessionScreen({super.key});

  Future<void> _pickExercise(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(activeSessionProvider.notifier);
    final session = ref.read(activeSessionProvider);
    final l = tr(context);

    // Find the most recently-added unfinished entry (top of the list, since
    // addExercise prepends and finished entries sink). If one exists, ask the
    // user whether they're done with it before prepending another.
    final unfinished = session?.entries
        .where((e) => !e.isFinished)
        .toList(growable: false);
    if (unfinished != null && unfinished.isNotEmpty) {
      final current = unfinished.first;
      final answer = await showDialog<bool>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: Text(l.addExerciseConfirmTitle),
          content: Text(l.addExerciseConfirmBody(current.exercise.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx, false),
              child: Text(l.addExerciseConfirmKeep),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogCtx, true),
              child: Text(l.addExerciseConfirmDone),
            ),
          ],
        ),
      );
      if (answer != true) return;
      controller.setEntryFinished(current.id, true);
    }

    if (!context.mounted) return;
    final picked = await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (picked != null) {
      controller.addExercise(picked);
    }
  }

  Future<void> _addSet(
    BuildContext context,
    WidgetRef ref,
    ExerciseEntry entry,
  ) async {
    final result = await showLogSetDialog(context, entry: entry);
    if (result != null) {
      ref.read(activeSessionProvider.notifier).addSetToEntry(entry.id, result);
      if (!context.mounted) return;
      _markRestStart(context, ref, entry);
    }
  }

  void _markRestStart(BuildContext context, WidgetRef ref, ExerciseEntry entry) {
    if (entry.exercise.kind == ExerciseKind.cardio) return;
    ref.read(lastSetAtProvider.notifier).state = DateTime.now();
    final l = tr(context);
    _scheduleRestNotification(ref, l.notifRestTitle, l.notifRestBody);
  }

  void _scheduleRestNotification(
    WidgetRef ref,
    String title,
    String body,
  ) {
    // Read current prefs without watching — we don't want this to trigger
    // re-renders. If notifications are off (or web), the call is a no-op.
    () async {
      final on = await ref.read(notificationsEnabledProvider.future);
      if (!on) return;
      final secs = await ref.read(restTimerSecondsProvider.future);
      await NotificationService.instance.scheduleRestEnd(
        Duration(seconds: secs),
        title: title,
        body: body,
      );
    }();
  }

  Future<void> _editSet(
    BuildContext context,
    WidgetRef ref,
    ExerciseEntry entry,
    WorkoutSet existing,
  ) async {
    final result =
        await showLogSetDialog(context, entry: entry, existing: existing);
    if (result != null) {
      ref
          .read(activeSessionProvider.notifier)
          .updateSetInEntry(entry.id, result);
    }
  }

  Future<void> _openRestTimerPicker(BuildContext context, WidgetRef ref) async {
    final current = await ref.read(restTimerSecondsProvider.future);
    if (!context.mounted) return;
    final picked = await showDialog<int>(
      context: context,
      builder: (_) => _RestTimerPickerDialog(initialSeconds: current),
    );
    if (picked == null || picked == current) return;
    final prefs = await ref.read(preferencesProvider.future);
    await prefs.setRestTimerSeconds(picked);
    ref.invalidate(restTimerSecondsProvider);
  }

  Future<bool?> _confirmCancel(BuildContext context) {
    final l = tr(context);
    return showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.activeCancelWorkout),
        content: Text(l.activeCancelHelp),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(l.actionKeepGoing),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(l.actionDiscard),
          ),
        ],
      ),
    );
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  void _repeatLastSet(BuildContext context, WidgetRef ref, ExerciseEntry entry) {
    if (entry.sets.isEmpty) return;
    final last = entry.sets.last;
    final dup = WorkoutSet(
      id: _newId(),
      weightKg: last.weightKg,
      reps: last.reps,
      rir: last.rir,
      distanceMeters: last.distanceMeters,
      durationSeconds: last.durationSeconds,
      // Skip notes — they're usually set-specific.
    );
    ref.read(activeSessionProvider.notifier).addSetToEntry(entry.id, dup);
    _markRestStart(context, ref, entry);
  }

  void _prefillFromLastSession(
    WidgetRef ref,
    ExerciseEntry entry,
    ExerciseEntry lastEntry,
  ) {
    final cloned = lastEntry.sets
        .map(
          (s) => WorkoutSet(
            id: _newId(),
            weightKg: s.weightKg,
            reps: s.reps,
            // Drop RIR/notes — they were specific to that day.
            distanceMeters: s.distanceMeters,
            durationSeconds: s.durationSeconds,
          ),
        )
        .toList();
    ref.read(activeSessionProvider.notifier).replaceSetsForEntry(
          entry.id,
          cloned,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final pastSessions = ref.watch(pastSessionsProvider).maybeWhen(
          data: (l) => l,
          orElse: () => <Session>[],
        );
    final experienceLevel = ref.watch(experienceLevelProvider).maybeWhen(
          data: (l) => l,
          orElse: () => ExperienceLevel.beginner,
        );
    final unit = ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    final scheme = Theme.of(context).colorScheme;
    final l = tr(context);

    return Scaffold(
      appBar: AppBar(
        title: BrandTitle(subtitle: l.activeTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l.activeCancelWorkout,
          onPressed: () async {
            final confirmed = await _confirmCancel(context);
            if (confirmed == true) {
              ref.read(activeSessionProvider.notifier).cancelSession();
              ref.read(lastSetAtProvider.notifier).state = null;
              // ignore: unawaited_futures
              NotificationService.instance.cancelRest();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            tooltip: l.restTimerSection,
            onPressed: () => _openRestTimerPicker(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: l.sessionDetailsTitle,
            onPressed: () async {
              final result = await showSessionDetailsDialog(
                context,
                initialName: session.name,
                initialPlace: session.place,
                initialMood: session.mood,
                initialNotes: session.notes,
                initialWeather: session.weather,
                initialFriends: session.friends,
              );
              if (result != null) {
                ref.read(activeSessionProvider.notifier).setSessionDetails(
                      name: result.name,
                      place: result.place,
                      mood: result.mood,
                      notes: result.notes,
                      weather: result.weather,
                      friends: result.friends,
                    );
              }
            },
          ),
          TextButton.icon(
            onPressed: () async {
              final navContext = context;
              final finished = await ref
                  .read(activeSessionProvider.notifier)
                  .finishSession(
                    inactivityTitle: l.notifInactivityTitle,
                    inactivityBody: l.notifInactivityBody,
                  );
              ref.read(lastSetAtProvider.notifier).state = null;
              // ignore: unawaited_futures
              NotificationService.instance.cancelRest();
              if (finished == null || !navContext.mounted) return;
              await showDialog<void>(
                context: navContext,
                builder: (_) => WorkoutFinishedDialog(
                  session: finished,
                  unit: unit,
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: Text(l.actionFinish),
          ),
        ],
      ),
      body: Column(
        children: [
          const _RestBanner(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: scheme.surfaceContainerHigh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Stat(label: l.statExercises, value: '${session.entries.length}'),
                    const SizedBox(width: 24),
                    _Stat(label: l.statSets, value: '${session.totalSets}'),
                    const SizedBox(width: 24),
                    _Stat(
                      label: l.statVolume,
                      value: formatVolumeFromKg(session.totalVolumeKg, unit),
                    ),
                  ],
                ),
                if (session.place != null ||
                    session.mood != null ||
                    session.weather != null ||
                    session.friends.isNotEmpty ||
                    (session.notes != null && session.notes!.isNotEmpty)) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (session.place != null)
                        _MetaChip(
                          icon: Icons.place_outlined,
                          label: session.place!,
                        ),
                      if (session.mood != null)
                        _MetaChip(
                          icon: Icons.mood_outlined,
                          label: l.moodLabel(session.mood!),
                        ),
                      if (session.weather != null)
                        _MetaChip(
                          icon: _weatherIconFor(session.weather!),
                          label: l.weatherLabel(session.weather!),
                        ),
                      if (session.friends.isNotEmpty)
                        _MetaChip(
                          icon: Icons.group_outlined,
                          label: session.friends.join(', '),
                        ),
                      if (session.notes != null &&
                          session.notes!.isNotEmpty)
                        _MetaChip(
                          icon: Icons.sticky_note_2_outlined,
                          label: session.notes!,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: session.entries.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l.activeNothingYet,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: session.entries.length,
                    buildDefaultDragHandles: false,
                    onReorder: (oldI, newI) => ref
                        .read(activeSessionProvider.notifier)
                        .reorderEntries(oldI, newI),
                    itemBuilder: (_, i) {
                      final entry = session.entries[i];
                      final lastEntry = findLastEntryFor(
                        exerciseId: entry.exercise.id,
                        sessions: pastSessions,
                      );
                      final feedback = evaluateEntry(
                        entry: entry,
                        history: pastSessions,
                        experienceLevel: experienceLevel,
                      );
                      return _ExerciseEntryCard(
                        key: ValueKey(entry.id),
                        index: i,
                        total: session.entries.length,
                        entry: entry,
                        unit: unit,
                        lastSessionEntry: lastEntry,
                        feedback: feedback,
                        onAddSet: () => _addSet(context, ref, entry),
                        onEditSet: (set) =>
                            _editSet(context, ref, entry, set),
                        onRemoveSet: (setId) => ref
                            .read(activeSessionProvider.notifier)
                            .removeSet(entry.id, setId),
                        onRemoveEntry: () => ref
                            .read(activeSessionProvider.notifier)
                            .removeEntry(entry.id),
                        onToggleFinished: () => ref
                            .read(activeSessionProvider.notifier)
                            .setEntryFinished(entry.id, !entry.isFinished),
                        onRepeatSet: () => _repeatLastSet(context, ref, entry),
                        onPrefillFromLastSession: lastEntry == null
                            ? null
                            : () => _prefillFromLastSession(
                                  ref,
                                  entry,
                                  lastEntry,
                                ),
                        onAddPhoto: () async {
                          final picked = await pickAndPersistPhoto(context);
                          if (picked != null) {
                            ref
                                .read(activeSessionProvider.notifier)
                                .addPhotoToEntry(entry.id, picked);
                          }
                        },
                        onViewPhoto: (idx) => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PhotoViewerScreen(
                              refs: entry.photoRefs,
                              initialIndex: idx,
                            ),
                          ),
                        ),
                        onDeletePhoto: (photoRef) async {
                          ref
                              .read(activeSessionProvider.notifier)
                              .removePhotoFromEntry(entry.id, photoRef);
                          await ImageService.instance.tryDelete(photoRef);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickExercise(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.actionAddExercise),
      ),
    );
  }
}

/// Top-of-page rest banner with a 64px progress ring + the elapsed countdown
/// + +15s / Skip pills. Only renders after the user has logged a strength set
/// during this session; auto-collapses when the rest target is reached or
/// the user dismisses it.
class _RestBanner extends ConsumerStatefulWidget {
  const _RestBanner();

  @override
  ConsumerState<_RestBanner> createState() => _RestBannerState();
}

class _RestBannerState extends ConsumerState<_RestBanner> {
  Timer? _ticker;
  Duration _addedTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _format(Duration d) {
    final ds = d.isNegative ? Duration.zero : d;
    final m = ds.inMinutes;
    final s = ds.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final startedAt = ref.watch(lastSetAtProvider);
    if (startedAt == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final restTarget = ref.watch(restTimerSecondsProvider).maybeWhen(
          data: (v) => v,
          orElse: () => 90,
        );
    final target = Duration(seconds: restTarget) + _addedTime;
    final elapsed = DateTime.now().difference(startedAt);
    final remaining = target - elapsed;
    final progress = target.inMilliseconds == 0
        ? 0.0
        : (elapsed.inMilliseconds / target.inMilliseconds).clamp(0.0, 1.0);

    void dismiss() {
      ref.read(lastSetAtProvider.notifier).state = null;
      _addedTime = Duration.zero;
      // ignore: unawaited_futures
      NotificationService.instance.cancelRest();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: brand.amberPale,
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          StreakRing(
            size: 56,
            strokeWidth: 5,
            progress: progress,
            useGlow: brand.useGlow,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EyebrowLabel(l.restingLabel, color: brand.amberDeep, dot: true),
                const SizedBox(height: 2),
                Text(
                  _format(remaining),
                  style:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontFeatures: const [
                              FontFeature.tabularFigures(),
                            ],
                          ),
                ),
              ],
            ),
          ),
          _RestPill(
            label: l.actionRestAdd15,
            onTap: () => setState(
              () => _addedTime += const Duration(seconds: 15),
            ),
          ),
          const SizedBox(width: 6),
          _RestPill(
            label: l.actionRestSkip,
            onTap: dismiss,
          ),
        ],
      ),
    );
  }
}

class _RestPill extends StatelessWidget {
  const _RestPill({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      shape: StadiumBorder(side: BorderSide(color: scheme.outlineVariant)),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: scheme.onSurface,
                ),
          ),
        ),
      ),
    );
  }
}

IconData _weatherIconFor(SessionWeather w) => switch (w) {
      SessionWeather.sunny => Icons.wb_sunny_outlined,
      SessionWeather.cloudy => Icons.cloud_outlined,
      SessionWeather.rainy => Icons.water_drop_outlined,
      SessionWeather.snowy => Icons.ac_unit_outlined,
      SessionWeather.hot => Icons.thermostat_outlined,
      SessionWeather.cold => Icons.severe_cold_outlined,
    };

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _ExerciseEntryCard extends StatelessWidget {
  const _ExerciseEntryCard({
    super.key,
    required this.index,
    required this.total,
    required this.entry,
    required this.lastSessionEntry,
    required this.feedback,
    required this.unit,
    required this.onAddSet,
    required this.onEditSet,
    required this.onRemoveSet,
    required this.onRemoveEntry,
    required this.onToggleFinished,
    required this.onAddPhoto,
    required this.onViewPhoto,
    required this.onDeletePhoto,
    required this.onRepeatSet,
    required this.onPrefillFromLastSession,
  });

  final int index;
  final int total;
  final ExerciseEntry entry;
  final WeightUnit unit;
  final ExerciseEntry? lastSessionEntry;
  final FeedbackResult? feedback;
  final VoidCallback onAddSet;
  final void Function(WorkoutSet existing) onEditSet;
  final void Function(String setId) onRemoveSet;
  final VoidCallback onRemoveEntry;
  final VoidCallback onToggleFinished;
  final VoidCallback onAddPhoto;
  final void Function(int index) onViewPhoto;
  final void Function(String photoRef) onDeletePhoto;
  final VoidCallback onRepeatSet;
  final VoidCallback? onPrefillFromLastSession;

  /// Suggested progression label ("+5 KG") if the feedback engine implies the
  /// lifter has matched their recent average and is ready to nudge up. Returns
  /// null when there's nothing meaningful to surface.
  String? _progressionPill(BuildContext context, FeedbackResult? f) {
    if (f == null) return null;
    if (f.tier != FeedbackTier.good && f.tier != FeedbackTier.oneMoreSet) {
      return null;
    }
    // Only suggest when we have at least one completed set with a weight.
    final last = entry.sets
        .where((s) => s.weightKg != null)
        .fold<WorkoutSet?>(null, (m, s) => s);
    if (last == null) return null;
    final bumpKg = last.weightKg! < 30 ? 1.25 : 2.5;
    final bump = unit.fromKg(bumpKg);
    final amount = bump % 1 == 0
        ? bump.toStringAsFixed(0)
        : bump.toStringAsFixed(1);
    return tr(context).activeProgressionPill(amount, unit.suffix);
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final isCardio = entry.exercise.kind == ExerciseKind.cardio;
    final pill = _progressionPill(context, feedback);
    final isDone = entry.isFinished;
    final cardOpacity = isDone ? 0.55 : 1.0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Opacity(
        opacity: cardOpacity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 6),
                    child: Icon(
                      Icons.drag_handle,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          EyebrowLabel(
                            l.activeExerciseCounter(index + 1, total),
                            color: brand.amberDeep,
                          ),
                          if (isDone) ...[
                            const SizedBox(width: 8),
                            EyebrowLabel(
                              l.activeExerciseDone,
                              color: scheme.secondary,
                              dot: true,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.exercise.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: scheme.onSurfaceVariant,
                            ),
                      ),
                      Text(
                        l.muscleLabel(entry.exercise.primaryMuscle),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                if (pill != null && !isDone) ...[
                  const SizedBox(width: 8),
                  AccentPill(text: pill),
                ],
                IconButton(
                  icon: Icon(
                    isDone
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: isDone ? scheme.secondary : null,
                  ),
                  tooltip: isDone
                      ? l.activeExerciseReopen
                      : l.activeExerciseFinish,
                  onPressed: onToggleFinished,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l.actionRemoveExercise,
                  onPressed: onRemoveEntry,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (entry.sets.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...entry.sets.asMap().entries.map((kv) {
                final i = kv.key + 1;
                final s = kv.value;
                return _SetRow(
                  index: i,
                  set: s,
                  unit: unit,
                  isCardio: isCardio,
                  onTap: () => onEditSet(s),
                  onDelete: () => onRemoveSet(s.id),
                );
              }),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onAddSet,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l.actionAddSet),
                  ),
                ),
                if (entry.sets.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: onRepeatSet,
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                    child: const Text('↻', style: TextStyle(fontSize: 18)),
                  ),
                ],
                if (entry.sets.isEmpty && onPrefillFromLastSession != null) ...[
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: onPrefillFromLastSession,
                    icon: const Icon(Icons.history, size: 16),
                    label: Text(
                      l.actionUseLast(lastSessionEntry!.sets.length),
                    ),
                  ),
                ],
              ],
            ),
            if (feedback != null) ...[
              const SizedBox(height: 12),
              AccentCallout(
                eyebrow: l.feedbackTierLabel(feedback!.tier),
                color: feedback!.tier == FeedbackTier.notEnough
                    ? scheme.error
                    : feedback!.tier == FeedbackTier.enough
                        ? scheme.secondary
                        : scheme.primary,
                body: Text(
                  l.feedbackRationaleFor(feedback!),
                  style: brand.useGlow
                      ? Theme.of(context).textTheme.bodyMedium
                      : brand.displayItalic.copyWith(
                          fontSize: 14,
                          color: scheme.onSurface,
                          height: 1.35,
                        ),
                ),
              ),
            ],
            if (entry.photoRefs.isNotEmpty || !isCardio) ...[
              const SizedBox(height: 12),
              PhotoStrip(
                refs: entry.photoRefs,
                onAdd: onAddPhoto,
                onView: onViewPhoto,
                onDelete: (ref) => _confirmDeletePhoto(context, ref),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _confirmDeletePhoto(BuildContext context, String ref) async {
    final l = tr(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l.actionRemovePhoto),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(l.actionRemove),
          ),
        ],
      ),
    );
    if (ok == true) onDeletePhoto(ref);
  }
}

class _SetRow extends StatelessWidget {
  const _SetRow({
    required this.index,
    required this.set,
    required this.unit,
    required this.isCardio,
    required this.onTap,
    required this.onDelete,
  });

  final int index;
  final WorkoutSet set;
  final WeightUnit unit;
  final bool isCardio;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTokens>()!;
    final done = isCardio
        ? (set.distanceMeters != null || set.durationSeconds != null)
        : (set.weightKg != null && set.reps != null);
    final fg = done ? scheme.onSurface : scheme.onSurfaceVariant;

    Widget label(String text) => Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: fg,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );

    final cells = <Widget>[];
    if (isCardio) {
      final dist = set.distanceMeters == null
          ? '—'
          : (set.distanceMeters! / 1000).toStringAsFixed(2);
      final dur = set.durationSeconds == null
          ? '—'
          : '${set.durationSeconds! ~/ 60}:${(set.durationSeconds! % 60).toString().padLeft(2, '0')}';
      cells.addAll([
        label(dist),
        label(dur),
        Text(
          'km · m:s',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ]);
    } else {
      final w = set.weightKg == null
          ? '—'
          : (() {
              final v = unit.fromKg(set.weightKg!);
              return v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
            })();
      cells.addAll([
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            label(w),
            const SizedBox(width: 4),
            Text(
              unit.suffix,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        label(set.reps?.toString() ?? '—'),
        Text(
          'RIR ${set.rir ?? '—'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
        ),
      ]);
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onDelete,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$index',
                style: brand.displayItalic.copyWith(
                  fontSize: 14,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
            for (var i = 0; i < cells.length; i++) ...[
              Expanded(child: cells[i]),
            ],
            SizedBox(
              width: 28,
              child: SetStatusGlyph(done: done),
            ),
          ],
        ),
      ),
    );
  }
}

/// Centered min+sec picker for the rest timer. Pops the chosen total in
/// seconds (clamped to >= 5s).
class _RestTimerPickerDialog extends StatefulWidget {
  const _RestTimerPickerDialog({required this.initialSeconds});

  final int initialSeconds;

  @override
  State<_RestTimerPickerDialog> createState() => _RestTimerPickerDialogState();
}

class _RestTimerPickerDialogState extends State<_RestTimerPickerDialog> {
  late int _minutes;
  late int _seconds;

  static const _presets = <int>[30, 60, 90, 120, 180, 240];

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialSeconds ~/ 60;
    _seconds = widget.initialSeconds % 60;
  }

  int get _total => (_minutes * 60 + _seconds).clamp(5, 60 * 30);

  void _setFromTotal(int total) {
    setState(() {
      _minutes = total ~/ 60;
      _seconds = total % 60;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(l.restTimerSection)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.restTimerHelp,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _NumberField(
                value: _minutes,
                max: 30,
                label: l.restTimerMinutes,
                onChanged: (v) => setState(() => _minutes = v),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  ':',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              _NumberField(
                value: _seconds,
                max: 59,
                step: 5,
                label: l.restTimerSeconds,
                onChanged: (v) => setState(() => _seconds = v),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            children: [
              for (final p in _presets)
                ChoiceChip(
                  label: Text(_formatPreset(p)),
                  selected: _total == p,
                  onSelected: (sel) {
                    if (sel) _setFromTotal(p);
                  },
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_total),
          child: Text(l.actionSave),
        ),
      ],
    );
  }

  String _formatPreset(int s) {
    if (s < 60) return '${s}s';
    final m = s ~/ 60;
    final r = s % 60;
    return r == 0 ? '${m}m' : '${m}m${r}s';
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.value,
    required this.max,
    required this.label,
    required this.onChanged,
    this.step = 1,
  });

  final int value;
  final int max;
  final int step;
  final String label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: value <= 0
                    ? null
                    : () => onChanged((value - step).clamp(0, max)),
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(
                width: 44,
                child: Text(
                  value.toString().padLeft(2, '0'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: value >= max
                    ? null
                    : () => onChanged((value + step).clamp(0, max)),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
