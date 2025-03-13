import 'package:flutter/material.dart';

/// Classe responsável por exibir o campo de texto para senha.
class PasswordTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? errorText;

  const PasswordTextField({super.key, required this.onChanged, this.errorText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      obscureText: true,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Color(0xFFCBB26A)),
        labelStyle: const TextStyle(color: Color(0xFFCBB26A)),
        labelText: 'Password',
        errorText: errorText,
      ),
    );
  }
}
