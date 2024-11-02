import 'package:flutter/material.dart';

class ScheduleState extends ChangeNotifier {
  DateTime currentWeek = DateTime.now();

  void nextWeek() {
    currentWeek = currentWeek.add(Duration(days: 7));
    notifyListeners();
  }

  void previousWeek() {
    currentWeek = currentWeek.subtract(Duration(days: 7));
    notifyListeners();
  }

  String getFormattedWeek() {
    final startOfWeek =
        currentWeek.subtract(Duration(days: currentWeek.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    return "${startOfWeek.day}.${startOfWeek.month}-${endOfWeek.day}.${endOfWeek.month}";
  }
}
