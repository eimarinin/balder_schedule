import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'edit_screen.dart';
import 'settings_screen.dart';

import '../state/schedule_state.dart';
import '../widgets/padded_screen.dart';

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

  final List<PageInfo> _pages = [
    PageInfo(
        title: 'Расписание',
        icon: Icons.schedule_outlined,
        page: Center(child: Text('Экран расписания'))),
    PageInfo(
        title: 'Редактирование', icon: Icons.edit_outlined, page: EditScreen()),
    PageInfo(
        title: 'Настройки',
        icon: Icons.settings_outlined,
        page: SettingsScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scheduleState = context.watch<ScheduleState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndex].title),
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
                      Text(scheduleState.getFormattedWeek()),
                      IconButton(
                        icon: Icon(Icons.arrow_forward_outlined),
                        onPressed: scheduleState.nextWeek,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(child: Text("Расписание на текущую неделю")),
                  ),
                ],
              )
            : _pages[_selectedIndex].page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 0,
        items: _pages
            .map((page) => BottomNavigationBarItem(
                  icon: Icon(page.icon),
                  label: page.title,
                ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
