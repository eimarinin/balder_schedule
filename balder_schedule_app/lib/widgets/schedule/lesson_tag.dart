import 'package:flutter/material.dart';

class LessonTag extends StatelessWidget {
  final String text;

  const LessonTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          height: 1,
        ),
      ),
    );
  }
}
