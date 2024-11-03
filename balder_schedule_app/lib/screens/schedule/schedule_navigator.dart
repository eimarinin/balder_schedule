import 'package:flutter/material.dart';

import '../../utils/unanimated_page_route.dart';
import 'schedule_screen.dart';

class ScheduleNavigator extends StatelessWidget {
  const ScheduleNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return UnanimatedPageRoute(
          builder: (context) => const ScheduleScreen(),
        );
      },
    );
  }
}
