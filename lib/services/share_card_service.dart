import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'share_save_web.dart'
    if (dart.library.io) 'share_save_io.dart' as save_helper;

class ShareCardService {
  ShareCardService._();
  static final ShareCardService instance = ShareCardService._();

  /// Captures the widget tree under [boundaryKey] as a PNG.
  Future<Uint8List> captureToPng({
    required GlobalKey boundaryKey,
    double pixelRatio = 1.5,
  }) async {
    final boundary = boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) {
      throw StateError('RepaintBoundary not in tree yet — open the dialog '
          'first, then capture.');
    }
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw StateError('Failed to encode share card to PNG.');
    }
    return byteData.buffer.asUint8List();
  }

  /// Persists or downloads. Returns a user-facing description of where the
  /// file ended up: a path on mobile, a "downloaded: …" string on web.
  Future<String> saveOrDownload(Uint8List bytes, String filename) {
    return save_helper.saveBytes(bytes, filename);
  }
}
