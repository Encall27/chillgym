/// Plate math is unit-agnostic — it operates on raw numbers. Callers pass in
/// the plate set and bar weight in whatever unit the user is working in
/// (kg or lb), and the result speaks the same unit back.
const List<double> kStandardPlatesKg = [25, 20, 15, 10, 5, 2.5, 1.25];

/// Standard US lb plate set: 45/35/25 are the big plates, 10/5/2.5 round it
/// out. No 1.25 lb in most commercial gyms.
const List<double> kStandardPlatesLb = [45, 35, 25, 10, 5, 2.5];

/// Default Olympic bar weight per unit.
const double kDefaultBarKg = 20;
const double kDefaultBarLb = 45;

class PlateBreakdown {
  const PlateBreakdown({
    required this.bar,
    required this.total,
    required this.platesPerSide,
    required this.unaccounted,
  });

  final double bar;
  final double total;

  /// Plate weights to load *on each side* of the bar, largest first.
  final List<double> platesPerSide;

  /// Whatever can't be matched with the available plates. Zero when the
  /// target is exactly achievable.
  final double unaccounted;

  bool get exact => unaccounted.abs() < 0.001;
}

/// Greedy plate calculator. Produces the largest-first plate stack on each
/// side of the bar that gets closest to (but not over) the target.
PlateBreakdown calculatePlates({
  required double target,
  double bar = kDefaultBarKg,
  List<double> availablePlates = kStandardPlatesKg,
}) {
  if (target <= bar) {
    return PlateBreakdown(
      bar: bar,
      total: target,
      platesPerSide: const [],
      unaccounted: target - bar,
    );
  }
  var remainingPerSide = (target - bar) / 2;
  final picked = <double>[];
  final sorted = [...availablePlates]..sort((a, b) => b.compareTo(a));
  for (final plate in sorted) {
    while (remainingPerSide + 0.0001 >= plate) {
      picked.add(plate);
      remainingPerSide -= plate;
    }
  }
  return PlateBreakdown(
    bar: bar,
    total: target,
    platesPerSide: picked,
    unaccounted: remainingPerSide * 2,
  );
}
