import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/state/schedule_state.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/page_header.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_calendar.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_day.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_item.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleState(),
      child: Scaffold(
        appBar: PageHeader(title: S.of(context).scheduleTitle),
        body: MarginScreen(child: ScheduleContent()),
      ),
    );
  }
}

class ScheduleContent extends StatelessWidget {
  const ScheduleContent({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleState = context.watch<ScheduleState>();
    final weekDates = getWeekDates(scheduleState.currentWeek);

    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          ScheduleCalendar(scheduleState: scheduleState),
          const Gap(12),
          ...weekDates.entries.map(
            (entry) {
              final weekday = entry.key;
              final formattedDate = entry.value;

              return FutureBuilder<List<LessonModel>>(
                future: DatabaseService().getLessonsByDayAndWeek(
                    weekday, scheduleState.currentParity),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Ошибка загрузки занятий для $weekday');
                  } else {
                    final lessons = snapshot.data ?? [];

                    if (lessons.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return ScheduleDay(
                      date: formattedDate,
                      lessons: lessons.map((lesson) {
                        return ScheduleItem(
                          startTime: lesson.time.split('-')[0],
                          endTime: lesson.time.split('-')[1],
                          subject: lesson.name,
                          lectureType: lesson.lessonType,
                          room: lesson.classRoom,
                          teacher: lesson.teacher,
                        );
                      }).toList(),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
