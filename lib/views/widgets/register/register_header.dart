/// Stateless widget displaying the header text for the registration screen.
library;
import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Register',
          style: TextStyle(fontSize: 50.0, color: Color(0xFFCBB26A)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lets get',
              style: TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
            ),
            Text(
              'you on board.',
              style: TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
            ),
          ],
        ),
      ],
    );
  }
}
