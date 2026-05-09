/// One progress photo of the user's body, dated and optionally tagged with a
/// bodyweight reading and a free-form note. The slideshow plays these in
/// chronological order so the user can see physical changes over time.
class BodyPhotoEntry {
  const BodyPhotoEntry({
    required this.id,
    required this.date,
    required this.photoRef,
    this.weightKg,
    this.note,
  });

  final String id;

  /// Day-precision date the photo represents.
  final DateTime date;

  /// Either a data URL (web) or an absolute file path (mobile). Same format
  /// as exercise-attachment refs so callers can reuse `PhotoRefImage`.
  final String photoRef;

  final double? weightKg;
  final String? note;

  static const _unset = Object();

  BodyPhotoEntry copyWith({
    DateTime? date,
    String? photoRef,
    Object? weightKg = _unset,
    Object? note = _unset,
  }) {
    return BodyPhotoEntry(
      id: id,
      date: date ?? this.date,
      photoRef: photoRef ?? this.photoRef,
      weightKg: identical(weightKg, _unset)
          ? this.weightKg
          : weightKg as double?,
      note: identical(note, _unset) ? this.note : note as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'photoRef': photoRef,
        if (weightKg != null) 'weightKg': weightKg,
        if (note != null) 'note': note,
      };

  factory BodyPhotoEntry.fromJson(Map<String, dynamic> json) => BodyPhotoEntry(
        id: json['id'] as String,
        date: DateTime.parse(json['date'] as String),
        photoRef: json['photoRef'] as String,
        weightKg: (json['weightKg'] as num?)?.toDouble(),
        note: json['note'] as String?,
      );
}
