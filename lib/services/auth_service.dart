import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> registerWithEmailAndPassword(String email, String password, String name) async {
    if (!_isValidEmail(email)) {
      throw Exception('Please enter a valid email address.');
    }
    if (!_isValidPassword(password)) {
      throw Exception('Please enter a password with at least 6 characters.');
    }

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        await updateDisplayName(user, name);
        final userModel = UserModel(uid: user.uid, name: name, email: email);
        await saveUserData(user, userModel);
      }
      return user;
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
        throw Exception('The email address is already in use by another account');
      } else {
        throw Exception('Failed to register user: $e');
      }
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw Exception('Failed to sign in with email and password: $e');
    }
  }

  Future<User?> signInWithGoogle(GoogleSignIn googleSignIn) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        return userCredential.user;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  Future<void> updateDisplayName(User user, String name) async {
    try {
      await user.updateDisplayName(name);
    } catch (e) {
      throw Exception('Failed to update display name: $e');
    }
  }

  Future<void> saveUserData(User user, UserModel userModel) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      await userRef.set(userModel.toMap());
    } catch (e) {
      throw Exception('Failed to save user data: $e');
    }
  }

  Future<void> saveGoogleUserData(User user, String name, String email) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      final DocumentSnapshot userSnapshot = await userRef.get();
      if (!userSnapshot.exists) {
        await userRef.set({
          'name': name,
          'email': email,
          'friends': [],
        });
      }
    } catch (e) {
      throw Exception('Failed to save Google user data: $e');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}
