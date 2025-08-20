import 'package:flutter/material.dart';

class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  final Color primary;
  final Color primaryVariant;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color error;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;
  final Color onError;

  // Common colors
  final Color lightGray;
  final Color darkGray;
  final Color mediumGray;
  final Color black;
  final Color white;
  final Color red;
  final Color blue;
  final Color green;
  final Color purple;
  final Color orange;
  final Color teal;
  final Color selection;
  final Color grayishBlue;
  final Color primaryCommon;
  final Color greyText;

  const AppColorsTheme({
    required this.primary,
    required this.primaryVariant,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
    required this.lightGray,
    required this.darkGray,
    required this.mediumGray,
    required this.black,
    required this.white,
    required this.red,
    required this.blue,
    required this.green,
    required this.purple,
    required this.orange,
    required this.teal,
    required this.selection,
    required this.grayishBlue,
    required this.primaryCommon,
    required this.greyText,
  });

  /// Light theme
  factory AppColorsTheme.light() => const AppColorsTheme(
    primary: Color(0xFFFFB600),
    primaryVariant: Color(0xFFC79100),
    secondary: Color(0xFFB6B6B6),
    background: Color(0xFFf9fafd),
    surface: Color(0xFFFFFFFF),
    error: Color(0xFFD32F2F),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onBackground: Color(0xFF333333),
    onSurface: Color(0xFF333333),
    onError: Color(0xFFFFFFFF),

    lightGray: Color(0xFFF5F6FA),
    darkGray: Color(0xFF333333),
    mediumGray: Color(0xFFB6B6B6),
    black: Color(0xFF000000),
    white: Color(0xFFFFFFFF),
    red: Color(0xFFD32F2F),
    blue: Color(0xFF0288D1),
    green: Color(0xFF43A047),
    purple: Color(0xFFBB86FC),
    orange: Color(0xFFFF7043),
    teal: Color(0xFF00ACC1),
    selection: Color(0xFFFFF0CC),
    grayishBlue: Color(0xFF5A6274),
    primaryCommon: Color(0xFFFFB600),
    greyText: Color(0xFFb8bac0),
  );

  /// Dark theme
  factory AppColorsTheme.dark() => const AppColorsTheme(
    primary: Color(0xFF1C1C1C),
    primaryVariant: Color(0xFFCC8400),
    secondary: Color(0xFF9F7CFF),
    background: Color(0xFF121212),
    surface: Color(0xFF1C1C1C),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onBackground: Color(0xFFFFFFFF),
    onSurface: Color(0xFFFFFFFF),
    onError: Color(0xFF000000),

    lightGray: Color(0xFFF5F6FA),
    darkGray: Color(0xFF333333),
    mediumGray: Color(0xFFB6B6B6),
    black: Color(0xFF000000),
    white: Color(0xFFFFFFFF),
    red: Color(0xFFD32F2F),
    blue: Color(0xFF0288D1),
    green: Color(0xFF43A047),
    purple: Color(0xFFBB86FC),
    orange: Color(0xFFFF7043),
    teal: Color(0xFF00ACC1),
    selection: Color(0xFFFFF0CC),
    grayishBlue: Color(0xFF5A6274),
    primaryCommon: Color(0xFFFFB600),
    greyText: Color(0xFFb8bac0),
  );

  @override
  AppColorsTheme copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? error,
    Color? onPrimary,
    Color? onSecondary,
    Color? onBackground,
    Color? onSurface,
    Color? onError,
    Color? lightGray,
    Color? darkGray,
    Color? mediumGray,
    Color? black,
    Color? white,
    Color? red,
    Color? blue,
    Color? green,
    Color? purple,
    Color? orange,
    Color? teal,
    Color? selection,
    Color? grayishBlue,
    Color? primaryCommon,
    Color? greyText,
  }) {
    return AppColorsTheme(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      onSecondary: onSecondary ?? this.onSecondary,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      onError: onError ?? this.onError,
      lightGray: lightGray ?? this.lightGray,
      darkGray: darkGray ?? this.darkGray,
      mediumGray: mediumGray ?? this.mediumGray,
      black: black ?? this.black,
      white: white ?? this.white,
      red: red ?? this.red,
      blue: blue ?? this.blue,
      green: green ?? this.green,
      purple: purple ?? this.purple,
      orange: orange ?? this.orange,
      teal: teal ?? this.teal,
      selection: selection ?? this.selection,
      grayishBlue: grayishBlue ?? this.grayishBlue,
      primaryCommon: primaryCommon ?? this.primaryCommon,
      greyText: greyText ?? this.greyText,
    );
  }

  @override
  AppColorsTheme lerp(ThemeExtension<AppColorsTheme>? other, double t) {
    if (other is! AppColorsTheme) return this;

    return AppColorsTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      error: Color.lerp(error, other.error, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      lightGray: Color.lerp(lightGray, other.lightGray, t)!,
      darkGray: Color.lerp(darkGray, other.darkGray, t)!,
      mediumGray: Color.lerp(mediumGray, other.mediumGray, t)!,
      black: Color.lerp(black, other.black, t)!,
      white: Color.lerp(white, other.white, t)!,
      red: Color.lerp(red, other.red, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      green: Color.lerp(green, other.green, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      selection: Color.lerp(selection, other.selection, t)!,
      grayishBlue: Color.lerp(grayishBlue, other.grayishBlue, t)!,
      primaryCommon: Color.lerp(primaryCommon, other.primaryCommon, t)!,
      greyText: Color.lerp(greyText, other.greyText, t)!,
    );
  }
}
