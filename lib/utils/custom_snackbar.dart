import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

abstract class CustomSnackbar {
  static success({required context, required String text}) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final AppColors appColors = AppColors(context);

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
        backgroundColor: appColors.success,
      ),
    );
  }

  static error({required context, required String text}) {
    final theme = Theme.of(context);
    final deviceSize = MediaQuery.of(context).size;
    final AppColors appColors = AppColors(context);

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
        backgroundColor: appColors.error,
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
            color: Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
