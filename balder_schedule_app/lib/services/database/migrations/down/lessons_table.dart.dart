import 'package:sqflite/sqflite.dart';

Future<void> removeLessonsTable(Database db) async {
  await db.execute('DROP TABLE IF EXISTS lessons;');
}
