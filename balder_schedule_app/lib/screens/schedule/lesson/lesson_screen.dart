import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/lesson_db.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';
import 'package:balder_schedule_app/widgets/schedule/lesson/lesson_tag.dart';
import 'package:balder_schedule_app/widgets/schedule/lesson/lesson_time.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonScreen extends StatelessWidget {
  final int id;
  final String date;

  const LessonScreen({
    super.key,
    required this.id,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LessonModel?>(
      future: LessonDatabase().getLessonById(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Загрузка урока')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Ошибка')),
            body: Center(child: Text('Не удалось загрузить урок')),
          );
        }

        final lesson = snapshot.data;

        if (lesson == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Урок не найден')),
            body: Center(child: Text('Урок с ID $id не найден')),
          );
        }

        return Scaffold(
          appBar: PageHeaderChild(title: lesson.name),
          body: MarginScreen(
            child: LessonContent(
              lesson: lesson,
              date: date,
            ),
          ),
        );
      },
    );
  }
}

class LessonContent extends StatefulWidget {
  final LessonModel lesson;
  final String date;

  const LessonContent({
    super.key,
    required this.lesson,
    required this.date,
  });

  @override
  State<LessonContent> createState() => _LessonContentState();
}

class _LessonContentState extends State<LessonContent> {
  late LessonModel lesson = widget.lesson;
  late String date = widget.date;

  bool _isNoteFormVisible = false;

  void _toggleNoteFormVisibility() {
    setState(() {
      _isNoteFormVisible = !_isNoteFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Row(
            children: [
              LessonTime(text: lesson.time.split('-')[0]),
              const Gap(12),
              Text('-', style: TextStyle(fontSize: 24)),
              const Gap(12),
              LessonTime(text: lesson.time.split('-')[1]),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Wrap(
                    runSpacing: 24.0,
                    children: [
                      LessonTag(label: lesson.lessonType),
                      const Divider(thickness: 2, height: 0),
                      LessonTag(
                        label: lesson.classRoom.toLowerCase() == 'online'
                            ? 'Онлайн'
                            : lesson.classRoom,
                      ),
                      const Divider(thickness: 2, height: 0),
                      LessonTag(label: lesson.teacher),
                      const Divider(thickness: 2, height: 0),
                      if (lesson.weekParity != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LessonTag(
                              label: 'Кратность недель: ${lesson.weekParity!}',
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (lesson.notes != null) ...[
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    child: Wrap(
                      runSpacing: 12.0,
                      children: [
                        Text('Основная заметка',
                            style: Theme.of(context).textTheme.bodyLarge),
                        const Divider(thickness: 2, height: 0),
                        Text(lesson.notes ?? ''),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _toggleNoteFormVisibility,
                  child: Text(_isNoteFormVisible
                      ? 'Скрыть заметку'
                      : 'Добавить заметку'),
                ),
              ),
            ],
          ),
          if (_isNoteFormVisible) ...[
            const Gap(12),
            TextField(
              decoration: InputDecoration(
                labelText: 'Заметка на $date',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                hintText: 'Например, сделать домашку...',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              maxLines: null,
              minLines: 5,
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      Icons.check_outlined,
                      size: 18,
                    ),
                    label: Text('Сохранить'),
                  ),
                ),
              ],
            ),
          ],
          const Gap(12),
        ],
      ),
    );
  }
}
