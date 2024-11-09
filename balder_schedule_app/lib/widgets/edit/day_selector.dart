import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaySelector extends StatefulWidget {
  const DaySelector({super.key});

  @override
  State<DaySelector> createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  DateTime _selectedDate = DateTime.now();

  void _changeDay(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
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
          toBeginningOfSentenceCase(DateFormat('EEEE').format(_selectedDate)) ??
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
