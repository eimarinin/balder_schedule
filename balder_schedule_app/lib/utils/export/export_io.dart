// export_io.dart
import 'package:balder_schedule_app/utils/logger.dart';

Future<void> exportData(List<Map<String, dynamic>> data) async {
  try {
    warn(
        'Экспорт данных невозможен в данной среде (не поддерживается на мобильных устройствах или других платформах, кроме Web)',
        data: {'data': data});
  } catch (e) {
    error('Ошибка при попытке экспортировать данные',
        data: {'error': e.toString()});
  }
}
