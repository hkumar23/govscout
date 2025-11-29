import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
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
    // context.read<AuthBloc>().add(AppStartedEvent());
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: BlocListener<AuthBloc, AuthState>(
    //     listener: (context, state) {
    //       if (state is LoggedInState) {
    //         if (state.role == AppConstants.admin) {
    //           context.go(AppRoutes.admin);
    //         } else if (state.role == AppConstants.candidate) {
    //           context.go(AppRoutes.candidate);
    //         } else {
    //           context.go(AppRoutes.login);
    //         }
    //       }
    //       if (state is AuthErrorState) {
    //         context.go(AppRoutes.login);
    //         CustomSnackbar.error(
    //           context: context,
    //           text: state.error.message,
    //         );
    //       }
    //       if (state is LoggedOutState) {
    //         context.go(AppRoutes.login);
    //       }
    //       if (state is UserNotAuthendicatedState) {
    //         context.go(AppRoutes.login);
    //       }
    //     },
    //     child: const Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   ),
    // );

    return Placeholder();
  }
}
