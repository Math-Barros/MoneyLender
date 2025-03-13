import 'package:flutter/material.dart';

/// Classe responsável por exibir o divisor com texto "Or".
class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: 60.0,
            color: const Color(0xFFCBB26A),
          ),
        ),
        const Text(
          'Or',
          style: TextStyle(fontSize: 25.0, color: Color(0xFFCBB26A)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: 60.0,
            color: const Color(0xFFCBB26A),
          ),
        ),
      ],
    );
  }
}
