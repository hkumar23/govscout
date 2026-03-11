import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_language.dart';
import '../../constants/app_routes.dart';
import '../../core/theme/app_theme_mode.dart';
import '../../core/theme/bloc/theme_bloc.dart';
import '../../core/theme/bloc/theme_event.dart';
import '../../core/theme/bloc/theme_state.dart';
import '../../data/repositories/auth_repo.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/auth/auth_state.dart';
import '../../utils/app_methods.dart';
import '../../utils/custom_snackbar.dart';

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
              return SingleChildScrollView(
                child: Column(
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome,
                              color: Colors.blue, size: 30),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "New Features Coming Soon",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "We're working on exciting updates. Stay tuned!",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
