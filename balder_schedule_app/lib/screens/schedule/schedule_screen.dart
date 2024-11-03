import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/schedule_state.dart';
import '../../utils/padded_screen.dart';
import '../../generated/l10n.dart';
import '../../widgets/page_header.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScheduleState(),
      child: Scaffold(
        appBar: PageHeader(title: S.of(context).scheduleTitle),
        body: const PaddedScreen(child: ScheduleContent()),
      ),
    );
  }
}

class ScheduleContent extends StatelessWidget {
  const ScheduleContent({super.key});

  @override
  Widget build(BuildContext context) {
    var scheduleState = context.watch<ScheduleState>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_outlined),
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

                if (pickedDate != null &&
                    pickedDate != scheduleState.currentWeek) {
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
                  SizedBox(width: 8.0),
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
              icon: Icon(Icons.arrow_forward_outlined),
              onPressed: scheduleState.nextWeek,
            ),
          ],
        ),
        Expanded(
          child: Center(child: Text('Экран расписания')),
        ),
      ],
    );
  }
}
