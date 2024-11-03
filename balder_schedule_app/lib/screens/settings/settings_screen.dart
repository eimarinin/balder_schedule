import 'package:flutter/material.dart';

import '../../widgets/page_header.dart';
import '../../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: S.of(context).settingsTitle),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 40.0),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.auto_awesome_outlined,
                      color: Colors.black,
                      size: 36,
                    ),
                    title: Text(S.of(context).appearanceTitle),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          '/notifications'); // Переход на экран AppearanceScreen
                    },
                  ),
                  Divider(color: Colors.grey, thickness: 1.5),
                  ListTile(
                    leading: Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                      size: 36,
                    ),
                    title: Text(S.of(context).notificationsTitle),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          '/notifications'); // Переход на экран AppearanceScreen
                    },
                  ),
                  Divider(color: Colors.grey, thickness: 1.5),
                  ListTile(
                    leading: Icon(
                      Icons.qr_code_outlined,
                      color: Colors.black,
                      size: 36,
                    ),
                    title: Text(
                      'QR',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    onTap: () {
                      // Переход на экран QRScreen
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
