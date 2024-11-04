import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/padded_screen.dart';
import '../../widgets/page_header.dart';
import '../../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: S.of(context).settingsTitle),
      body: const PaddedScreen(child: SettingsContent()),
    );
  }
}

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(12),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.auto_awesome_outlined,
                    size: 24,
                  ),
                  title: Text(
                    S.of(context).appearanceTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.2,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/appearance');
                  },
                ),
                Divider(thickness: 2),
                ListTile(
                  leading: Icon(
                    Icons.notifications_outlined,
                    size: 24,
                  ),
                  title: Text(S.of(context).notificationsTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.2,
                      )),
                  onTap: () {
                    Navigator.of(context).pushNamed('/notifications');
                  },
                ),
                Divider(thickness: 2),
                ListTile(
                  leading: Icon(
                    Icons.qr_code_outlined,
                    size: 24,
                  ),
                  title: Text(S.of(context).qrTitle,
                      style: const TextStyle(fontSize: 20, height: 1.2)),
                  onTap: () {
                    Navigator.of(context).pushNamed('/qr');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
