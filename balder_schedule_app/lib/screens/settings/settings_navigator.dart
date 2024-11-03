import 'package:flutter/material.dart';

import '../../utils/unanimated_page_route.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class SettingsNavigator extends StatelessWidget {
  const SettingsNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/notifications':
            return UnanimatedPageRoute(
              builder: (context) => const NotificationsScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const SettingsScreen(),
            );
        }
      },
    );
  }
}
