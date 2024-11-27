import 'package:balder_schedule_app/widgets/schedule/schedule_tag.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_time.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

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
      onTap: () => context.go('/schedule/lesson'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const Gap(6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ScheduleTime(startTime: startTime, endTime: endTime),
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScheduleTag(text: room),
                      const Gap(2),
                      ScheduleTag(text: lectureType),
                      const Gap(2),
                      ScheduleTag(text: teacher),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
