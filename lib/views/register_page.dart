import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../controllers/auth_controller.dart';
import 'widgets/loading_indicator.dart'; // Importe o AuthController

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String name = '';
  late String email = '';
  late String password = '';

  bool _showSpinner = false;
  bool _wrongEmail = false;

  String _emailText = 'Please use a valid email';

  final AuthService _authService = AuthService();
  final AuthController _authController =
      AuthController(); // Instância do AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      resizeToAvoidBottomInset: false,
      body: Stack(
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
          const Padding(
            padding: EdgeInsets.only(
              top: 60.0,
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Widgets de registro
              ],
            ),
          ),
          _showSpinner ? const LoadingIndicator() : const SizedBox(),
        ],
      ),
    );
  }

  void _onRegisterButtonPressed() async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return;
    }

    setState(() {
      _showSpinner = true;
    });

    try {
      await _authService.registerWithEmailAndPassword(email, password, name);

      setState(() {
        name = '';
        email = '';
        password = '';
      });

      _loginAndNavigateToHome(); // Alterado para chamar o método _loginAndNavigateToHome
    } on Exception catch (e) {
      setState(() {
        _wrongEmail = true;
        if (e.toString().contains('email-already-in-use')) {
          _emailText = 'The email address is already in use by another account';
        }
      });
    }

    setState(() {
      _showSpinner = false;
    });
  }

  void _loginAndNavigateToHome() async {
    try {
      await _authController.loginWithEmailAndPassword(context, email, password);
      // Se o login for bem-sucedido, a navegação para a página inicial é tratada no AuthController
    } catch (e) {
      print("Login error: $e");
      // Lidar com o erro de login
    }
  }
}
