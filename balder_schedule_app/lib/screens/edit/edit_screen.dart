import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/utils/export/export.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/edit/day_selector.dart';
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
      floatingActionButton: ElevatedButton.icon(
        onPressed: () => context.go('/edit/lesson_create'),
        icon: Icon(Icons.add_outlined),
        label: Text('Добавить'),
      ),
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
          if (kIsWeb)
            IconButton(
              icon: Icon(Icons.download_outlined),
              tooltip: 'Экспортировать данные',
              onPressed: () async {
                final lessons = await DatabaseService().getLessons();
                exportData(lessons.map((lesson) => lesson.toMap()).toList());
              },
            ),
          const Gap(12),
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
                return DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Название')),
                    DataColumn(label: Text('Аудитория')),
                    DataColumn(label: Text('Тип')),
                    DataColumn(label: Text('Время')),
                    DataColumn(label: Text('Преподаватель')),
                  ],
                  rows: lessons.map((lesson) {
                    return DataRow(
                      cells: [
                        DataCell(Text(lesson.id?.toString() ?? '-')),
                        DataCell(Text(lesson.name)),
                        DataCell(Text(lesson.classRoom)),
                        DataCell(Text(lesson.lessonType)),
                        DataCell(Text(lesson.time)),
                        DataCell(Text(lesson.teacher)),
                      ],
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
