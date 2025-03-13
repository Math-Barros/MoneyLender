import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController {
  final User? user;
  String? profileImageUrl;
  String? displayName;

  EditProfileController({required this.user});

  Future<void> fetchProfileData() async {
    if (user != null) {
      displayName = user!.displayName ?? '';
      try {
        profileImageUrl = await FirebaseStorage.instance
            .ref('profile_images/${user!.uid}.jpg')
            .getDownloadURL();
      } catch (e) {
        profileImageUrl = null;
      }
    }
  }

  Future<void> selectProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user?.uid}.jpg');
      final uploadTask = storageRef.putFile(File(pickedImage.path));

      await uploadTask;
      profileImageUrl = await storageRef.getDownloadURL();
    }
  }

  Future<void> updateProfile(String name) async {
    if (user != null) {
      await user!.updateProfile(displayName: name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'name': name});
    }
  }

  Future<void> changePassword() async {
    if (user != null && user!.email != null) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: user!.email!);
    }
  }

  bool get isEmailUser => user?.providerData.any((info) => info.providerId == 'password') ?? false;
}
