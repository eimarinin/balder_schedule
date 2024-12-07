import 'package:balder_schedule_app/widgets/schedule/schedule_tag.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_time.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ScheduleItem extends StatelessWidget {
  final int id;
  final String startTime;
  final String endTime;
  final String subject;
  final String lectureType;
  final String room;
  final String teacher;
  final bool specialDay;
  final String date;

  const ScheduleItem({
    super.key,
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.lectureType,
    required this.room,
    required this.teacher,
    required this.specialDay,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(
        '/lesson/$id?date=${Uri.encodeComponent(date)}',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (specialDay) ...[
            Container(
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                subject,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
          ] else ...[
            Text(
              subject,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
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
                      if (room == 'online') ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Онлайн',
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ] else ...[
                        ScheduleTag(text: room),
                      ],
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
