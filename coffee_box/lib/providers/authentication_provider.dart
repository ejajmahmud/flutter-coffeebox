import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_box/screens/home_screen.dart';
import 'package:coffee_box/screens/starting_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? userName;
  String? userAddress;
  String? userPhoneNumber;
  String? userEmail;
  String _customerId = '';
  static const String createCustomerUrl =
      'http://192.168.0.14:8080/api/customers';
  User? get user => _user;
  String get customerId => _customerId;

  AuthProvider() {
    _loadUserFromPreferences();
  }

  Future<void> _loadUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      _user = _auth.currentUser;
      await fetchUserData();
      notifyListeners();
    }
  }

  Future<void> _saveUserToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_user != null) {
      await prefs.setString('userId', _user!.uid);
    }
  }

  Future<void> _clearUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      await _saveUserToPreferences();
      notifyListeners();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } catch (e) {
      print("Failed to sign in: $e");
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email,
      String password,
      String name,
      String address,
      String phoneNumber,
      BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      await FirebaseFirestore.instance.collection('Users').doc(_user?.uid).set({
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
        'email': email,
      });

      _customerId = await createCustomer(
        email: email,
        address: address,
        firstName: name.split(' ').first,
        lastName: name.split(' ').last,
      );

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_user?.uid)
          .update({
        'customerId': _customerId,
      });

      await _saveUserToPreferences();
      notifyListeners();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } catch (e) {
      print("Failed to sign up: $e");
    }
  }

  Future<String> createCustomer({
    required String email,
    required String address,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(createCustomerUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'idempotencyKey': DateTime.now().millisecondsSinceEpoch.toString(),
          'emailAddress': email,
          'addressLine1': address,
          'country': 'RS',
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody['id'] as String;
      } else {
        print('Failed to create customer: ${response.body}');
        return '';
      }
    } catch (e) {
      print('Exception creating customer: $e');
      return '';
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    _user = null;
    await _clearUserFromPreferences();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => StartingScreen()),
      (route) => false,
    );
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(_user!.uid)
            .get();
        if (userDoc.exists) {
          userName = userDoc['name'];
          userAddress = userDoc['address'];
          userPhoneNumber = userDoc['phoneNumber'];
          userEmail = userDoc['email'];
          _customerId = userDoc['customerId'];
          notifyListeners();
        }
      } catch (e) {
        print("Failed to fetch user data: $e");
      }
    } else {
      print("No user is currently logged in.");
    }
  }
}
