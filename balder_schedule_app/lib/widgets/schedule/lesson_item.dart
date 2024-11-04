import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'lesson_tag.dart';
import 'lesson_time.dart';

class LessonItem extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String subject;
  final String lectureType;
  final String room;
  final String teacher;

  const LessonItem({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.lectureType,
    required this.room,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/lesson');
      },
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 66,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: TimeRange(startTime: startTime, endTime: endTime),
            ),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  subject,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        LessonTag(text: lectureType),
                        const Gap(2),
                        LessonTag(text: room),
                      ],
                    ),
                    const Gap(2),
                    LessonTag(text: teacher),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
