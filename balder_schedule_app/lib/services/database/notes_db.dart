import 'package:sqflite/sqflite.dart';
import 'package:balder_schedule_app/services/database/database_service.dart';
import 'package:balder_schedule_app/models/notes_model.dart';

class NotesDatabase {
  static const String _tableNotes = 'notes';

  Future<void> insertNote(NotesModel note) async {
    final db = await DatabaseService().database;
    await db.insert(
      _tableNotes,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Future<void> deleteNoteById(int id) async {
    final db = await DatabaseService().database;
    await db.delete(
      _tableNotes,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
