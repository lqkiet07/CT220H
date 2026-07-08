import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userAvatar = '';
  String _userEmail = '';

  bool _isAdmin = false;

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userAvatar => _userAvatar;
  String get userEmail => _userEmail;
  bool get isAdmin => _isAdmin;

  // Mock login method
  Future<void> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Assign mock data
    _isLoggedIn = true;
    _userEmail = email;
    
    // Admin authentication check
    if (email == 'admin@gmail.com' && password == 'admin123') {
      _isAdmin = true;
      _userName = 'Quản trị viên';
      _userAvatar = 'https://ui-avatars.com/api/?name=Admin&background=B00710&color=fff';
    } else {
      _isAdmin = false;
      // Extract name from email (e.g., kiemthe@gmail.com -> Kiemthe)
      _userName = email.split('@')[0];
      _userName = _userName[0].toUpperCase() + _userName.substring(1); 
      _userAvatar = 'https://i.pravatar.cc/150?u=$email'; // Random avatar based on email
    }

    notifyListeners();
  }

  // Logout user and clear data
  void logout() {
    _isLoggedIn = false;
    _isAdmin = false;
    _userName = '';
    _userAvatar = '';
    _userEmail = '';
    notifyListeners();
  }
}
