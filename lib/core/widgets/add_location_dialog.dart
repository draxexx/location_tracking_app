import 'package:flutter/material.dart';

void showAddLocationDialog({
  required BuildContext context,
  required Function(String locationName) onSubmit,
}) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Add New Location"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Location Name (e.g. Home)",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.of(ctx).pop();
                onSubmit(name);
              }
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}
