import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/widgets/schedule/schedule_tag.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EditCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onDelete;

  const EditCard({
    super.key,
    required this.lesson,
    required this.onDelete,
  });

  List<String> _parseTime(String time) {
    final parts = time.split('-');
    if (parts.length == 2) {
      return parts;
    }
    return ['--:--', '--:--'];
  }

  Future<void> _deleteLesson() async {
    final databaseService = DatabaseService();
    await databaseService.deleteLesson(lesson.id!);
    onDelete();
  }

  bool isValidDateFormat(String date) {
    try {
      DateFormat('dd/MM/yyyy').parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  String convertDateFormat(String date) {
    try {
      final DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date);

      final String formattedDate =
          DateFormat('dd MMMM yyyy - EEEE', 'ru_RU').format(parsedDate);

      return formattedDate;
    } catch (e) {
      return 'Неверный формат даты';
    }
  }

  @override
  Widget build(BuildContext context) {
    final times = _parseTime(lesson.time);
    final startTime = times[0];
    final endTime = times[1];

    return InkWell(
      onTap: () => context.go('/'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isValidDateFormat(lesson.lessonDate!)) ...[
            ScheduleTag(text: convertDateFormat('${lesson.lessonDate}')),
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
                      lesson.name,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (lesson.classRoom == 'online') ...[
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
                              ScheduleTag(text: lesson.classRoom),
                            ],
                            const Gap(2),
                            ScheduleTag(text: lesson.lessonType),
                            if (lesson.weekParity != null &&
                                lesson.weekParity!.isNotEmpty) ...[
                              const Gap(2),
                              ScheduleTag(
                                text: 'Четность недели: ${lesson.weekParity}',
                              ),
                            ],
                          ],
                        ),
                        const Gap(2),
                        ScheduleTag(text: lesson.teacher),
                      ],
                    ),
                  ],
                ),
                IconButton.filled(
                  onPressed: _deleteLesson,
                  icon: Icon(Icons.delete),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
