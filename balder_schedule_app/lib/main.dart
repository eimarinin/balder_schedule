// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'screens/schedule_screen.dart';
import 'state/schedule_state.dart';
import 'state/settings_state.dart';

void main() {
  runApp(const MyApp());
}

/// Основное приложение с Material 3, локализацией и провайдерами состояния
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScheduleState()),
        ChangeNotifierProvider(create: (context) => SettingsState()),
      ],
      child: MaterialApp(
        title: 'Schedule App',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontSize: 20, // Задаем размер текста
              color: Colors.black, // Цвет текста
            ),
          ),
          buttonTheme: const ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: const Locale('ru'),
        home: ScheduleScreen(),
      ),
    );
  }
}
