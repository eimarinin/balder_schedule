// storage_service_web.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web/web.dart';
import 'package:balder_schedule_app/utils/logger.dart';

class StorageService {
  Future<List<Map<String, dynamic>>> loadLessonData() async {
    try {
      final data = window.localStorage['lesson_data'];
      return data != null
          ? List<Map<String, dynamic>>.from(jsonDecode(data))
          : [];
    } catch (e) {
      error('Ошибка при загрузке данных с веб-хранилища',
          data: {'error': e.toString()});
      return [];
    }
  }

  Future<void> saveLessonData(
      BuildContext context, Map<String, dynamic> lessonData) async {
    try {
      final lessons = await loadLessonData();
      lessonData['id'] = (lessons.length + 1).toString();
      lessons.add(lessonData);

      window.localStorage['lesson_data'] = jsonEncode(lessons);
      info('Данные успешно сохранены в localStorage', data: lessonData);
    } catch (e) {
      error('Ошибка при сохранении данных в localStorage',
          data: {'error': e.toString()});
    }
  }
}
