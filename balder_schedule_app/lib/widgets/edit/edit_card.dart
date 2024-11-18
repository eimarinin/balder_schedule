import 'package:balder_schedule_app/widgets/schedule/schedule_tag.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditCard extends StatelessWidget {
  final String name;
  final String classRoom;
  final String lessonType;
  final String time;
  final String? weekParity;
  final String? lessonDate;
  final String teacher;
  final String? notes;

  const EditCard({
    super.key,
    required this.name,
    required this.classRoom,
    required this.lessonType,
    required this.time,
    this.weekParity,
    this.lessonDate,
    required this.teacher,
    this.notes,
  });

  List<String> _parseTime(String time) {
    final parts = time.split('-');
    if (parts.length == 2) {
      return parts;
    }
    return ['--:--', '--:--'];
  }

  @override
  Widget build(BuildContext context) {
    final times = _parseTime(time);
    final startTime = times[0];
    final endTime = times[1];

    return InkWell(
      onTap: () => context.go('/'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (lessonDate != null && lessonDate!.isNotEmpty) ...[
            ScheduleTag(text: 'Только $lessonDate'),
            const Gap(8),
          ],
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        startTime,
                        style: const TextStyle(fontSize: 24, height: 1.2),
                      ),
                      Text(
                        endTime,
                        style: const TextStyle(fontSize: 24, height: 1.2),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ScheduleTag(text: classRoom),
                            const Gap(2),
                            ScheduleTag(text: lessonType),
                            if (weekParity != null &&
                                weekParity!.isNotEmpty) ...[
                              const Gap(2),
                              ScheduleTag(text: 'Четность недели: $weekParity'),
                            ],
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
        ],
      ),
    );
  }
}
