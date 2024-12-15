import 'package:balder_schedule_app/globals.dart';
import 'package:balder_schedule_app/services/database/migrations/down/lessons_table.dart.dart';
import 'package:balder_schedule_app/services/database/migrations/down/notes_table.dart';
import 'package:balder_schedule_app/services/database/migrations/up/lessons_table.dart.dart';
import 'package:balder_schedule_app/services/database/migrations/up/notes_table.dart';
import 'package:balder_schedule_app/utils/cloud_functions.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  static const int currentDbVersion = 2;

  final List<Future<void> Function(Database)> _migrations = [
    addLessonsTable,
    addNotesTable,
  ];

  final List<Future<void> Function(Database)> _migrationsDown = [
    removeLessonsTable,
    removeNotesTable,
  ];

  void initializeDatabaseFactory() {
    if (kIsWeb ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      // Инициализация для FFI
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
      dbPath = await getDatabasesPath();

      // await deleteDatabase();
      dbName = '${await getDeviceId()}_schedule.db';

      return await openDatabase(
        join(dbPath, dbName),
        version: currentDbVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade,
      );
    } catch (e) {
      throw Exception('Ошибка при инициализации базы данных: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await _migrateDatabase(db, version);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion + 1; i <= newVersion; i++) {
      await _applyMigration(db, i);
    }
  }

  Future<void> _onDowngrade(Database db, int oldVersion, int newVersion) async {
    for (int i = oldVersion; i > newVersion; i--) {
      await _revertMigration(db, i);
    }
  }

  Future<void> _applyMigration(Database db, int version) async {
    if (version > _migrations.length || version <= 0) {
      throw Exception('Миграция версии $version отсутствует.');
    }
    await _migrations[version - 1](db);
  }

  Future<void> _revertMigration(Database db, int version) async {
    if (version > _migrationsDown.length || version <= 0) {
      throw Exception('Миграция вниз для версии $version отсутствует.');
    }
    await _migrationsDown[version - 1](db);
  }

  Future<void> _migrateDatabase(Database db, int version) async {
    for (int i = 1; i <= version; i++) {
      await _applyMigration(db, i);
    }
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteDatabase() async {
    try {
      await closeDatabase();

      final path = join(dbPath, dbName);

      await databaseFactory.deleteDatabase(path);

      debugPrint('База данных $dbName успешно удалена.');
    } catch (e) {
      throw Exception('Ошибка при удалении базы данных: $e');
    }
  }
}
