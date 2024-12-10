import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/lesson_db.dart';
import 'package:balder_schedule_app/state/schedule_state.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/page_header.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_calendar.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_day.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_item.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class ScheduleContent extends StatefulWidget {
  const ScheduleContent({super.key});

  @override
  State<ScheduleContent> createState() => _ScheduleContentState();
}

class _ScheduleContentState extends State<ScheduleContent> {
  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<Map<String, List<LessonModel>>> _loadLessons() async {
    final scheduleState = context.read<ScheduleState>();
    final weekDates = getWeekDates(scheduleState.currentWeek);

    return _getFilteredLessons(weekDates, scheduleState);
  }

  Future<void> _refreshLessons() async {
    setState(() {
      _loadLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleState = context.watch<ScheduleState>();
    final weekDates = getWeekDates(scheduleState.currentWeek);

    return RefreshIndicator(
      onRefresh: _refreshLessons,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                Scaffold.of(context).appBarMaxHeight! -
                (Theme.of(context).navigationBarTheme.height ?? 80.0),
          ),
          child: Column(
            children: [
              const Gap(12),
              ScheduleCalendar(scheduleState: scheduleState),
              const Gap(12),
              FutureBuilder<Map<String, List<LessonModel>>>(
                future: _getFilteredLessons(weekDates, scheduleState),
                builder: (context, snapshot) {
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

                      return FutureBuilder<List<ScheduleItem>>(
                        future: _buildScheduleItems(
                            lessons, weekDates[weekday]!['short']!),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Ошибка загрузки расписания');
                          }

                          final scheduleItems = snapshot.data ?? [];
                          return ScheduleDay(
                            date: weekDates[weekday]!['formatted']!,
                            lessons: scheduleItems,
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(12),
                  );
                },
              ),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, List<LessonModel>>> _getFilteredLessons(
  Map<String, Map<String, String>> weekDates,
  ScheduleState scheduleState,
) async {
  final filteredWeekDates = <String, List<LessonModel>>{};

  for (final weekday in weekDates.keys) {
    final specificDate = weekDates[weekday]!['date']!;
    try {
      final lessons = await Future.wait([
        LessonDatabase()
            .getLessonsByDayAndWeek(weekday, scheduleState.currentParity),
        LessonDatabase().getLessonsBySpecificDate(specificDate),
      ]).then((results) {
        final lessonsByDayAndWeek = results[0];
        final lessonsBySpecificDate = results[1];
        return [...lessonsByDayAndWeek, ...lessonsBySpecificDate];
      });

      if (lessons.isNotEmpty) {
        filteredWeekDates[weekday] = lessons;
      }
    } catch (e) {
      debugPrint('Ошибка при получении данных: $e');
      filteredWeekDates[weekday] = [];
    }
  }

  return filteredWeekDates;
}

Future<List<ScheduleItem>> _buildScheduleItems(
    List<LessonModel> lessons, String shortDate) async {
  final scheduleItems = <ScheduleItem>[];

  for (final lesson in lessons) {
    try {
      final countNotes =
          await LessonDatabase().getTotalNotesCountForLesson(lesson.id!);
      scheduleItems.add(ScheduleItem(
        id: lesson.id!,
        startTime: lesson.time.split('-')[0],
        endTime: lesson.time.split('-')[1],
        subject: lesson.name,
        lectureType: lesson.lessonType,
        room: lesson.classRoom,
        teacher: lesson.teacher,
        specialDay: _isSpecialDay(lesson.lessonDate),
        date: shortDate,
        lessonNote: lesson.notes ?? '',
        countNotes: countNotes,
      ));
    } catch (e) {
      debugPrint('Ошибка загрузки заметок для урока ${lesson.id}: $e');
      scheduleItems.add(ScheduleItem(
        id: lesson.id!,
        startTime: lesson.time.split('-')[0],
        endTime: lesson.time.split('-')[1],
        subject: lesson.name,
        lectureType: lesson.lessonType,
        room: lesson.classRoom,
        teacher: lesson.teacher,
        specialDay: _isSpecialDay(lesson.lessonDate),
        date: shortDate,
        lessonNote: lesson.notes ?? '',
        countNotes: 0, // Если произошла ошибка, устанавливаем 0
      ));
    }
  }

  return scheduleItems;
}

bool _isSpecialDay(String date) {
  try {
    DateFormat('dd/MM/yyyy').parse(date);
    return true;
  } catch (e) {
    return false;
  }
}
