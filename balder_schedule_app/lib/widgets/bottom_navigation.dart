// lib/widgets/bottom_navigation.dart

import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const BottomNavigation({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onItemTapped,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      destinations: [
        NavigationDestination(
            icon: Icon(Icons.schedule_outlined),
            label: S.of(context).scheduleTitle),
        NavigationDestination(
            icon: Icon(Icons.edit_outlined), label: S.of(context).editTitle),
        NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: S.of(context).settingsTitle),
      ],
    );
  }
}
