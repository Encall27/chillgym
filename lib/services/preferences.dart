import 'package:shared_preferences/shared_preferences.dart';

import '../domain/feedback_engine.dart';
import '../domain/units.dart';

/// Lightweight typed wrapper over `shared_preferences`. Keep this file the only
/// place that knows about preference keys.
class Preferences {
  Preferences(this._prefs);

  final SharedPreferences _prefs;

  static Future<Preferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return Preferences(prefs);
  }

  static const _kHealthEnabled = 'pref_health_enabled';
  static const _kExperienceLevel = 'pref_experience_level';
  static const _kNotificationsEnabled = 'pref_notifications_enabled';
  static const _kRestTimerSeconds = 'pref_rest_timer_seconds';
  static const _kInactivityNudgeDays = 'pref_inactivity_nudge_days';
  static const _kShowRir = 'pref_show_rir';
  static const _kProfileName = 'pref_profile_name';
  static const _kProfileHeightCm = 'pref_profile_height_cm';
  static const _kProfileGoal = 'pref_profile_goal';
  static const _kWeightUnit = 'pref_weight_unit';
  static const _kLengthUnit = 'pref_length_unit';

  bool get healthEnabled => _prefs.getBool(_kHealthEnabled) ?? false;

  Future<void> setHealthEnabled(bool value) =>
      _prefs.setBool(_kHealthEnabled, value);

  ExperienceLevel get experienceLevel =>
      ExperienceLevel.fromName(_prefs.getString(_kExperienceLevel));

  Future<void> setExperienceLevel(ExperienceLevel value) =>
      _prefs.setString(_kExperienceLevel, value.name);

  bool get notificationsEnabled =>
      _prefs.getBool(_kNotificationsEnabled) ?? false;

  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(_kNotificationsEnabled, value);

  /// Default rest duration in seconds (90 = 1m30s).
  int get restTimerSeconds => _prefs.getInt(_kRestTimerSeconds) ?? 90;

  Future<void> setRestTimerSeconds(int value) =>
      _prefs.setInt(_kRestTimerSeconds, value);

  /// Days of inactivity before the nudge fires. 0 disables the nudge.
  int get inactivityNudgeDays => _prefs.getInt(_kInactivityNudgeDays) ?? 3;

  Future<void> setInactivityNudgeDays(int value) =>
      _prefs.setInt(_kInactivityNudgeDays, value);

  /// Whether to show the RIR (reps-in-reserve) input on the set sheet.
  bool get showRir => _prefs.getBool(_kShowRir) ?? true;

  Future<void> setShowRir(bool value) => _prefs.setBool(_kShowRir, value);

  String? get profileName {
    final v = _prefs.getString(_kProfileName);
    return (v == null || v.isEmpty) ? null : v;
  }

  Future<void> setProfileName(String? value) async {
    if (value == null || value.isEmpty) {
      await _prefs.remove(_kProfileName);
    } else {
      await _prefs.setString(_kProfileName, value);
    }
  }

  double? get profileHeightCm {
    final v = _prefs.getDouble(_kProfileHeightCm);
    return v;
  }

  Future<void> setProfileHeightCm(double? value) async {
    if (value == null) {
      await _prefs.remove(_kProfileHeightCm);
    } else {
      await _prefs.setDouble(_kProfileHeightCm, value);
    }
  }

  /// Free-form for now; UI offers preset chips.
  String? get profileGoal {
    final v = _prefs.getString(_kProfileGoal);
    return (v == null || v.isEmpty) ? null : v;
  }

  Future<void> setProfileGoal(String? value) async {
    if (value == null || value.isEmpty) {
      await _prefs.remove(_kProfileGoal);
    } else {
      await _prefs.setString(_kProfileGoal, value);
    }
  }

  WeightUnit get weightUnit =>
      WeightUnitX.fromName(_prefs.getString(_kWeightUnit));

  Future<void> setWeightUnit(WeightUnit value) =>
      _prefs.setString(_kWeightUnit, value.name);

  LengthUnit get lengthUnit =>
      LengthUnitX.fromName(_prefs.getString(_kLengthUnit));

  Future<void> setLengthUnit(LengthUnit value) =>
      _prefs.setString(_kLengthUnit, value.name);

  static const _kLocale = 'pref_locale';

  /// `null` = follow system locale; otherwise an explicit override like `"en"`
  /// or `"zh_HK"`.
  String? get localeTag {
    final v = _prefs.getString(_kLocale);
    return (v == null || v.isEmpty) ? null : v;
  }

  Future<void> setLocaleTag(String? value) async {
    if (value == null || value.isEmpty) {
      await _prefs.remove(_kLocale);
    } else {
      await _prefs.setString(_kLocale, value);
    }
  }

  static const _kThemeMode = 'pref_theme_mode';

  /// Stored as 'system' / 'light' / 'dark'. `null` => system.
  String? get themeModeTag {
    final v = _prefs.getString(_kThemeMode);
    return (v == null || v.isEmpty) ? null : v;
  }

  Future<void> setThemeModeTag(String? value) async {
    if (value == null || value.isEmpty || value == 'system') {
      await _prefs.remove(_kThemeMode);
    } else {
      await _prefs.setString(_kThemeMode, value);
    }
  }
}
