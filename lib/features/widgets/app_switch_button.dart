import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_language.dart';

class AppSwitchButton extends StatefulWidget {
  bool isActive;
  AppSwitchButton({
    super.key,
    required this.isActive,
  });

  @override
  State<AppSwitchButton> createState() => _AppSwitchButtonState();
}

class _AppSwitchButtonState extends State<AppSwitchButton> {
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
            value: widget.isActive,
            onChanged: (val) {
              setState(() {
                widget.isActive = val;
              });
            },
            activeTrackColor: Colors.green.withAlpha(70),
            activeColor: appColors.onBackground.withAlpha(180),
          ),
          SizedBox(width: 6),
          Text(
            widget.isActive ? AppLanguage.active : AppLanguage.inactive,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: widget.isActive ? Colors.green : Colors.red,
                ),
          ),
        ],
      ),
    );
  }
}
