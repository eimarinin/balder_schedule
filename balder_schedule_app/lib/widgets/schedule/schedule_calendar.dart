import 'package:balder_schedule_app/state/schedule_state.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

Map<String, Map<String, String>> getWeekDates(DateTime currentWeek) {
  final weekStart =
      currentWeek.subtract(Duration(days: currentWeek.weekday - 1));
  final Map<String, Map<String, String>> weekDates = {};

  for (int i = 0; i < 7; i++) {
    final date = weekStart.add(Duration(days: i));
    final weekday = _weekdayFromNumber(i + 1);
    weekDates[weekday] = {
      'formatted':
          '$weekday - ${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}',
      'date': DateFormat('dd/MM/yyyy').format(date),
    };
  }

  return weekDates;
}

String _weekdayFromNumber(int weekday) {
  const weekdays = {
    1: 'Понедельник',
    2: 'Вторник',
    3: 'Среда',
    4: 'Четверг',
    5: 'Пятница',
    6: 'Суббота',
    7: 'Воскресенье',
  };
  return weekdays[weekday] ?? '';
}

class ScheduleCalendar extends StatelessWidget {
  final ScheduleState scheduleState;

  const ScheduleCalendar({
    super.key,
    required this.scheduleState,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: scheduleState.previousWeek,
        ),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 24),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: scheduleState.currentWeek,
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null && pickedDate != scheduleState.currentWeek) {
              final weeksDifference =
                  scheduleState.calculateWeekDifference(pickedDate);
              scheduleState.setCurrentWeek(pickedDate,
                  parity: scheduleState.calculateNewParity(weeksDifference));
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                size: 18.0,
                Icons.today_outlined,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
              const Gap(8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    scheduleState.getWeekParityText(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    scheduleState.getFormattedWeek(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              )
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_outlined),
          onPressed: scheduleState.nextWeek,
        ),
      ],
    );
  }
}
