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
          FutureBuilder<Map<String, List<LessonModel>>>(
            future: _getFilteredLessons(weekDates, scheduleState),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Text('Ошибка загрузки данных');
              }

              final filteredWeekDates = snapshot.data ?? {};

              if (filteredWeekDates.isEmpty) {
                return const Text('Нет расписания на текущую неделю');
              }

              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredWeekDates.length,
                itemBuilder: (context, index) {
                  final weekday = filteredWeekDates.keys.elementAt(index);
                  final lessons = filteredWeekDates[weekday]!;

                  return ScheduleDay(
                    date: weekDates[weekday]!['formatted']!,
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
                },
                separatorBuilder: (context, index) => const Gap(12),
              );
            },
          ),
          const Gap(12),
        ],
      ),
    );
  }

  Future<Map<String, List<LessonModel>>> _getFilteredLessons(
      Map<String, Map<String, String>> weekDates,
      ScheduleState scheduleState) async {
    final filteredWeekDates = <String, List<LessonModel>>{};

    for (final weekday in weekDates.keys) {
      final specificDate = weekDates[weekday]!['date']!;

      final lessons = await Future.wait([
        DatabaseService()
            .getLessonsByDayAndWeek(weekday, scheduleState.currentParity),
        DatabaseService().getLessonsBySpecificDate(specificDate),
      ]).then((results) {
        final lessonsByDayAndWeek = results[0];
        final lessonsBySpecificDate = results[1];
        return [...lessonsByDayAndWeek, ...lessonsBySpecificDate];
      });

      if (lessons.isNotEmpty) {
        filteredWeekDates[weekday] = lessons;
      }
    }

    return filteredWeekDates;
  }
}
