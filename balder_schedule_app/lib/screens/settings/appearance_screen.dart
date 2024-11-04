// lib/screens/notifications_screen.dart

import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appearanceTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0), // Отступ сверху
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(
                  24.0), // Увеличенный отступ внутри контейнера
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainer, // Фон карточки
                borderRadius: BorderRadius.circular(6.0), // Закругленные углы
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Опция выбора темы
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      S.of(context).lightthemeTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),
                    trailing: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Прозрачный фиолетовый цвет
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Icon(
                        Icons.wb_sunny, // Иконка солнца
                        color: Colors.white, // Цвет иконки белый
                        size: 24, // Увеличенный размер иконки
                      ),
                    ),
                    onTap: () {
                      // Логика для переключения темы
                    },
                  ),
                  const SizedBox(
                      height: 55.0), // Увеличенный отступ между элементами
                  // Опция выбора языка
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      S.of(context).applanguageTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.2,
                      ),
                    ),
                    trailing: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Прозрачный фиолетовый цвет
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      alignment:
                          Alignment.center, // Выравнивание текста по центру
                      child: Text(
                        S.of(context).ru_enTitle, // Текст вместо иконки
                        style: const TextStyle(
                          color: Colors.white, // Цвет текста белый
                          fontSize: 20, // Размер текста
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () {
                      // Логика для выбора языка
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
