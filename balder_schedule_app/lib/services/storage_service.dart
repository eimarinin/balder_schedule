import 'dart:convert';
import 'dart:io';

import 'package:balder_schedule_app/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/lesson_data.json';
    info('File path obtained', data: {'path': path});
    return path;
  }

  Future<List<Map<String, dynamic>>> loadLessonData() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        info('File read successfully', data: {'filePath': filePath});
        return List<Map<String, dynamic>>.from(jsonDecode(contents));
      } else {
        warn('File does not exist, returning empty list');
        return [];
      }
    } catch (e) {
      error('Failed to load lesson data', data: {'error': e.toString()});
      return [];
    }
  }

  Future<int> getLastId() async {
    try {
      final lessons = await loadLessonData();
      if (lessons.isEmpty) {
        info('No lessons found, returning ID 0');
        return 0;
      }

      final lastId = lessons
          .map((lesson) => int.tryParse(lesson['id'].toString()) ?? 0)
          .reduce((curr, next) => curr > next ? curr : next);
      info('Last ID found', data: {'lastId': lastId});
      return lastId;
    } catch (e) {
      error('Failed to get last ID', data: {'error': e.toString()});
      return 0;
    }
  }

  Future<void> saveLessonData(Map<String, dynamic> lessonData) async {
    try {
      final filePath = await _getFilePath();
      final lessons = await loadLessonData();
      final newId = (await getLastId() + 1).toString();
      lessonData['id'] = newId;

      lessons.add(lessonData);
      await _writeJsonToFile(filePath, lessons);
      info('Lesson data saved successfully', data: lessonData);
    } catch (e) {
      error('Failed to save lesson data', data: {'error': e.toString()});
    }
  }

  Future<void> _writeJsonToFile(
      String filePath, List<Map<String, dynamic>> jsonData) async {
    try {
      final file = File(filePath);
      await file.writeAsString(jsonEncode(jsonData));
      info('JSON data written to file', data: {'filePath': filePath});
    } catch (e) {
      error('Failed to write JSON to file', data: {'error': e.toString()});
    }
  }
}
