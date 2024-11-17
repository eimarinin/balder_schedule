import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:balder_schedule_app/utils/logger.dart';

class PermissionService {
  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.status;

    if (status.isGranted) {
      info('Разрешение на доступ к хранилищу уже предоставлено.');
      return true;
    }

    if (status.isDenied || status.isPermanentlyDenied) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        info('Разрешение на доступ к хранилищу предоставлено пользователем.');
        return true;
      } else if (result.isPermanentlyDenied) {
        warn('Разрешение отклонено и больше не запрашивается.');
        return false;
      } else {
        warn('Разрешение отклонено.');
      }
    }

    return false;
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Требуется разрешение'),
        content: const Text(
            'Для сохранения данных расписания нужно разрешение на доступ к хранилищу. '
            'Перейдите в настройки и включите доступ.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Настройки'),
          ),
        ],
      ),
    );
  }
}
