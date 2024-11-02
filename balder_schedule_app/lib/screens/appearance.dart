import 'package:flutter/material.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Внешний вид'),
      ),
      body: Stack(
        children: [
          // Серый верхний бар
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 1.0, // Высота для статуса
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0), // Отступ сверху
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24.0), // Увеличенный отступ внутри контейнера
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50, // Фон карточки
                    borderRadius: BorderRadius.circular(10.0), // Закругленные углы
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Опция выбора темы
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Светлая тема',
                          style: TextStyle(fontSize: 22, color: Colors.black), // Увеличенный размер текста
                        ),
                        trailing: Container(
                          width: 50, // Установите одинаковую ширину
                          height: 50, // Установите одинаковую высоту
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(218, 44, 25, 80).withOpacity(0.5), // Прозрачный фиолетовый цвет
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.wb_sunny, // Иконка солнца
                            color: Colors.white, // Цвет иконки белый
                            size: 30, // Увеличенный размер иконки
                          ),
                        ),
                        onTap: () {
                          // Логика для переключения темы
                        },
                      ),
                      const SizedBox(height: 16.0), // Увеличенный отступ между элементами
                      // Опция выбора языка
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Язык приложения',
                          style: TextStyle(fontSize: 22, color: Colors.black), // Увеличенный размер текста
                        ),
                        trailing: Container(
                          width: 50, // Установите одинаковую ширину
                          height: 50, // Установите одинаковую высоту
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(218, 44, 25, 80).withOpacity(0.5), // Прозрачный фиолетовый цвет
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.language, // Иконка языка
                            color: Colors.white, // Цвет иконки белый
                            size: 30, // Увеличенный размер иконки
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
        ],
      ),
    );
  }
}
