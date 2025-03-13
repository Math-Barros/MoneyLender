import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../views/home_page.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final GoogleSignIn googleSignIn = GoogleSignIn(); // Criando a instância aqui

  Future<void> loginWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      }
    } catch (e) {
      print("Login error: $e");
      // handle error
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      final User? user = await _authService.signInWithGoogle(googleSignIn);
      if (user != null) {
        await _authService.saveGoogleUserData(
            user, user.displayName ?? '', user.email ?? '');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      }
    } catch (e) {
      print("Google login error: $e");
      // handle error
    }
  }
}
