import 'package:flutter/material.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Код'),
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
            child: Center( // Центрируем контент
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Выровнять содержимое в верхней части
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0), // Увеличенный отступ внутри контейнера
                    margin: const EdgeInsets.symmetric(horizontal: 8.0), // Уменьшенные боковые отступы
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(164, 225, 190, 231), // Цвет фона карточки
                      borderRadius: BorderRadius.circular(10.0), // Закругленные углы
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Кнопка "Сканировать QR код"
                        ElevatedButton.icon(
                          onPressed: () {
                            // Логика для сканирования QR-кода
                          },
                          icon: const Icon(Icons.camera_alt, size: 24),
                          label: const Text('Сканировать QR код', style: TextStyle(fontSize: 20)), // Увеличенный размер текста
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Цвет кнопки
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0), // Увеличенные отступы
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0), // Отступ между кнопкой и квадратом
                        // Большой серый квадрат вместо QR-кода
                        Container(
                          width: 300, // Увеличенная ширина серого квадрата
                          height: 300, // Увеличенная высота серого квадрата
                          color: Colors.grey, // Цвет серого квадрата
                        ),
                        const SizedBox(height: 24.0), // Отступ между квадратом и кнопкой "Поделиться"
                        // Кнопка "Поделиться"
                        ElevatedButton.icon(
                          onPressed: () {
                            // Логика для поделиться QR-кодом
                          },
                          icon: const Icon(Icons.share, size: 24),
                          label: const Text('Поделиться QR кодом', style: TextStyle(fontSize: 20)), // Увеличенный размер текста
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 252, 252, 255), // Цвет кнопки
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0), // Увеличенные отступы
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
