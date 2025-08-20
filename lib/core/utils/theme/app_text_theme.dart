import 'package:flutter/material.dart';

class AppTextTheme extends ThemeExtension<AppTextTheme> {
  final String fontFamily;

  AppTextTheme({
    required this.fontFamily,
  });

  TextStyle get display2XlRegular => TextStyle(
        fontSize: AppFontSize.fs72,
        fontWeight: FontWeight.w400,
        //2Xl Regular
        fontFamily: fontFamily,
        letterSpacing: -1.44,
        height: 1.25,
      );

  TextStyle get display2XlMedium => TextStyle(
        fontSize: AppFontSize.fs72,
        fontWeight: FontWeight.w500,
        //2Xl Medium
        fontFamily: fontFamily,
        letterSpacing: -1.44,
        height: 1.25,
      );

  TextStyle get display2XlSemibold => TextStyle(
        fontSize: AppFontSize.fs72,
        fontWeight: FontWeight.w600,
        //2Xl Semibold
        fontFamily: fontFamily,
        letterSpacing: -1.44,
        height: 1.25,
      );

  TextStyle get display2XlBold => TextStyle(
        fontSize: AppFontSize.fs72,
        fontWeight: FontWeight.w700,
        //2Xl Bold
        fontFamily: fontFamily,
        letterSpacing: -1.44,
        height: 1.25,
      );

  TextStyle get displayXlRegular => TextStyle(
        fontSize: AppFontSize.fs60,
        fontWeight: FontWeight.w400, //Xl Regularl
        fontFamily: fontFamily,
      );

  TextStyle get displayXlMedium => TextStyle(
      fontSize: AppFontSize.fs60,
      fontWeight: FontWeight.w500,
      //Xl Medium
      fontFamily: fontFamily,
      letterSpacing: -1.2,
      height: 1.2);

  TextStyle get displayXlSemibold => TextStyle(
      fontSize: AppFontSize.fs60  ,
      fontWeight: FontWeight.w600,
      //Xl Semibold
      fontFamily: fontFamily,
      letterSpacing: -1.2,
      height: 1.2);

  TextStyle get displayXlBold => TextStyle(
      fontSize: AppFontSize.fs60  ,
      fontWeight: FontWeight.w700,
      //Xl Bold
      fontFamily: fontFamily,
      letterSpacing: -1.2,
      height: 1.2);

  TextStyle get displayLgRegular => TextStyle(
      fontSize: AppFontSize.fs48  ,
      fontWeight: FontWeight.w400,
      //LG Regular
      fontFamily: fontFamily,
      letterSpacing: -0.96,
      height: 1.25);

  TextStyle get displayLgMedium => TextStyle(
      fontSize: AppFontSize.fs48  ,
      fontWeight: FontWeight.w500,
      //LG Medium
      fontFamily: fontFamily,
      letterSpacing: -0.96,
      height: 1.25);

  TextStyle get displayLgSemibold => TextStyle(
      fontSize: AppFontSize.fs48  ,
      fontWeight: FontWeight.w600,
      //LG Semibold
      fontFamily: fontFamily,
      letterSpacing: -0.96,
      height: 1.25);

  TextStyle get displayLgBold => TextStyle(
      fontSize: AppFontSize.fs48  ,
      fontWeight: FontWeight.w700,
      //LG Bold
      fontFamily: fontFamily,
      letterSpacing: -0.96,
      height: 1.25);

  TextStyle get displayMdRegular => TextStyle(
        fontSize: AppFontSize.fs36  ,
        fontWeight: FontWeight.w400,
        //MD Regular
        fontFamily: fontFamily,
        height: 1.22,
        letterSpacing: -0.26,
      );

  TextStyle get displayMdMedium => TextStyle(
        fontSize: AppFontSize.fs36  ,
        fontWeight: FontWeight.w500,
        //MD Medium
        fontFamily: fontFamily,
        height: 1.22,
        letterSpacing: -0.26,
      );

  TextStyle get displayMdSemibold => TextStyle(
        fontSize: AppFontSize.fs36  ,
        fontWeight: FontWeight.w600,
        //MD Semibold
        fontFamily: fontFamily,
        height: 1.22,
        letterSpacing: -0.26,
      );

  TextStyle get displayMdBold => TextStyle(
        fontSize: AppFontSize.fs36  ,
        fontWeight: FontWeight.w700,
        //MD Bold
        fontFamily: fontFamily,
        height: 1.22,
        letterSpacing: -0.26,
      );

  TextStyle get displaySmRegular => TextStyle(
        fontSize: AppFontSize.fs30  ,
        fontWeight: FontWeight.w400, //SM Regular
        fontFamily: fontFamily,
        height: 1.27,
      );

  TextStyle get displaySmMedium => TextStyle(
        fontSize: AppFontSize.fs30  ,
        fontWeight: FontWeight.w500, //SM Medium
        fontFamily: fontFamily,
        height: 1.27,
      );

  TextStyle get displaySmSemibold => TextStyle(
        fontSize: AppFontSize.fs30  ,
        fontWeight: FontWeight.w600, //SM Semibold
        fontFamily: fontFamily,
        height: 1.27,
      );

  TextStyle get displaySmBold => TextStyle(
        fontSize: AppFontSize.fs30  ,
        fontWeight: FontWeight.w700, //SM Bold
        fontFamily: fontFamily,
        height: 1.27,
      );

  TextStyle get displayXsRegular => TextStyle(
        fontSize: AppFontSize.fs24  ,
        fontWeight: FontWeight.w400, //SM Regular
        fontFamily: fontFamily,
        height: 1.33,
      );

  TextStyle get displayXsMedium => TextStyle(
        fontSize: AppFontSize.fs24  ,
        fontWeight: FontWeight.w500, //SM Medium
        fontFamily: fontFamily,
        height: 1.33,
      );

  TextStyle get displayXsSemibold => TextStyle(
        fontSize: AppFontSize.fs24  ,
        fontWeight: FontWeight.w600, //SM Semibold
        fontFamily: fontFamily,
        height: 1.33,
      );

  TextStyle get displayXsBold => TextStyle(
        fontSize: AppFontSize.fs24  ,
        fontWeight: FontWeight.w700, //SM Bold
        fontFamily: fontFamily,
        height: 1.33,
      );

  TextStyle get textXlRegular => TextStyle(
        fontSize: AppFontSize.fs22  ,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textXlMedium => TextStyle(
        fontSize: AppFontSize.fs22  ,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textXlSemibold => TextStyle(
        fontSize: AppFontSize.fs22  ,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textXlBold => TextStyle(
        fontSize: AppFontSize.fs22  ,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textLgRegular => TextStyle(
        fontSize: AppFontSize.fs20  ,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        height: 1.56,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textLgMedium => TextStyle(
        fontSize: AppFontSize.fs20  ,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.56,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textLgSemibold => TextStyle(
        fontSize: AppFontSize.fs20  ,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        height: 1.56,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textLgBold => TextStyle(
        fontSize: AppFontSize.fs20  ,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
        height: 1.56,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textMdRegular => TextStyle(
        fontSize: AppFontSize.fs18  ,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textMdMedium => TextStyle(
        fontSize: AppFontSize.fs18  ,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textMdSemibold => TextStyle(
        fontSize: AppFontSize.fs18  ,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textMdBold => TextStyle(
        fontSize: AppFontSize.fs18  ,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textSmRegular => TextStyle(
        fontSize: AppFontSize.fs16  ,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        height: 1.43,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textSmMedium => TextStyle(
        fontSize: AppFontSize.fs16  ,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.43,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textSmSemibold => TextStyle(
        fontSize: AppFontSize.fs16  ,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        height: 1.43,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textSmBold => TextStyle(
        fontSize: AppFontSize.fs16  ,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
        height: 1.43,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textXsRegular => TextStyle(
        fontSize: AppFontSize.fs14  ,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textXsMedium => TextStyle(
        fontSize: AppFontSize.fs14  ,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textXsSemibold => TextStyle(
        fontSize: AppFontSize.fs14  ,
        fontWeight: FontWeight.w600,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get textXsBold => TextStyle(
        fontSize: AppFontSize.fs14  ,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
        height: 1.5,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get text2xsRegular => TextStyle(
        fontSize: AppFontSize.fs12  ,
        fontWeight: FontWeight.w400,
        fontFamily: fontFamily,
        height: 1.4,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get text2xsMedium => TextStyle(
        fontSize: AppFontSize.fs12  ,
        fontWeight: FontWeight.w500,
        fontFamily: fontFamily,
        height: 1.4,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get text2xsSemibold => TextStyle(
        fontSize: AppFontSize.fs12  ,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
        height: 1.4,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  TextStyle get text2xsBold => TextStyle(
        fontSize: AppFontSize.fs12  ,
        fontWeight: FontWeight.w700,
        fontFamily: fontFamily,
        height: 1.4,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
      );

  @override
  ThemeExtension<AppTextTheme> copyWith() => this;

  @override
  ThemeExtension<AppTextTheme> lerp(
    covariant ThemeExtension<AppTextTheme>? other,
    double t,
  ) =>
      this;
}

class AppFontSize {
  /// Headings
  static const double fs72 = 72;
  static const double fs60 = 60;
  static const double fs48 = 48;
  static const double fs36 = 36;
  static const double fs30 = 30;
  static const double fs26 = 26;
  static const double fs24 = 24;

  /// Content
  static const double fs22 = 22;
  static const double fs20 = 20;
  static const double fs18 = 18;
  static const double fs16 = 16;
  static const double fs14 = 14;
  static const double fs12 = 12;
  static const double fs10 = 10;
}
