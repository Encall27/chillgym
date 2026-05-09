import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/body_photo_entry.dart';

abstract class BodyPhotoRepository {
  Future<List<BodyPhotoEntry>> all();
  Future<void> save(BodyPhotoEntry entry);
  Future<void> delete(String id);
  Future<void> replaceAll(List<BodyPhotoEntry> entries);
}

class SharedPrefsBodyPhotoRepository implements BodyPhotoRepository {
  SharedPrefsBodyPhotoRepository._(this._prefs);

  static const _key = 'body_photos_v1';
  final SharedPreferences _prefs;

  static Future<SharedPrefsBodyPhotoRepository> create() async {
    final p = await SharedPreferences.getInstance();
    return SharedPrefsBodyPhotoRepository._(p);
  }

  @override
  Future<List<BodyPhotoEntry>> all() async {
    final raw = _prefs.getStringList(_key) ?? const <String>[];
    return raw
        .map((e) => BodyPhotoEntry.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> save(BodyPhotoEntry entry) async {
    final list = await all();
    final idx = list.indexWhere((e) => e.id == entry.id);
    if (idx >= 0) {
      list[idx] = entry;
    } else {
      list.add(entry);
    }
    await _writeAll(list);
  }

  @override
  Future<void> delete(String id) async {
    final list = await all();
    list.removeWhere((e) => e.id == id);
    await _writeAll(list);
  }

  @override
  Future<void> replaceAll(List<BodyPhotoEntry> entries) async {
    await _writeAll(entries);
  }

  Future<void> _writeAll(List<BodyPhotoEntry> list) async {
    await _prefs.setStringList(
      _key,
      list.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }
}
