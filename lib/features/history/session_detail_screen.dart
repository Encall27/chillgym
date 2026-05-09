import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/brand_title.dart';
import '../../domain/models/exercise.dart';
import '../../domain/models/exercise_entry.dart';
import '../../domain/models/session.dart';
import '../../domain/models/workout_set.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../services/image_service.dart';
import '../../state/preferences_provider.dart';
import '../../state/session_repository_provider.dart';
import '../log/exercise_picker_screen.dart';
import '../log/log_set_sheet.dart';
import '../share/share_card_dialog.dart';
import '../shared/entry_photos.dart';
import '../shared/session_details_sheet.dart';

/// Editable detail view of a finished session. Every mutation persists to the
/// repository immediately and invalidates the past-sessions list, so changes
/// reflect in History / Calendar / Progress without a manual save step.
class SessionDetailScreen extends ConsumerStatefulWidget {
  const SessionDetailScreen({super.key, required this.session});

  final Session session;

  @override
  ConsumerState<SessionDetailScreen> createState() =>
      _SessionDetailScreenState();
}

class _SessionDetailScreenState extends ConsumerState<SessionDetailScreen> {
  late Session _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> _persist(Session updated) async {
    setState(() => _session = updated);
    final repo = await ref.read(sessionRepositoryProvider.future);
    await repo.save(updated);
    ref.invalidate(pastSessionsProvider);
  }

  Future<void> _addExercise() async {
    final picked = await Navigator.of(context).push<Exercise>(
      MaterialPageRoute(builder: (_) => const ExercisePickerScreen()),
    );
    if (picked == null) return;
    final entry = ExerciseEntry(id: _newId(), exercise: picked);
    await _persist(
      _session.copyWith(entries: [..._session.entries, entry]),
    );
  }

  Future<void> _removeEntry(ExerciseEntry entry) async {
    await _persist(
      _session.copyWith(
        entries: _session.entries.where((e) => e.id != entry.id).toList(),
      ),
    );
  }

  Future<void> _addSet(ExerciseEntry entry) async {
    final result = await showModalBottomSheet<WorkoutSet>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LogSetSheet(entry: entry),
    );
    if (result == null) return;
    final entries = _session.entries.map((e) {
      if (e.id != entry.id) return e;
      return e.copyWith(sets: [...e.sets, result]);
    }).toList();
    await _persist(_session.copyWith(entries: entries));
  }

  Future<void> _editSet(ExerciseEntry entry, WorkoutSet existing) async {
    final result = await showModalBottomSheet<WorkoutSet>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LogSetSheet(entry: entry, existing: existing),
    );
    if (result == null) return;
    final entries = _session.entries.map((e) {
      if (e.id != entry.id) return e;
      return e.copyWith(
        sets: e.sets.map((s) => s.id == result.id ? result : s).toList(),
      );
    }).toList();
    await _persist(_session.copyWith(entries: entries));
  }

  Future<void> _deleteSet(ExerciseEntry entry, WorkoutSet set) async {
    final entries = _session.entries.map((e) {
      if (e.id != entry.id) return e;
      return e.copyWith(sets: e.sets.where((s) => s.id != set.id).toList());
    }).toList();
    await _persist(_session.copyWith(entries: entries));
  }

  Future<void> _editDetails() async {
    final result = await showSessionDetailsDialog(
      context,
      initialName: _session.name,
      initialPlace: _session.place,
      initialMood: _session.mood,
      initialNotes: _session.notes,
      initialWeather: _session.weather,
      initialFriends: _session.friends,
    );
    if (result == null) return;
    await _persist(_session.copyWith(
      name: result.name,
      place: result.place,
      mood: result.mood,
      notes: result.notes,
      weather: result.weather,
      friends: result.friends,
    ));
  }

  Future<void> _addPhoto(ExerciseEntry entry) async {
    final picked = await pickAndPersistPhoto(context);
    if (picked == null) return;
    final entries = _session.entries.map((e) {
      if (e.id != entry.id) return e;
      return e.copyWith(photoRefs: [...e.photoRefs, picked]);
    }).toList();
    await _persist(_session.copyWith(entries: entries));
  }

  Future<void> _deletePhoto(ExerciseEntry entry, String photoRef) async {
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
    if (ok != true) return;
    final entries = _session.entries.map((e) {
      if (e.id != entry.id) return e;
      return e.copyWith(
        photoRefs: e.photoRefs.where((p) => p != photoRef).toList(),
      );
    }).toList();
    await _persist(_session.copyWith(entries: entries));
    await ImageService.instance.tryDelete(photoRef);
  }

  bool _hasAnyTag() =>
      _session.place != null ||
      _session.mood != null ||
      _session.weather != null ||
      _session.friends.isNotEmpty ||
      (_session.notes != null && _session.notes!.isNotEmpty);

  IconData _weatherIcon(SessionWeather w) => switch (w) {
        SessionWeather.sunny => Icons.wb_sunny_outlined,
        SessionWeather.cloudy => Icons.cloud_outlined,
        SessionWeather.rainy => Icons.water_drop_outlined,
        SessionWeather.snowy => Icons.ac_unit_outlined,
        SessionWeather.hot => Icons.thermostat_outlined,
        SessionWeather.cold => Icons.severe_cold_outlined,
      };

  String _setLine(WorkoutSet s, bool cardio, WeightUnit unit) {
    if (cardio) {
      final parts = <String>[];
      if (s.distanceMeters != null) {
        parts.add('${(s.distanceMeters! / 1000).toStringAsFixed(2)} km');
      }
      if (s.durationSeconds != null) {
        final m = s.durationSeconds! ~/ 60;
        final ss = s.durationSeconds! % 60;
        parts.add('${m}m ${ss.toString().padLeft(2, '0')}s');
      }
      return parts.isEmpty ? '—' : parts.join(' · ');
    }
    final w = s.weightKg == null
        ? '—'
        : formatWeightFromKg(s.weightKg!, unit);
    final rir = s.rir != null ? ' · RIR ${s.rir}' : '';
    final reps = s.reps?.toString() ?? '—';
    return '$w × $reps$rir';
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final localeName = Localizations.localeOf(context).toString();
    final df = DateFormat.yMMMMEEEEd(localeName).add_jm();
    final scheme = Theme.of(context).colorScheme;
    final unit =
        ref.watch(weightUnitProvider).valueOrNull ?? WeightUnit.kg;
    return Scaffold(
      appBar: AppBar(
        title: BrandTitle(subtitle: df.format(_session.startedAt)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: l.shareCardTitle,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) =>
                  ShareCardDialog(session: _session, unit: unit),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: l.sessionDetailsTitle,
            onPressed: _editDetails,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addExercise,
        icon: const Icon(Icons.add),
        label: Text(l.actionAddExercise),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Stat(label: l.statExercises, value: '${_session.entries.length}'),
                      _Stat(label: l.statSets, value: '${_session.totalSets}'),
                      _Stat(
                        label: l.statVolume,
                        value: formatVolumeFromKg(_session.totalVolumeKg, unit),
                      ),
                      _Stat(
                        label: l.statDuration,
                        value: '${_session.duration.inMinutes}m',
                      ),
                    ],
                  ),
                  if (_hasAnyTag()) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (_session.place != null)
                          Chip(
                            avatar: const Icon(Icons.place_outlined, size: 16),
                            label: Text(_session.place!),
                          ),
                        if (_session.mood != null)
                          Chip(
                            avatar: const Icon(Icons.mood_outlined, size: 16),
                            label: Text(l.moodLabel(_session.mood!)),
                          ),
                        if (_session.weather != null)
                          Chip(
                            avatar: Icon(
                              _weatherIcon(_session.weather!),
                              size: 16,
                            ),
                            label: Text(l.weatherLabel(_session.weather!)),
                          ),
                        if (_session.friends.isNotEmpty)
                          Chip(
                            avatar: const Icon(
                              Icons.group_outlined,
                              size: 16,
                            ),
                            label: Text(_session.friends.join(', ')),
                          ),
                        if (_session.notes != null &&
                            _session.notes!.isNotEmpty)
                          Chip(
                            avatar: const Icon(
                              Icons.sticky_note_2_outlined,
                              size: 16,
                            ),
                            label: ConstrainedBox(
                              constraints:
                                  const BoxConstraints(maxWidth: 220),
                              child: Text(
                                _session.notes!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (_session.entries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l.sessionDetailEmpty,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ),
          ..._session.entries.map((entry) {
            final cardio = entry.exercise.kind == ExerciseKind.cardio;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.exercise.name,
                                style:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                l.muscleLabel(entry.exercise.primaryMuscle),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: l.actionRemoveExercise,
                          onPressed: () => _removeEntry(entry),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ...entry.sets.asMap().entries.map((kv) {
                      final i = kv.key + 1;
                      final s = kv.value;
                      return InkWell(
                        onTap: () => _editSet(entry, s),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 28, child: Text('$i.')),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(_setLine(s, cardio, unit)),
                                    if (s.notes != null &&
                                        s.notes!.isNotEmpty)
                                      Text(
                                        s.notes!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: scheme.onSurfaceVariant,
                                              fontStyle: FontStyle.italic,
                                            ),
                                      ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _deleteSet(entry, s),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    PhotoStrip(
                      refs: entry.photoRefs,
                      onAdd: () => _addPhoto(entry),
                      onView: (idx) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PhotoViewerScreen(
                            refs: entry.photoRefs,
                            initialIndex: idx,
                          ),
                        ),
                      ),
                      onDelete: (photoRef) => _deletePhoto(entry, photoRef),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _addSet(entry),
                        icon: const Icon(Icons.add),
                        label: Text(l.actionAddSet),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 80),
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
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
