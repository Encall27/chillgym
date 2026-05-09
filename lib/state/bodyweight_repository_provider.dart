import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/bodyweight_repository.dart';
import '../domain/models/bodyweight_entry.dart';

final bodyweightRepositoryProvider =
    FutureProvider<BodyweightRepository>((ref) {
  return SharedPrefsBodyweightRepository.create();
});

final bodyweightEntriesProvider =
    FutureProvider<List<BodyweightEntry>>((ref) async {
  final repo = await ref.watch(bodyweightRepositoryProvider.future);
  return repo.all();
});
