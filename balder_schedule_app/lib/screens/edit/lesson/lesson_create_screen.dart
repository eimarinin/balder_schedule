import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/services/storage/storage_service.dart';
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

  bool _isSpecificDate = false;

  void _toggleSpecificDate(bool value) {
    setState(() {
      _isSpecificDate = value;
    });
  }

  final _formKey = GlobalKey<FormState>();

  final StorageService _storageService = StorageService();

  void _saveToJson() async {
    final lessonData = {
      'name': _nameController.text,
      'class': _classController.text,
      'lessonType': _lessonTypeController.text,
      'time': _timeController.text,
      if (!_isSpecificDate) 'weekParity': _weekParityController.text,
      if (_isSpecificDate) 'lessonDate': _dateController.text,
    };

    try {
      await _storageService.saveLessonData(lessonData);

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _lessonTypeController.dispose();
    _timeController.dispose();
    _weekParityController.dispose();
    _dateController.dispose();

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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            _saveToJson();
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
  final TextEditingController weekParityController;
  final TextEditingController dateController;
  final bool isSpecificDate;
  final ValueChanged<bool> onSpecificDateChanged;

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
                            _startController.text = time.start;
                            _endController.text = time.end;
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
                                controller: _startController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '8:00',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = null;
                                    widget.timeController.text =
                                        '${_startController.text}-${_endController.text}';
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
                        const Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                textAlign: TextAlign.center,
                                controller: _endController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '9:35',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTime = null;
                                    widget.timeController.text =
                                        '${_startController.text}-${_endController.text}';
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
    _customWeekParityController.dispose();

    super.dispose();
  }
}
