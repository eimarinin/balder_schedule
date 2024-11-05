import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      leading: Icon(
        icon,
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          height: 1.2,
        ),
      ),
      onTap: onTap,
    );
  }
}
