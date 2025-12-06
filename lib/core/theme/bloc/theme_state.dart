import '../app_theme_mode.dart';

class ThemeState {
  final AppThemeMode themeMode;

  const ThemeState({required this.themeMode});

  ThemeState copyWith({AppThemeMode? themeMode}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode);
  }
}
