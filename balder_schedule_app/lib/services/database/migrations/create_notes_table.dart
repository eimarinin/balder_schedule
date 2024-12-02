import 'package:sqflite/sqflite.dart';

Future<void> addNotesTable(Database db) async {
  await db.execute('''
    CREATE TABLE one_time_notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      lessonId INTEGER NOT NULL,
      note TEXT NOT NULL,
      date TEXT NOT NULL,
      FOREIGN KEY (lessonId) REFERENCES lessons (id) ON DELETE CASCADE
    )
  ''');
}
