import 'package:flutter/material.dart';

class ForgotPasswordForm extends StatelessWidget {
  final Function(String) onResetPassword;

  const ForgotPasswordForm({super.key, required this.onResetPassword});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text(
          'Reset Password',
          style: TextStyle(fontSize: 40.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your email',
              style: TextStyle(fontSize: 30.0),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            backgroundColor: const Color(0xff447def),
          ),
          onPressed: () {
            final email = emailController.text.trim();
            onResetPassword(email);
          },
          child: const Text(
            'Reset Password',
            style: TextStyle(fontSize: 25.0, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
