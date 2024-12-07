import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:balder_schedule_app/models/lesson_model.dart';

class LessonDatabase {
  static const String _tableLessons = 'lessons';

  Future<Database> _getDatabase() async {
    try {
      return await DatabaseService().database;
    } catch (e) {
      throw Exception('База данных недоступна: $e');
    }
  }

  Future<void> insertLesson(LessonModel lesson) async {
    try {
      final db = await _getDatabase();

      await db.insert(
        _tableLessons,
        lesson.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Ошибка при добавлении урока: $e');
    }
  }

  Future<List<LessonModel>> getLessons() async {
    try {
      final db = await _getDatabase();

      final List<Map<String, dynamic>> maps = await db.query(_tableLessons);
      return maps.map((map) => LessonModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Ошибка при получении уроков: $e');
    }
  }

  Future<List<LessonModel>> getLessonsByDay(String weekday) async {
    try {
      final db = await _getDatabase();

      final result = await db.query(
        _tableLessons,
        where: 'lessonDate = ?',
        whereArgs: [weekday.toLowerCase()],
      );

      return result.map((lesson) => LessonModel.fromMap(lesson)).toList();
    } catch (e) {
      throw Exception(
          'Ошибка при получении уроков для дня недели $weekday: $e');
    }
  }

  Future<List<LessonModel>> getLessonsByDayAndWeek(
      String weekday, int weekParity) async {
    try {
      final db = await _getDatabase();

      String weekParityString = weekParity.toString();

      final result = await db.query(
        _tableLessons,
        where: 'lessonDate = ? AND weekParity LIKE ?',
        whereArgs: [weekday.toLowerCase(), '%$weekParityString%'],
      );

      return result.map((lesson) => LessonModel.fromMap(lesson)).toList();
    } catch (e) {
      throw Exception(
          'Ошибка при получении уроков для $weekday ($weekParity): $e');
    }
  }

  Future<List<LessonModel>> getLessonsBySpecificDate(String date) async {
    try {
      final db = await _getDatabase();

      final result = await db.query(
        _tableLessons,
        where: 'lessonDate = ?',
        whereArgs: [date],
      );

      return result.map((lesson) => LessonModel.fromMap(lesson)).toList();
    } catch (e) {
      throw Exception('Ошибка при получении занятий для даты $date: $e');
    }
  }

  Future<void> updateLesson(LessonModel lesson) async {
    try {
      final db = await _getDatabase();

      final count = await db.query(
        _tableLessons,
        where: 'id = ?',
        whereArgs: [lesson.id],
      );

      if (count.isEmpty) {
        throw Exception('Запись с ID ${lesson.id} не найдена');
      }

      await db.update(
        _tableLessons,
        lesson.toMap(),
        where: 'id = ?',
        whereArgs: [lesson.id],
      );
    } catch (e) {
      throw Exception('Ошибка при обновлении урока: $e');
    }
  }

  Future<void> deleteLesson(int id) async {
    try {
      final db = await _getDatabase();

      final count = await db.query(
        _tableLessons,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count.isEmpty) {
        throw Exception('Запись с ID $id не найдена');
      }

      await db.delete(
        _tableLessons,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Ошибка при удалении урока: $e');
    }
  }

  Future<LessonModel?> getLessonById(int id) async {
    try {
      final db = await _getDatabase();

      final List<Map<String, dynamic>> result = await db.query(
        _tableLessons,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (result.isEmpty) return null;

      return LessonModel.fromMap(result.first);
    } catch (e) {
      throw Exception('Ошибка при получении урока с ID $id: $e');
    }
  }
}
