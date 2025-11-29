import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

abstract class CustomSnackbar {
  static success({required context, required String text}) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: deviceSize.width - 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: Text(
          text,
          style: theme.textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // backgroundColor: AppColors.orangeYellow,
        backgroundColor: AppColors.success,
      ),
    );
  }

  static error({required context, required String text}) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: deviceSize.width - 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: Text(
          text,
          style: theme.textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  static neutral({required context, required String text}) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: deviceSize.width - 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        content: Text(
          text,
          style: theme.textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
