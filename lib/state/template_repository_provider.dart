import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/template_repository.dart';
import '../domain/models/template.dart';

final templateRepositoryProvider = FutureProvider<TemplateRepository>((ref) {
  return SharedPrefsTemplateRepository.create();
});

final templatesProvider = FutureProvider<List<WorkoutTemplate>>((ref) async {
  final repo = await ref.watch(templateRepositoryProvider.future);
  final list = await repo.all();
  list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return list;
});
