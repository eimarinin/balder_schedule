import 'dart:io';
import 'package:balder_schedule_app/generated/l10n.dart';
import 'package:balder_schedule_app/globals.dart';
import 'package:balder_schedule_app/services/database/lesson_db.dart';
import 'package:balder_schedule_app/utils/cloud_functions.dart'; // Импорт сервиса для работы с БД
import 'package:balder_schedule_app/utils/margin_screen.dart';
import 'package:balder_schedule_app/widgets/page_header_child.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:path/path.dart' as path;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageHeaderChild(title: S.of(context).qrTitle),
      body: MarginScreen(child: const QrContent()),
    );
  }
}

class QrContent extends StatefulWidget {
  const QrContent({super.key});

  @override
  State<QrContent> createState() => _QrContentState();
}

class _QrContentState extends State<QrContent> {
  String? _formattedLessons; // Строка с данными из базы
  bool _isLoading = true; // Статус загрузки
  bool _hasError = false; // Флаг ошибки
  bool _isUploading = false; // Статус загрузки базы данных
  String? _downloadLink; // Ссылка для скачивания файла

  @override
  void initState() {
    super.initState();
    _loadFormattedLessons();
  }

  /// Получение уникального ID устройства
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

  /// Загружаем данные из базы и форматируем их
  Future<void> _loadFormattedLessons() async {
    final databaseService = LessonDatabase();

    try {
      // Получаем список уроков
      final lessons = await databaseService.getLessons();
      if (lessons.isEmpty) {
        throw Exception('Данные отсутствуют');
      }

      // Форматируем строку
      final result = lessons.map((lesson) {
        return '''
Урок: ${lesson.name}
Аудитория: ${lesson.classRoom}
Тип: ${lesson.lessonType}
Время: ${lesson.time}
Неделя: ${lesson.weekParity ?? 'Не указано'}
Дата урока: ${lesson.lessonDate}
Преподаватель: ${lesson.teacher}
Заметки: ${lesson.notes ?? 'Нет заметок'}
        ''';
      }).join('\n---\n');

      setState(() {
        _formattedLessons = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _formattedLessons = 'Ошибка при загрузке данных: $e';
        _isLoading = false;
      });
    }
  }

  /// Генерация QR-кода
  /// Генерация QR-кода из ссылки
  Widget _buildQrCode(String? link) {
    if (link == null || link.isEmpty) {
      return const Center(
        child: Text(
          'Ссылка не доступна',
          style: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return QrImageView(
      data: link,
      version: QrVersions.auto,
      size: 364, // Размер QR-кода
      gapless: false,
      errorStateBuilder: (context, error) {
        return const Center(
          child: Text(
            'Ошибка при создании QR-кода',
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }

  /// Отправка базы данных в хранилище с уникальным именем, основанным на ID устройства
  Future<void> _uploadDatabase() async {
    final cloudFunctions = CloudFunctions(); // Инициализация CloudFunctions

    final filePath = path.join(dbPath, 'schedule.db'); // Путь к базе данных
    final file = File(filePath);

    final deviceId = await getDeviceId();
    final fileName = '$deviceId-schedule.db'; // Уникальное имя файла

    if (!file.existsSync()) {
      print('Ошибка: файл не существует по пути $filePath');
      setState(() {
        _isUploading = false;
      });
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Загрузка файла
      await cloudFunctions.uploadFile(filePath, fileName);

      // Генерация публичной ссылки
      final downloadLink = await cloudFunctions.generatePublicLink(fileName);

      // Сохранение ссылки в состояние
      setState(() {
        _downloadLink = downloadLink;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('База данных успешно отправлена!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при отправке базы данных: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Gap(12),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {}, // Можно добавить функцию сканирования
                    icon:
                        const Icon(Icons.video_camera_front_outlined, size: 18),
                    label: Text(S.of(context).scanNewScheduleTitle),
                  ),
                ),
                const Gap(12),
                Container(
                  width: 364,
                  height: 364,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(), // Индикатор загрузки
                          )
                        : _buildQrCode(
                            _downloadLink), // Генерация QR-кода из ссылки
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: _isUploading
                        ? null
                        : () {
                            _uploadDatabase(); // Вызов метода отправки базы данных
                          },
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text(S.of(context).shareScheduleTitle),
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
