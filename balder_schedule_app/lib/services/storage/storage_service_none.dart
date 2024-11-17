import 'package:balder_schedule_app/utils/logger.dart';
import 'package:flutter/material.dart';

class StorageService {
  Future<List<Map<String, dynamic>>> loadLessonData() async {
    try {
      warn('Хранение данных не поддерживается в этой среде');
      return [];
    } catch (e) {
      error('Ошибка при попытке загрузить данные',
          data: {'error': e.toString()});
      return [];
    }
  }

  Future<void> saveLessonData(
      BuildContext context, Map<String, dynamic> lessonData) async {
    try {
      warn('Сохранение данных не поддерживается в этой среде',
          data: lessonData);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Сохранение данных не поддерживается в этой среде'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      error('Ошибка при попытке сохранить данные',
          data: {'error': e.toString()});
    }
  }
}
