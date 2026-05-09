import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Saves the bytes to `<docs>/share/<filename>` and returns the path. Mobile
/// share-sheet integration (share_plus) is intentionally deferred until iOS
/// device testing — for now the user can find the file in their app's
/// document directory.
Future<String> saveBytes(Uint8List bytes, String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final shareDir = Directory('${dir.path}/share');
  if (!await shareDir.exists()) {
    await shareDir.create(recursive: true);
  }
  final path = '${shareDir.path}/$filename';
  final f = File(path);
  await f.writeAsBytes(bytes, flush: true);
  return path;
}
