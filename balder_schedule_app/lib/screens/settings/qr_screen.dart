// lib/screens/notifications_screen.dart

import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../utils/padded_screen.dart';
import '../../widgets/page_header_child.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).qrTitle),
      body: const PaddedScreen(child: QrContent()),
    );
  }
}

class QrContent extends StatelessWidget {
  const QrContent({super.key});

  @override
  Widget build(BuildContext context) {
    const double uniformSpacing = 24.0; // Установим единое значение отступа

    return Column(
      children: [
        const Gap(12),
        Padding(
          padding: const EdgeInsets.only(top: 0.0), // Отступ сверху
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .start, // Выровнять содержимое в верхней части
              children: [
                Container(
                  padding:
                      const EdgeInsets.all(12.0), // Отступ внутри контейнера
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0.0), // Боковые отступы для всего контейнера
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainer, // Цвет фона карточки
                    borderRadius:
                        BorderRadius.circular(6.0), // Закругленные углы
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Кнопка "Сканировать новое расписание"
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Логика для сканирования QR-кода
                          },
                          icon: const Icon(Icons.camera_alt, size: 24),
                          label: Text(
                            S.of(context).scanNewScheduleTitle,
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            minimumSize: const Size.fromHeight(
                                50), // Минимальная высота кнопки
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: uniformSpacing), // Единый отступ после кнопки
                      // Большой серый квадрат вместо QR-кода
                      Container(
                        width: 370, // Увеличенная ширина серого квадрата
                        height: 370, // Увеличенная высота серого квадрата
                        color: Colors.grey, // Цвет серого квадрата
                      ),
                      const SizedBox(
                          height:
                              uniformSpacing), // Единый отступ после квадрата
                      // Надпись "Поделиться расписанием" с иконкой
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.share,
                            size: 24,
                          ),
                          const SizedBox(
                              width: 8.0), // Отступ между иконкой и текстом
                          Text(
                            S.of(context).shareScheduleTitle,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ), // Единый отступ до нижней границы
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
