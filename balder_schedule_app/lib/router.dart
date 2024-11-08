import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:balder_schedule_app/screens/edit/edit_screen.dart';
import 'package:balder_schedule_app/screens/schedule/lesson_screen.dart';
import 'package:balder_schedule_app/screens/schedule/schedule_screen.dart';
import 'package:balder_schedule_app/screens/settings/appearance_screen.dart';
import 'package:balder_schedule_app/screens/settings/notifications_screen.dart';
import 'package:balder_schedule_app/screens/settings/qr_screen.dart';
import 'package:balder_schedule_app/screens/settings/settings_screen.dart';

import 'widgets/navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorScheduleKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSchedule');
final _shellNavigatorEditKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellEdit');
final _shellNavigatorSettingsKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellSettings');

final goRouter = GoRouter(
  initialLocation: '/schedule',
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorScheduleKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const ScheduleScreen(),
            ),
            GoRoute(
              path: '/schedule',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ScheduleScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'lesson',
                  builder: (context, state) => const LessonScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorEditKey,
          routes: [
            GoRoute(
              path: '/edit',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: EditScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SettingsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'appearance',
                  builder: (context, state) => const AppearanceScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => const NotificationsScreen(),
                ),
                GoRoute(
                  path: 'qr',
                  builder: (context, state) => const QrScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
