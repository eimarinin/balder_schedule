import 'package:flutter/material.dart';

class LessonField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isNumeric;

  const LessonField({
    super.key,
    required this.labelText,
    required this.controller,
    this.isNumeric = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainer,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Поле не может быть пустым';
        }

        if (isNumeric && int.tryParse(value) == null) {
          return 'Введите число';
        }

        return null;
      },
    );
  }
}
