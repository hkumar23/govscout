import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/app_language.dart';
import '../logic/blocs/auth/auth_bloc.dart';
import '../logic/blocs/auth/auth_event.dart';
import '../widgets/show_modern_dialog.dart';

class AppMethods {
  static void logoutWithDialog(BuildContext ctx) {
    showModernDialog(
      context: ctx,
      title: AppLanguage.logout,
      content: "Are you sure you want to logout?",
      onConfirm: (context) {
        Navigator.of(context).pop();
        BlocProvider.of<AuthBloc>(ctx).add(LogoutEvent());
      },
    );
  }
}
