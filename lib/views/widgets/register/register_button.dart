/// Stateless widget for the registration button.
library;
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RegisterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        backgroundColor: const Color(0xFFCBB26A),
      ),
      onPressed: onPressed,
      child: const Text(
        'Register',
        style: TextStyle(fontSize: 25.0, color: Colors.white),
      ),
    );
  }
}
