import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/utils/export/export.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/edit/day_selector.dart';
import 'package:balder_schedule_app/widgets/edit/edit_card.dart';
import 'package:balder_schedule_app/widgets/page_header.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: S.of(context).editTitle),
      body: MarginScreen(child: EditContent()),
    );
  }
}

class EditContent extends StatelessWidget {
  const EditContent({super.key});

  Future<List<LessonModel>> _loadLessons() async {
    return await DatabaseService().getLessons();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          DaySelector(),
          const Gap(12),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => context.go('/edit/lesson_create'),
                      icon: Icon(Icons.add_outlined),
                      label: Text('Добавить'),
                    ),
                  ),
                ],
              ),
              const Gap(12),
            ],
          ),
          if (kIsWeb) ...[
            IconButton(
              icon: Icon(Icons.download_outlined),
              tooltip: 'Экспортировать данные',
              onPressed: () async {
                final lessons = await DatabaseService().getLessons();
                exportData(lessons.map((lesson) => lesson.toMap()).toList());
              },
            ),
            const Gap(12),
          ],
          FutureBuilder<List<LessonModel>>(
            future: _loadLessons(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Ошибка загрузки данных: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Данных нет');
              } else {
                final lessons = snapshot.data!;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];
                      return EditCard(
                        name: lesson.name,
                        classRoom: lesson.classRoom,
                        lessonType: lesson.lessonType,
                        time: lesson.time,
                        weekParity: lesson.weekParity,
                        lessonDate: lesson.lessonDate,
                        teacher: lesson.teacher,
                        notes: lesson.notes,
                      );
                    },
                    separatorBuilder: (context, index) => Column(
                      children: const [
                        Gap(12),
                        Divider(thickness: 2, height: 0),
                        Gap(12),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
