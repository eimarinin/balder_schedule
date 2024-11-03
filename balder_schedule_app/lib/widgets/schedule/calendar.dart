import 'package:flutter/material.dart';

import '../../state/schedule_state.dart';

class Calendar extends StatelessWidget {
  final ScheduleState scheduleState;

  const Calendar({
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
        FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.secondaryContainer,
            ),
            foregroundColor: WidgetStateProperty.all(
              Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          onPressed: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: scheduleState.currentWeek,
              firstDate: DateTime(2020),
              lastDate: DateTime(2101),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: Theme.of(context),
                  child: child!,
                );
              },
            );

            if (pickedDate != null && pickedDate != scheduleState.currentWeek) {
              scheduleState.setCurrentWeek(pickedDate);
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
              const SizedBox(width: 8.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${scheduleState.getWeekNumber()} неделя',
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
