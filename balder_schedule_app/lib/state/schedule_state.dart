import 'package:flutter/material.dart';

class ScheduleState extends ChangeNotifier {
  DateTime currentWeek = DateTime.now();

  void setCurrentWeek(DateTime newDate) {
    currentWeek = newDate;
    notifyListeners();
  }

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
    return "${startOfWeek.day}.${startOfWeek.month} - ${endOfWeek.day}.${endOfWeek.month}";
  }

  int getWeekNumber() {
    final startOfYear = DateTime(currentWeek.year, 1, 1);
    final daysSinceStartOfYear = currentWeek.difference(startOfYear).inDays;

    return ((daysSinceStartOfYear + startOfYear.weekday - 1) ~/ 7) + 1;
  }
}
