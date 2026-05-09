import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/body_photo_repository.dart';
import '../data/bodyweight_repository.dart';
import '../data/custom_exercise_repository.dart';
import '../data/session_repository.dart';
import '../data/template_repository.dart';
import '../domain/feedback_engine.dart';
import '../domain/models/body_photo_entry.dart';
import '../domain/models/bodyweight_entry.dart';
import '../domain/models/exercise.dart';
import '../domain/models/session.dart';
import '../domain/models/template.dart';
import '../domain/units.dart';
import 'preferences.dart';

/// Backwards-incompatible schema bumps go here. Imports check the version and
/// refuse anything they don't understand.
const int kBackupSchemaVersion = 1;

/// Container for a full export. Top-level shape is intentionally flat so it's
/// easy to inspect by eye in a JSON viewer.
class BackupBundle {
  const BackupBundle({
    required this.exportedAt,
    required this.sessions,
    required this.templates,
    required this.customExercises,
    required this.bodyweightEntries,
    required this.experienceLevel,
    required this.healthEnabled,
    required this.notificationsEnabled,
    required this.restTimerSeconds,
    required this.inactivityNudgeDays,
    required this.showRir,
    required this.profileName,
    required this.profileHeightCm,
    required this.profileGoal,
    required this.weightUnit,
    required this.lengthUnit,
    required this.bodyPhotos,
    this.localeTag,
    this.themeModeTag,
  });

  final DateTime exportedAt;
  final List<Session> sessions;
  final List<WorkoutTemplate> templates;
  final List<Exercise> customExercises;
  final List<BodyweightEntry> bodyweightEntries;
  final ExperienceLevel experienceLevel;
  final bool healthEnabled;
  final bool notificationsEnabled;
  final int restTimerSeconds;
  final int inactivityNudgeDays;
  final bool showRir;
  final String? profileName;
  final double? profileHeightCm;
  final String? profileGoal;
  final WeightUnit weightUnit;
  final LengthUnit lengthUnit;
  final List<BodyPhotoEntry> bodyPhotos;
  final String? localeTag;
  final String? themeModeTag;

  Map<String, dynamic> toJson() => {
        'schemaVersion': kBackupSchemaVersion,
        'exportedAt': exportedAt.toIso8601String(),
        'sessions': sessions.map((e) => e.toJson()).toList(),
        'templates': templates.map((e) => e.toJson()).toList(),
        'customExercises': customExercises.map((e) => e.toJson()).toList(),
        'bodyweightEntries':
            bodyweightEntries.map((e) => e.toJson()).toList(),
        'bodyPhotos': bodyPhotos.map((e) => e.toJson()).toList(),
        'preferences': {
          'experienceLevel': experienceLevel.name,
          'healthEnabled': healthEnabled,
          'notificationsEnabled': notificationsEnabled,
          'restTimerSeconds': restTimerSeconds,
          'inactivityNudgeDays': inactivityNudgeDays,
          'showRir': showRir,
          if (profileName != null) 'profileName': profileName,
          if (profileHeightCm != null) 'profileHeightCm': profileHeightCm,
          if (profileGoal != null) 'profileGoal': profileGoal,
          'weightUnit': weightUnit.name,
          'lengthUnit': lengthUnit.name,
          if (localeTag != null) 'localeTag': localeTag,
          if (themeModeTag != null) 'themeModeTag': themeModeTag,
        },
      };

  factory BackupBundle.fromJson(Map<String, dynamic> json) {
    final v = json['schemaVersion'] as int?;
    if (v == null || v > kBackupSchemaVersion) {
      throw FormatException(
        'Unsupported backup schema version: $v (this build understands '
        'up to $kBackupSchemaVersion).',
      );
    }
    final prefs = (json['preferences'] as Map<String, dynamic>?) ?? const {};
    return BackupBundle(
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      sessions: (json['sessions'] as List<dynamic>? ?? [])
          .map((e) => Session.fromJson(e as Map<String, dynamic>))
          .toList(),
      templates: (json['templates'] as List<dynamic>? ?? [])
          .map((e) => WorkoutTemplate.fromJson(e as Map<String, dynamic>))
          .toList(),
      customExercises: (json['customExercises'] as List<dynamic>? ?? [])
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      bodyweightEntries: (json['bodyweightEntries'] as List<dynamic>? ?? [])
          .map((e) => BodyweightEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      bodyPhotos: (json['bodyPhotos'] as List<dynamic>? ?? [])
          .map((e) => BodyPhotoEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      experienceLevel:
          ExperienceLevel.fromName(prefs['experienceLevel'] as String?),
      healthEnabled: prefs['healthEnabled'] as bool? ?? false,
      notificationsEnabled:
          prefs['notificationsEnabled'] as bool? ?? false,
      restTimerSeconds: prefs['restTimerSeconds'] as int? ?? 90,
      inactivityNudgeDays: prefs['inactivityNudgeDays'] as int? ?? 3,
      showRir: prefs['showRir'] as bool? ?? true,
      profileName: prefs['profileName'] as String?,
      profileHeightCm: (prefs['profileHeightCm'] as num?)?.toDouble(),
      profileGoal: prefs['profileGoal'] as String?,
      weightUnit: WeightUnitX.fromName(prefs['weightUnit'] as String?),
      lengthUnit: LengthUnitX.fromName(prefs['lengthUnit'] as String?),
      localeTag: prefs['localeTag'] as String?,
      themeModeTag: prefs['themeModeTag'] as String?,
    );
  }
}

/// One-stop service for export / import / wipe. All operations go through the
/// repositories so a future swap to Firestore needs no changes here.
class BackupService {
  BackupService._();
  static final BackupService instance = BackupService._();

  Future<String> exportToJsonString() async {
    final bundle = await _collect();
    final encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(bundle.toJson());
  }

  /// One row per logged set. CSV is a one-way export; importing it back is
  /// not supported — JSON is the round-trip format.
  Future<String> exportSetsToCsv() async {
    final bundle = await _collect();
    final buf = StringBuffer();
    buf.writeln(
      'session_id,session_started_at,place,mood,weather,'
      'exercise,muscle,kind,'
      'set_index,weight_kg,reps,rir,distance_m,duration_s,notes',
    );
    for (final s in bundle.sessions) {
      for (final e in s.entries) {
        for (var i = 0; i < e.sets.length; i++) {
          final w = e.sets[i];
          buf.writeln([
            _csv(s.id),
            _csv(s.startedAt.toIso8601String()),
            _csv(s.place),
            _csv(s.mood?.name),
            _csv(s.weather?.name),
            _csv(e.exercise.name),
            _csv(e.exercise.primaryMuscle.name),
            _csv(e.exercise.kind.name),
            i + 1,
            _csv(w.weightKg),
            _csv(w.reps),
            _csv(w.rir),
            _csv(w.distanceMeters),
            _csv(w.durationSeconds),
            _csv(w.notes),
          ].join(','));
        }
      }
    }
    return buf.toString();
  }

  String _csv(Object? v) {
    if (v == null) return '';
    final s = v.toString();
    if (s.contains(',') || s.contains('"') || s.contains('\n')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }

  Future<BackupBundle> _collect() async {
    final sessionRepo = await SharedPrefsSessionRepository.create();
    final templateRepo = await SharedPrefsTemplateRepository.create();
    final customRepo = await SharedPrefsCustomExerciseRepository.create();
    final bwRepo = await SharedPrefsBodyweightRepository.create();
    final bpRepo = await SharedPrefsBodyPhotoRepository.create();
    final prefs = await Preferences.create();
    return BackupBundle(
      exportedAt: DateTime.now(),
      sessions: await sessionRepo.all(),
      templates: await templateRepo.all(),
      customExercises: await customRepo.all(),
      bodyweightEntries: await bwRepo.all(),
      bodyPhotos: await bpRepo.all(),
      localeTag: prefs.localeTag,
      themeModeTag: prefs.themeModeTag,
      experienceLevel: prefs.experienceLevel,
      healthEnabled: prefs.healthEnabled,
      notificationsEnabled: prefs.notificationsEnabled,
      restTimerSeconds: prefs.restTimerSeconds,
      inactivityNudgeDays: prefs.inactivityNudgeDays,
      showRir: prefs.showRir,
      profileName: prefs.profileName,
      profileHeightCm: prefs.profileHeightCm,
      profileGoal: prefs.profileGoal,
      weightUnit: prefs.weightUnit,
      lengthUnit: prefs.lengthUnit,
    );
  }

  /// Replaces every collection with the bundle's contents. Throws on parse
  /// errors; the caller should keep the user's existing data untouched in that
  /// case.
  Future<void> importFromJsonString(String json) async {
    final decoded = jsonDecode(json);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Backup must be a JSON object.');
    }
    final bundle = BackupBundle.fromJson(decoded);

    final sessionRepo = await SharedPrefsSessionRepository.create();
    final templateRepo = await SharedPrefsTemplateRepository.create();
    final customRepo = await SharedPrefsCustomExerciseRepository.create();
    final bwRepo = await SharedPrefsBodyweightRepository.create();
    final bpRepo = await SharedPrefsBodyPhotoRepository.create();
    final prefs = await Preferences.create();

    // Clear then restore. We don't merge — predictable round-trip > clever.
    await sessionRepo.clear();
    for (final s in bundle.sessions) {
      await sessionRepo.save(s);
    }

    for (final t in await templateRepo.all()) {
      await templateRepo.delete(t.id);
    }
    for (final t in bundle.templates) {
      await templateRepo.save(t);
    }

    for (final e in await customRepo.all()) {
      await customRepo.delete(e.id);
    }
    for (final e in bundle.customExercises) {
      await customRepo.save(e);
    }

    await bwRepo.replaceAll(bundle.bodyweightEntries);
    await bpRepo.replaceAll(bundle.bodyPhotos);

    await prefs.setExperienceLevel(bundle.experienceLevel);
    await prefs.setHealthEnabled(bundle.healthEnabled);
    await prefs.setNotificationsEnabled(bundle.notificationsEnabled);
    await prefs.setRestTimerSeconds(bundle.restTimerSeconds);
    await prefs.setInactivityNudgeDays(bundle.inactivityNudgeDays);
    await prefs.setShowRir(bundle.showRir);
    await prefs.setProfileName(bundle.profileName);
    await prefs.setProfileHeightCm(bundle.profileHeightCm);
    await prefs.setProfileGoal(bundle.profileGoal);
    await prefs.setWeightUnit(bundle.weightUnit);
    await prefs.setLengthUnit(bundle.lengthUnit);
    await prefs.setLocaleTag(bundle.localeTag);
    await prefs.setThemeModeTag(bundle.themeModeTag);
  }

  /// Wipes every key this app owns from `shared_preferences`. Photos on disk
  /// (mobile only) are intentionally left in place; they're orphans that will
  /// be cleaned up on next pick. Keeping the wipe simple beats half-cleaning.
  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    const keys = [
      'sessions_v1',
      'templates_v1',
      'custom_exercises_v1',
      'bodyweight_v1',
      'pref_health_enabled',
      'pref_experience_level',
      'pref_notifications_enabled',
      'pref_rest_timer_seconds',
      'pref_inactivity_nudge_days',
      'pref_show_rir',
      'pref_profile_name',
      'pref_profile_height_cm',
      'pref_profile_goal',
      'pref_weight_unit',
      'pref_length_unit',
      'pref_locale',
      'pref_theme_mode',
      'body_photos_v1',
    ];
    for (final k in keys) {
      await prefs.remove(k);
    }
  }
}
