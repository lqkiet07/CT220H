import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user.dart'; // Model User của bạn

class UserRepositoryImpl implements UserRepository {
  // Gọi "nhân viên" Auth và "nhà kho" Firestore của Firebase ra làm việc
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserRepositoryImpl(); // Không cần truyền ApiService hay SharedPreferences nữa

  @override
  Future<bool> login(String email, String password) async {
    try {
      // Firebase lo hết việc kiểm tra email/pass
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      throw Exception('Sai email hoặc mật khẩu!');
    }
  }

  @override
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      // 1. Tạo tài khoản trên hệ thống Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: userData['email'],
        password: userData['password'],
      );

      // 2. Tạo thành công thì lưu thêm thông tin (tên, role) vào Database
      if (credential.user != null) {
        await _firestore.collection('users').doc(credential.user!.uid).set({
          'uid': credential.user!.uid,
          'email': userData['email'],
          'fullName': userData['fullName'] ?? 'Khách hàng',
          'role': 'user', // Mặc định ai đăng ký cũng là user thường
          'createdAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Lỗi đăng ký: Tài khoản có thể đã tồn tại.');
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      // Lấy user đang đăng nhập hiện tại
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('Chưa đăng nhập');

      // Chạy vào Firestore lấy thông tin chi tiết của user này ra
      final doc = await _firestore.collection('users').doc(currentUser.uid).get();

      if (doc.exists && doc.data() != null) {
        return User.fromJson(doc.data()!);
      } else {
        throw Exception('Không tìm thấy thông tin hồ sơ');
      }
    } catch (e) {
      throw Exception('Lỗi tải hồ sơ: $e');
    }
  }
}