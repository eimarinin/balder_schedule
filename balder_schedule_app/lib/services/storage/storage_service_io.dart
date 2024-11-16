// storage_service_io.dart
import 'dart:convert';
import 'dart:io';
import 'package:balder_schedule_app/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/lesson_data.json';
  }

  Future<List<Map<String, dynamic>>> loadLessonData() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        info('Файл успешно прочитан', data: {'filePath': filePath});
        return List<Map<String, dynamic>>.from(jsonDecode(contents));
      } else {
        warn('Файл не найден, возвращается пустой список');
        return [];
      }
    } catch (e) {
      error('Ошибка при загрузке данных из файла',
          data: {'error': e.toString()});
      return [];
    }
  }

  Future<void> saveLessonData(Map<String, dynamic> lessonData) async {
    try {
      final filePath = await _getFilePath();
      final lessons = await loadLessonData();
      lessonData['id'] = (lessons.length + 1).toString();
      lessons.add(lessonData);
      final file = File(filePath);
      await file.writeAsString(jsonEncode(lessons));
      info('Данные успешно сохранены в файл', data: lessonData);
    } catch (e) {
      error('Ошибка при сохранении данных в файл',
          data: {'error': e.toString()});
    }
  }
}
