import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? profileImageUrl;
  String defaultProfileImageUrl = 'assets/images/user.png';

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrl();
    _nameController.text = widget.user?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileImage(),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: const Text('Update Profile'),
            ),
            if (_isEmailUser())
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: const Text('Change Password'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CircleAvatar(
            radius: 75,
            backgroundImage: profileImageUrl != null
                ? NetworkImage(profileImageUrl!)
                : AssetImage(defaultProfileImageUrl) as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Container(
                  padding: const EdgeInsets.all(2),
                  color: const Color.fromRGBO(19, 42, 101, 1.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 16,
                    ),
                    onPressed: _selectProfileImage,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectProfileImage() async {
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

  void _updateProfile() async {
    String name = _nameController.text.trim();

    try {
      await widget.user!.updateProfile(displayName: name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user?.uid)
          .update({'name': name});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $error')),
        );
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
        if (widget.user?.photoURL != null) {
          setState(() {
            profileImageUrl = widget.user!.photoURL;
          });
        } else {
          setState(() {
            profileImageUrl = defaultProfileImageUrl;
          });
        }
      }
    }
  }

  bool _isEmailUser() {
    return widget.user?.providerData.any((info) => info.providerId == 'password') ?? false;
  }

  void _changePassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.user!.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending password reset email: $error')),
      );
    }
  }
}
