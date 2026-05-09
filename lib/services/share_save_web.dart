// dart:html still works in Flutter web. The package:web migration is queued for
// when we touch this file again — see issue tracker.
// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:typed_data';

/// Triggers a browser download of the bytes as a file with the given filename.
/// Returns a sentinel string so callers can show a "downloaded" message
/// uniformly with the io path.
Future<String> saveBytes(Uint8List bytes, String filename) async {
  final blob = html.Blob([bytes], 'image/png');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..download = filename
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
  return 'downloaded: $filename';
}
