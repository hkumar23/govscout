import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Shows a simple, modern dialog with a clean UI and a smooth scale/fade animation.
///
/// [context] is the BuildContext from which the dialog is shown.
/// [title] is the main headline of the dialog.
/// [content] is the descriptive text.
/// [icon] is an optional widget (usually an Icon) to display above the title.
/// [onConfirm] is the callback executed when the primary action button is pressed.
/// [onCancel] is the callback for the secondary action button.
/// [confirmText] is the text for the primary button (defaults to "Confirm").
/// [cancelText] is the text for the secondary button (defaults to "Cancel").
/// [confirmButtonColor] allows customizing the primary button's color.
void showModernDialog({
  required BuildContext context,
  required String? title,
  required String? content,
  Widget? icon,
  required Function(BuildContext ctx) onConfirm,
  Function(BuildContext ctx)? onCancel,
  String confirmText = "Yes",
  String cancelText = "No",
  Color? confirmButtonColor,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Simple Modern Dialog',
    transitionDuration: const Duration(milliseconds: 350),
    // The pageBuilder builds the main, non-animated content of the dialog.
    pageBuilder: (context, animation, secondaryAnimation) {
      return _SimpleModernDialogContent(
        title: title,
        content: content,
        icon: icon,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmButtonColor: confirmButtonColor,
      );
    },
    // The transitionBuilder builds the animation.
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // Use a curved animation for a more dynamic "pop" effect.
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves
            .easeOutBack, // This curve makes the dialog "spring" into view
      );

      return ScaleTransition(
        scale: curvedAnimation,
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );
    },
  );
}

/// The private widget that builds the actual dialog UI.
class _SimpleModernDialogContent extends StatelessWidget {
  final String? title;
  final String? content;
  final Widget? icon;
  final Function(BuildContext ctx) onConfirm;
  final Function(BuildContext ctx)? onCancel;
  final String confirmText;
  final String cancelText;
  final Color? confirmButtonColor;

  const _SimpleModernDialogContent({
    required this.title,
    required this.content,
    this.icon,
    required this.onConfirm,
    required this.onCancel,
    required this.confirmText,
    required this.cancelText,
    this.confirmButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors(context);

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
        ),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // color: appColors.primaryContainer,
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use min size for the content
          children: [
            // Display the icon if it's provided
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 16),
            ],

            // Title
            if (title != null)
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appColors.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
            if (title != null) const SizedBox(height: 16),

            // Content
            if (content != null)
              Text(
                content!,
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: appColors.onBackground.withAlpha(200),
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                  onPressed: () => onConfirm(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: confirmButtonColor ??
                        appColors.onSecondaryContainer.withAlpha(50),
                    foregroundColor: appColors.onSecondaryContainer,
                  ),
                  child: Text(confirmText),
                ),
                const SizedBox(width: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        appColors.onSecondaryContainer.withAlpha(50),
                    foregroundColor: appColors.onSecondaryContainer,
                  ),
                  onPressed: () {
                    if (onCancel == null) {
                      Navigator.of(context).pop();
                    } else {
                      onCancel!(context);
                    }
                  },
                  child: Text(cancelText),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
