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
import 'package:moneylender/views/profile_screen.dart'; // Import the ProfileScreen class
import 'package:moneylender/views/edit_event_screen.dart'; // Import the EditEventScreen class

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
        EventDetailsScreen.id: (context) => EventDetailsScreen(
              eventId: 'my events',
              eventPassword: 'password', // Add a sample password
              user: currentUser!, // Pass the current user
            ),
        AddEventScreen.id: (context) => AddEventScreen(
            user: currentUser!), // Pass the current user to AddEventScreen
        EditEventScreen.id: (context) => EditEventScreen(
            eventId: 'my events', // Add a sample event ID
            eventPassword: 'password', // Add a sample password
            user: currentUser!), // Pass the current user to EditEventScreen
        FriendListScreen.id: (context) => FriendListScreen(
            userId: currentUser?.uid ??
                ''), // Pass the ID of the current user to FriendListScreen
        ProfileScreen.id: (context) => ProfileScreen(
            user: currentUser,
            googleSignIn: googleSignIn), // Add the route for ProfileScreen
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
