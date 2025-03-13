import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("O email não pode estar vazio.");
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (error) {
      throw Exception("Erro ao enviar o email de redefinição: $error");
    }
  }
}