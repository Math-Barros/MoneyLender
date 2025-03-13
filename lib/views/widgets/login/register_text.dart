import 'package:flutter/material.dart';
import '../../register_page.dart';

/// Classe responsável por exibir o texto "Don't have an account? Register now.".
class RegisterText extends StatelessWidget {
  const RegisterText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterPage(),
          ),
        );
      },
      child: const Text(
        'Don\'t have an account? Register now.',
        style: TextStyle(fontSize: 20.0, color: Color(0xFFCBB26A)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
