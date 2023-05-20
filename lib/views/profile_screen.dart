import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = '/profile';

  final User? user;
  final GoogleSignIn googleSignIn;

  const ProfileScreen({required this.user, required this.googleSignIn});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (profileImageUrl != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageUrl!),
              ),
            const SizedBox(height: 16.0),
            Text(
              'ID do usuário: ${widget.user?.uid ?? ''}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Nome do usuário: ${widget.user?.displayName ?? ''}',
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
    );
  }

  Future<void> _selectProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/${widget.user?.uid}.jpg');
      final uploadTask = storageRef.putFile(File(pickedImage.path));

      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        profileImageUrl = imageUrl;
      });
    }
  }

  void _handleSignOut(BuildContext context) async {
    if (widget.user != null) {
      if (await widget.googleSignIn.isSignedIn()) {
        await widget.googleSignIn.signOut();
      }
      Navigator.pop(context);
    }
  }
}
