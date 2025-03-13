import 'package:flutter/material.dart';
import 'package:moneylender/views/forgot_password_page.dart';

/// Classe responsável por exibir o botão de "Esqueceu a senha?".
class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(),
          ),
        );
      },
      child: const Text(
        'Forgot your password?',
        style: TextStyle(fontSize: 20.0, color: Color(0xFFCBB26A)),
      ),
    );
  }
}
