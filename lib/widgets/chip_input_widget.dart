import 'package:flutter/material.dart';
import 'package:govscout/widgets/app_text_form_field.dart';

import '../constants/app_colors.dart';

class ChipInputWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String) onAdd;
  final Function(String) onDelete;

  const ChipInputWidget({
    super.key,
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final appColors = AppColors(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: appColors.onBackground.withAlpha(130),
                ),
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: items
              .map((item) => Chip(
                    label: Text(item),
                    onDeleted: () => onDelete(item),
                    deleteIcon: const Icon(Icons.close, size: 18),
                  ))
              .toList(),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: AppTextFormField(
                controller: controller,
                hintText: 'Add a ${title.toLowerCase().singular()}',
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: appColors.primary,
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onAdd(controller.text.trim());
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

// A simple extension to get the singular form of a word
extension StringExtension on String {
  String singular() {
    if (endsWith('s')) {
      return substring(0, length - 1);
    }
    return this;
  }
}
