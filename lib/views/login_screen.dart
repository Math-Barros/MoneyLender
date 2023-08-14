import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneylender/views/forgot_password.dart';
import 'package:moneylender/views/home_screen.dart';
import 'package:moneylender/views/register_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const LoginPage({Key? key, required this.googleSignIn}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;

  bool _showSpinner = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                  _buildHeaderText(),
                  const SizedBox(height: 20.0),
                  _buildWelcomeText(),
                  _buildEmailTextField(),
                  const SizedBox(height: 20.0),
                  _buildPasswordTextField(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: _buildForgotPasswordButton(),
                  ),
                  const SizedBox(height: 30.0),
                  _buildLoginButton(),
                  const SizedBox(height: 20.0),
                  _buildDivider(),
                  const SizedBox(height: 20.0),
                  _buildGoogleSignInButton(),
                  const SizedBox(height: 20.0),
                  _buildRegisterText(),
                ],
              ),
            ),
            _showSpinner ? _buildLoadingIndicator() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return const Text(
      'Login',
      style: TextStyle(fontSize: 50.0, color: Color(0xFFCBB26A)),
    );
  }

  Widget _buildWelcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back,',
          style: TextStyle(fontSize: 30.0, color: Color(0xFFCBB26A)),
        ),
        Text(
          'please login to your account.',
          style: TextStyle(fontSize: 25.0, color: Color(0xFFCBB26A)),
        ),
      ],
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
        hintStyle: const TextStyle(color: Color(0xFFCBB26A)),
        labelStyle: const TextStyle(color: Color(0xFFCBB26A)),
        labelText: 'Email',
        errorText: _wrongEmail ? 'Email doesn\'t match' : null,
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      obscureText: true,
      onChanged: (value) {
        setState(() {
          password = value;
          _wrongPassword = false;
        });
      },
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Color(0xFFCBB26A)),
        labelStyle: const TextStyle(color: Color(0xFFCBB26A)),
        labelText: 'Password',
        errorText: _wrongPassword ? 'Password doesn\'t match' : null,
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPassword(),
          ),
        );
      },
      child: const Text(
        'Forgot your password?',
        style: TextStyle(fontSize: 20.0, color: Color(0xFFCBB26A)),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        backgroundColor: const Color(0xFFCBB26A),
      ),
      onPressed: _onLoginButtonPressed,
      child: const Text(
        'Login',
        style: TextStyle(fontSize: 25.0, color: Colors.white),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: 60.0,
            color: const Color(0xFFCBB26A),
          ),
        ),
        const Text(
          'Or',
          style: TextStyle(fontSize: 25.0, color: Color(0xFFCBB26A)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            height: 1.0,
            width: 60.0,
            color: const Color(0xFFCBB26A),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return ElevatedButton(
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
    );
  }

  Widget _buildRegisterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don\'t have an account?',
          style: TextStyle(fontSize: 20.0, color: Colors.white),
        ),
        GestureDetector(
          onTap: _navigateToRegisterPage,
          child: const Text(
            ' Register now',
            style: TextStyle(fontSize: 20.0, color: Color(0xFFCBB26A)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _onLoginButtonPressed() async {
    setState(() {
      _showSpinner = true;
    });

    try {
      setState(() {
        _wrongEmail = false;
        _wrongPassword = false;
      });

      final newUser = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (newUser.user != null) {
        final googleSignInAccount = await widget.googleSignIn.signIn();
        if (googleSignInAccount != null) {
          await _saveUserData(
            newUser.user!,
            googleSignInAccount.displayName ?? '',
            googleSignInAccount.email ?? '',
          );
        }

        _navigateToHomeScreen(newUser.user!);
      }
    } catch (e) {
      if (e.toString() == 'ERROR_WRONG_PASSWORD') {
        setState(() {
          _wrongPassword = true;
        });
      } else {
        setState(() {
          _wrongEmail = true;
          _wrongPassword = true;
        });
      }
    } finally {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  Future<void> onGoogleSignIn(BuildContext context) async {
    User? user = await _handleSignIn();

    if (user != null) {
      final googleSignInAccount = await widget.googleSignIn.signIn();
      if (googleSignInAccount != null) {
        await _saveUserData(
          user,
          googleSignInAccount.displayName ?? '',
          googleSignInAccount.email,
        );

        _navigateToHomeScreen(user);
      }
    }
  }

  Future<User?> _handleSignIn() async {
    User? user;

    bool isSignedIn = await widget.googleSignIn.isSignedIn();
    if (isSignedIn) {
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount? googleUser =
          await widget.googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        user = (await _auth.signInWithCredential(credential)).user;
        if (user != null) {
          await _saveUserData(
            user,
            googleUser.displayName ?? '',
            googleUser.email,
          );
        }
      }
    }

    return user;
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

  void _navigateToHomeScreen(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomeScreen(user: user, googleSignIn: widget.googleSignIn),
      ),
    );
  }

  void _navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(googleSignIn: widget.googleSignIn),
      ),
    );
  }
}
