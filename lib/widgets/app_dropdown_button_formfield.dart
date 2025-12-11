import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppDropdownButtonFormField extends StatelessWidget {
  final String? value;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final List<String> items;
  final void Function(String?)? onChanged;
  final double bottomPadding;
  const AppDropdownButtonFormField({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.bottomPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          filled: true,
          fillColor: appColors.secondaryContainer,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: colorScheme.primary,
                )
              : null,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
        items: items
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: onChanged,
      ),
    );
    // const SizedBox(height: 16),
  }
}
