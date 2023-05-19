import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  static const String id = '/home';

  final User? user;
  final GoogleSignIn googleSignIn;

  const HomeScreen({required this.user, required this.googleSignIn});

  void _handleSignOut(BuildContext context) async {
    if (user != null) {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user?.photoURL != null)
              ClipOval(
                child: Image.network(
                  user!.photoURL!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16.0),
            if (user?.displayName != null)
              Text(
                user!.displayName!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
