import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_screen.dart';
import 'settings_screen.dart';

import '../state/schedule_state.dart';
import '../widgets/padded_screen.dart';
import '../generated/l10n.dart';

class PageInfo {
  final String title;
  final IconData icon;
  final Widget page;

  PageInfo({required this.title, required this.icon, required this.page});
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scheduleState = context.watch<ScheduleState>();

    final List<PageInfo> pages = [
      PageInfo(
          title: S.of(context).scheduleTitle,
          icon: Icons.schedule_outlined,
          page: Center(child: Text(S.of(context).scheduleScreen))),
      PageInfo(
          title: S.of(context).editTitle,
          icon: Icons.edit_outlined,
          page: EditScreen()),
      PageInfo(
          title: S.of(context).settingsTitle,
          icon: Icons.settings_outlined,
          page: SettingsScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 61,
        title: PaddedScreen(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pages[_selectedIndex].title),
              const SizedBox(height: 12),
              const Divider(
                height: 1,
              ),
            ],
          ),
        ),
      ),
      body: PaddedScreen(
        child: _selectedIndex == 0
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_outlined),
                        onPressed: scheduleState.previousWeek,
                      ),
                      FilledButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.secondaryContainer,
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: scheduleState.currentWeek,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2101),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light(),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null &&
                              pickedDate != scheduleState.currentWeek) {
                            scheduleState.setCurrentWeek(pickedDate);
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              size: 18.0,
                              Icons.today_outlined,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                            SizedBox(width: 8.0),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Центрируем по горизонтали
                              children: [
                                Text(
                                  '${scheduleState.getWeekNumber()} неделя',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Text(
                                  scheduleState.getFormattedWeek(),
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_outlined),
                        onPressed: scheduleState.nextWeek,
                      ),
                    ],
                  ),
                  Expanded(
                    child:
                        Center(child: Text(S.of(context).currentWeekSchedule)),
                  ),
                ],
              )
            : pages[_selectedIndex].page,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: pages.map((page) {
          return NavigationDestination(
            icon: Icon(page.icon),
            label: page.title,
          );
        }).toList(),
      ),
    );
  }
}
