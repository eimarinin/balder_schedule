import 'package:balder_schedule_app/models/lesson_model.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  static const String _tableLessons = 'lessons';
  static const String _columnId = 'id';
  static const String _columnName = 'name';
  static const String _columnClassRoom = 'classRoom';
  static const String _columnLessonType = 'lessonType';
  static const String _columnTime = 'time';
  static const String _columnWeekParity = 'weekParity';
  static const String _columnLessonDate = 'lessonDate';
  static const String _columnTeacher = 'teacher';
  static const String _columnNotes = 'notes';

  void initializeDatabaseFactory() {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      // Для веба и десктопных платформ используем FFI
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      initializeDatabaseFactory();

      final dbPath = await getDatabasesPath();
      return await openDatabase(
        join(dbPath, 'schedule.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableLessons(
              $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $_columnName TEXT NOT NULL,
              $_columnClassRoom TEXT NOT NULL,
              $_columnLessonType TEXT NOT NULL,
              $_columnTime TEXT NOT NULL,
              $_columnWeekParity TEXT,
              $_columnLessonDate TEXT,
              $_columnTeacher TEXT,
              $_columnNotes TEXT
            )
          ''');
        },
      );
    } catch (e) {
      throw Exception('Ошибка при инициализации базы данных: $e');
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> insertLesson(LessonModel lesson) async {
    try {
      final db = await database;
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
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(_tableLessons);
      return maps.map((map) => LessonModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Ошибка при получении уроков: $e');
    }
  }

  Future<void> updateLesson(LessonModel lesson) async {
    try {
      final db = await database;

      final count = await db.query(
        _tableLessons,
        where: '$_columnId = ?',
        whereArgs: [lesson.id],
      );

      if (count.isEmpty) {
        throw Exception('Запись с ID ${lesson.id} не найдена');
      }

      await db.update(
        _tableLessons,
        lesson.toMap(),
        where: '$_columnId = ?',
        whereArgs: [lesson.id],
      );
    } catch (e) {
      throw Exception('Ошибка при обновлении урока: $e');
    }
  }

  Future<void> deleteLesson(int id) async {
    try {
      final db = await database;

      final count = await db.query(
        _tableLessons,
        where: '$_columnId = ?',
        whereArgs: [id],
      );

      if (count.isEmpty) {
        throw Exception('Запись с ID $id не найдена');
      }

      await db.delete(
        _tableLessons,
        where: '$_columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Ошибка при удалении урока: $e');
    }
  }
}
