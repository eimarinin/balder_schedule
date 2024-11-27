import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Класс для форматирования данных из базы
class LessonFormatter {
  final DatabaseService _databaseService = DatabaseService();

  /// Метод для получения всех данных таблицы в формате строки
  Future<String> getFormattedLessons() async {
    try {
      // Получаем список уроков из базы
      List<LessonModel> lessons = await _databaseService.getLessons();

      if (lessons.isEmpty) {
        return 'Данные отсутствуют';
      }

      // Преобразуем список уроков в одну строку
      String result = lessons.map((lesson) {
        return '''
Урок: ${lesson.name}
Аудитория: ${lesson.classRoom}
Тип: ${lesson.lessonType}
Время: ${lesson.time}
Неделя: ${lesson.weekParity ?? 'Не указано'}
Дата урока: ${lesson.lessonDate}
Преподаватель: ${lesson.teacher}
Заметки: ${lesson.notes ?? 'Нет заметок'}
        ''';
      }).join('\n---\n');

      return result;
    } catch (e) {
      String errorMessage = 'Ошибка при получении данных: $e';
      return errorMessage;
    }
  }

  /// Метод для создания виджета QR-кода из строки данных
  Future<Widget> getQrCodeFromLessons() async {
    try {
      // Получаем строку с данными уроков
      String formattedLessons = await getFormattedLessons();

      // Генерируем QR-код из строки
      return Future.value(
        QrImageView(
          data: formattedLessons,
          version: QrVersions.auto,
          size: 364, // Размер QR-кода
          gapless: false,
          errorStateBuilder: (context, error) {
            return Center(
              child: Text(
                'Ошибка при создании QR-кода',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      );
    } catch (e) {
      return Future.value(
        Center(
          child: Text(
            'Ошибка при создании QR-кода',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}
