import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/app_colors.dart';

class ActionDashboardTile extends StatelessWidget {
  const ActionDashboardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textStyle,
  });
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appColors = AppColors(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: appColors.secondaryContainer,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 30,
              color: appColors.onSecondaryContainer,
            ),
            SizedBox(height: 5),
            Wrap(
              children: [
                Text(
                  title,
                  style: textStyle ??
                      textTheme.bodyLarge!.copyWith(
                        color: appColors.onSecondaryContainer,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
