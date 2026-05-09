import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/bodyweight_entry.dart';

abstract class BodyweightRepository {
  Future<List<BodyweightEntry>> all();
  Future<void> save(BodyweightEntry entry);
  Future<void> delete(DateTime date);
  Future<void> replaceAll(List<BodyweightEntry> entries);
}

class SharedPrefsBodyweightRepository implements BodyweightRepository {
  SharedPrefsBodyweightRepository(this._prefs);

  static const _key = 'bodyweight_v1';
  final SharedPreferences _prefs;

  static Future<SharedPrefsBodyweightRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsBodyweightRepository(prefs);
  }

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Future<List<BodyweightEntry>> all() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    final entries = list
        .map((e) => BodyweightEntry.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  @override
  Future<void> save(BodyweightEntry entry) async {
    final day = _dayOnly(entry.date);
    final current = await all();
    final without = current.where((e) => e.date != day).toList();
    final updated = [
      ...without,
      BodyweightEntry(date: day, weightKg: entry.weightKg, note: entry.note),
    ];
    await _persist(updated);
  }

  @override
  Future<void> delete(DateTime date) async {
    final day = _dayOnly(date);
    final current = await all();
    final updated = current.where((e) => e.date != day).toList();
    await _persist(updated);
  }

  @override
  Future<void> replaceAll(List<BodyweightEntry> entries) async {
    await _persist(entries);
  }

  Future<void> _persist(List<BodyweightEntry> list) async {
    await _prefs.setString(
      _key,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
  }
}
