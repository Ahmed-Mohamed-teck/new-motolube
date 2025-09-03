// Theme Extensions
import 'package:flutter/material.dart';

import '../../../features/app/app_color_theme.dart';
import '../theme/app_text_theme.dart';


extension SugarExt on BuildContext {

  ThemeData get theme => Theme.of(this);

  AppColorsTheme get appColors => theme.extension<AppColorsTheme>()!;
  AppTextTheme get textStyles => theme.extension<AppTextTheme>()!;

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

}

