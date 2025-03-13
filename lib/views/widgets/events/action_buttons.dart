import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onDelete;

  const ActionButtons({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onDelete,
          child: const Text('Excluir Evento'),
        ),
      ],
    );
  }
}
