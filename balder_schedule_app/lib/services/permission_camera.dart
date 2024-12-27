import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCamera {
  static Future<bool> checkCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied || status.isRestricted) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        return true;
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Камера недоступна. Проверьте настройки приложения.'),
        ),
      );
    }
    return false;
  }
}
