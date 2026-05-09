/// One bodyweight reading. We dedupe by `date` (day-only) so the latest entry
/// of the day wins.
class BodyweightEntry {
  const BodyweightEntry({
    required this.date,
    required this.weightKg,
    this.note,
  });

  /// Day-only — keep this normalised at construction time.
  final DateTime date;
  final double weightKg;
  final String? note;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'weightKg': weightKg,
        if (note != null) 'note': note,
      };

  factory BodyweightEntry.fromJson(Map<String, dynamic> json) {
    final d = DateTime.parse(json['date'] as String);
    return BodyweightEntry(
      date: DateTime(d.year, d.month, d.day),
      weightKg: (json['weightKg'] as num).toDouble(),
      note: json['note'] as String?,
    );
  }
}
