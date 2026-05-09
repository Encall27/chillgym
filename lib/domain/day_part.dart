import 'package:flutter/material.dart';

/// Part of the day a session was started in. Used by the calendar to show
/// AM / PM / EVE / NIGHT indicators per session on each trained day.
enum DayPart {
  morning,
  afternoon,
  evening,
  night;

  String get shortLabel => switch (this) {
        DayPart.morning => 'AM',
        DayPart.afternoon => 'PM',
        DayPart.evening => 'EVE',
        DayPart.night => 'NIGHT',
      };

  IconData get icon => switch (this) {
        DayPart.morning => Icons.wb_twilight,
        DayPart.afternoon => Icons.wb_sunny,
        DayPart.evening => Icons.brightness_4,
        DayPart.night => Icons.nights_stay,
      };
}

/// Bucketing rules:
///  - morning:  05:00 – 11:59
///  - afternoon: 12:00 – 16:59
///  - evening:   17:00 – 20:59
///  - night:     21:00 – 04:59
DayPart dayPartOf(DateTime t) {
  final h = t.hour;
  if (h >= 5 && h < 12) return DayPart.morning;
  if (h >= 12 && h < 17) return DayPart.afternoon;
  if (h >= 17 && h < 21) return DayPart.evening;
  return DayPart.night;
}
