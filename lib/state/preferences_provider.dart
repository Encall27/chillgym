import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/feedback_engine.dart';
import '../domain/units.dart';
import '../services/preferences.dart';

final preferencesProvider = FutureProvider<Preferences>((ref) {
  return Preferences.create();
});

/// Synchronous-feeling provider over the health-enabled flag. UI uses
/// `healthEnabledProvider` to read; the toggle calls into `Preferences`
/// directly and then invalidates this provider.
final healthEnabledProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.healthEnabled;
});

final experienceLevelProvider = FutureProvider<ExperienceLevel>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.experienceLevel;
});

final notificationsEnabledProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.notificationsEnabled;
});

final restTimerSecondsProvider = FutureProvider<int>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.restTimerSeconds;
});

final inactivityNudgeDaysProvider = FutureProvider<int>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.inactivityNudgeDays;
});

final showRirProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.showRir;
});

final profileNameProvider = FutureProvider<String?>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.profileName;
});

final profileHeightCmProvider = FutureProvider<double?>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.profileHeightCm;
});

final profileGoalProvider = FutureProvider<String?>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.profileGoal;
});

final weightUnitProvider = FutureProvider<WeightUnit>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.weightUnit;
});

final lengthUnitProvider = FutureProvider<LengthUnit>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.lengthUnit;
});

/// Stored locale tag. `null` = follow the device's system locale.
final localeTagProvider = FutureProvider<String?>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.localeTag;
});

/// Stored theme-mode tag (`'light'`, `'dark'`, or `null` for system).
final themeModeTagProvider = FutureProvider<String?>((ref) async {
  final prefs = await ref.watch(preferencesProvider.future);
  return prefs.themeModeTag;
});
