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

  @override
  void initState() {
    super.initState();
    _loadFormattedLessons();
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
  Widget _buildQrCode() {
    if (_hasError || _formattedLessons == null) {
      return Center(
        child: Text(
          _formattedLessons ?? 'Ошибка',
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return QrImageView(
      data: _formattedLessons!,
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

  /// проверка пути бд

  /// Отправка базы данных в хранилище
  Future<void> _uploadDatabase() async {
    final cloudFunctions = CloudFunctions(); // Инициализация CloudFunctions

    // Получаем путь к файлу базы данных
    final filePath = path.join(
        dbPath, 'schedule.db'); // Вызываем getDatabasePath для получения пути
    final file = File(filePath);

    // Выводим путь к файлу в консоль
    print('Путь к файлу базы данных: $filePath');

    // Проверяем, существует ли файл
    if (!file.existsSync()) {
      print('Ошибка: файл не существует по пути $filePath');
      setState(() {
        _isUploading = false; // Скрываем индикатор загрузки
      });
      return; // Прерываем выполнение, если файл не найден
    }

    const fileName = 'schedule.db'; // Имя файла в хранилище

    setState(() {
      _isUploading = true; // Показываем индикатор загрузки
    });

    try {
      // Вызов метода загрузки из CloudFunctions
      await cloudFunctions.uploadFile(filePath, fileName);

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
          _isUploading = false; // Скрываем индикатор загрузки
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
                        : _buildQrCode(), // Генерация QR-кода или ошибка
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
