import 'package:flutter/material.dart';

enum AppThemeMode { system, light, dark }

extension AppThemeModeX on AppThemeMode {
  ThemeMode get toFlutterMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
