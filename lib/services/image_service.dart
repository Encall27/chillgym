import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'image_io_stub.dart' if (dart.library.io) 'image_io.dart' as io_helper;

/// Cross-platform photo picker. Returns a stable string reference that can be
/// stored in JSON: a `data:image/...;base64,...` URL on web, or an absolute file
/// path under app documents on mobile.
class ImageService {
  ImageService._();
  static final ImageService instance = ImageService._();

  final ImagePicker _picker = ImagePicker();

  /// Picks an image from camera (mobile only) or gallery and returns a ref.
  /// Returns null if the user cancelled.
  ///
  /// On web, photos are base64-encoded into data URLs and the *whole* list of
  /// refs is round-tripped through `shared_preferences` → `localStorage`, which
  /// only allows ~5MB per origin. Defaults are tuned so a typical user can
  /// keep dozens of photos before hitting the quota; pass tighter values for
  /// volume-heavy use-cases like body progress shots.
  Future<String?> pickAndPersist({
    required ImageSource source,
    int maxWidthMobile = 1600,
    int qualityMobile = 75,
    int maxWidthWeb = 1024,
    int qualityWeb = 60,
  }) async {
    // Camera is not meaningful on web — fall back to gallery.
    final effective = (kIsWeb && source == ImageSource.camera)
        ? ImageSource.gallery
        : source;
    final XFile? picked = await _picker.pickImage(
      source: effective,
      maxWidth: (kIsWeb ? maxWidthWeb : maxWidthMobile).toDouble(),
      imageQuality: kIsWeb ? qualityWeb : qualityMobile,
    );
    if (picked == null) return null;

    if (kIsWeb) {
      final bytes = await picked.readAsBytes();
      final mime = _mimeFor(picked.name);
      return 'data:$mime;base64,${base64Encode(bytes)}';
    }
    return io_helper.persistPickedFile(picked);
  }

  /// Best-effort delete of a stored photo. Data URLs and missing files are
  /// silently ignored.
  Future<void> tryDelete(String ref) async {
    if (kIsWeb || ref.startsWith('data:')) return;
    await io_helper.deleteFile(ref);
  }

  String _mimeFor(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.heic') || lower.endsWith('.heif')) return 'image/heic';
    return 'image/jpeg';
  }
}
