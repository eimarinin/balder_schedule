// export_none.dart
import 'package:balder_schedule_app/utils/logger.dart';

Future<void> exportData(List<Map<String, dynamic>> data) async {
  try {
    warn('Экспорт данных не поддерживается в этой среде', data: {'data': data});
  } catch (e) {
    error('Ошибка при попытке экспортировать данные',
        data: {'error': e.toString()});
  }
}
