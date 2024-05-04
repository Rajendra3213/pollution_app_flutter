import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<bool> signIn(String username, String password) async {
    // Simulated login logic
    await Future.delayed(const Duration(seconds: 2));

    if (username == 'username' && password == 'password') {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void signOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
