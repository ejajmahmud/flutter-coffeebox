import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Error signing in: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
