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
      body: Padding(
        padding: const EdgeInsets.only(top: 23.0), // Отступ сверху
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24.0), // Увеличенный отступ внутри контейнера
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color:Theme.of(context).colorScheme.onInverseSurface, // Фон карточки
                borderRadius: BorderRadius.circular(10.0), // Закругленные углы
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Расписание на завтра',
                      style: TextStyle(fontSize: 22, color: Colors.black), // Увеличенный размер текста
                    ),
                  ),
                  Switch.adaptive(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                    activeColor:const Color.fromARGB(255, 255, 255, 255), // Цвет фона в включенном состоянии
                    activeTrackColor:Theme.of(context).colorScheme.primary, // Цвет дорожки в включенном состоянии
                    inactiveThumbColor:const Color.fromARGB(255, 133, 133, 133), // Цвет фона в выключенном состоянии
                    inactiveTrackColor: Colors.grey.shade300, // Цвет дорожки в выключенном состоянии
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
