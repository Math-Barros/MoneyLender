// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moneylender/views/add_event_screen.dart';
import 'package:moneylender/views/event_details_screen.dart';
import 'package:moneylender/views/home_screen.dart';
import 'package:moneylender/views/login_screen.dart';
import 'package:moneylender/views/register_screen.dart';
import 'package:moneylender/views/friend_list_screen.dart';
import 'package:moneylender/views/profile_screen.dart'; // Importe a classe ProfileScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'Money Lender',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Abel',
      ),
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(googleSignIn: googleSignIn),
        RegisterPage.id: (context) => RegisterPage(googleSignIn: googleSignIn),
        HomeScreen.id: (context) =>
            HomeScreen(user: currentUser, googleSignIn: googleSignIn),
        EventDetailsScreen.id: (context) =>
            const EventDetailsScreen(eventId: 'my events'),
        AddEventScreen.id: (context) => AddEventScreen(
            user: currentUser!), // Passe o usuário atual para AddEventScreen
        FriendListScreen.id: (context) => FriendListScreen(
            userId: currentUser?.uid ??
                ''), // Passe o ID do usuário atual para FriendListScreen
        ProfileScreen.id: (context) => ProfileScreen(
            user: currentUser,
            googleSignIn: googleSignIn), // Adicione a rota para ProfileScreen
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Página não encontrada'),
            ),
          ),
        );
      },
    );
  }
}
