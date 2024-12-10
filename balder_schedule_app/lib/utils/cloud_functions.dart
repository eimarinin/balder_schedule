import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:dio/dio.dart';

class CloudFunctions {
  Future<void> uploadDatabaseToStorage() async {
    try {
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, 'schedule.db'));

      if (!dbFile.existsSync()) {
        throw Exception('Файл базы данных не найден.');
      }

      // Конфигурация клиента Dio
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://hb.bizmrg.com',
          headers: {
            'Access-Key': 'fhS3aDD9EyeLEW6YdgcVp2', // Ваш Access Key
            'Secret-Key':
                '9R2KBwN2rWivrp7LY6KSQUcDzPjpWeqd3YMgjXdEJqMq', // Ваш Secret Key
          },
        ),
      );

      final fileName = 'schedule_${DateTime.now().toIso8601String()}.db';
      final fileLength = await dbFile.length();

      // Выполняем загрузку файла
      final response = await dio.put(
        '/balderstorage/$fileName', // Бакет и имя файла
        data: dbFile.openRead(),
        options: Options(
          headers: {
            'Content-Type': 'application/octet-stream',
          },
        ),
      );

      // Проверяем успешность запроса
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Файл успешно загружен в хранилище.');
      } else {
        throw Exception(
          'Ошибка при загрузке файла: ${response.statusCode} ${response.statusMessage}',
        );
      }
    } catch (e) {
      throw Exception('Ошибка при загрузке базы данных: $e');
    }
  }
}
