import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'schedule_item.dart';

class ScheduleDay extends StatelessWidget {
  final String date;
  final List<ScheduleItem> lessons;

  const ScheduleDay({
    super.key,
    required this.date,
    required this.lessons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const Gap(12),
          ..._buildLessonItems(),
        ],
      ),
    );
  }

  List<Widget> _buildLessonItems() {
    List<Widget> lessonWidgets = [];
    for (var i = 0; i < lessons.length; i++) {
      lessonWidgets.add(lessons[i]);
      if (i < lessons.length - 1) {
        lessonWidgets.add(const Divider(thickness: 2));
      }
    }
    return lessonWidgets;
  }
}
