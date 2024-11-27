import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_field.dart';
import 'package:balder_schedule_app/widgets/edit/lesson/lesson_segment.dart';
import 'package:balder_schedule_app/widgets/flash/snackbar_handler.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

enum ControllerKey {
  name,
  classRoom,
  lessonType,
  time,
  weekParity,
  date,
  teacher,
  notes,
}

enum CustomControllerKey {
  lessonType,
  online,
  weekParity,
  startTime,
  endTime,
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

class LessonCreateScreen extends StatefulWidget {
  final DateTime selectedDay;

  const LessonCreateScreen({super.key, required this.selectedDay});

  @override
  State<LessonCreateScreen> createState() => _LessonCreateScreenState();
}

class _LessonCreateScreenState extends State<LessonCreateScreen> {
  final Map<ControllerKey, TextEditingController> _controllers = {
    for (var key in ControllerKey.values) key: TextEditingController(),
  };

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }

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
            controllers: _controllers,
            selectedDay: widget.selectedDay,
            formKey: _formKey,
          ),
        ),
      ),
    );
  }
}

class LessonCreateContent extends StatefulWidget {
  final Map<ControllerKey, TextEditingController> controllers;
  final DateTime selectedDay;
  final GlobalKey<FormState> formKey;

  const LessonCreateContent({
    super.key,
    required this.controllers,
    required this.formKey,
    required this.selectedDay,
  });

  @override
  State<LessonCreateContent> createState() => _LessonCreateContentState();
}

class _LessonCreateContentState extends State<LessonCreateContent> {
  final Map<CustomControllerKey, TextEditingController> _customControllers = {
    for (var key in CustomControllerKey.values) key: TextEditingController(),
  };

  late TextEditingController name = widget.controllers[ControllerKey.name]!;
  late TextEditingController classRoom =
      widget.controllers[ControllerKey.classRoom]!;
  late TextEditingController lessonType =
      widget.controllers[ControllerKey.lessonType]!;
  late TextEditingController time = widget.controllers[ControllerKey.time]!;
  late TextEditingController weekParity =
      widget.controllers[ControllerKey.weekParity]!;
  late TextEditingController lessonDate =
      widget.controllers[ControllerKey.date]!;
  late TextEditingController teacher =
      widget.controllers[ControllerKey.teacher]!;
  late TextEditingController notes = widget.controllers[ControllerKey.notes]!;

  late TextEditingController customLessonType =
      _customControllers[CustomControllerKey.lessonType]!;
  late TextEditingController customOnline =
      _customControllers[CustomControllerKey.online]!;
  late TextEditingController customWeekParity =
      _customControllers[CustomControllerKey.weekParity]!;
  late TextEditingController startTime =
      _customControllers[CustomControllerKey.startTime]!;
  late TextEditingController endTime =
      _customControllers[CustomControllerKey.endTime]!;

  ListTime? _selectedTime = ListTime.first;
  bool _isSpecificDate = false;
  bool _isOnlineLesson = false;

  void _toggleSpecificDate(bool value) {
    setState(() {
      _isSpecificDate = value;
    });
  }

  void _saveToDatabase() async {
    if (widget.formKey.currentState?.validate() ?? false) {
      final lesson = LessonModel(
        name: name.text,
        classRoom: _isOnlineLesson ? 'online' : classRoom.text,
        lessonType: customLessonType.text.isNotEmpty
            ? customLessonType.text
            : lessonType.text,
        time: time.text,
        weekParity: _isSpecificDate
            ? null
            : customWeekParity.text.isNotEmpty
                ? customWeekParity.text
                : weekParity.text,
        lessonDate: _isSpecificDate
            ? lessonDate.text
            : DateFormat('EEEE').format(widget.selectedDay),
        teacher: teacher.text,
        notes: notes.text.isNotEmpty ? notes.text : null,
      );

      SnackbarHandler.handleAction(
        context,
        () async {
          await DatabaseService().insertLesson(lesson);

          if (mounted && context.canPop()) {
            context.pop();
          }
        },
        'Занятие успешно добавлено!',
        'Ошибка при добавлении занятия.',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Пожалуйста, проверьте поля.',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _customControllers[CustomControllerKey.startTime]!.text =
        _selectedTime?.start ?? '';
    _customControllers[CustomControllerKey.endTime]!.text =
        _selectedTime?.end ?? '';
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
                controller: name,
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
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<String>(
                            showSelectedIcon: false,
                            emptySelectionAllowed: true,
                            style: SegmentedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                            segments: [
                              LessonSegment(value: 'Лекция', text: 'Лекция'),
                              LessonSegment(
                                  value: 'Практика', text: 'Практика'),
                              LessonSegment(
                                  value: 'Лаб. работа', text: 'Лаб. работа'),
                            ],
                            selected: {lessonType.text},
                            onSelectionChanged: (Set<String> value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  final selectedValue = value.first;
                                  lessonType.text = selectedValue;

                                  customLessonType.clear();
                                }
                              });
                            },
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          textAlign: TextAlign.center,
                          controller: customLessonType,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Свой вариант',
                            hintStyle: Theme.of(context).textTheme.labelLarge,
                            errorMaxLines: 2,
                          ),
                          onChanged: (value) {
                            setState(() {
                              lessonType.clear();
                              customLessonType.text = value;
                            });
                          },
                          validator: (value) {
                            if ((lessonType.text.isEmpty &&
                                    (value == null || value.isEmpty)) ||
                                (lessonType.text.isNotEmpty &&
                                    value!.isNotEmpty)) {
                              return 'Введите тип занятия или выберите из списка';
                            }
                            return null;
                          },
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
                  children: [
                    TextFormField(
                      controller: classRoom,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Аудитория или адрес',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor:
                            Theme.of(context).colorScheme.surfaceContainer,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (_isOnlineLesson) {
                          return null;
                        }

                        if (value == null || value.isEmpty) {
                          return 'Поле не может быть пустым';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            _isOnlineLesson = false;
                          }
                        });
                      },
                    ),
                    const Gap(8),
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
                    const Gap(8),
                    Row(
                      children: [
                        Checkbox(
                          value: _isOnlineLesson,
                          onChanged: (value) {
                            setState(() {
                              _isOnlineLesson = value ?? false;
                              if (_isOnlineLesson) {
                                classRoom.clear();
                              }
                            });
                          },
                        ),
                        const Gap(8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isOnlineLesson = !_isOnlineLesson;
                              if (_isOnlineLesson) {
                                classRoom.clear();
                              }
                            });
                          },
                          child: Text('Онлайн занятие'),
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
                      controller: time,
                      requestFocusOnTap: false,
                      onSelected: (ListTime? timeItem) {
                        setState(() {
                          if (timeItem != null) {
                            _selectedTime = timeItem;
                            startTime.text = timeItem.start;
                            endTime.text = timeItem.end;
                            time.text = timeItem.label;
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
                                controller: startTime,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '8:00',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = null;
                                    time.text =
                                        '${startTime.text}-${endTime.text}';
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
                                controller: endTime,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '9:35',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = null;
                                    time.text =
                                        '${startTime.text}-${endTime.text}';
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
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<String>(
                            showSelectedIcon: false,
                            emptySelectionAllowed: true,
                            multiSelectionEnabled: true,
                            style: SegmentedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                            ),
                            segments: [
                              LessonSegment(value: '1', text: '1'),
                              LessonSegment(value: '2', text: '2'),
                            ],
                            selected: widget
                                    .controllers[ControllerKey.weekParity]!
                                    .text
                                    .isEmpty
                                ? <String>{}
                                : widget
                                    .controllers[ControllerKey.weekParity]!.text
                                    .split(',')
                                    .toSet(),
                            onSelectionChanged: (Set<String> value) {
                              setState(() {
                                final sortedValues = value.toList()
                                  ..sort((a, b) => a.compareTo(b));
                                weekParity.text = sortedValues.join(',');

                                customWeekParity.clear();

                                _toggleSpecificDate(false);
                                lessonDate.clear();
                              });
                            },
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: customWeekParity,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Свой вариант',
                            hintStyle: Theme.of(context).textTheme.labelLarge,
                            errorMaxLines: 2,
                            helper: Text(
                                'Например, введите "123", чтобы задать первую, вторую и третью честность недели.'),
                          ),
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                final sortedValues = value
                                    .split('')
                                    .where((element) =>
                                        element.trim().isNotEmpty &&
                                        element != ',')
                                    .toSet()
                                    .toList()
                                  ..sort((a, b) => a.compareTo(b));

                                final joinedValues = sortedValues.join(',');
                                if (customWeekParity.text != joinedValues) {
                                  customWeekParity.text = joinedValues;
                                }
                              } else {
                                customWeekParity.clear();
                              }

                              weekParity.clear();
                              _toggleSpecificDate(false);
                              lessonDate.clear();
                            });
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                weekParity.text.isEmpty &&
                                lessonDate.text.isEmpty) {
                              return 'Выберите четность недели или дату проведения занятия';
                            }

                            if (value != null &&
                                value.isNotEmpty &&
                                value.split(',').any(
                                    (v) => int.tryParse(v.trim()) == null)) {
                              return 'Четность недели должна содержать только числа, разделенные запятыми.';
                            }

                            return null;
                          },
                        ),
                      ],
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
                      controller: lessonDate,
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
                            _toggleSpecificDate(true);
                            weekParity.clear();
                            customWeekParity.clear();
                            lessonDate.text =
                                DateFormat('dd/MM/yyyy').format(selectedDate);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              LessonField(
                labelText: 'Преподаватель',
                controller: teacher,
              ),
              TextFormField(
                controller: notes,
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
    for (var customController in _customControllers.values) {
      customController.dispose();
    }

    super.dispose();
  }
}
