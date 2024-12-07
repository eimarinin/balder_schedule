import 'package:sqflite/sqflite.dart';

Future<void> removeNotesTable(Database db) async {
  await db.execute('DROP TABLE IF EXISTS notes;');
}
