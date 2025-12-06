import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:govscout/utils/custom_snackbar.dart';

import '../constants/app_colors.dart';
import '../constants/app_language.dart';
import '../constants/app_routes.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_event.dart';
import '../logic/blocs/auth/auth_state.dart';
import '../utils/app_methods.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColors appColors = AppColors(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          CustomSnackbar.neutral(
            context: context,
            text: "Logged Out Successfully",
          );
          if (state is LoggedOutState) {
            GoRouter.of(context).go(AppRoutes.signIn);
          }
        },
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
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
              )
            ],
          );
        },
      ),
    );
  }
}
