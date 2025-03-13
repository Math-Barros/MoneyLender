import 'package:flutter/material.dart';

/// Classe responsável por exibir o campo de texto para email.
class EmailTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? errorText;

  const EmailTextField({super.key, required this.onChanged, this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Color(0xFFCBB26A)),
        labelStyle: const TextStyle(color: Color(0xFFCBB26A)),
        labelText: 'Email',
        errorText: errorText,
      ),
    );
  }
}
