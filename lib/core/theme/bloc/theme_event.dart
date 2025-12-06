import '../app_theme_mode.dart';

abstract class ThemeEvent {}

class LoadUserTheme extends ThemeEvent {
  final String userId;
  LoadUserTheme(this.userId);
}

class ChangeTheme extends ThemeEvent {
  final AppThemeMode themeMode;
  final String userId;
  ChangeTheme(this.themeMode, this.userId);
}
