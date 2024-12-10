import 'dart:async';
import 'package:minio/minio.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';

class CloudFunctions {
  final String endpoint =
      'https://hb.bizmrg.com'; // S3-совместимый API VK Cloud
  final String accessKey = 'w1RsvMGPTqWEwmncjnRzDB'; // Ваш Access Key
  final String secretKey =
      '4q1im5jUTPywfnMfhgad5KbyVeREzQKZvzeTRn2xvoeR'; // Ваш Secret Key
  final String bucketName = 'balderstorage1.0.1'; // Имя бакета

  late Minio _minio;

  CloudFunctions() {
    _minio = Minio(
      endPoint: endpoint.replaceFirst('https://', ''), // Убираем протокол
      accessKey: accessKey,
      secretKey: secretKey,
    );
  }

  /// Генерация временной публичной ссылки для скачивания файла
  Future<String> generatePublicLink(String fileName,
      {int expirySeconds = 3600}) async {
    try {
      // Генерация временной ссылки (3600 секунд = 1 час)
      final url = await _minio.presignedGetObject(bucketName, fileName,
          expires: expirySeconds);
      print("Ссылка для скачивания файла '$fileName': $url");
      return url;
    } catch (e) {
      print("Ошибка при генерации ссылки: $e");
      rethrow; // Пробрасываем ошибку дальше
    }
  }

  /// Загрузка файла
  Future<void> uploadFile(String filePath, String fileName) async {
    final file = File(filePath);

    try {
      // Преобразуем поток в Stream<Uint8List>
      final fileStream = file.openRead().transform<List<int>>(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            sink.add(Uint8List.fromList(data));
          },
        ),
      ).cast<Uint8List>();

      final fileLength = await file.length(); // Получаем размер файла

      await _minio.putObject(
        bucketName,
        fileName,
        fileStream, // Передаем преобразованный поток
        size: fileLength, // Размер файла
        metadata: {'Content-Type': 'application/octet-stream'},
      );

      print("Файл '$fileName' успешно загружен!");
    } catch (e) {
      print("Ошибка при загрузке файла: $e");
    }
  }

  /// Список файлов в бакете
  Future<void> listFiles() async {
    try {
      // Получаем список объектов из бакета
      final objects = await _minio.listObjects(bucketName).toList();

      if (objects.isNotEmpty) {
        print("Список файлов в бакете:");

        // Выводим структуру каждого объекта
        for (var obj in objects) {
          print("Объект целиком: $obj"); // Выводим объект целиком
        }
      } else {
        print("Бакет пуст.");
      }
    } catch (e) {
      print("Ошибка получения списка файлов: $e");
    }
  }

  /// Скачивание файла
  Future<void> downloadFile(String fileName, String savePath) async {
    try {
      final stream = await _minio.getObject(bucketName, fileName);
      final file = File(savePath);
      await file.openWrite().addStream(stream);
      print("Файл '$fileName' успешно загружен в $savePath!");
    } catch (e) {
      print("Ошибка при скачивании файла: $e");
    }
  }

  /// Удаление файла
  Future<void> deleteFile(String fileName) async {
    try {
      await _minio.removeObject(bucketName, fileName);
      print("Файл '$fileName' успешно удален!");
    } catch (e) {
      print("Ошибка удаления файла: $e");
    }
  }
}

Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = '';

  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id ?? ''; // Используем id вместо androidId
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor ?? ''; // Уникальный ID для iOS
  }

  return deviceId;
}
