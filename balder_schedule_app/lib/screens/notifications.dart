import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isChecked = false; // Состояние переключателя

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
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
            padding: const EdgeInsets.only(top: 23.0), // Отступ сверху
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24.0), // Увеличенный отступ внутри контейнера
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50, // Фон карточки
                    borderRadius: BorderRadius.circular(10.0), // Закругленные углы
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: const Text(
                          'Расписание на завтра',
                          style: TextStyle(fontSize: 22, color: Colors.black), // Увеличенный размер текста
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked; // Переключаем состояние переключателя
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 60, // Увеличенная ширина контейнера
                          height: 35, // Увеличенная высота контейнера
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15), // Закругленные края
                            color: isChecked ? const Color.fromARGB(216, 105, 71, 184) : Colors.grey, // Цвет фона
                          ),
                          alignment: isChecked ? Alignment.centerRight : Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 30, // Увеличенная ширина внутреннего кружка
                            height: 30, // Увеличенная высота внутреннего кружка
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white, // Цвет кружка
                            ),
                            child: Center(
                              child: isChecked
                                  ? const Icon(
                                      Icons.check, // Иконка галочки
                                      color: Color.fromARGB(255, 58, 24, 102), // Цвет галочки
                                      size: 18, // Размер иконки
                                    )
                                  : const Icon(
                                      Icons.close, // Иконка крестика
                                      color: Color.fromARGB(255, 99, 99, 99), // Цвет крестика
                                      size: 18, // Размер иконки
                                    ),
                            ),
                          ),
                        ),
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
