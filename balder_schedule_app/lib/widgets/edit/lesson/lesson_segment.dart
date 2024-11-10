import 'package:flutter/material.dart';

class LessonSegment extends ButtonSegment<String> {
  LessonSegment({required super.value, required String text})
      : super(
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0),
            child: Text(text),
          ),
        );
}
