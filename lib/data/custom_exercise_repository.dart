import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/exercise.dart';

abstract class CustomExerciseRepository {
  Future<List<Exercise>> all();
  Future<void> save(Exercise exercise);
  Future<void> delete(String id);
}

class SharedPrefsCustomExerciseRepository implements CustomExerciseRepository {
  SharedPrefsCustomExerciseRepository(this._prefs);

  static const _key = 'custom_exercises_v1';
  final SharedPreferences _prefs;

  static Future<SharedPrefsCustomExerciseRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsCustomExerciseRepository(prefs);
  }

  @override
  Future<List<Exercise>> all() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(Exercise exercise) async {
    final current = await all();
    final without = current.where((e) => e.id != exercise.id).toList();
    final updated = [...without, exercise];
    await _prefs.setString(
      _key,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<void> delete(String id) async {
    final current = await all();
    final updated = current.where((e) => e.id != id).toList();
    await _prefs.setString(
      _key,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }
}
