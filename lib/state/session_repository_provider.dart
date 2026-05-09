import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/session_repository.dart';
import '../domain/models/session.dart';

/// Async-resolved repository. UI code reads `pastSessionsProvider` and lets
/// Riverpod handle the loading state; writes go through `repositoryProvider`.
final sessionRepositoryProvider = FutureProvider<SessionRepository>((ref) {
  return SharedPrefsSessionRepository.create();
});

/// Stream-like FutureProvider over the persisted session list. Invalidate this
/// after writes so listeners re-fetch.
final pastSessionsProvider = FutureProvider<List<Session>>((ref) async {
  final repo = await ref.watch(sessionRepositoryProvider.future);
  return repo.all();
});
