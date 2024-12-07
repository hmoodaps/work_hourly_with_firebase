import 'package:flutter/material.dart';
import 'package:work_hourly/presentation/cubit/cubit_class.dart';

class FontWeightManager {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w700;
  static const FontWeight bold = FontWeight.w900;
}

class TextStyleManager {
  static TextStyle textStyle({
    required FontWeight fontWeight,
    required double fontSize,
    required String fontFamily,
    required Color color,
  }) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontFamily: fontFamily,
        color: color);
  }

  static TextStyle? header(BuildContext context) {
    return CubitClass.headerStyle(context);
  }

  static TextStyle? titleStyle(BuildContext context) {
    return CubitClass.titleStyle(context);
  }

  static TextStyle? bodyStyle(BuildContext context) {
    return CubitClass.bodyStyle(context);
  }

  static TextStyle? paragraphStyle(BuildContext context) {
    return CubitClass.paragraphStyle(context);
  }

  static TextStyle? smallParagraphStyle(BuildContext context) {
    return CubitClass.smallParagraphStyle(context);
  }
}
