import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../utils/padded_screen.dart';
import '../../widgets/page_header.dart';
import '../../generated/l10n.dart';
import '../../widgets/settings/settings_item.dart';

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
    return SingleChildScrollView(
      child: Column(
        children: [
          Gap(12),
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              children: [
                SettingsItem(
                  icon: Icons.palette_outlined,
                  title: S.of(context).appearanceTitle,
                  onTap: () => context.go('/settings/appearance'),
                ),
                Divider(thickness: 2, height: 0, indent: 12, endIndent: 12),
                SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: S.of(context).notificationsTitle,
                  onTap: () => context.go('/settings/notifications'),
                ),
                Divider(thickness: 2, height: 0, indent: 12, endIndent: 12),
                SettingsItem(
                  icon: Icons.qr_code_outlined,
                  title: S.of(context).qrTitle,
                  onTap: () => context.go('/settings/qr'),
                ),
              ],
            ),
          ),
          Gap(12),
        ],
      ),
    );
  }
}
