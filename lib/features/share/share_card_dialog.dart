import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/models/session.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../../services/share_card_service.dart';
import '../shared/entry_photos.dart';
import 'share_card.dart';

/// Shows the rendered share card at preview size + a row of session photos
/// the user can share instead. Two actions: **Save** (download / write to
/// disk) and **Share** (system share sheet on mobile, download fallback on
/// web). When the session has no photos yet, suggests taking one now.
class ShareCardDialog extends StatefulWidget {
  const ShareCardDialog({
    super.key,
    required this.session,
    required this.unit,
  });

  final Session session;
  final WeightUnit unit;

  @override
  State<ShareCardDialog> createState() => _ShareCardDialogState();
}

class _ShareCardDialogState extends State<ShareCardDialog> {
  final _boundaryKey = GlobalKey();
  bool _busy = false;

  /// Aggregate every photoRef attached to any entry of this session.
  List<String> get _sessionPhotoRefs {
    final out = <String>[];
    for (final e in widget.session.entries) {
      out.addAll(e.photoRefs);
    }
    return out;
  }

  String _filename() {
    final stamp = DateFormat('yyyyMMdd_HHmm').format(widget.session.startedAt);
    return 'chillgym_$stamp.png';
  }

  Future<Uint8List> _captureCard() {
    return ShareCardService.instance.captureToPng(
      boundaryKey: _boundaryKey,
      pixelRatio: 1.5,
    );
  }

  Future<void> _saveCard() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l = tr(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final png = await _captureCard();
      final result =
          await ShareCardService.instance.saveOrDownload(png, _filename());
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(kIsWeb ? l.dataDownloaded : l.dataSavedTo(result)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l.genericFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _shareCard() async {
    if (_busy) return;
    setState(() => _busy = true);
    final l = tr(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final png = await _captureCard();
      if (kIsWeb) {
        // The Web Share API is patchy for raw images across browsers — fall
        // back to a download. Users can then attach it manually.
        await ShareCardService.instance.saveOrDownload(png, _filename());
        if (mounted) {
          messenger.showSnackBar(SnackBar(content: Text(l.dataDownloaded)));
        }
      } else {
        await Share.shareXFiles(
          [
            XFile.fromData(
              png,
              mimeType: 'image/png',
              name: _filename(),
            ),
          ],
          text: l.shareCardShareCaption,
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l.shareCardShareFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sharePhotoRef(String ref) async {
    if (_busy) return;
    setState(() => _busy = true);
    final l = tr(context);
    final messenger = ScaffoldMessenger.of(context);
    try {
      if (ref.startsWith('data:')) {
        // Web → decode + download. share_plus on web doesn't reliably round-
        // trip data URLs across browsers.
        final comma = ref.indexOf(',');
        if (comma < 0) {
          throw const FormatException('Bad photo data URL.');
        }
        final bytes = base64Decode(ref.substring(comma + 1));
        await ShareCardService.instance.saveOrDownload(
          bytes,
          'chillgym_photo_${DateTime.now().microsecondsSinceEpoch}.jpg',
        );
        if (mounted) {
          messenger.showSnackBar(SnackBar(content: Text(l.dataDownloaded)));
        }
      } else {
        await Share.shareXFiles(
          [XFile(ref)],
          text: l.shareCardShareCaption,
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l.shareCardShareFailed(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _takeAndSharePhoto() async {
    if (_busy) return;
    final picked = await pickAndPersistPhoto(context);
    if (picked == null) return;
    await _sharePhotoRef(picked);
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    final photos = _sessionPhotoRefs;
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.shareCardTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Flexible(
                flex: 4,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: RepaintBoundary(
                    key: _boundaryKey,
                    child: ShareCard(
                      session: widget.session,
                      unit: widget.unit,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l.shareCardSessionPhotosTitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: 8),
              if (photos.isEmpty)
                _NoPhotosPrompt(onTake: _busy ? null : _takeAndSharePhoto)
              else
                _PhotoStrip(
                  refs: photos,
                  onShare: _busy ? null : _sharePhotoRef,
                  onAdd: _busy ? null : _takeAndSharePhoto,
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
                    onPressed:
                        _busy ? null : () => Navigator.of(context).pop(),
                    child: Text(l.actionClose),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: _busy ? null : _saveCard,
                    icon: Icon(kIsWeb ? Icons.download : Icons.save_alt),
                    label: Text(l.shareCardSave),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _busy ? null : _shareCard,
                    icon: _busy
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.ios_share),
                    label: Text(l.shareCardShareToApps),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({
    required this.refs,
    required this.onShare,
    required this.onAdd,
  });

  final List<String> refs;
  final void Function(String ref)? onShare;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 84,
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
                width: 84,
                decoration: BoxDecoration(
                  border: Border.all(color: scheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            );
          }
          final ref = refs[i];
          return InkWell(
            onTap: onShare == null ? null : () => onShare!(ref),
            borderRadius: BorderRadius.circular(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PhotoRefImage(ref: ref, width: 84, height: 84),
                  Positioned(
                    right: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(
                        Icons.ios_share,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NoPhotosPrompt extends StatelessWidget {
  const _NoPhotosPrompt({required this.onTake});

  final VoidCallback? onTake;

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.camera_alt_outlined, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l.shareCardNoSessionPhotos,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonalIcon(
            onPressed: onTake,
            icon: const Icon(Icons.add_a_photo_outlined, size: 18),
            label: Text(l.shareCardTakePhoto),
          ),
        ],
      ),
    );
  }
}
