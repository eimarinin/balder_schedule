import 'package:flutter/material.dart';

class SnackbarHandler {
  static Future<void> handleSaveAction(
    BuildContext context,
    Future<void> Function() asyncAction,
    String successMessage,
    String errorMessage,
  ) async {
    try {
      await asyncAction();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$errorMessage: $e',
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
