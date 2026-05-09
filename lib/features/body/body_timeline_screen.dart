import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/body_photo_entry.dart';
import '../../domain/units.dart';
import '../../l10n/translations.dart';
import '../shared/entry_photos.dart';

enum _Speed { slow, normal, fast }

/// Auto-advancing slideshow that "plays back" the user's progress photos in
/// chronological order with a crossfade between slides. Tap to pause/resume,
/// swipe to scrub, change speed in the bottom bar.
class BodyTimelineScreen extends StatefulWidget {
  const BodyTimelineScreen({
    super.key,
    required this.entries,
    required this.unit,
  });

  /// Chronological order required (oldest first). The screen does not sort.
  final List<BodyPhotoEntry> entries;
  final WeightUnit unit;

  @override
  State<BodyTimelineScreen> createState() => _BodyTimelineScreenState();
}

class _BodyTimelineScreenState extends State<BodyTimelineScreen> {
  int _index = 0;
  bool _playing = true;
  _Speed _speed = _Speed.normal;
  Timer? _timer;

  Duration get _slideDuration => switch (_speed) {
        _Speed.slow => const Duration(milliseconds: 2500),
        _Speed.normal => const Duration(milliseconds: 1400),
        _Speed.fast => const Duration(milliseconds: 700),
      };

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _restartTimer() {
    _timer?.cancel();
    if (!_playing) return;
    _timer = Timer.periodic(_slideDuration, (_) {
      if (!mounted) return;
      setState(() {
        if (_index + 1 >= widget.entries.length) {
          // Loop back to the start so the user can re-watch.
          _index = 0;
        } else {
          _index += 1;
        }
      });
    });
  }

  void _togglePlay() {
    setState(() => _playing = !_playing);
    _restartTimer();
  }

  void _changeSpeed(_Speed s) {
    setState(() => _speed = s);
    _restartTimer();
  }

  void _scrub(int direction) {
    setState(() {
      _index = (_index + direction).clamp(0, widget.entries.length - 1);
    });
    if (_playing) _restartTimer();
  }

  @override
  Widget build(BuildContext context) {
    final l = tr(context);
    final entry = widget.entries[_index];
    final dateFmt = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    );
    final weightLine = entry.weightKg == null
        ? null
        : formatWeightFromKg(entry.weightKg!, widget.unit);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l.bodyPhotosTimelineTitle),
        actions: [
          IconButton(
            icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
            tooltip: l.bodyPhotosPlay,
            onPressed: _togglePlay,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _togglePlay,
        onHorizontalDragEnd: (d) {
          final v = d.primaryVelocity ?? 0;
          if (v < -200) _scrub(1);
          if (v > 200) _scrub(-1);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Center(
                  key: ValueKey(entry.id),
                  child: PhotoRefImage(
                    ref: entry.photoRef,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 12,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dateFmt.format(entry.date),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (weightLine != null || entry.note != null)
                        Text(
                          [
                            if (weightLine != null) weightLine,
                            if (entry.note != null) entry.note!,
                          ].join(' · '),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: widget.entries.length == 1
                        ? 1
                        : _index / (widget.entries.length - 1),
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l.bodyPhotosSlideRate,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(width: 12),
                      _SpeedChip(
                        label: l.bodyPhotosSlideRateSlow,
                        selected: _speed == _Speed.slow,
                        onTap: () => _changeSpeed(_Speed.slow),
                      ),
                      const SizedBox(width: 8),
                      _SpeedChip(
                        label: l.bodyPhotosSlideRateNormal,
                        selected: _speed == _Speed.normal,
                        onTap: () => _changeSpeed(_Speed.normal),
                      ),
                      const SizedBox(width: 8),
                      _SpeedChip(
                        label: l.bodyPhotosSlideRateFast,
                        selected: _speed == _Speed.fast,
                        onTap: () => _changeSpeed(_Speed.fast),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.bodyPhotosPlayHint,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.white12,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
