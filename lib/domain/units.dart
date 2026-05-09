/// Unit conversions and display formatting.
///
/// Storage stays metric everywhere — `weightKg`, `heightCm`, `distanceMeters`
/// in models never change. Only input parsing and rendering flip when the user
/// switches preference. Keeping data in one canonical unit means a stale toggle
/// can never corrupt history.
library;

const double _kgPerLb = 0.45359237;
const double _cmPerInch = 2.54;

enum WeightUnit { kg, lb }

enum LengthUnit { cm, inch }

extension WeightUnitX on WeightUnit {
  String get suffix => this == WeightUnit.kg ? 'kg' : 'lb';

  /// Display value (in this unit) given a stored kg value.
  double fromKg(double kg) =>
      this == WeightUnit.kg ? kg : kg / _kgPerLb;

  /// Storage value (kg) given a user-entered display value in this unit.
  double toKg(double v) =>
      this == WeightUnit.kg ? v : v * _kgPerLb;

  static WeightUnit fromName(String? name) {
    switch (name) {
      case 'lb':
        return WeightUnit.lb;
      case 'kg':
      default:
        return WeightUnit.kg;
    }
  }
}

extension LengthUnitX on LengthUnit {
  String get suffix => this == LengthUnit.cm ? 'cm' : 'in';

  double fromCm(double cm) =>
      this == LengthUnit.cm ? cm : cm / _cmPerInch;

  double toCm(double v) =>
      this == LengthUnit.cm ? v : v * _cmPerInch;

  static LengthUnit fromName(String? name) {
    switch (name) {
      case 'inch':
      case 'in':
        return LengthUnit.inch;
      case 'cm':
      default:
        return LengthUnit.cm;
    }
  }
}

/// Trim trailing `.0` so 100.0 reads as "100" but 102.5 reads as "102.5".
String _trim(double v, {int decimals = 1}) =>
    v % 1 == 0 ? v.toStringAsFixed(0) : v.toStringAsFixed(decimals);

/// "100 kg" / "220 lb" — used for individual set weights.
String formatWeightFromKg(double kg, WeightUnit unit) {
  return '${_trim(unit.fromKg(kg))} ${unit.suffix}';
}

/// "1240 kg" / "2735 lb" — total volume always rounds to a whole number.
String formatVolumeFromKg(double kg, WeightUnit unit) {
  return '${unit.fromKg(kg).toStringAsFixed(0)} ${unit.suffix}';
}

/// "180 cm" / "70.9 in".
String formatHeightFromCm(double cm, LengthUnit unit) {
  return '${_trim(unit.fromCm(cm))} ${unit.suffix}';
}

/// Plate value already in the user's preferred unit (e.g. 25 / 45). Used by
/// the plate calculator chips.
String formatPlate(double v, WeightUnit unit) =>
    '${_trim(v)} ${unit.suffix}';

/// Convert a free-form numeric input string into kg, treating the input as
/// already being in [unit]. Returns null on parse failure.
double? parseInputAsKg(String text, WeightUnit unit) {
  final v = double.tryParse(text.trim());
  return v == null ? null : unit.toKg(v);
}

/// Symmetric helper for length inputs.
double? parseInputAsCm(String text, LengthUnit unit) {
  final v = double.tryParse(text.trim());
  return v == null ? null : unit.toCm(v);
}
