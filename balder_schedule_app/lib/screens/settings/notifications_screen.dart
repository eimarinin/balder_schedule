// lib/screens/notifications_screen.dart

import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/padded_screen.dart';
import '../../widgets/page_header_child.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).notificationsTitle),
      body: const PaddedScreen(child: NotificationsContent()),
    );
  }
}

class NotificationsContent extends StatefulWidget {
  const NotificationsContent({super.key});

  @override
  _NotificationsContentState createState() => _NotificationsContentState();
}

class _NotificationsContentState extends State<NotificationsContent> {
  bool isChecked = false; // Изначально выключено

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(12),
        Padding(
          padding: const EdgeInsets.only(top: 0.0), // Отступ сверху
          child: Container(
            padding: const EdgeInsets.all(
                24.0), // Увеличенный отступ внутри контейнера
            margin: const EdgeInsets.symmetric(horizontal: 0.0),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainer, // Фон карточки
              borderRadius: BorderRadius.circular(6.0), // Закругленные углы
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    S.of(context).shedule_tomorrowTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      // Цвет текста
                    ),
                  ),
                ),
                Switch.adaptive(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value;
                    });
                  },
                  activeColor: Theme.of(context)
                      .colorScheme
                      .primary, // Цвет фона в включенном состоянии
                  activeTrackColor: Theme.of(context)
                      .colorScheme
                      .onPrimary, // Цвет дорожки в включенном состоянии
                  inactiveThumbColor: const Color.fromARGB(
                      255, 133, 133, 133), // Цвет фона в выключенном состоянии
                  inactiveTrackColor: Colors
                      .grey.shade300, // Цвет дорожки в выключенном состоянии
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
