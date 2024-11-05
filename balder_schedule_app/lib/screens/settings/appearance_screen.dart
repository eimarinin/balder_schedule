// lib/screens/notifications_screen.dart

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../generated/l10n.dart';
import '../../utils/padded_screen.dart';
import '../../widgets/page_header_child.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).appearanceTitle),
      body: const PaddedScreen(child: AppearanceContent()),
    );
  }
}

class AppearanceContent extends StatelessWidget {
  const AppearanceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
                title: Text(
                  S.of(context).lightthemeTitle,
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
                    Icons.wb_sunny_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
                onTap: () {
                  // Логика для переключения темы
                },
              ),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
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
      ],
    );
  }
}
