// storage_service_none.dart
import 'package:balder_schedule_app/utils/logger.dart';

class StorageService {
  Future<List<Map<String, dynamic>>> loadLessonData() async {
    try {
      // Возвращаем пустой список, так как нет поддержки хранения данных
      warn('Хранение данных не поддерживается в этой среде');
      return [];
    } catch (e) {
      error('Ошибка при попытке загрузить данные',
          data: {'error': e.toString()});
      return [];
    }
  }

  Future<void> saveLessonData(Map<String, dynamic> lessonData) async {
    try {
      // Просто логируем, что сохранение невозможно в данной среде
      warn('Сохранение данных не поддерживается в этой среде',
          data: lessonData);
    } catch (e) {
      error('Ошибка при попытке сохранить данные',
          data: {'error': e.toString()});
    }
  }
}
