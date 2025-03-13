/// Stateless widget containing the text fields for user input during registration.
library;
import 'package:flutter/material.dart';

class RegisterTextFields extends StatelessWidget {
  final Function(String) onNameChanged;
  final Function(String) onEmailChanged;
  final Function(String) onPasswordChanged;
  final bool wrongEmail;
  final String emailText;

  const RegisterTextFields({
    super.key,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.wrongEmail,
    required this.emailText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          onChanged: onNameChanged,
          decoration: const InputDecoration(
            labelText: 'Name',
            labelStyle: TextStyle(color: Color(0xFFCBB26A)),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          onChanged: onEmailChanged,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: wrongEmail ? emailText : null,
            labelStyle: const TextStyle(color: Color(0xFFCBB26A)),
            errorStyle: const TextStyle(color: Colors.red),
          ),
        ),
        const SizedBox(height: 20.0),
        TextField(
          style: const TextStyle(color: Colors.white),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          onChanged: onPasswordChanged,
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Color(0xFFCBB26A)),
          ),
        ),
      ],
    );
  }
}
