/// Stateless widget for the "Sign In" text with a tap gesture to navigate to the login page.
library;
import 'package:flutter/material.dart';

/// Stateless widget for the "Sign In" text with a tap gesture to navigate to the login page.
class SignInText extends StatelessWidget {
  final VoidCallback onTap;

  const SignInText({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Text(
        'Already have an account? Sign in',
        style: TextStyle(fontSize: 20.0, color: Color(0xFFCBB26A)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
