import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'schedule_tag.dart';
import 'schedule_time.dart';

class ScheduleItem extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String subject;
  final String lectureType;
  final String room;
  final String teacher;

  const ScheduleItem({
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
              child: ScheduleTime(startTime: startTime, endTime: endTime),
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
                        ScheduleTag(text: lectureType),
                        const Gap(2),
                        ScheduleTag(text: room),
                      ],
                    ),
                    const Gap(2),
                    ScheduleTag(text: teacher),
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
