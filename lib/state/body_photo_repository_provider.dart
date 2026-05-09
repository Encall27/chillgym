import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/body_photo_repository.dart';
import '../domain/models/body_photo_entry.dart';

final bodyPhotoRepositoryProvider =
    FutureProvider<BodyPhotoRepository>((ref) async {
  return SharedPrefsBodyPhotoRepository.create();
});

final bodyPhotosProvider = FutureProvider<List<BodyPhotoEntry>>((ref) async {
  final repo = await ref.watch(bodyPhotoRepositoryProvider.future);
  return repo.all();
});
