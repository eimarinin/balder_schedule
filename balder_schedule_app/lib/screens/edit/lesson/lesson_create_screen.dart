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
  final TextEditingController _lessonTypeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _lessonTypeController.dispose();
    _timeController.dispose();

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
            lessonTypeController: _lessonTypeController,
            timeController: _timeController,
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
  final TextEditingController lessonTypeController;
  final TextEditingController timeController;

  const LessonCreateContent({
    super.key,
    required this.nameController,
    required this.classController,
    required this.lessonTypeController,
    required this.timeController,
  });

  @override
  State<LessonCreateContent> createState() => _LessonCreateContentState();
}

enum ListTime {
  first('8:00-9:45'),
  second('9:45-11:20'),
  third('11:35-13:10'),
  fourth('13:40-15:15'),
  fifth('15:25-17:00'),
  sixth('17:10-18:45'),
  seventh('18:55-20:30');

  const ListTime(this.label);
  final String label;
}

class _LessonCreateContentState extends State<LessonCreateContent> {
  final TextEditingController _customLessonTypeController =
      TextEditingController();

  ListTime? _selectedTime = ListTime.first;

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
                padding: const EdgeInsets.all(12),
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
                    const Gap(12),
                    LessonSegments(
                      selected: {widget.lessonTypeController.text},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          if (_customLessonTypeController.text.isEmpty) {
                            widget.lessonTypeController.text =
                                newSelection.isNotEmpty
                                    ? newSelection.first
                                    : '';
                          } else {
                            widget.lessonTypeController.text =
                                _customLessonTypeController.text;
                          }
                        });
                      },
                      segments: [
                        LessonSegment(value: 'Лекция', text: 'Лекция'),
                        LessonSegment(value: 'Практика', text: 'Практика'),
                        LessonSegment(
                            value: 'Лаб. работа', text: 'Лаб. работа'),
                      ],
                      customController: _customLessonTypeController,
                      validator: (value) {
                        if (widget.lessonTypeController.text.isNotEmpty ||
                            _customLessonTypeController.text.isNotEmpty) {
                          return null;
                        }
                        return 'Пожалуйста, выберите тип занятия';
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Время занятия',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(12),
                    DropdownMenu<ListTime>(
                      width: double.infinity,
                      leadingIcon: Icon(
                        Icons.schedule_outlined,
                        size: 20,
                      ),
                      initialSelection: _selectedTime,
                      controller: widget.timeController,
                      requestFocusOnTap: false,
                      onSelected: (ListTime? time) {
                        setState(() {
                          _selectedTime = time;
                          widget.timeController.text = time?.label ?? '';
                        });
                      },
                      dropdownMenuEntries: ListTime.values
                          .map<DropdownMenuEntry<ListTime>>((ListTime time) {
                        return DropdownMenuEntry<ListTime>(
                          value: time,
                          label: time.label,
                          style: MenuItemButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
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
    _customLessonTypeController.dispose();

    super.dispose();
  }
}
