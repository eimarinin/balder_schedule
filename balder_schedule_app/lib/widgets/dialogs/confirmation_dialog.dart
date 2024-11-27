import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConfirmationDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    String cancelButtonText = 'Отмена',
    bool isDanger = false,
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: Text(cancelButtonText),
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    style: isDanger
                        ? FilledButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.onError,
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          )
                        : null,
                    child: Text(confirmButtonText),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (result == 'OK' && context.mounted) {
      onConfirm();
    }
  }
}
