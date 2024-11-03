import 'package:flutter/material.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Код'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0), // Отступ сверху
        child: Center( // Центрируем контент
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Выровнять содержимое в верхней части
            children: [
              Container(
                padding: const EdgeInsets.all(24.0), // Отступ внутри контейнера
                margin: const EdgeInsets.symmetric(horizontal: 8.0), // Боковые отступы для всего контейнера
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onInverseSurface, // Цвет фона карточки
                  borderRadius: BorderRadius.circular(10.0), // Закругленные углы
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
                        label: const Text('Сканировать новое расписание', style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          minimumSize: const Size.fromHeight(50), // Минимальная высота кнопки
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0), // Отступ между кнопкой и квадратом
                    // Большой серый квадрат вместо QR-кода
                    Container(
                      width: 350, // Увеличенная ширина серого квадрата
                      height: 350, // Увеличенная высота серого квадрата
                      color: Colors.grey, // Цвет серого квадрата
                    ),
                    const SizedBox(height: 24.0), // Отступ между квадратом и текстом
                    // Надпись "Поделиться расписанием" с иконкой
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.share, size: 24, color: Colors.black),
                        SizedBox(width: 8.0), // Отступ между иконкой и текстом
                        Text(
                          'Поделиться расписанием',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
