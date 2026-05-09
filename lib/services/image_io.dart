import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Copies the picked image into app documents and returns the absolute path.
Future<String> persistPickedFile(XFile picked) async {
  final dir = await getApplicationDocumentsDirectory();
  final photosDir = Directory('${dir.path}/photos');
  if (!await photosDir.exists()) {
    await photosDir.create(recursive: true);
  }
  final ext = _extOf(picked.name);
  final filename =
      '${DateTime.now().microsecondsSinceEpoch}${ext.isEmpty ? '.jpg' : ext}';
  final dest = '${photosDir.path}/$filename';
  await File(picked.path).copy(dest);
  return dest;
}

Future<void> deleteFile(String path) async {
  try {
    final f = File(path);
    if (await f.exists()) await f.delete();
  } catch (_) {
    // Ignore — UI already removed the reference.
  }
}

Widget fileImage(
  String path, {
  BoxFit fit = BoxFit.cover,
  double? width,
  double? height,
  required Widget Function() onError,
}) {
  return Image.file(
    File(path),
    fit: fit,
    width: width,
    height: height,
    errorBuilder: (_, __, ___) => onError(),
  );
}

String _extOf(String name) {
  final dot = name.lastIndexOf('.');
  if (dot < 0) return '';
  return name.substring(dot).toLowerCase();
}
