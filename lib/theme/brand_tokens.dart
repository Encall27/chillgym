import 'package:flutter/material.dart';

/// Theme-extension carrying ChillGym brand tokens that don't map cleanly onto
/// Material 3's `ColorScheme`. Use via:
///
/// ```dart
/// final brand = Theme.of(context).extension<BrandTokens>()!;
/// Container(color: brand.amberPale, ...);
/// ```
///
/// The two concrete instances (`warmEditorial` and `darkPerformance`) come
/// from the design handoff. Field meaning is theme-stable: `positive` is
/// always the "good thing happened" green, even though Warm uses sage and
/// Dark uses lime.
@immutable
class BrandTokens extends ThemeExtension<BrandTokens> {
  const BrandTokens({
    required this.amberDeep,
    required this.amberPale,
    required this.positive,
    required this.info,
    required this.warning,
    required this.displayItalic,
    required this.useGlow,
  });

  /// Amber tone safe to put as text on a light background. Reads as the
  /// brand colour without breaking contrast (light: amberDeep #9A6B12,
  /// dark: pure amber #FFB627).
  final Color amberDeep;

  /// Pale tint behind amber-themed UI (rest banner background, "+8 KG"
  /// pill background, range chip selected state). Light cream tint in
  /// Warm Editorial; dark amber wash (`amberDim`) in Dark Performance.
  final Color amberPale;

  /// Positive delta colour. Sage green on light, lime on dark.
  final Color positive;

  /// Informational accent. Sky blue on light, cyan on dark.
  final Color info;

  /// Warning / "push category" accent. Rose on light, hot pink on dark.
  final Color warning;

  /// Display TextStyle base for screens that want the editorial serif look —
  /// Fraunces italic in Warm Editorial; falls back to bold Inter in Dark
  /// Performance so callers can use it unconditionally.
  final TextStyle displayItalic;

  /// Whether the theme should layer subtle glow effects (drop shadows on
  /// amber elements, halo on PR markers). True only in Dark Performance.
  final bool useGlow;

  @override
  BrandTokens copyWith({
    Color? amberDeep,
    Color? amberPale,
    Color? positive,
    Color? info,
    Color? warning,
    TextStyle? displayItalic,
    bool? useGlow,
  }) {
    return BrandTokens(
      amberDeep: amberDeep ?? this.amberDeep,
      amberPale: amberPale ?? this.amberPale,
      positive: positive ?? this.positive,
      info: info ?? this.info,
      warning: warning ?? this.warning,
      displayItalic: displayItalic ?? this.displayItalic,
      useGlow: useGlow ?? this.useGlow,
    );
  }

  @override
  BrandTokens lerp(ThemeExtension<BrandTokens>? other, double t) {
    if (other is! BrandTokens) return this;
    return BrandTokens(
      amberDeep: Color.lerp(amberDeep, other.amberDeep, t)!,
      amberPale: Color.lerp(amberPale, other.amberPale, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      info: Color.lerp(info, other.info, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      // TextStyle.lerp handles font-style/weight smoothly enough for the
      // 250ms theme-swap animation in the design spec.
      displayItalic:
          TextStyle.lerp(displayItalic, other.displayItalic, t) ?? displayItalic,
      useGlow: t < 0.5 ? useGlow : other.useGlow,
    );
  }
}
