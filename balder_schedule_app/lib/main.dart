// lib/main.dart
import 'package:flutter/material.dart';

import 'app_config.dart';
import 'screens/edit/edit_navigator.dart';
import 'screens/schedule/schedule_navigator.dart';
import 'screens/settings/settings_navigator.dart';
import 'widgets/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

/// Основное приложение с Material 3, локализацией и провайдерами состояния
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule App',
      theme: AppConfig.themeData(),
      localizationsDelegates: AppConfig.localizationsDelegates,
      supportedLocales: AppConfig.supportedLocales,
      locale: const Locale('ru'),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Список страниц с вложенными навигаторами
  final List<Widget> _pages = [
    const ScheduleNavigator(),
    const EditNavigator(),
    const SettingsNavigator(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
