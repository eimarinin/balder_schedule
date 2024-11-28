import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {
  int weekNumber() {
    final startOfYear = DateTime(year, 1, 1);
    final daysDifference = difference(startOfYear).inDays;
    return (daysDifference / 7).floor() + 1;
  }
}

class ScheduleState extends ChangeNotifier {
  DateTime currentWeek = DateTime.now();
  int currentParity = 2; // Начальная четность недели
  final int maxParity = 3; // Максимальная четность недели

  void setCurrentWeek(DateTime newDate, {int? parity}) {
    currentWeek = newDate;
    if (parity != null) {
      currentParity = parity;
    }
    notifyListeners();
  }

  void nextWeek() {
    currentParity = (currentParity % maxParity) + 1;
    currentWeek = currentWeek.add(Duration(days: 7));
    notifyListeners();
  }

  void previousWeek() {
    if (currentParity == 1) {
      currentParity = maxParity;
    } else {
      currentParity--;
    }
    currentWeek = currentWeek.subtract(Duration(days: 7));
    notifyListeners();
  }

  String getFormattedWeek() {
    final startOfWeek = currentWeek.subtract(
      Duration(days: (currentWeek.weekday - 1) % 7),
    );
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    return "${startOfWeek.day}.${startOfWeek.month} - ${endOfWeek.day}.${endOfWeek.month}";
  }

  String getWeekParityText() {
    return 'Кратность: $currentParity';
  }

  int calculateWeekDifference(DateTime newDate) {
    final int currentWeekNumber = currentWeek.weekNumber();
    final int newWeekNumber = newDate.weekNumber();

    return newWeekNumber - currentWeekNumber;
  }

  int calculateNewParity(int weeksDifference) {
    int newParity = (currentParity + weeksDifference - 1) % maxParity + 1;
    return newParity;
  }

  int getWeekNumber() {
    // Задаем дату начала отсчета - 2 сентября
    DateTime startDate = DateTime(currentWeek.year, 8, 28); // 2 сентября

    // Получаем день недели для текущей даты
    int today = currentWeek.weekday;

    // ISO week date недели начинаются с понедельника
    // Корректируем номер дня
    var dayNr = (today + 6) % 7;

    // Находим понедельник текущей недели
    var thisMonday = currentWeek.subtract(Duration(days: dayNr));

    // Находим четверг текущей недели
    var thisThursday = thisMonday.add(Duration(days: 3));

    // Находим первый четверг года (для вычисления начала недели)
    var firstThursday = DateTime(currentWeek.year, DateTime.january, 1);

    if (firstThursday.weekday != DateTime.thursday) {
      firstThursday = DateTime(currentWeek.year, DateTime.january,
          1 + ((4 - firstThursday.weekday) + 7) % 7);
    }

    // Вычисляем разницу между первым четвергом года и 2 сентября
    var x = thisThursday.difference(startDate).inMilliseconds;

    // Вычисляем номер недели
    var weekNumber = (x / 604800000).ceil(); // 604800000 = 7 * 24 * 3600 * 1000

    return weekNumber;
  }
}
