import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:moneylender/views/widgets/login/forgot_password_form.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final ForgotPasswordController _controller = ForgotPasswordController();

  void _handleResetPassword(BuildContext context, String email) async {
    try {
      await _controller.resetPassword(email);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Email Enviado ✈️',
        desc: 'Verifique seu email para redefinir sua senha!',
        btnOkOnPress: () {},
      ).show();
    } catch (error) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Erro',
        desc: error.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ForgotPasswordForm(onResetPassword: (email) {
          _handleResetPassword(context, email);
        }),
      ),
    );
  }
}
