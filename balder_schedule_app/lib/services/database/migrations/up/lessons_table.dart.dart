import 'package:sqflite/sqflite.dart';

Future<void> addLessonsTable(Database db) async {
  await db.execute('''
    CREATE TABLE lessons (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      classRoom TEXT NOT NULL,
      lessonType TEXT NOT NULL,
      time TEXT NOT NULL,
      weekParity TEXT,
      lessonDate TEXT,
      teacher TEXT,
      notes TEXT
    )
  ''');
}
