import 'package:flutter/material.dart';

class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final bool enabled;
  final bool readOnly;
  final bool isPassword;
  final bool alignLabelWithHint;
  final double bottomPadding;
  final int maxLines;
  final int minLines;
  final TextStyle? style;
  final void Function()? onTap;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;

  const AppTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.readOnly = false,
    this.isPassword = false,
    this.alignLabelWithHint = false,
    this.bottomPadding = 12,
    this.maxLines = 1,
    this.minLines = 1,
    this.style,
    this.onTap,
    this.onSaved,
    this.onChanged,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withAlpha(50),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintText: widget.hintText,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  color: Theme.of(context).colorScheme.primary,
                )
              : null,
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
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          floatingLabelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          enabled: widget.enabled,
          alignLabelWithHint: widget.alignLabelWithHint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
        ),
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        readOnly: widget.readOnly,
        obscureText: widget.isPassword ? isObscured : false,
        style: widget.style,
        onTap: widget.onTap,
        onSaved: widget.onSaved,
        onChanged: widget.onChanged,
      ),
    );
  }
}
