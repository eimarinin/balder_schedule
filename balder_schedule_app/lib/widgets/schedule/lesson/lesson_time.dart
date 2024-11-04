import 'package:flutter/material.dart';

class LessonTime extends StatelessWidget {
  final String text;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;

  const LessonTime({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.horizontalPadding = 12.0,
    this.verticalPadding = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
