import 'package:flutter/material.dart';
import '../../../controllers/auth_controller.dart';

/// Classe responsável por exibir o botão de login com Google.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        backgroundColor: const Color(0xFFCBB26A),
      ),
      onPressed: () async {
        final AuthController authController = AuthController();
        await authController.loginWithGoogle(context);
      },
      child: const Text(
        'Sign in with Google',
        style: TextStyle(fontSize: 25.0, color: Colors.white),
      ),
    );
  }
}
