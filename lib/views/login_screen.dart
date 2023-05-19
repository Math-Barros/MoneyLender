import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moneylender/views/home_screen.dart';
import 'package:moneylender/views/register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

bool _wrongEmail = false;
bool _wrongPassword = false;

class LoginPage extends StatefulWidget {
  static String id = '/LoginPage';
  final GoogleSignIn googleSignIn;

  LoginPage({required this.googleSignIn});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;

  bool _showSpinner = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> _handleSignIn() async {
    bool isSignedIn = await widget.googleSignIn.isSignedIn();
    if (isSignedIn) {
      return _auth.currentUser;
    } else {
      final GoogleSignInAccount? googleUser =
          await widget.googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    }
  }

  void onGoogleSignIn(BuildContext context) async {
    setState(() {
      _showSpinner = true;
    });

    User? user = await _handleSignIn();

    setState(() {
      _showSpinner = false;
    });

    if (user != null) {
      Navigator.pushNamed(context, HomeScreen.id, arguments: user);
    }
  }

  String emailText = 'Email doesn\'t match';
  String passwordText = 'Password doesn\'t match';

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
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 50.0, color: Color(0xFFCBB26A)),
                  ),
                  const SizedBox(height: 20.0),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style:
                            TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
                      ),
                      
                      Text(
                        'please login to your account.',
                        style:
                            TextStyle(fontSize: 25.0, color: Color(0xFFCBB26A)),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20.0),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Color(0xFFCBB26A)),
                          labelStyle: const TextStyle(color: Color(0xFFCBB26A)),
                          labelText: 'Email',
                          errorText: _wrongEmail ? emailText : null,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Color(0xFFCBB26A)),
                          labelStyle: const TextStyle(color: Color(0xFFCBB26A)),
                          labelText: 'Password',
                          errorText: _wrongPassword ? passwordText : null,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                            setState(() {
                              _wrongEmail = false;
                              _wrongPassword = false;
                            });
                            final newUser =
                                await _auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            if (newUser != null) {
                              Navigator.pushNamed(context, HomeScreen.id,
                                  arguments: newUser.user);
                            }
                          } catch (e) {
                            print(e.toString());
                            if (e.toString() == 'ERROR_WRONG_PASSWORD') {
                              setState(() {
                                _wrongPassword = true;
                              });
                            } else {
                              setState(() {
                                emailText = 'User doesn\'t exist';
                                passwordText = 'Please check your email';

                                _wrongPassword = true;
                                _wrongEmail = true;
                              });
                            }
                          } finally {
                            setState(() {
                              _showSpinner = false;
                            });
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 1.0,
                              width: 60.0,
                              color: const Color(0xFFCBB26A),
                            ),
                          ),
                          const Text(
                            'Or',
                            style: TextStyle(
                                fontSize: 25.0, color: Color(0xFFCBB26A)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 1.0,
                              width: 60.0,
                              color: const Color(0xFFCBB26A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

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
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: 20.0), // Espaçamento adicionado aqui
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          ' Register now',
                          style: TextStyle(
                              fontSize: 20.0, color: Color(0xFFCBB26A)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_showSpinner)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
