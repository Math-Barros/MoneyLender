// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/views/login_screen.dart';
import 'package:validators/validators.dart' as validator;
import 'package:moneylender/views/home_screen.dart';

class RegisterPage extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const RegisterPage({required this.googleSignIn});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String email = '';
  late String password = '';

  bool _showSpinner = false;
  bool _wrongEmail = false;

  String _emailText = 'Please use a valid email';
  final String _passwordText = 'Please use a strong password';

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
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 50.0, color: Color(0xFFCBB26A)),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lets get',
                      style:
                          TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
                    ),
                    Text(
                      'you on board.',
                      style:
                          TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
                    ),
                  ],
                ),
                Column(
                  children: [
                    TextField(
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
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
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
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    backgroundColor: const Color(0xFFCBB26A),
                  ),
                  onPressed: () async {
                    setState(() {
                      _showSpinner = true;
                    });

                    try {
                      if (validator.isEmail(email) &&
                          validator.isLength(password, 6)) {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              user: newUser.user!,
                              googleSignIn: widget.googleSignIn,
                            ),
                          ),
                        );
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
                          _emailText =
                              'The email address is already in use by another account';
                        }
                      });
                    }

                    setState(() {
                      _showSpinner = false;
                    });
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    onGoogleSignIn(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(googleSignIn: widget.googleSignIn),
                          ),
                        );
                      },
                      child: const Text(
                        ' Sign In',
                        style:
                            TextStyle(fontSize: 20.0, color: Color(0xFFCBB26A)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _showSpinner
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Future<User?> _handleSignIn() async {
    User? user;
    bool isSignedIn = await widget.googleSignIn.isSignedIn();
    if (isSignedIn) {
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount? googleUser =
          await widget.googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      user = (await _auth.signInWithCredential(credential)).user;
    }

    return user;
  }

  Future<void> onGoogleSignIn(BuildContext context) async {
    User? user = await _handleSignIn();
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(user: user, googleSignIn: widget.googleSignIn),
        ),
      );
    }
  }
}
