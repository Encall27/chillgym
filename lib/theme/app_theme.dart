import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'brand_tokens.dart';

// =====================================================================
// Warm Editorial (light theme) — design tokens
// =====================================================================
const _wePageBg = Color(0xFFF6F1E7); // bg
const _weInsetBg = Color(0xFFEFE7D5); // bg2 (calendar cells, stat tiles)
const _weCard = Color(0xFFFFFFFF); // card
const _weBorder = Color(0xFFE5DCCB); // hairlines
const _weInk = Color(0xFF1B1814); // primary text + dark accent surface
const _weInk2 = Color(0xFF5C5247); // secondary text
const _weInk3 = Color(0xFF8A8076); // tertiary / muted
const _weAmber = Color(0xFFE0A82E); // primary accent
const _weAmberDeep = Color(0xFF9A6B12); // amber-as-text on light
const _weAmberPale = Color(0xFFFBF5E8); // amber tint background
const _weGood = Color(0xFF3F6B4A); // positive delta
const _weRose = Color(0xFFB5532A); // warning / Push category
const _weSage = Color(0xFF6B8E76); // secondary accent
const _weSky = Color(0xFF3A6B8C); // secondary accent

// =====================================================================
// Dark Performance (dark theme) — design tokens
// =====================================================================
const _dpPageBg = Color(0xFF0B0B0F);
const _dpInsetBg = Color(0xFF13141A);
const _dpCard = Color(0xFF1A1B22);
const _dpBorder = Color(0xFF262833);
const _dpInk = Color(0xFFF1EFE8);
const _dpInk2 = Color(0xFF9C9DA8);
const _dpInk3 = Color(0xFF6E6F7A);
const _dpAmber = Color(0xFFFFB627);
const _dpAmberDim = Color(0xFF3A2E10);
const _dpLime = Color(0xFFC8FF00);
const _dpPink = Color(0xFF8E2349); // hue-shifted from FF4D8D so it works as M3 error
const _dpCyan = Color(0xFF5BE9F2);
// `good` from the design — currently unused because the dark scheme exposes
// `positive` as lime; keep the constant for future success-state surfaces.
// ignore: unused_element
const _dpGood = Color(0xFF3F8E5C);

ThemeData buildLightTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: _weAmber,
    onPrimary: _weInk,
    primaryContainer: _weAmberPale,
    onPrimaryContainer: _weAmberDeep,
    secondary: _weSage,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE5EDE7),
    onSecondaryContainer: Color(0xFF2C4030),
    tertiary: _weSky,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFDCE7F0),
    onTertiaryContainer: Color(0xFF1A3041),
    error: _weRose,
    onError: Colors.white,
    errorContainer: Color(0xFFF5DACE),
    onErrorContainer: Color(0xFF5C2410),
    surface: _wePageBg,
    onSurface: _weInk,
    onSurfaceVariant: _weInk2,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFFBF8F0),
    surfaceContainer: _weInsetBg,
    surfaceContainerHigh: _weCard,
    surfaceContainerHighest: _weInsetBg,
    outline: _weInk3,
    outlineVariant: _weBorder,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: _weInk,
    onInverseSurface: _wePageBg,
    inversePrimary: _dpAmber,
  );

  final brand = BrandTokens(
    amberDeep: _weAmberDeep,
    amberPale: _weAmberPale,
    positive: _weGood,
    info: _weSky,
    warning: _weRose,
    displayItalic: _frauncesItalic(scheme.onSurface, fontSize: 28, weight: FontWeight.w400),
    useGlow: false,
  );

  return _buildTheme(scheme: scheme, brand: brand);
}

ThemeData buildDarkTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: _dpAmber,
    onPrimary: Color(0xFF000000),
    primaryContainer: _dpAmberDim,
    onPrimaryContainer: _dpAmber,
    secondary: _dpLime,
    onSecondary: Color(0xFF0B0B0F),
    secondaryContainer: Color(0xFF22260A),
    onSecondaryContainer: _dpLime,
    tertiary: _dpCyan,
    onTertiary: Color(0xFF0B0B0F),
    tertiaryContainer: Color(0xFF0F2A2E),
    onTertiaryContainer: _dpCyan,
    error: _dpPink,
    onError: Colors.white,
    errorContainer: Color(0xFF3A0F1F),
    onErrorContainer: Color(0xFFFF8FB6),
    surface: _dpPageBg,
    onSurface: _dpInk,
    onSurfaceVariant: _dpInk2,
    surfaceContainerLowest: Color(0xFF06070B),
    surfaceContainerLow: _dpInsetBg,
    surfaceContainer: _dpInsetBg,
    surfaceContainerHigh: _dpCard,
    surfaceContainerHighest: _dpCard,
    outline: _dpInk3,
    outlineVariant: _dpBorder,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: _dpInk,
    onInverseSurface: _dpPageBg,
    inversePrimary: _weAmber,
  );

  // Dark Performance is all Inter — no Fraunces. The display style stays
  // typed-as `displayItalic` so screens can write `brand.displayItalic`
  // unconditionally; the dark variant is just a heavier Inter.
  final brand = BrandTokens(
    amberDeep: _dpAmber,
    amberPale: _dpAmberDim,
    positive: _dpLime,
    info: _dpCyan,
    warning: _dpPink,
    displayItalic: GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.5,
      color: scheme.onSurface,
    ),
    useGlow: true,
  );

  return _buildTheme(scheme: scheme, brand: brand, isDark: true);
}

ThemeData _buildTheme({
  required ColorScheme scheme,
  required BrandTokens brand,
  bool isDark = false,
}) {
  final base = ThemeData(
    useMaterial3: true,
    brightness: scheme.brightness,
    colorScheme: scheme,
    extensions: [brand],
    scaffoldBackgroundColor: scheme.surface,
  );
  final textTheme = isDark
      ? _darkTextTheme(base.textTheme, scheme)
      : _warmTextTheme(base.textTheme, scheme);

  return base.copyWith(
    textTheme: textTheme,
    primaryTextTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontFamily: GoogleFonts.inter().fontFamily,
        color: scheme.onSurface,
      ),
      shape: Border(
        bottom: BorderSide(color: scheme.outlineVariant, width: 1),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: isDark ? scheme.surfaceContainerLow : scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primaryContainer,
      labelTextStyle: WidgetStatePropertyAll(
        textTheme.labelSmall?.copyWith(
          fontSize: 11,
          letterSpacing: 0.6,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? brand.amberDeep : scheme.onSurfaceVariant,
        );
      }),
    ),
    cardTheme: CardThemeData(
      // surfaceContainerHigh maps to white in Warm and `card` in Dark — the
      // exact "card surface" colour from each design.
      color: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: scheme.outlineVariant, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.onSurface,
        textStyle: textTheme.labelLarge,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHigh,
      selectedColor: scheme.primaryContainer,
      side: BorderSide(color: scheme.outlineVariant),
      shape: const StadiumBorder(),
      labelStyle: textTheme.labelMedium,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerHigh,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

// ---------------------------------------------------------------------
// Typography
// ---------------------------------------------------------------------

TextTheme _warmTextTheme(TextTheme base, ColorScheme scheme) {
  // Fraunces for displays, Inter for everything else. Numerics get
  // tabular figures everywhere through TextStyle.copyWith below.
  final inter = GoogleFonts.interTextTheme(base);

  TextStyle fr(double size, {FontWeight weight = FontWeight.w400, double letter = -0.01}) =>
      _frauncesItalic(scheme.onSurface, fontSize: size, weight: weight, letterSpacing: letter);

  TextStyle ui(double size, {FontWeight weight = FontWeight.w400, double letter = 0, Color? color}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letter,
        color: color ?? scheme.onSurface,
      );

  return inter.copyWith(
    displayLarge: fr(56, weight: FontWeight.w300, letter: -0.02),
    displayMedium: fr(44, weight: FontWeight.w300),
    displaySmall: fr(36, weight: FontWeight.w300),
    headlineLarge: fr(28, weight: FontWeight.w400),
    headlineMedium: fr(24, weight: FontWeight.w400),
    headlineSmall: fr(20, weight: FontWeight.w400),
    titleLarge: fr(20, weight: FontWeight.w400),
    titleMedium: fr(18, weight: FontWeight.w400),
    titleSmall: ui(14, weight: FontWeight.w600, letter: 0.3),
    bodyLarge: ui(16),
    bodyMedium: ui(14),
    bodySmall: ui(12, color: scheme.onSurfaceVariant),
    labelLarge: ui(14, weight: FontWeight.w600, letter: 0.1),
    labelMedium: ui(12, weight: FontWeight.w600, letter: 0.1),
    labelSmall: ui(10, weight: FontWeight.w600, letter: 1.5, color: scheme.onSurfaceVariant),
  );
}

TextTheme _darkTextTheme(TextTheme base, ColorScheme scheme) {
  final inter = GoogleFonts.interTextTheme(base);
  TextStyle ui(double size, {FontWeight weight = FontWeight.w400, double letter = 0, Color? color}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: letter,
        color: color ?? scheme.onSurface,
      );

  return inter.copyWith(
    displayLarge: ui(52, weight: FontWeight.w800, letter: -1.5),
    displayMedium: ui(44, weight: FontWeight.w800, letter: -1.0),
    displaySmall: ui(36, weight: FontWeight.w800, letter: -0.8),
    headlineLarge: ui(24, weight: FontWeight.w800, letter: -0.5),
    headlineMedium: ui(22, weight: FontWeight.w800, letter: -0.4),
    headlineSmall: ui(20, weight: FontWeight.w700, letter: -0.3),
    titleLarge: ui(18, weight: FontWeight.w700),
    titleMedium: ui(16, weight: FontWeight.w700),
    titleSmall: ui(14, weight: FontWeight.w600, letter: 0.2),
    bodyLarge: ui(16),
    bodyMedium: ui(14),
    bodySmall: ui(12, color: scheme.onSurfaceVariant),
    labelLarge: ui(14, weight: FontWeight.w600, letter: 0.1),
    labelMedium: ui(12, weight: FontWeight.w600, letter: 0.1),
    labelSmall: ui(10, weight: FontWeight.w600, letter: 1.5, color: scheme.onSurfaceVariant),
  );
}

TextStyle _frauncesItalic(
  Color color, {
  required double fontSize,
  FontWeight weight = FontWeight.w400,
  double letterSpacing = -0.01,
}) {
  return GoogleFonts.fraunces(
    fontSize: fontSize,
    fontStyle: FontStyle.italic,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    color: color,
    height: 1.05,
  );
}
