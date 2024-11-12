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
  first('8:00-9:35', '8:00', '9:35'),
  second('9:45-11:20', '9:45', '11:20'),
  third('11:35-13:10', '11:35', '13:10'),
  fourth('13:40-15:15', '13:40', '15:15'),
  fifth('15:25-17:00', '15:25', '17:00'),
  sixth('17:10-18:45', '17:10', '18:45'),
  seventh('18:55-20:30', '18:55', '20:30');

  const ListTime(this.label, this.start, this.end);
  final String label;
  final String start;
  final String end;
}

class _LessonCreateContentState extends State<LessonCreateContent> {
  final TextEditingController _customLessonTypeController =
      TextEditingController();

  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  ListTime? _selectedTime = ListTime.first;

  @override
  void initState() {
    super.initState();
    _startController.text = _selectedTime?.start ?? '';
    _endController.text = _selectedTime?.end ?? '';
  }

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
                      menuStyle: MenuStyle(),
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
                          _startController.text = time?.start ?? '';
                          _endController.text = time?.end ?? '';
                          widget.timeController.text = time?.label ?? '';
                        });
                      },
                      dropdownMenuEntries: ListTime.values
                          .map<DropdownMenuEntry<ListTime>>((ListTime time) {
                        return DropdownMenuEntry<ListTime>(
                          value: time,
                          label: time.label,
                        );
                      }).toList(),
                    ),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'или',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Начало занятия',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Gap(8),
                              TextFormField(
                                controller: _startController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '8:00',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // Если пользователь изменяет время, обновляем start
                                    _selectedTime = ListTime.values.firstWhere(
                                      (time) => time.start == value,
                                      orElse: () => ListTime.first,
                                    );
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Пожалуйста, введите время начала';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                              ),
                            ],
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Конец занятия',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const Gap(8),
                              TextFormField(
                                controller: _endController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '9:35',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    // Если пользователь изменяет время, обновляем end
                                    _selectedTime = ListTime.values.firstWhere(
                                      (time) => time.end == value,
                                      orElse: () => ListTime.first,
                                    );
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Пожалуйста, введите время конца';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                              ),
                            ],
                          ),
                        ),
                      ],
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
    _startController.dispose();
    _endController.dispose();

    super.dispose();
  }
}
