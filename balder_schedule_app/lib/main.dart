// lib/main.dart
import 'package:balder_schedule_app/app_config.dart';
import 'package:balder_schedule_app/router.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

void main() {
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppConfig(),
      child: Consumer<AppConfig>(
        builder: (context, appConfig, child) {
          return MaterialApp.router(
            title: 'Schedule App',
            routerConfig: goRouter,
            debugShowCheckedModeBanner: false,
            theme: appConfig.currentTheme,
            localizationsDelegates: AppConfig.localizationsDelegates,
            supportedLocales: AppConfig.getSupportedLocales(),
            locale: AppConfig.getDefaultLocale(),
          );
        },
      ),
    );
  }
}
