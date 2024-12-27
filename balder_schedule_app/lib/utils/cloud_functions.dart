import 'dart:async';
import 'package:minio/minio.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

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

  Future<String> generatePublicLink(String fileName,
      {int expirySeconds = 3600}) async {
    try {
      // Генерация временной ссылки
      final url = await _minio.presignedGetObject(bucketName, fileName,
          expires: expirySeconds);

      // Сокращение ссылки с помощью TinyURL
      final shortUrl = await _shortenWithTinyURL(url);

      return shortUrl;
    } catch (e) {
      rethrow;
    }
  }

  /// Метод для сокращения ссылки через TinyURL
  Future<String> _shortenWithTinyURL(String url) async {
    final response = await http
        .get(Uri.parse('https://tinyurl.com/api-create.php?url=$url'));

    if (response.statusCode == 200) {
      return response.body; // Возвращает короткую ссылку
    } else {
      throw Exception('Ошибка при сокращении ссылки через TinyURL');
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

      final fileLength = await file.length();

      await _minio.putObject(
        bucketName,
        fileName,
        fileStream,
        size: fileLength,
        metadata: {'Content-Type': 'application/octet-stream'},
      );
    } catch (e) {
      throw Exception("Ошибка при загрузке файла: $e");
    }
  }

  /// Скачивание файла
  Future<void> downloadFile(String fileUrl, String savePath) async {
    try {
      final uri = Uri.parse(fileUrl);
      final httpClient = HttpClient();

      final request = await httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == 200) {
        final file = File(savePath);
        await file.openWrite().addStream(response);
      } else {
        throw Exception('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Удаление файла
  Future<void> deleteFile(String fileName) async {
    try {
      await _minio.removeObject(bucketName, fileName);
    } catch (e) {
      throw Exception("Ошибка удаления файла: $e");
    }
  }
}

Future<String> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = '';

  if (Platform.isAndroid) {
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    deviceId = androidInfo.id;
  } else if (Platform.isIOS) {
    final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    deviceId = iosInfo.identifierForVendor ?? '';
  } else if (Platform.isMacOS) {
    final MacOsDeviceInfo macosInfo = await deviceInfo.macOsInfo;
    deviceId = macosInfo.systemGUID ?? '';
  } else if (Platform.isWindows) {
    final WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    deviceId = windowsInfo.computerName;
  } else if (Platform.isLinux) {
    final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    deviceId = linuxInfo.name;
  }

  return deviceId;
}
