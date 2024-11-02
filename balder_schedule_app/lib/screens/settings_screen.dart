import 'package:flutter/material.dart';
import 'appearance.dart'; // Импортируем экран внешнего вида
import 'notifications.dart'; // Импортируем экран уведомлений
import 'qr.dart'; // Импортируем экран QR кода

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top + 1.0,
              color: Colors.grey,
            ),
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 40.0),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.auto_awesome_outlined,
                          color: Colors.black,
                          size: 36,
                        ),
                        title: Text(
                          'Внешний вид',
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                        onTap: () {
                          // Переход на экран AppearanceScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AppearanceScreen()),
                          );
                        },
                      ),
                      Divider(color: Colors.grey, thickness: 1.5),
                      ListTile(
                        leading: Icon(
                          Icons.notifications_outlined,
                          color: Colors.black,
                          size: 36,
                        ),
                        title: Text(
                          'Уведомления',
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                        onTap: () {
                          // Переход на экран NotificationsScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                          );
                        },
                      ),
                      Divider(color: Colors.grey, thickness: 1.5),
                      ListTile(
                        leading: Icon(
                          Icons.qr_code_outlined,
                          color: Colors.black,
                          size: 36,
                        ),
                        title: Text(
                          'QR',
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                        onTap: () {
                          // Переход на экран QRScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const QRScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
