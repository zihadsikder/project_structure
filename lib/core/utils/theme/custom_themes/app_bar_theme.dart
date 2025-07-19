import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class AppBarThemeData {
  AppBarThemeData._();

  static AppBarTheme _baseAppBarTheme({
    required Color backgroundColor,
    required Color iconColor,
    required Color titleColor,
    required Color surfaceTintColor,
    required double elevation,
  }) {
    return AppBarTheme(
      foregroundColor: Colors.transparent,
      surfaceTintColor: surfaceTintColor,
      elevation: elevation,
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: iconColor),
      titleTextStyle: TextStyle(
        color: titleColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      actionsIconTheme: IconThemeData(color: iconColor),
      centerTitle: true,
      // systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  static final AppBarTheme lightAppBarTheme = _baseAppBarTheme(
    backgroundColor: Colors.white,
    iconColor: Colors.black,
    titleColor: Colors.black,
    surfaceTintColor: AppColors.primary,
    elevation: 3,
  );

  static final AppBarTheme darkAppBarTheme = _baseAppBarTheme(
    backgroundColor: Colors.grey[900]!,
    iconColor: Colors.white,
    titleColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
  );
}