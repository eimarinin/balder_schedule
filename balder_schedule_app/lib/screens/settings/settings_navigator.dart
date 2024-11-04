import 'package:balder_schedule_app/screens/settings/appearance_screen.dart';
import 'package:balder_schedule_app/screens/settings/qr_screen.dart';
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
          case '/appearance':
            return UnanimatedPageRoute(
              builder: (context) => const AppearanceScreen(),
            );
          case '/qr':
            return UnanimatedPageRoute(
              builder: (context) => const QrScreen(),
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
