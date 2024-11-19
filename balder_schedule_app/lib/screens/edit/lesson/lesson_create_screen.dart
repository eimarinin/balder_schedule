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
  const LessonCreateScreen({super.key});

  @override
  State<LessonCreateScreen> createState() => _LessonCreateScreenState();
}

class _LessonCreateScreenState extends State<LessonCreateScreen> {
  final Map<ControllerKey, TextEditingController> _controllers = {
    for (var key in ControllerKey.values) key: TextEditingController(),
  };

  bool _isSpecificDate = false;

  void _toggleSpecificDate(bool value) {
    setState(() {
      _isSpecificDate = value;
    });
  }

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
            isSpecificDate: _isSpecificDate,
            onSpecificDateChanged: _toggleSpecificDate,
            formKey: _formKey,
          ),
        ),
      ),
    );
  }
}

class LessonCreateContent extends StatefulWidget {
  final Map<ControllerKey, TextEditingController> controllers;
  final bool isSpecificDate;
  final ValueChanged<bool> onSpecificDateChanged;
  final GlobalKey<FormState> formKey;

  const LessonCreateContent({
    super.key,
    required this.controllers,
    required this.isSpecificDate,
    required this.onSpecificDateChanged,
    required this.formKey,
  });

  @override
  State<LessonCreateContent> createState() => _LessonCreateContentState();
}

class _LessonCreateContentState extends State<LessonCreateContent> {
  final Map<CustomControllerKey, TextEditingController> _customControllers = {
    for (var key in CustomControllerKey.values) key: TextEditingController(),
  };

  ListTime? _selectedTime = ListTime.first;

  void _saveToDatabase() async {
    if (widget.formKey.currentState?.validate() ?? false) {
      final lesson = LessonModel(
        name: widget.controllers[ControllerKey.name]!.text,
        classRoom: widget.controllers[ControllerKey.classRoom]!.text,
        lessonType:
            _customControllers[CustomControllerKey.lessonType]!.text.isNotEmpty
                ? _customControllers[CustomControllerKey.lessonType]!.text
                : widget.controllers[ControllerKey.lessonType]!.text,
        time: widget.controllers[ControllerKey.time]!.text,
        weekParity: widget.isSpecificDate
            ? null
            : _customControllers[CustomControllerKey.weekParity]!
                    .text
                    .isNotEmpty
                ? _customControllers[CustomControllerKey.weekParity]!.text
                : widget.controllers[ControllerKey.weekParity]!.text,
        lessonDate: widget.isSpecificDate
            ? widget.controllers[ControllerKey.date]!.text
            : null,
        teacher: widget.controllers[ControllerKey.teacher]!.text,
        notes: widget.controllers[ControllerKey.notes]!.text.isNotEmpty
            ? widget.controllers[ControllerKey.notes]!.text
            : null,
      );

      SnackbarHandler.handleSaveAction(
        context,
        () async {
          await DatabaseService().insertLesson(lesson);
        },
        'Занятие успешно сохранено!',
        'Ошибка при сохранении занятия',
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
                controller: widget.controllers[ControllerKey.name]!,
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
                            selected: {
                              widget.controllers[ControllerKey.lessonType]!.text
                            },
                            onSelectionChanged: (Set<String> value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  final selectedValue = value.first;
                                  widget.controllers[ControllerKey.lessonType]!
                                      .text = selectedValue;

                                  _customControllers[
                                          CustomControllerKey.lessonType]!
                                      .clear();
                                }
                              });
                            },
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                            textAlign: TextAlign.center,
                            controller: _customControllers[
                                CustomControllerKey.lessonType]!,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Свой вариант',
                              hintStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            onChanged: (value) {
                              setState(() {
                                widget.controllers[ControllerKey.lessonType]!
                                    .clear();
                                _customControllers[
                                        CustomControllerKey.lessonType]!
                                    .text = value;
                              });
                            },
                            validator: (value) {
                              if ((widget.controllers[ControllerKey.lessonType]!
                                          .text.isEmpty &&
                                      (value == null || value.isEmpty)) ||
                                  (widget.controllers[ControllerKey.lessonType]!
                                          .text.isNotEmpty &&
                                      value!.isNotEmpty)) {
                                return 'Введите тип занятия или выберите из списка';
                              }
                              return null;
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              LessonField(
                labelText: 'Аудитория',
                controller: widget.controllers[ControllerKey.classRoom]!,
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
                      controller: widget.controllers[ControllerKey.time]!,
                      requestFocusOnTap: false,
                      onSelected: (ListTime? time) {
                        setState(() {
                          if (time != null) {
                            _selectedTime = time;
                            _customControllers[CustomControllerKey.startTime]!
                                .text = time.start;
                            _customControllers[CustomControllerKey.endTime]!
                                .text = time.end;
                            widget.controllers[ControllerKey.time]!.text =
                                time.label;
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
                                controller: _customControllers[
                                    CustomControllerKey.startTime]!,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '8:00',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = null;
                                    widget.controllers[ControllerKey.time]!
                                            .text =
                                        '${_customControllers[CustomControllerKey.startTime]!.text}-${_customControllers[CustomControllerKey.endTime]!.text}';
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
                                controller: _customControllers[
                                    CustomControllerKey.endTime]!,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '9:35',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = null;
                                    widget.controllers[ControllerKey.time]!
                                            .text =
                                        '${_customControllers[CustomControllerKey.startTime]!.text}-${_customControllers[CustomControllerKey.endTime]!.text}';
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
                                widget.controllers[ControllerKey.weekParity]!
                                    .text = sortedValues.join(',');

                                _customControllers[
                                        CustomControllerKey.weekParity]!
                                    .clear();

                                widget.onSpecificDateChanged(false);
                                widget.controllers[ControllerKey.date]!.clear();
                              });
                            },
                          ),
                        ),
                        const Gap(8),
                        TextFormField(
                          textAlign: TextAlign.center,
                          controller: _customControllers[
                              CustomControllerKey.weekParity]!,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Свой вариант',
                            hintStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          onChanged: (value) {
                            setState(() {
                              widget.controllers[ControllerKey.weekParity]!
                                  .clear();
                              _customControllers[
                                      CustomControllerKey.weekParity]!
                                  .text = value;

                              widget.onSpecificDateChanged(false);
                              widget.controllers[ControllerKey.date]!.clear();
                            });
                          },
                          validator: (value) {
                            if ((value == null || value.isEmpty) &&
                                widget.controllers[ControllerKey.weekParity]!
                                    .text.isEmpty &&
                                widget.controllers[ControllerKey.date]!.text
                                    .isEmpty) {
                              return 'Выберите четность недели или дату проведения занятия';
                            }

                            if (value != null &&
                                value.isNotEmpty &&
                                int.tryParse(value) == null) {
                              return 'Четность недели должна быть числом';
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
                      controller: widget.controllers[ControllerKey.date]!,
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
                            widget.controllers[ControllerKey.weekParity]!
                                .clear();
                            _customControllers[CustomControllerKey.weekParity]!
                                .clear();
                            widget.controllers[ControllerKey.date]!.text =
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
                controller: widget.controllers[ControllerKey.teacher]!,
              ),
              TextFormField(
                controller: widget.controllers[ControllerKey.notes]!,
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
