import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_theme_mode.dart';
import 'theme_event.dart';
import '../theme_repository.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository repo;

  ThemeBloc(this.repo)
      : super(const ThemeState(themeMode: AppThemeMode.system)) {
    on<LoadUserTheme>(_onLoadUserTheme);
    on<ChangeTheme>(_onChangeTheme);
  }

  Future<void> _onLoadUserTheme(
    LoadUserTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final mode = await repo.loadTheme(event.userId);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<ThemeState> emit,
  ) async {
    await repo.saveTheme(event.userId, event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
