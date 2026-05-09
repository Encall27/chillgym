import 'package:flutter/material.dart';

import '../../domain/models/session.dart';
import '../../l10n/translations.dart';

/// Returned to the caller; null/empty fields mean "clear it".
class SessionDetailsResult {
  const SessionDetailsResult({
    this.name,
    this.place,
    this.mood,
    this.notes,
    this.weather,
    this.friends = const [],
  });
  final String? name;
  final String? place;
  final SessionMood? mood;
  final String? notes;
  final SessionWeather? weather;
  final List<String> friends;
}

/// Centered Dialog body for editing session-level tags. Pops with a
/// [SessionDetailsResult] or null if the user cancels. Use
/// [showSessionDetailsDialog] to display.
class SessionDetailsSheet extends StatefulWidget {
  const SessionDetailsSheet({
    super.key,
    this.initialName,
    required this.initialPlace,
    required this.initialMood,
    required this.initialNotes,
    required this.initialWeather,
    required this.initialFriends,
  });

  final String? initialName;
  final String? initialPlace;
  final SessionMood? initialMood;
  final String? initialNotes;
  final SessionWeather? initialWeather;
  final List<String> initialFriends;

  @override
  State<SessionDetailsSheet> createState() => _SessionDetailsSheetState();
}

/// Show the session details editor as a centered Dialog. Returns the
/// SessionDetailsResult on save, or null if cancelled.
Future<SessionDetailsResult?> showSessionDetailsDialog(
  BuildContext context, {
  String? initialName,
  required String? initialPlace,
  required SessionMood? initialMood,
  required String? initialNotes,
  required SessionWeather? initialWeather,
  required List<String> initialFriends,
}) {
  return showDialog<SessionDetailsResult>(
    context: context,
    barrierDismissible: false,
    builder: (dialogCtx) {
      final viewInsets = MediaQuery.of(dialogCtx).viewInsets;
      return Dialog(
        insetPadding: EdgeInsets.fromLTRB(
          16,
          24,
          16,
          24 + viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 720),
          child: SessionDetailsSheet(
            initialName: initialName,
            initialPlace: initialPlace,
            initialMood: initialMood,
            initialNotes: initialNotes,
            initialWeather: initialWeather,
            initialFriends: initialFriends,
          ),
        ),
      );
    },
  );
}

class _SessionDetailsSheetState extends State<SessionDetailsSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _placeCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _friendsCtrl;
  SessionMood? _mood;
  SessionWeather? _weather;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName ?? '');
    _placeCtrl = TextEditingController(text: widget.initialPlace ?? '');
    _notesCtrl = TextEditingController(text: widget.initialNotes ?? '');
    _friendsCtrl =
        TextEditingController(text: widget.initialFriends.join(', '));
    _mood = widget.initialMood;
    _weather = widget.initialWeather;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _placeCtrl.dispose();
    _notesCtrl.dispose();
    _friendsCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    final place = _placeCtrl.text.trim();
    final notes = _notesCtrl.text.trim();
    final friends = _friendsCtrl.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    Navigator.of(context).pop(SessionDetailsResult(
      name: name.isEmpty ? null : name,
      place: place.isEmpty ? null : place,
      mood: _mood,
      notes: notes.isEmpty ? null : notes,
      weather: _weather,
      friends: friends,
    ));
  }

  IconData _weatherIcon(SessionWeather w) => switch (w) {
        SessionWeather.sunny => Icons.wb_sunny_outlined,
        SessionWeather.cloudy => Icons.cloud_outlined,
        SessionWeather.rainy => Icons.water_drop_outlined,
        SessionWeather.snowy => Icons.ac_unit_outlined,
        SessionWeather.hot => Icons.thermostat_outlined,
        SessionWeather.cold => Icons.severe_cold_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.sessionDetailsTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                tooltip: l.actionClose,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l.sessionName,
                      hintText: l.sessionNameHint,
                      prefixIcon: const Icon(Icons.edit_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _placeCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l.sessionPlace,
                      prefixIcon: const Icon(Icons.place_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.sessionMoodPrompt,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final m in SessionMood.values)
                        ChoiceChip(
                          label: Text(l.moodLabel(m)),
                          selected: _mood == m,
                          onSelected: (sel) => setState(
                            () => _mood = sel ? m : null,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.sessionWeather,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final w in SessionWeather.values)
                        ChoiceChip(
                          avatar: Icon(_weatherIcon(w), size: 16),
                          label: Text(l.weatherLabel(w)),
                          selected: _weather == w,
                          onSelected: (sel) => setState(
                            () => _weather = sel ? w : null,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _friendsCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l.sessionFriends,
                      helperText: l.sessionFriendsHelper,
                      prefixIcon: const Icon(Icons.group_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _notesCtrl,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l.fieldNotes,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l.actionCancel),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(l.actionSave),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
