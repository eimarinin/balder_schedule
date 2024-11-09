import 'package:balder_schedule_app/state/schedule_state.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
        FilledButton(
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
              const Gap(8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Четность: 2',
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
