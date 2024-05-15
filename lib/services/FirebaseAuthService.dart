// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential;
    } catch (_) {}
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (_) {}
    return null;
  }

  void signOut() async {
    _auth.signOut();
  }

  void deleteUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      currentUser.delete();
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}