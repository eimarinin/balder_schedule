import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/state/schedule_state.dart';
import 'package:balder_schedule_app/utils/padded_screen.dart';
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
        body: PaddedScreen(child: ScheduleContent()),
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
          const Gap(12),
          ScheduleCalendar(scheduleState: scheduleState),
          const Gap(12),
          ScheduleDay(
            date: "Понедельник - 28.10",
            lessons: [
              ScheduleItem(
                startTime: '8:00',
                endTime: '9:35',
                subject: 'Алгебра',
                lectureType: 'Лекция',
                room: '6512',
                teacher: 'Багаев Андрей Владимирович',
              ),
              ScheduleItem(
                startTime: '9:45',
                endTime: '11:20',
                subject: 'Ведение проектов',
                lectureType: 'Практика',
                room: '6210',
                teacher: 'Захаров',
              ),
            ],
          ),
          const Gap(12),
          ScheduleDay(
            date: "Вторник - 29.10",
            lessons: [
              ScheduleItem(
                startTime: '11:35',
                endTime: '13:10',
                subject: 'Базы данных',
                lectureType: 'Лекция',
                room: '1221',
                teacher: 'Моисеев',
              ),
              ScheduleItem(
                startTime: '13:40',
                endTime: '15:15',
                subject: 'Распределенные системы',
                lectureType: 'Практика',
                room: '1222',
                teacher: 'Рыбин',
              ),
            ],
          ),
          const Gap(12),
          ScheduleDay(
            date: "Среда - 30.10",
            lessons: [
              ScheduleItem(
                startTime: '11:35',
                endTime: '13:10',
                subject: 'Базы данных',
                lectureType: 'Лекция',
                room: '1221',
                teacher: 'Моисеев',
              ),
              ScheduleItem(
                startTime: '13:40',
                endTime: '15:15',
                subject: 'Распределенные системы',
                lectureType: 'Практика',
                room: '1222',
                teacher: 'Рыбин',
              ),
            ],
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
