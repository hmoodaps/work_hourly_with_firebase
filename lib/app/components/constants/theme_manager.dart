import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';
import 'general_strings.dart';
import 'size_manager.dart';

TextTheme commonTextTheme(Color textColor) {
  return TextTheme(
    headlineLarge: TextStyleManager.textStyle(
      fontWeight: FontWeightManager.bold,
      fontSize: SizeManager.d22,
      fontFamily: GeneralStrings.sand,
      color: textColor,
    ),
    titleLarge: TextStyleManager.textStyle(
      fontWeight: FontWeight.bold,
      fontSize: SizeManager.d16,
      fontFamily: GeneralStrings.sand,
      color: textColor,
    ),
    bodyLarge: TextStyleManager.textStyle(
      fontWeight: FontWeightManager.light,
      fontSize: SizeManager.d16,
      fontFamily: GeneralStrings.cinzel, // نفس الخط في الوضعين
      color: textColor,
    ),
    labelLarge: TextStyleManager.textStyle(
      fontWeight: FontWeightManager.regular,
      fontSize: SizeManager.d14,
      fontFamily: GeneralStrings.cinzel, // نفس الخط في الوضعين
      color: textColor,
    ),
  );
}

AppBarTheme commonAppBarTheme(Color color) {
  return AppBarTheme(
    backgroundColor: color,
    iconTheme: IconThemeData(color: ColorManager.primarySecond),
  );
}

ButtonThemeData commonButtonTheme() {
  return ButtonThemeData(
    buttonColor: ColorManager.primarySecond,
  );
}

IconThemeData commonIconTheme() {
  return IconThemeData(
    color: ColorManager.primarySecond,
  );
}

BottomNavigationBarThemeData commonBottomNavigationBarTheme() {
  return BottomNavigationBarThemeData(
    backgroundColor: ColorManager.primary,
    selectedItemColor: ColorManager.primarySecond,
    unselectedItemColor: ColorManager.privateGrey,
  );
}

ThemeData lightThemeData() {
  return ThemeData(
    textTheme: commonTextTheme(Colors.black),
    scaffoldBackgroundColor: ColorManager.primary,
    appBarTheme: commonAppBarTheme(ColorManager.primary),
    buttonTheme: commonButtonTheme(),
    iconTheme: commonIconTheme(),
    bottomNavigationBarTheme: commonBottomNavigationBarTheme(),
  );
}

ThemeData darkThemeData() {
  return ThemeData(
    textTheme: commonTextTheme(Colors.white),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: commonAppBarTheme(Colors.black),
    buttonTheme: commonButtonTheme(),
    iconTheme: commonIconTheme(),
    bottomNavigationBarTheme: commonBottomNavigationBarTheme(),
  );
}
