import 'package:balder_schedule_app/services/database/migrations/up/lessons_table.dart.dart';
import 'package:balder_schedule_app/services/database/migrations/up/notes_table.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dio/dio.dart'; // Для HTTP-запросов

class CloudFunctions {
  Future<void> uploadDatabaseToStorage() async {
    try {
      // Путь к базе данных
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, 'schedule.db'));

      // Проверяем, существует ли файл
      if (!dbFile.existsSync()) {
        throw Exception('Файл базы данных не найден.');
      }

      // Конфигурация клиента Dio с правильными заголовками для VK Cloud
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://balderstorage.hb.bizmrg.com/',
          headers: {
            'X-Auth-Access-Key': 'fhS3aDD9EyeLEW6YdgcVp2',
            'X-Auth-Secret-Key': '9R2KBwN2rWivrp7LY6KSQUcDzPjpWeqd3YMgjXdEJqMq',
          },
        ),
      );

      // Имя файла в хранилище
      final fileName = 'schedule_${DateTime.now().toIso8601String()}.db';
      final fileLength = await dbFile.length();

      // Выполняем загрузку файла с правильными заголовками
      final response = await dio.put(
        '/balderstorage/$fileName',
        data: dbFile.openRead(),
        options: Options(
          headers: {
            'Content-Type': 'application/octet-stream',
            'Content-Length': fileLength.toString(),
            'X-Content-Type': 'application/octet-stream',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Файл успешно загружен в хранилище.');
      } else {
        throw Exception(
          'Ошибка при загрузке файла: ${response.statusCode} ${response.statusMessage}\nТело ответа: ${response.data}',
        );
      }
    } catch (e) {
      throw Exception('Ошибка при загрузке базы данных: $e');
    }
  }
}
