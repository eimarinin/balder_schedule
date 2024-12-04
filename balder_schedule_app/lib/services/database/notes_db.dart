import 'package:sqflite/sqflite.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/models/notes_model.dart';

class NotesDatabase {
  static const String _tableNotes = 'notes';

  Future<void> insertNote(NotesModel note) async {
    try {
      final db = await DatabaseService().database;
      await db.insert(
        _tableNotes,
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Ошибка при добавлении заметки: $e');
    }
  }

  Future<List<NotesModel>> getNotesByLessonId(int lessonId) async {
    final db = await DatabaseService().database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableNotes,
      where: 'lessonId = ?',
      whereArgs: [lessonId],
    );
    return maps.map((map) => NotesModel.fromMap(map)).toList();
  }

  Future<void> updateNote(int noteId, String updatedText) async {
    try {
      final db = await DatabaseService().database;

      // Пытаемся найти заметку по ID
      final count = await db.query(
        _tableNotes,
        where: 'id = ?',
        whereArgs: [noteId],
      );

      if (count.isEmpty) {
        throw Exception('Заметка с ID $noteId не найдена');
      }

      await db.update(
        _tableNotes,
        {'note': updatedText},
        where: 'id = ?',
        whereArgs: [noteId],
      );
    } catch (e) {
      throw Exception('Ошибка при обновлении заметки: $e');
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      final db = await DatabaseService().database;

      final count = await db.query(
        _tableNotes,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count.isEmpty) {
        throw Exception('Заметка с ID $id не найдена');
      }

      await db.delete(
        _tableNotes,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Ошибка при удалении урока: $e');
    }
  }
}
