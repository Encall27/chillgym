import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/custom_exercise_repository.dart';
import '../data/exercise_catalog.dart';
import '../domain/models/exercise.dart';

final customExerciseRepositoryProvider =
    FutureProvider<CustomExerciseRepository>((ref) {
  return SharedPrefsCustomExerciseRepository.create();
});

/// User-defined exercises persisted via the custom repository.
final customExercisesProvider = FutureProvider<List<Exercise>>((ref) async {
  final repo = await ref.watch(customExerciseRepositoryProvider.future);
  final list = await repo.all();
  list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return list;
});

/// Merged catalog of built-in + custom exercises. UI watches this. Returns
/// the built-ins immediately and folds customs in once loaded; that way the
/// library is never blank on first paint.
final exerciseCatalogProvider = Provider<List<Exercise>>((ref) {
  final asyncCustom = ref.watch(customExercisesProvider);
  final customs = asyncCustom.maybeWhen(data: (l) => l, orElse: () => const []);
  return List.unmodifiable([...kBuiltInExercises, ...customs]);
});
