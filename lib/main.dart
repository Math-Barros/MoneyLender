import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Importe o pacote 'google_sign_in.dart'
import 'package:moneylender/views/home_screen.dart';
import 'package:moneylender/views/login_screen.dart';
import 'package:moneylender/views/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Lender',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Abel'
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(googleSignIn: googleSignIn),
        RegisterPage.id: (context) => RegisterPage(googleSignIn: googleSignIn),
        HomeScreen.id: (context) =>
            HomeScreen(user: null, googleSignIn: GoogleSignIn()),
      },
    );
  }
}
