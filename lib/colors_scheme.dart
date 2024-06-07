import 'package:flutter/material.dart';

class AppColorScheme {
  // Define your colors as static constants
  static TextStyle heading1({
    double? fontSize,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 24.0,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle heading2({
    double? fontSize,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 22.0,
      fontWeight: fontWeight,
      color: color ?? white,
    );
  }

  static TextStyle heading3({
    double? fontSize,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 20.0,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle heading4({
    double? fontSize,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 18.0,
      fontWeight: fontWeight,
      color: color ?? white,
    );
  }

  static TextStyle bodyText({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 16.0,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle buttonText({
    double? fontSize,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 18.0,
      fontWeight: fontWeight,
      color: color ?? Colors.white,
    );
  }

  static const Color primaryColor = Color(0xFF2196F3);
  static const Color blackColor = Color(0xFF000000);
  static const Color secondaryColor = Color(0xFF73192A);
  static const Color accentColor = Color(0xFFFDEE52);
  static const Color backgroundColor = Color(0xFF181255);
  static const Color white = Colors.white;
  static Color get borderColor => Color(0xFFE5EBF0);
  static Color get whiteColor => Color(0xFFFFFFFF);
}
