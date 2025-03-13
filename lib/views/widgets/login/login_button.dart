import 'package:flutter/material.dart';

/// Classe responsável por exibir o botão de login.
class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        backgroundColor: const Color(0xFFCBB26A),
      ),
      onPressed: onPressed,
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 25.0, color: Colors.white),
      ),
    );
  }
}
