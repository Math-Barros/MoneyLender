// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneylender/views/friend_list_screen.dart';
import 'package:moneylender/views/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;
  final GoogleSignIn googleSignIn;

  const ProfileScreen(
      {Key? key, required this.user, required this.googleSignIn})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profileImageUrl;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            if (profileImageUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageUrl!),
              ),
            const SizedBox(height: 16.0),
            Text(
              widget.user?.displayName ?? '',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _selectProfileImage(context),
              child: const Text('Selecionar Imagem de Perfil'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _handleSignOut(context),
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: const Color.fromRGBO(19, 42, 101, 1.0),
        color: const Color(0xFFCBB26A),
        buttonBackgroundColor: const Color(0xFFCBB26A),
        height: 50,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              _navigateToHome(context);
            } else if (index == 2) {
              _navigateToFriendList(context);
            }
          });
        },
        items: const <Widget>[
          Icon(Icons.home, color: Color.fromRGBO(19, 42, 101, 1.0)),
          Icon(Icons.person, color: Color.fromRGBO(19, 42, 101, 1.0)),
          Icon(Icons.people, color: Color.fromRGBO(19, 42, 101, 1.0)),
        ],
      ),
    );
  }

  Future<void> _selectProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${widget.user?.uid}.jpg');
      final uploadTask = storageRef.putFile(File(pickedImage.path));

      try {
        await uploadTask;
        final imageUrl = await storageRef.getDownloadURL();
        setState(() {
          profileImageUrl = imageUrl;
        });
      } catch (e) {
        print("Error uploading or fetching profile image URL: $e");
      }
    }
  }

  Future<void> _fetchProfileImageUrl() async {
    if (widget.user != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${widget.user?.uid}.jpg');

      try {
        final imageUrl = await storageRef.getDownloadURL();
        setState(() {
          profileImageUrl = imageUrl;
        });
      } catch (e) {
        print("Error fetching profile image URL: $e");
        // Se a imagem não estiver disponível no Storage, tenta obter a imagem do perfil do Google
        if (widget.user?.photoURL != null) {
          setState(() {
            profileImageUrl = widget.user!.photoURL;
          });
        }
      }
    }
  }

  void _handleSignOut(BuildContext context) async {
    if (widget.user != null) {
      if (await widget.googleSignIn.isSignedIn()) {
        await widget.googleSignIn.signOut();
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _navigateToFriendList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendListScreen(userId: widget.user!.uid),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomeScreen(user: widget.user, googleSignIn: widget.googleSignIn),
      ),
    );
  }
}
