import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_language.dart';
import '../constants/app_routes.dart';
import '../core/theme/app_theme_mode.dart';
import '../core/theme/bloc/theme_bloc.dart';
import '../core/theme/bloc/theme_event.dart';
import '../core/theme/bloc/theme_state.dart';
import '../data/repositories/auth_repo.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_state.dart';
import '../utils/app_methods.dart';
import '../utils/custom_snackbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = AppColors(context);
    final String userId = AuthRepository().currentUser!.uid;

    return Scaffold(
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is LoggedOutState) {
                GoRouter.of(context).go(AppRoutes.signIn);
                CustomSnackbar.neutral(
                  context: context,
                  text: "Logged Out Successfully",
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.color_lens_rounded),
                    title: Text(
                      AppLanguage.selectTheme,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 45, bottom: 16.0),
                    child: Wrap(
                      children: [
                        AppThemeMode.system,
                        AppThemeMode.light,
                        AppThemeMode.dark
                      ]
                          .map((mode) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ChoiceChip(
                                  label: Text(
                                    mode.name[0].toUpperCase() +
                                        mode.name.substring(1),
                                  ),
                                  selected: themeState.themeMode == mode,
                                  onSelected: (selected) {
                                    if (selected) {
                                      context.read<ThemeBloc>().add(
                                            ChangeTheme(
                                              mode,
                                              userId,
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: appColors.error,
                    ),
                    title: Text(
                      AppLanguage.logout,
                      style: TextStyle(color: appColors.error),
                    ),
                    onTap: () {
                      AppMethods.logoutWithDialog(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
