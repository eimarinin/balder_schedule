import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/utils/export/export.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/edit/day_selector.dart';
import 'package:balder_schedule_app/widgets/edit/edit_card.dart';
import 'package:balder_schedule_app/widgets/flash/snackbar_handler.dart';
import 'package:balder_schedule_app/widgets/page_header.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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

class EditContent extends StatefulWidget {
  const EditContent({super.key});

  @override
  State<EditContent> createState() => _EditContentState();
}

class _EditContentState extends State<EditContent> {
  DateTime _selectedDay = DateTime.now();

  void _onDayChanged(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() {
    setState(() {
      DatabaseService().getLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          DaySelector(onDayChanged: _onDayChanged),
          const Gap(12),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => context.go('/edit/lesson_create',
                          extra: _selectedDay),
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
            future: DatabaseService().getLessons(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Ошибка загрузки данных: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Данных нет');
              } else {
                final lessons = snapshot.data!;

                String selectedDay = DateFormat('EEEE').format(_selectedDay);
                final filteredLessons = lessons.where((lesson) {
                  if (lesson.lessonDate != null) {
                    return lesson.lessonDate! == selectedDay;
                  }
                  return false;
                }).toList();

                final specialDateLessons = lessons.where((lesson) {
                  if (lesson.lessonDate != null) {
                    try {
                      DateFormat('dd/MM/yyyy').parse(lesson.lessonDate!);
                      return true;
                    } catch (e) {
                      return false;
                    }
                  }
                  return false;
                }).toList();

                if (filteredLessons.isEmpty && specialDateLessons.isEmpty) {
                  return const Text('Нет добавленных занятий для этого дня');
                }

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    children: [
                      if (filteredLessons.isNotEmpty) ...[
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredLessons.length,
                          itemBuilder: (context, index) {
                            final lesson = filteredLessons[index];
                            return EditCard(
                              lesson: lesson,
                              onDelete: () async {
                                SnackbarHandler.handleSaveAction(
                                  context,
                                  () async {
                                    await DatabaseService()
                                        .deleteLesson(lesson.id!);
                                  },
                                  'Занятие успешно удалено!',
                                  'Ошибка при удалении занятия',
                                );
                                await DatabaseService()
                                    .deleteLesson(lesson.id!);
                                _loadLessons();
                              },
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
                      ],
                      if (specialDateLessons.isNotEmpty) ...[
                        const Gap(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'Особые даты',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const Gap(12),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: specialDateLessons.length,
                          itemBuilder: (context, index) {
                            final lesson = specialDateLessons[index];
                            return EditCard(
                              lesson: lesson,
                              onDelete: () async {
                                SnackbarHandler.handleSaveAction(
                                  context,
                                  () async {
                                    await DatabaseService()
                                        .deleteLesson(lesson.id!);
                                  },
                                  'Занятие успешно удалено!',
                                  'Ошибка при удалении занятия',
                                );
                                await DatabaseService()
                                    .deleteLesson(lesson.id!);
                                _loadLessons();
                              },
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
                      ],
                    ],
                  ),
                );
              }
            },
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
