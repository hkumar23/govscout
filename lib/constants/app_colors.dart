import 'package:flutter/material.dart';

class AppColors {
  BuildContext context;
  AppColors(this.context);
  // Remove const → use getters instead
  Color get primary => const Color(0xFF4169E1);
  Color get onPrimary => const Color.fromARGB(255, 255, 255, 255);

  Color get success => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF4CAF50)
      : const Color(0xFF66BB6A);

  Color get error => const Color(0xFFF44336);
  Color get onError => const Color(0xFFFFFFFF);

  Color get background => Theme.of(context).brightness == Brightness.dark
      ? const Color.fromARGB(255, 23, 23, 23)
      : const Color(0xFFFFFFFF);
  Color get onBackground => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFFFFFFF)
      : const Color(0xFF000000);

  Color get secondaryContainer =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 29, 31, 41)
          // : Theme.of(context).colorScheme.secondaryContainer;
          : const Color.fromARGB(255, 223, 226, 246);
  Color get onSecondaryContainer =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 231, 231, 231)
          : const Color(0xFF2C2C2C);
}
