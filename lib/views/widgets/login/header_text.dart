import 'package:flutter/material.dart';

/// Classe responsável por exibir o texto "Login".
class HeaderText extends StatelessWidget {
  const HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Login',
      style: TextStyle(fontSize: 50.0, color: Color(0xFFCBB26A)),
    );
  }
}
