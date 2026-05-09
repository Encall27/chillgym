import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../l10n/translations.dart';
import '../../services/image_io_stub.dart'
    if (dart.library.io) '../../services/image_io.dart' as io_helper;
import '../../services/image_service.dart';

/// Renders a photo from a stored ref (data URL on web, file path on mobile).
class PhotoRefImage extends StatelessWidget {
  const PhotoRefImage({
    super.key,
    required this.ref,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String ref;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (ref.startsWith('data:')) {
      final comma = ref.indexOf(',');
      if (comma < 0) return _broken(context);
      try {
        final bytes = base64Decode(ref.substring(comma + 1));
        return Image.memory(bytes, fit: fit, width: width, height: height);
      } catch (_) {
        return _broken(context);
      }
    }
    if (kIsWeb) return _broken(context);
    return io_helper.fileImage(
      ref,
      fit: fit,
      width: width,
      height: height,
      onError: () => _broken(context),
    );
  }

  Widget _broken(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      color: scheme.surfaceContainerHigh,
      alignment: Alignment.center,
      child: Icon(Icons.broken_image_outlined, color: scheme.onSurfaceVariant),
    );
  }
}

/// Horizontal strip of square photo thumbnails plus an "add" button.
class PhotoStrip extends StatelessWidget {
  const PhotoStrip({
    super.key,
    required this.refs,
    required this.onAdd,
    required this.onView,
    required this.onDelete,
  });

  final List<String> refs;
  final VoidCallback onAdd;
  final void Function(int index) onView;
  final void Function(String ref) onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: refs.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == refs.length) {
            return InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            );
          }
          final ref = refs[i];
          return GestureDetector(
            onTap: () => onView(i),
            onLongPress: () => onDelete(ref),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: PhotoRefImage(ref: ref, width: 72, height: 72),
            ),
          );
        },
      ),
    );
  }
}

/// Full-screen viewer for an attached photo.
class PhotoViewerScreen extends StatelessWidget {
  const PhotoViewerScreen({
    super.key,
    required this.refs,
    required this.initialIndex,
  });

  final List<String> refs;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: initialIndex);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${initialIndex + 1} / ${refs.length}'),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: refs.length,
        itemBuilder: (_, i) => InteractiveViewer(
          child: Center(
            child: PhotoRefImage(ref: refs[i], fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}

/// Asks the user where to pick the photo from. Returns the picked + persisted
/// ref, or null if cancelled.
///
/// `compact: true` shrinks the on-web encoding further (~800px / quality 50)
/// for volume-heavy use cases like body progress photos, where dozens or
/// hundreds of shots need to coexist in localStorage's tiny ~5MB quota.
Future<String?> pickAndPersistPhoto(
  BuildContext context, {
  bool compact = false,
}) async {
  final l = tr(context);
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!kIsWeb)
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(l.actionTakePhoto),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: Text(l.actionChooseFromGallery),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null) return null;
  if (compact) {
    return ImageService.instance.pickAndPersist(
      source: source,
      maxWidthWeb: 800,
      qualityWeb: 50,
    );
  }
  return ImageService.instance.pickAndPersist(source: source);
}
