import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userAvatar = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userAvatar => _userAvatar;
  String get userEmail => _userEmail;

  // Giả lập Đăng nhập
  Future<void> login(String email, String password) async {
    // Đợi 1 chút giả lập mạng (1.5s)
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Gán dữ liệu ảo
    _isLoggedIn = true;
    _userEmail = email;
    // Bóc tách tên từ Email (VD: kiemthe@gmail.com -> Tên: Kiemthe)
    _userName = email.split('@')[0];
    _userName = _userName[0].toUpperCase() + _userName.substring(1); 
    _userAvatar = 'https://i.pravatar.cc/150?u=$email'; // Avatar ngẫu nhiên theo email

    notifyListeners();
  }

  // Đăng xuất
  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userAvatar = '';
    _userEmail = '';
    notifyListeners();
  }
}
