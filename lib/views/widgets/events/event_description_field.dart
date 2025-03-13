import 'package:flutter/material.dart';

class EventDescriptionField extends StatelessWidget {
  final TextEditingController controller;

  const EventDescriptionField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(labelText: 'Descrição do Evento'),
    );
  }
}