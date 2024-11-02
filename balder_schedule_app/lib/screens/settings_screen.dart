import 'package:flutter/material.dart';
import 'appearance.dart';
import 'notifications.dart';
import 'qr.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const NotificationsScreen()),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NotificationsScreen()),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRScreen()),
            );
          },
        ),
      ],
    );
  }
}
