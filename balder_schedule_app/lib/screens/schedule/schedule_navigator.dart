import 'package:balder_schedule_app/screens/schedule/lesson_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/unanimated_page_route.dart';
import 'schedule_screen.dart';

class ScheduleNavigator extends StatelessWidget {
  const ScheduleNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/lesson':
            return UnanimatedPageRoute(
              builder: (context) => const LessonScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const ScheduleScreen(),
            );
        }
      },
    );
  }
}
