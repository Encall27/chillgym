import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Stub used on web — never actually invoked because callers gate on
/// `kIsWeb` first.
Future<String> persistPickedFile(XFile picked) async {
  throw UnsupportedError('persistPickedFile is not supported on web');
}

Future<void> deleteFile(String path) async {
  // No-op on web.
}

Widget fileImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  required Widget Function() onError,
}) {
  return onError();
}
