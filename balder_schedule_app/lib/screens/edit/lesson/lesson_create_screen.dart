import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_segments.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_field.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_segment.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _weekParityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isSpecificDate = false;

  void _toggleSpecificDate(bool value) {
    setState(() {
      _isSpecificDate = value;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _lessonTypeController.dispose();
    _timeController.dispose();
    _weekParityController.dispose();
    _dateController.dispose();
    _teacherController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).lessonCreateScreenTitle),
      body: MarginScreen(
        child: Form(
          key: _formKey,
          child: LessonCreateContent(
            nameController: _nameController,
            classController: _classController,
            lessonTypeController: _lessonTypeController,
            timeController: _timeController,
            weekParityController: _weekParityController,
            dateController: _dateController,
            isSpecificDate: _isSpecificDate,
            onSpecificDateChanged: _toggleSpecificDate,
            teacherController: _teacherController,
            notesController: _notesController,
            formKey: _formKey,
          ),
        ),
      ),
    );
  }
}

class LessonCreateContent extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController classController;
  final TextEditingController lessonTypeController;
  final TextEditingController timeController;
  final TextEditingController weekParityController;
  final TextEditingController dateController;
  final bool isSpecificDate;
  final ValueChanged<bool> onSpecificDateChanged;
  final TextEditingController teacherController;
  final TextEditingController notesController;
  final GlobalKey<FormState> formKey;

  const LessonCreateContent({
    super.key,
    required this.nameController,
    required this.classController,
    required this.lessonTypeController,
    required this.timeController,
    required this.weekParityController,
    required this.dateController,
    required this.isSpecificDate,
    required this.onSpecificDateChanged,
    required this.teacherController,
    required this.notesController,
    required this.formKey,
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
  final TextEditingController _customWeekParityController =
      TextEditingController();

  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  ListTime? _selectedTime = ListTime.first;

  void _saveToDatabase() async {
    if (widget.formKey.currentState?.validate() ?? false) {
      final lesson = LessonModel(
        name: widget.nameController.text,
        classRoom: widget.classController.text,
        lessonType: widget.lessonTypeController.text,
        time: widget.timeController.text,
        weekParity:
            widget.isSpecificDate ? null : widget.weekParityController.text,
        lessonDate: widget.isSpecificDate ? widget.dateController.text : null,
        teacher: widget.teacherController.text,
        notes: widget.notesController.text.isNotEmpty
            ? widget.notesController.text
            : null,
      );

      try {
        await DatabaseService().insertLesson(lesson);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Занятие успешно сохранено!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка при сохранении занятия: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Пожалуйста, проверьте поля.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimeController.text = _selectedTime?.start ?? '';
    _endTimeController.text = _selectedTime?.end ?? '';
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
                      width: MediaQuery.of(context).size.width,
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
                          if (time != null) {
                            _selectedTime = time;
                            _startTimeController.text = time.start;
                            _endTimeController.text = time.end;
                            widget.timeController.text = time.label;
                          }
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
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                textAlign: TextAlign.center,
                                controller: _startTimeController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '8:00',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = null;
                                    widget.timeController.text =
                                        '${_startTimeController.text}-${_endTimeController.text}';
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Пожалуйста, введите время начала занятия';
                                  }

                                  final timeRegex =
                                      RegExp(r'^(?:\d|[01]\d|2[0-3]):[0-5]\d$');
                                  if (!timeRegex.hasMatch(value)) {
                                    return 'Введите время в формате HH:mm';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.datetime,
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                textAlign: TextAlign.center,
                                controller: _endTimeController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '9:35',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = null;
                                    widget.timeController.text =
                                        '${_startTimeController.text}-${_endTimeController.text}';
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Пожалуйста, введите время завершения занятия';
                                  }

                                  final timeRegex =
                                      RegExp(r'^(?:\d|[01]\d|2[0-3]):[0-5]\d$');
                                  if (!timeRegex.hasMatch(value)) {
                                    return 'Введите время в формате HH:mm';
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Theme.of(context).colorScheme.surfaceContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Четность недели',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(12),
                    LessonSegments(
                      selected: {widget.weekParityController.text},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          if (_customWeekParityController.text.isEmpty) {
                            widget.weekParityController.text =
                                newSelection.isNotEmpty
                                    ? newSelection.first
                                    : '';
                          } else {
                            widget.weekParityController.text =
                                _customWeekParityController.text;
                          }
                          widget.onSpecificDateChanged(false);
                          widget.dateController.clear();
                        });
                      },
                      segments: [
                        LessonSegment(value: '1', text: '1'),
                        LessonSegment(value: '2', text: '2'),
                      ],
                      customController: _customWeekParityController,
                      validator: (value) {
                        final parityValue =
                            widget.weekParityController.text.isNotEmpty
                                ? widget.weekParityController.text
                                : _customWeekParityController.text;

                        if (!widget.isSpecificDate && parityValue.isEmpty) {
                          return 'Пожалуйста, выберите четность недели или дату проведения занятия';
                        }

                        if (!widget.isSpecificDate &&
                            int.tryParse(parityValue) == null) {
                          return 'Четность недели должна быть числом';
                        }

                        return null;
                      },
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
                    const Gap(12),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodyLarge,
                      readOnly: true,
                      controller: widget.dateController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.today_outlined),
                        hintText: 'Выбрать дату',
                        helper: Text(
                          'Вы можете добавить это занятие на конкретный день, например, указать дату проведения экзамена или индивидуального занятия.',
                        ),
                      ),
                      onTap: () async {
                        final DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            widget.onSpecificDateChanged(true);
                            widget.weekParityController.clear();
                            widget.dateController.text =
                                DateFormat('dd.MM.yyyy').format(selectedDate);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              LessonField(
                labelText: 'Преподаватель',
                controller: widget.teacherController,
              ),
              TextFormField(
                controller: widget.notesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  labelText: 'Заметка',
                  hintText: 'Например, нельзя опаздывать...',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  helper: Text(
                      'Необязательное поле. Эта заметка будет отображаться каждую неделю для этого занятия'),
                ),
                maxLines: null,
                minLines: 3,
              ),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                      ),
                      icon: Icon(
                        Icons.check_outlined,
                        size: 18,
                      ),
                      label: Text('Сохранить'),
                      onPressed: _saveToDatabase,
                    ),
                  ),
                ],
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
    _startTimeController.dispose();
    _endTimeController.dispose();
    _customWeekParityController.dispose();

    super.dispose();
  }
}
