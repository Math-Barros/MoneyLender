import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/views/login_screen.dart';
import 'package:validators/validators.dart' as validator;
import 'package:moneylender/views/home_screen.dart';

class RegisterPage extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const RegisterPage({super.key, required this.googleSignIn});

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                _buildHeaderText(),
                _buildNameTextField(),
                const SizedBox(height: 20.0),
                _buildEmailTextField(),
                const SizedBox(height: 20.0),
                _buildPasswordTextField(),
                const SizedBox(height: 10.0),
                _buildRegisterButton(),
                _buildSignInText(),
                const SizedBox(),
              ],
            ),
          ),
          _showSpinner ? _buildLoadingIndicator() : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildHeaderText() {
    // ignore: prefer_const_constructors
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Register',
          style: TextStyle(fontSize: 50.0, color: Color(0xFFCBB26A)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lets get',
              style: TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
            ),
            Text(
              'you on board.',
              style: TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNameTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.text,
      onChanged: (value) {
        setState(() {
          name = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(color: Color(0xFFCBB26A)),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onChanged: (value) {
        setState(() {
          email = value;
          _wrongEmail = false;
        });
      },
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: _wrongEmail ? _emailText : null,
        labelStyle: const TextStyle(color: Color(0xFFCBB26A)),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) {
        setState(() {
          password = value;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Color(0xFFCBB26A)),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        backgroundColor: const Color(0xFFCBB26A),
      ),
      onPressed: _onRegisterButtonPressed,
      child: const Text(
        'Register',
        style: TextStyle(fontSize: 25.0, color: Colors.white),
      ),
    );
  }

  Widget _buildSignInText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        GestureDetector(
          onTap: _navigateToLoginPage,
          child: const Text(
            ' Sign In',
            style: TextStyle(fontSize: 20.0, color: Color(0xFFCBB26A)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
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
      if (validator.isEmail(email) && validator.isLength(password, 6)) {
        final UserCredential newUserCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await newUserCredential.user!.updateDisplayName(name);
        await _saveUserData(newUserCredential.user!, name, email);

        setState(() {
          name = '';
          email = '';
          password = '';
        });

        _navigateToHome(newUserCredential.user!);
      } else {
        setState(() {
          if (!validator.isEmail(email)) {
            _wrongEmail = true;
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _wrongEmail = true;
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          _emailText = 'The email address is already in use by another account';
        }
      });
    } catch (e) {
      print("Error during registration: $e");
    }

    setState(() {
      _showSpinner = false;
    });
  }

  Future<void> _saveUserData(User user, String name, String email) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      await userRef.set({
        'name': name,
        'email': email,
        'friends': [],
      });
    }
  }

  void _navigateToLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(googleSignIn: widget.googleSignIn),
      ),
    );
  }

  void _navigateToHome(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomeScreen(user: user, googleSignIn: widget.googleSignIn),
      ),
    );
  }
}
