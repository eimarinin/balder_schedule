import 'package:flutter/material.dart';

import '../../widgets/page_header.dart';
import '../../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeader(title: S.of(context).settingsTitle),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/notifications');
          },
          child: const Text('Уведомления'),
        ),
      ),
    );
  }
}
