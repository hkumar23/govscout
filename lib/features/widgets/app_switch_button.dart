import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_language.dart';

class AppSwitchButton extends StatelessWidget {
  final bool isActive;
  Function(bool) onChange;
  AppSwitchButton({
    super.key,
    required this.isActive,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Switch(
            value: isActive,
            onChanged: onChange,
            activeTrackColor: Colors.green.withAlpha(70),
            activeColor: appColors.onBackground.withAlpha(180),
          ),
          SizedBox(width: 6),
          Text(
            isActive ? AppLanguage.active : AppLanguage.inactive,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: isActive ? Colors.green : Colors.red,
                ),
          ),
        ],
      ),
    );
  }
}
