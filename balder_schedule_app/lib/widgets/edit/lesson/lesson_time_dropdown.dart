import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LessonTimeDropdown extends StatefulWidget {
  const LessonTimeDropdown({super.key});

  @override
  State<LessonTimeDropdown> createState() => _LessonTimeDropdownState();
}

class _LessonTimeDropdownState extends State<LessonTimeDropdown> {
  String _selectedTime = '8:00-9:45';

  final List<String> _timeOptions = [
    '8:00-9:45',
    '9:45-11:20',
    '11:35-13:10',
    '13:40-15:15',
    '15:25-17:00',
    '17:10-18:45',
    '18:55-20:30',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Время занятия',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Gap(12),
        DropdownButtonFormField<String>(
          value: _selectedTime,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
          items: _timeOptions.map((String time) {
            return DropdownMenuItem<String>(
              value: time,
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const Gap(8),
                  Text(time),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedTime = newValue!;
            });
          },
          icon: const Icon(Icons.arrow_drop_down), // trailing icon
        ),
      ],
    );
  }
}
