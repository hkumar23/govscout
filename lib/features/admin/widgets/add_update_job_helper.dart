import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class AddUpdateJobHelper {
  final BuildContext context;
  final AppColors appColors;

  AddUpdateJobHelper(
    this.context,
    this.appColors,
  );

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: appColors.onBackground.withAlpha(180),
            ),
      ),
    );
  }

  Widget buildFieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: appColors.onBackground.withAlpha(130),
            ),
      ),
    );
  }
}
