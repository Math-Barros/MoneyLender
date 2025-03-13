import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final User? user;

  ProfileService({this.user});

  Future<Map<String, dynamic>> fetchUserData() async {
    Map<String, dynamic> userData = {};

    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        userData = snapshot.data() as Map<String, dynamic>;
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }

    return userData;
  }

  Future<String> fetchProfileImageUrl() async {
    String profileImageUrl = '';

    if (user != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user?.uid}.jpg');

      try {
        profileImageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print("Error fetching profile image URL: $e");
        profileImageUrl = user!.photoURL ?? '';
      }
    }

    return profileImageUrl;
  }
}
