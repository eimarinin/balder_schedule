import 'package:flutter/material.dart';

class SettingsState extends ChangeNotifier {
  bool notificationsEnabled = true;

  void toggleNotifications() {
    notificationsEnabled = !notificationsEnabled;
    notifyListeners();
  }
}
