import 'package:flutter/material.dart';

void showConfirmDialog({
  required BuildContext context,
  required Function() onSubmit,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("⚠️ Warning"),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onSubmit();
            },
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}
