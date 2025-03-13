import 'package:flutter/material.dart';

class NameField extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onNameChanged;

  const NameField({
    super.key,
    required this.initialValue,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: const InputDecoration(labelText: 'Name'),
      onChanged: onNameChanged,
    );
  }
}