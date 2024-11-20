import 'package:flutter/material.dart';

class GlobalThemData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        colorScheme: colorScheme,
        canvasColor: colorScheme.surface,
        scaffoldBackgroundColor: colorScheme.surface,
        highlightColor: Colors.transparent,
        focusColor: focusColor);
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    // 主色
    primary: Color.fromARGB(255, 255, 255, 255),
    // 主色上元素使用颜色
    onPrimary: Colors.black,

    secondary: Color(0xFFEFF3F3),
    onSecondary: Color.fromARGB(255, 53, 52, 56),
    error: Colors.redAccent,
    onError: Colors.white,
    surfaceBright: Color(0xFFE6EBEB),
    onSurfaceVariant: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 243, 238, 238),
    secondary: Color.fromARGB(255, 15, 13, 17),
    surfaceBright: Color.fromARGB(255, 20, 18, 23),
    surface: Color.fromARGB(255, 29, 29, 30),
    onSurfaceVariant: Color.fromARGB(13, 19, 18, 18),
    error: Colors.redAccent,
    onError: Color.fromARGB(255, 243, 238, 238),
    onPrimary: Color.fromARGB(255, 243, 238, 238),
    onSecondary: Color.fromARGB(255, 243, 238, 238),
    onSurface: Color.fromARGB(255, 243, 238, 238),
    brightness: Brightness.dark,
  );
}
