import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../controllers/auth_controller.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/login/divider_with_text.dart';
import 'widgets/login/email_text_field.dart';
import 'widgets/login/forgot_password_button.dart';
import 'widgets/login/google_sign_in_button.dart';
import 'widgets/login/login_button.dart';
import 'widgets/login/password_text_field.dart';
import 'widgets/login/register_text.dart';
import 'widgets/login/welcome_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = AuthController();
  late String email;
  late String password;

  bool _showSpinner = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Criando a instância aqui

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 130,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  Color(0xFFCBB26A),
                  BlendMode.srcATop,
                ),
                child: Transform.scale(
                  scale: 0.5,
                  child: Image.asset('assets/images/logo.jpg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 60.0,
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const WelcomeText(),
                  const SizedBox(height: 20.0),
                  EmailTextField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                        _wrongEmail = false;
                      });
                    },
                    errorText: _wrongEmail ? 'Email doesn\'t match' : null,
                  ),
                  const SizedBox(height: 20.0),
                  PasswordTextField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        _wrongPassword = false;
                      });
                    },
                    errorText:
                        _wrongPassword ? 'Password doesn\'t match' : null,
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: ForgotPasswordButton(),
                  ),
                  const SizedBox(height: 30.0),
                  LoginButton(
                    onPressed: () async {
                      setState(() {
                        _showSpinner = true;
                      });

                      await _authController.loginWithEmailAndPassword(
                          context, email, password);

                      setState(() {
                        _showSpinner = false;
                      });
                    },
                  ),
                  const SizedBox(height: 20.0),
                  const DividerWithText(),
                  const SizedBox(height: 20.0),
                  const GoogleSignInButton(), // Passando a instância criada
                  const SizedBox(height: 20.0),
                  const RegisterText(),
                ],
              ),
            ),
            _showSpinner ? const LoadingIndicator() : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
