import 'package:flutter/material.dart';

class EventNameField extends StatelessWidget {
  final TextEditingController controller;

  const EventNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Nome do Evento'),
    );
  }
}