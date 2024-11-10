// lib/screens/qr_screen.dart

import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/utils/padded_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';
import 'package:balder_schedule_app/utils/logger.dart'; // Импорт логгера

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).qrTitle),
      body: PaddedScreen(child: QrContent()),
    );
  }
}

class QrContent extends StatelessWidget {
  const QrContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Логирование события нажатия кнопки "Сканировать новый график"
                      info('Scan new schedule button clicked');
                      // Действие при нажатии кнопки
                    },
                    icon: Icon(Icons.video_camera_front_outlined, size: 18),
                    label: Text(S.of(context).scanNewScheduleTitle),
                  ),
                ),
                const Gap(12),
                Container(
                  width: 364,
                  height: 364,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/qr.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      // Логирование события нажатия кнопки "Поделиться графиком"
                      info('Share schedule button clicked');
                      // Действие при нажатии кнопки
                    },
                    icon: Icon(Icons.share_outlined, size: 18),
                    label: Text(S.of(context).shareScheduleTitle),
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
