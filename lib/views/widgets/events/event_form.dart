import 'package:flutter/material.dart';

class EventForm extends StatelessWidget {
  final Function(String, String) onAddEvent;

  const EventForm({super.key, required this.onAddEvent});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Nome do Evento'),
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(labelText: 'Descrição do Evento'),
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () => onAddEvent(
            nameController.text.trim(),
            descriptionController.text.trim(),
          ),
          child: const Text('Adicionar Evento'),
        ),
      ],
    );
  }
}
