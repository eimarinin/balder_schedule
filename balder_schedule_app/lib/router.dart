import 'package:balder_schedule_app/screens/edit/lesson/lesson_create_screen.dart';
import 'package:balder_schedule_app/screens/edit/lesson/lesson_edit_screen.dart';
import 'package:balder_schedule_app/widgets/navigation.dart';
import 'package:balder_schedule_app/screens/edit/edit_screen.dart';
import 'package:balder_schedule_app/screens/schedule/lesson/lesson_screen.dart';
import 'package:balder_schedule_app/screens/schedule/schedule_screen.dart';
import 'package:balder_schedule_app/screens/settings/appearance_screen.dart';
import 'package:balder_schedule_app/screens/settings/notifications_screen.dart';
import 'package:balder_schedule_app/screens/settings/qr_screen.dart';
import 'package:balder_schedule_app/screens/settings/settings_screen.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              builder: (context, state) => ScheduleScreen(),
            ),
            GoRoute(
              path: '/schedule',
              pageBuilder: (context, state) => NoTransitionPage(
                child: ScheduleScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'lesson',
                  builder: (context, state) => LessonScreen(),
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
              pageBuilder: (context, state) => NoTransitionPage(
                child: EditScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'lesson_create',
                  builder: (context, state) => LessonCreateScreen(
                    selectedDay: state.extra as DateTime,
                  ),
                ),
                GoRoute(
                  path: 'lesson_edit',
                  builder: (context, state) => LessonEditScreen(
                    params: state.extra as LessonEditParams,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorSettingsKey,
          routes: [
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => NoTransitionPage(
                child: SettingsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'appearance',
                  builder: (context, state) => AppearanceScreen(),
                ),
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => NotificationsScreen(),
                ),
                GoRoute(
                  path: 'qr',
                  builder: (context, state) => QrScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
