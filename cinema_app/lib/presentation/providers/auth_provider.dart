import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/repositories/user_repository.dart';
import '../../data/models/user.dart';

class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  AuthProvider(this._userRepository) {
    // Kiểm tra trạng thái đăng nhập khi khởi tạo
    _checkCurrentUser();
  }

  bool _isLoggedIn = false;
  User? _currentUser;
  bool _isAdmin = false;
  bool _isLoading = false;
  String _error = '';

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  String get userName => _currentUser?.name ?? 'Khách';
  String get userAvatar => 'https://ui-avatars.com/api/?name=${userName}&background=random';
  String get userEmail => _currentUser?.email ?? '';
  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;
  String get error => _error;

  void _checkCurrentUser() async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    try {
      _currentUser = await _userRepository.getProfile();
      _isLoggedIn = true;
      // Logic phân quyền Admin đơn giản: check email
      _isAdmin = _currentUser?.email == 'admin@gmail.com';
      notifyListeners();
    } catch (e) {
      _isLoggedIn = false;
      _currentUser = null;
      _isAdmin = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final success = await _userRepository.login(email, password);
      if (success) {
        await fetchProfile();
      }
      return success;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final success = await _userRepository.register({
        'name': name,
        'email': email,
        'password': password,
      });
      return success;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await firebase_auth.FirebaseAuth.instance.signOut();
    _isLoggedIn = false;
    _currentUser = null;
    _isAdmin = false;
    notifyListeners();
  }
}
