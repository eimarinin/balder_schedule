import 'package:flutter/material.dart';

class LessonTag extends StatelessWidget {
  final String label;

  const LessonTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 24,
        height: 1.2,
      ),
    );
  }
}
