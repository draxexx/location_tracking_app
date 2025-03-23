import 'package:flutter/material.dart';

void showAddLocationDialog({
  required BuildContext context,
  required Function(String locationName) onSubmit,
}) {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: const Text("Add New Location"),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Location Name (e.g. Home)",
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a location name';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop();
                onSubmit(controller.text.trim());
              }
            },
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}
