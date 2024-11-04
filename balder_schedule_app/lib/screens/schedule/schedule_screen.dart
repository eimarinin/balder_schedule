import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

import '../../state/schedule_state.dart';
import '../../utils/padded_screen.dart';
import '../../generated/l10n.dart';
import '../../widgets/page_header.dart';
import '../../widgets/schedule/calendar.dart';
import '../../widgets/schedule/day_schedule.dart';
import '../../widgets/schedule/lesson_item.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleState(),
      child: Scaffold(
        appBar: PageHeader(title: S.of(context).scheduleTitle),
        body: const PaddedScreen(child: ScheduleContent()),
      ),
    );
  }
}

class ScheduleContent extends StatelessWidget {
  const ScheduleContent({super.key});

  @override
  Widget build(BuildContext context) {
    var scheduleState = context.watch<ScheduleState>();
    return SingleChildScrollView(
      child: Column(
        children: [
          Calendar(scheduleState: scheduleState),
          Gap(12),
          DaySchedule(
            date: "Понедельник - 28.10",
            lessons: [
              LessonItem(
                startTime: '8:00',
                endTime: '9:35',
                subject: 'Алгебра',
                lectureType: 'Лекция',
                room: '6512',
                teacher: 'Багаев Андрей Владимирович',
              ),
              LessonItem(
                startTime: '9:45',
                endTime: '11:20',
                subject: 'Ведение проектов',
                lectureType: 'Практика',
                room: '6210',
                teacher: 'Захаров',
              ),
            ],
          ),
          Gap(12),
          DaySchedule(
            date: "Вторник - 29.10",
            lessons: [
              LessonItem(
                startTime: '11:35',
                endTime: '13:10',
                subject: 'Базы данных',
                lectureType: 'Лекция',
                room: '1221',
                teacher: 'Моисеев',
              ),
              LessonItem(
                startTime: '13:40',
                endTime: '15:15',
                subject: 'Распределенные системы',
                lectureType: 'Практика',
                room: '1222',
                teacher: 'Рыбин',
              ),
            ],
          ),
          Gap(12),
          DaySchedule(
            date: "Среда - 30.10",
            lessons: [
              LessonItem(
                startTime: '11:35',
                endTime: '13:10',
                subject: 'Базы данных',
                lectureType: 'Лекция',
                room: '1221',
                teacher: 'Моисеев',
              ),
              LessonItem(
                startTime: '13:40',
                endTime: '15:15',
                subject: 'Распределенные системы',
                lectureType: 'Практика',
                room: '1222',
                teacher: 'Рыбин',
              ),
            ],
          ),
          Gap(12),
        ],
      ),
    );
  }
}
