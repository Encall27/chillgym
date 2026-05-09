import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/template.dart';

abstract class TemplateRepository {
  Future<List<WorkoutTemplate>> all();
  Future<void> save(WorkoutTemplate template);
  Future<void> delete(String id);
}

class SharedPrefsTemplateRepository implements TemplateRepository {
  SharedPrefsTemplateRepository(this._prefs);

  static const _key = 'templates_v1';
  final SharedPreferences _prefs;

  static Future<SharedPrefsTemplateRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsTemplateRepository(prefs);
  }

  @override
  Future<List<WorkoutTemplate>> all() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => WorkoutTemplate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> save(WorkoutTemplate template) async {
    final current = await all();
    final without = current.where((t) => t.id != template.id).toList();
    final updated = [...without, template];
    await _prefs.setString(
      _key,
      jsonEncode(updated.map((t) => t.toJson()).toList()),
    );
  }

  @override
  Future<void> delete(String id) async {
    final current = await all();
    final updated = current.where((t) => t.id != id).toList();
    await _prefs.setString(
      _key,
      jsonEncode(updated.map((t) => t.toJson()).toList()),
    );
  }
}
