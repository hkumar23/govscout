import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
import '../core/theme/bloc/theme_bloc.dart';
import '../core/theme/bloc/theme_event.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_event.dart';
import '../logic/blocs/auth/auth_state.dart';
import '../utils/custom_snackbar.dart';

enum UserRole { admin, candidate }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AppStartedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignUpWithEmailSuccessState) {
            context.go(AppRoutes.candidate);
          }
          if (state is LoggedInState) {
            // BlocProvider.of<ThemeBloc>(context)
            //     .add(LoadUserTheme(state.userId));
            if (state.role == AppConstants.admin) {
              context.go(AppRoutes.admin);
            } else if (state.role == AppConstants.candidate) {
              context.go(AppRoutes.candidate);
            } else {
              context.go(AppRoutes.signIn);
            }
          }
          if (state is AuthErrorState) {
            context.go(AppRoutes.signIn);
            CustomSnackbar.error(
              context: context,
              text: state.e.message,
            );
          }
          if (state is LoggedOutState) {
            context.go(AppRoutes.signIn);
          }
          if (state is UserNotAuthendicatedState) {
            context.go(AppRoutes.signIn);
          }
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
