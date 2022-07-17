import 'package:flutter/material.dart';
import 'commons/utils/app_colors.dart';

class AppFontWeight {
  static const thin = FontWeight.w100;
  static const extraLight = FontWeight.w200;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
  static const ultraBold = FontWeight.w900;
}

abstract class AppStyles {
  ThemeData? themeData;

}

class DefaultAppStyles implements AppStyles {
  @override
  ThemeData? themeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    backgroundColor: AppColors.backgroundColor,
    highlightColor: AppColors.slightTextColor,
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 48, fontWeight: AppFontWeight.bold, color: Colors.black),
      headline2: TextStyle(fontSize: 32, fontWeight: AppFontWeight.semiBold, color: Colors.black),
      headline4: TextStyle(fontSize: 24, fontWeight: AppFontWeight.semiBold, color: Colors.black),
      headline5: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      headline6: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      bodyText2: TextStyle(fontSize: 14.4, fontWeight: FontWeight.normal, color: Colors.black),
      bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
    ),
    fontFamily: 'Source Sans Pro',
  );
}