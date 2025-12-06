import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTapped,
    required this.icons,
    required this.labels,
  });
  final int selectedIndex;
  final Function onTapped;
  final List<IconData> icons;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withAlpha(50), // shadow color
        //     spreadRadius: 1, // how wide the shadow spreads
        //     blurRadius: 8, // how soft the shadow looks
        //     offset: Offset(0, -2), // x: right/left, y: up/down
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          return buildNavItem(index, context);
        }),
      ),
    );
  }

  Widget buildNavItem(int index, BuildContext context) {
    bool isSelected = selectedIndex == index;
    final theme = Theme.of(context);
    final appColors = AppColors(context);
    // final deviceSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTapped(index),
      child: Container(
        // duration: Duration(milliseconds: 600),
        // height: kIsWeb ? deviceSize.height*0.1 : null,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: isSelected ? const EdgeInsets.symmetric(horizontal: 5) : null,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            Icon(
              icons[index],
              color: isSelected
                  ? appColors.background
                  : appColors.onBackground.withAlpha(125),
              // size: deviceSize.width* 0.08,
              // size: Theme.of(context).iconTheme.size,
            ),
            if (isSelected) const SizedBox(width: 5),
            if (isSelected)
              Text(
                labels[index],
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: appColors.background,
                      fontWeight: FontWeight.w600,
                    ),
              )
          ],
        ),
      ),
    );
  }
}
