import 'package:flutter/material.dart';
import 'package:newmotorlube/core/utils/theme/app_colors.dart';
import 'package:newmotorlube/core/utils/theme/app_text_styles.dart';
import 'package:newmotorlube/features/app/app_color_theme.dart';

import 'app_text_theme.dart';



ThemeData getThemeData(
  BuildContext context,
    {String fontFamily = 'Cairo'}
    ) {
  // ThemeData
  return ThemeData(
    // <------------------------------------------------ Main Theme Font
    brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: fontFamily,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
colorScheme: const ColorScheme.light(
  primary: AppColors.lightPrimary,
    primaryContainer: AppColors.lightPrimaryVariant,
    secondary: AppColors.lightSecondary,
    surface: AppColors.lightSurface,
    error: AppColors.lightError,
    onPrimary: AppColors.lightOnPrimary,
    onSecondary: AppColors.lightOnSecondary,
    onSurface: AppColors.lightOnSurface,
    onError: AppColors.lightOnError,
  ),
    extensions: [
      AppColorsTheme.light(),
      AppTextTheme(
        fontFamily: fontFamily,
      )
    ],

    // <------------------------------------------------ App Bar Theme Theme
    appBarTheme:  AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.lightSurface,
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.lightSurface,
      headerBackgroundColor: AppColors.lightPrimary, // Header background color
      headerForegroundColor: AppColors.lightOnPrimary,
      dayStyle: const TextStyle(
        color: AppColors.lightOnSurface,
      ),

    ),

    // <------------------------------------------------ Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary, // Highlight color
          width: 2.0, // Thicker border for focus
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      labelStyle: const TextStyle(
        fontSize: 12,
      ),
    ),

    // <------------------------------------------------ Text Theme
    textTheme: const TextTheme(
      displayLarge: appLargeTitleStyle,
      //font size: 34 // headline1 dep
      displayMedium: appTitle1Style,
      //font size: 28 // headline2 dep
      displaySmall: appTitle2Style,
      //font size: 23 //headline3 dep
      headlineMedium: appTitle3Style,
      //font size: 20 // headline4 dep
      headlineSmall: appHeadLineStyle,
      //font size: 16 //headline5 dep
      titleLarge: appSubHeadStyle,
      //font size: 14 //headline6 dep
      titleMedium: appCaption1Style,
      //font size: 11 //subtitle1 dep
      titleSmall: appCaption2Style,
      //font size: 10 // subtitle2 dep
      bodyLarge: appBodyStyle,
      //font size: 16 //bodyText1 dep
      bodyMedium: appCallOutStyle,
      //font size: 15 // bodyText2 dep
      labelSmall: appFootNoteStyle,
      //font size: 12 // overline dep

    ),

    // <--------------------------------------- Bottomsheet Theme
    bottomSheetTheme: BottomSheetThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(4),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      backgroundColor: Colors.white,
    ),
  );



  }