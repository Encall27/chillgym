import 'exercise_entry.dart';

enum SessionMood {
  strong,
  normal,
  tired,
  sick;

  String get label => switch (this) {
        SessionMood.strong => 'Strong',
        SessionMood.normal => 'Normal',
        SessionMood.tired => 'Tired',
        SessionMood.sick => 'Sick',
      };

  static SessionMood? fromName(String? name) {
    if (name == null) return null;
    for (final m in SessionMood.values) {
      if (m.name == name) return m;
    }
    return null;
  }
}

enum SessionWeather {
  sunny,
  cloudy,
  rainy,
  snowy,
  hot,
  cold;

  String get label => switch (this) {
        SessionWeather.sunny => 'Sunny',
        SessionWeather.cloudy => 'Cloudy',
        SessionWeather.rainy => 'Rainy',
        SessionWeather.snowy => 'Snowy',
        SessionWeather.hot => 'Hot',
        SessionWeather.cold => 'Cold',
      };

  static SessionWeather? fromName(String? name) {
    if (name == null) return null;
    for (final w in SessionWeather.values) {
      if (w.name == name) return w;
    }
    return null;
  }
}

class Session {
  const Session({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.entries = const [],
    this.notes,
    this.place,
    this.mood,
    this.weather,
    this.friends = const [],
    this.name,
  });

  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final List<ExerciseEntry> entries;
  final String? notes;
  final String? place;
  final SessionMood? mood;
  final SessionWeather? weather;
  final List<String> friends;

  /// Optional user-supplied workout title ("Leg Day", "AM Push"). Falls back
  /// to the most-trained muscle / place when null at the display layer.
  final String? name;

  bool get isActive => endedAt == null;

  Duration get duration =>
      (endedAt ?? DateTime.now()).difference(startedAt);

  int get totalSets =>
      entries.fold(0, (sum, e) => sum + e.sets.length);

  double get totalVolumeKg =>
      entries.fold(0.0, (sum, e) => sum + e.totalVolumeKg);

  /// Use sentinel instances to distinguish "leave alone" from "clear to null".
  static const _unset = Object();

  Session copyWith({
    DateTime? endedAt,
    List<ExerciseEntry>? entries,
    Object? notes = _unset,
    Object? place = _unset,
    Object? mood = _unset,
    Object? weather = _unset,
    List<String>? friends,
    Object? name = _unset,
  }) {
    return Session(
      id: id,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      entries: entries ?? this.entries,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      place: identical(place, _unset) ? this.place : place as String?,
      mood: identical(mood, _unset) ? this.mood : mood as SessionMood?,
      weather: identical(weather, _unset)
          ? this.weather
          : weather as SessionWeather?,
      friends: friends ?? this.friends,
      name: identical(name, _unset) ? this.name : name as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'startedAt': startedAt.toIso8601String(),
        if (endedAt != null) 'endedAt': endedAt!.toIso8601String(),
        'entries': entries.map((e) => e.toJson()).toList(),
        if (notes != null) 'notes': notes,
        if (place != null) 'place': place,
        if (mood != null) 'mood': mood!.name,
        if (weather != null) 'weather': weather!.name,
        if (friends.isNotEmpty) 'friends': friends,
        if (name != null) 'name': name,
      };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
        endedAt: json['endedAt'] != null
            ? DateTime.parse(json['endedAt'] as String)
            : null,
        entries: (json['entries'] as List<dynamic>? ?? [])
            .map((e) => ExerciseEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        notes: json['notes'] as String?,
        place: json['place'] as String?,
        mood: SessionMood.fromName(json['mood'] as String?),
        weather: SessionWeather.fromName(json['weather'] as String?),
        friends: (json['friends'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(),
        name: json['name'] as String?,
      );
}
