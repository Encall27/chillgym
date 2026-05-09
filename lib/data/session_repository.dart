import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/session.dart';

/// Storage abstraction for finished sessions.
///
/// Implementation note: backed by `shared_preferences` (localStorage on web,
/// NSUserDefaults / SharedPreferences on iOS / Android). Good enough for the
/// MVP demo. The README's roadmap targets Drift; that swap happens here without
/// touching state or UI.
abstract class SessionRepository {
  Future<List<Session>> all();
  Future<void> save(Session session);
  Future<void> delete(String id);
  Future<void> clear();
}

class SharedPrefsSessionRepository implements SessionRepository {
  SharedPrefsSessionRepository(this._prefs);

  static const _key = 'sessions_v1';
  final SharedPreferences _prefs;

  static Future<SharedPrefsSessionRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsSessionRepository(prefs);
  }

  @override
  Future<List<Session>> all() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => Session.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
  }

  @override
  Future<void> save(Session session) async {
    final current = await all();
    final without = current.where((s) => s.id != session.id).toList();
    final updated = [...without, session]
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    await _prefs.setString(
      _key,
      jsonEncode(updated.map((s) => s.toJson()).toList()),
    );
  }

  @override
  Future<void> delete(String id) async {
    final current = await all();
    final updated = current.where((s) => s.id != id).toList();
    await _prefs.setString(
      _key,
      jsonEncode(updated.map((s) => s.toJson()).toList()),
    );
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_key);
  }
}
