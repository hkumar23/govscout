import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AuthFormField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;

  const AuthFormField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.validator,
    this.isPassword = false,
  });

  @override
  State<AuthFormField> createState() => _AuthFormFieldState();
}

class _AuthFormFieldState extends State<AuthFormField> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    // Using a theme to easily access colors and text styles
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? isObscured : false,
        validator: widget.validator,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          // The main styling for the input field
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscured = !isObscured;
                    });
                  },
                  icon: Icon(
                    isObscured
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: Colors.white.withAlpha(100),
                  ),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[850]?.withOpacity(0.8),
          // Hint text styling
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          // Prefix icon for visual context
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Icon(
              widget.icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          // Default border style
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none, // No border by default
          ),
          // Border style when the field is enabled and not focused
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.grey[800]!,
              width: 1.0,
            ),
          ),
          // Border style when the field is focused (being typed in)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: theme.colorScheme.primary, // Highlight color on focus
              width: 2.0,
            ),
          ),
          // Border style when there's a validation error
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: AppColors.error,
              width: 2.0,
            ),
          ),
          // Border style when focused and there's an error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: AppColors.error,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
