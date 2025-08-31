import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Uncomment when implementing Firebase Auth
import 'package:shared_preferences/shared_preferences.dart'; // For guest status

enum AuthStatus { unknown, authenticated, unauthenticated, guest }

class AuthProvider with ChangeNotifier {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; // Uncomment for Firebase
  AuthStatus _status = AuthStatus.unknown;
  // User? _user; // Uncomment for Firebase

  AuthStatus get status => _status;
  // User? get user => _user; // Uncomment for Firebase
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isGuest => _status == AuthStatus.guest;

  AuthProvider() {
    // In a real app, you would check persisted login status here
    // For prototype, we'll start as unknown, then move to unauthenticated
    Future.delayed(const Duration(milliseconds: 100), () {
       // Simulate checking stored token or guest status
      _checkCurrentUser();
    });
  }

  Future<void> _checkCurrentUser() async {
    // Simulate: if (await _isGuestUser()) { _status = AuthStatus.guest; } else ...
    // _user = _firebaseAuth.currentUser;
    // if (_user != null) {
    //   _status = AuthStatus.authenticated;
    // } else {
    _status = AuthStatus.unauthenticated; // Default to unauthenticated for prototype
    // }
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // Implement Google Sign-In logic here using firebase_auth
    // For prototype: simulate login
    _status = AuthStatus.authenticated;
    // _user = User(...); // mock user
    notifyListeners();
    print("Simulating Sign in with Google");
  }

  Future<void> continueAsGuest() async {
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isGuest', true);
    _status = AuthStatus.guest;
    notifyListeners();
    print("Continuing as Guest");
  }

  Future<void> signOut() async {
    // await _firebaseAuth.signOut();
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('isGuest');
    // _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
    print("Simulating Sign Out");
  }

  // Example method to simulate loading user preferences if any
  List<String> get userInterests => ['AI', 'Physics']; // Placeholder
}
