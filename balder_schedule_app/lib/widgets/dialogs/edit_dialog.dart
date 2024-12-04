import 'package:flutter/material.dart';

class EditNoteDialog {
  static Future<String?> show({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    String hintText = '',
    String confirmButtonText = 'Сохранить',
    String cancelButtonText = 'Отмена',
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
              hintText: hintText,
            ),
          ),
          actions: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.pop(dialogContext, null),
                    child: Text(cancelButtonText),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () =>
                        Navigator.pop(dialogContext, controller.text),
                    child: Text(confirmButtonText),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    return result;
  }
}
