import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySelector extends StatefulWidget {
  final Function(DateTime) onDayChanged;

  const DaySelector({super.key, required this.onDayChanged});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  DateTime _selectedDay = DateTime.now();

  void _changeDay(int days) {
    setState(() {
      _selectedDay = _selectedDay.add(Duration(days: days));
      widget.onDayChanged(_selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () => _changeDay(-1),
          ),
        ),
        Text(
          toBeginningOfSentenceCase(DateFormat('EEEE').format(_selectedDay)) ??
              '',
          style: TextStyle(fontSize: 20, height: 1.2),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_forward),
            color: Theme.of(context).colorScheme.onPrimary,
            onPressed: () => _changeDay(1),
          ),
        ),
      ],
    );
  }
}
