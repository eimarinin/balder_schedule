import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_segments.dart';
import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_field.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_segment.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonCreateScreen extends StatefulWidget {
  const LessonCreateScreen({super.key});

  @override
  State<LessonCreateScreen> createState() => _LessonCreateScreenState();
}

class _LessonCreateScreenState extends State<LessonCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).lessonCreateScreenTitle),
      body: PaddedScreen(
        child: Form(
          key: _formKey,
          child: LessonCreateContent(
            nameController: _nameController,
            classController: _classController,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            // Если форма валидна
            // Ваша логика
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class LessonCreateContent extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController classController;

  const LessonCreateContent({
    super.key,
    required this.nameController,
    required this.classController,
  });

  @override
  State<LessonCreateContent> createState() => _LessonCreateContentState();
}

class _LessonCreateContentState extends State<LessonCreateContent> {
  String _selectedLessonType = 'Лекция';
  final TextEditingController _customController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Wrap(
            runSpacing: 12.0,
            children: [
              LessonField(
                labelText: 'Название предмета',
                controller: widget.nameController,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Тип занятия',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Gap(12),
                    LessonSegments(
                      selected: {_selectedLessonType},
                      onSelectionChanged: (newSelection) {
                        if (_customController.text.isEmpty) {
                          setState(() {
                            _selectedLessonType = newSelection.isNotEmpty
                                ? newSelection.first
                                : '';
                          });
                        } else {
                          setState(() {
                            _selectedLessonType = _customController.text;
                          });
                        }
                        print('Выбран тип занятия: $_selectedLessonType');
                      },
                      segments: [
                        LessonSegment(value: 'Лекция', text: 'Лекция'),
                        LessonSegment(value: 'Практика', text: 'Практика'),
                        LessonSegment(
                            value: 'Лаб. работа', text: 'Лаб. работа'),
                      ],
                      customController: _customController,
                      validator: (value) {
                        if (_customController.text.isNotEmpty) {
                          return null;
                        }

                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, выберите тип занятия';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              LessonField(
                labelText: 'Аудитория',
                controller: widget.classController,
                isNumeric: true,
              ),
            ],
          ),
          const Gap(12),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }
}
