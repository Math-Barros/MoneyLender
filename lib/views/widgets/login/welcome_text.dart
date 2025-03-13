import 'package:flutter/material.dart';

/// Classe responsável por exibir o texto de boas-vindas.
class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
        ),
        Text(
          'please login to your account.',
          style: TextStyle(fontSize: 25.0, color: Color(0xFFCBB26A)),
        ),
      ],
    );
  }
}
