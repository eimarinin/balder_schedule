import 'package:flutter/material.dart';

class TimeRange extends StatelessWidget {
  final String startTime;
  final String endTime;

  const TimeRange({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          startTime,
          style: const TextStyle(
            fontSize: 24,
            height: 1.2,
          ),
        ),
        Text(
          endTime,
          style: const TextStyle(
            fontSize: 24,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
