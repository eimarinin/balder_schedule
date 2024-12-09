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

      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://balderschedule3.hb.ru-msk.vkcloud-storage.ru',
          headers: {
            'Access-Key': 'weETTYXrivELhUALM26zJi',
            'Secret-Key': 'bdFjHyV8zWD6ZtWonKKfW6YZoKVkg2J1wLMi3AdroTNE',
          },
        ),
      );

      final fileName = 'schedule_${DateTime.now().toIso8601String()}.db';

      final dbFileStream = dbFile.openRead();

      try {
        final response = await dio.put(
          '/balderschedule3/$fileName',
          data: dbFileStream,
          options: Options(
            headers: {
              'Content-Type': 'application/octet-stream',
            },
          ),
        );
        print('Ответ сервера: ${response.statusCode} ${response.data}');
      } catch (e) {
        print('Ошибка при отправке: $e');
      }

      // // Проверяем успешность запроса
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   print('Файл успешно загружен в хранилище.');
      // } else {
      //   throw Exception(
      //     'Ошибка при загрузке файла: ${response.statusCode} ${response.statusMessage}',
      //   );
      // }
    } catch (e) {
      throw Exception('Ошибка при загрузке базы данных: $e');
    }
  }
}
