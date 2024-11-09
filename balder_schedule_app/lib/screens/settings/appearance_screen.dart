// lib/screens/notifications_screen.dart

import 'package:balder_schedule_app/app_config.dart';
import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).appearanceTitle),
      body: PaddedScreen(child: AppearanceContent()),
    );
  }
}

class AppearanceContent extends StatelessWidget {
  const AppearanceContent({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 20.0),
                  title: Text(
                    isLightTheme
                        ? S.of(context).appearanceScreenThemeLight
                        : S.of(context).appearanceScreenThemeDark,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.2,
                    ),
                  ),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Icon(
                      isLightTheme
                          ? Icons.wb_sunny_outlined
                          : Icons.nights_stay_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                  onTap: () {
                    context.read<AppConfig>().toggleTheme();
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 20.0),
                  title: Text(
                    S.of(context).applanguageTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.2,
                    ),
                  ),
                  trailing: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      S.of(context).ru_enTitle,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ),
                  onTap: () {
                    // Логика для выбора языка
                  },
                ),
              ],
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
