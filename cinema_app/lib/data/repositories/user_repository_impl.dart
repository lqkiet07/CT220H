import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user.dart';
import '../remote/api_service.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;
  final SharedPreferences _prefs; // Dùng để lưu Token cục bộ

  UserRepositoryImpl(this._apiService, this._prefs);

  @override
  Future<bool> login(String email, String password) async {
    try {
      // Gọi API đăng nhập (Giả sử bạn đã thêm api login vào api_service.dart)
      final response = await _apiService.login({'email': email, 'password': password});

      if (response.isSuccessful) {
        final data = response.body;
        // Lấy token từ server trả về và lưu vào bộ nhớ máy
        final token = data['token'];
        await _prefs.setString('auth_token', token);
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Lỗi kết nối khi đăng nhập: $e');
    }
  }

  @override
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.register(userData);
      return response.isSuccessful;
    } catch (e) {
      throw Exception('Lỗi kết nối khi đăng ký: $e');
    }
  }

  @override
  Future<User> getProfile() async {
    try {
      // Lấy token từ máy lên để đính kèm vào header (nếu cần)
      final token = _prefs.getString('auth_token');
      if (token == null) throw Exception('Chưa đăng nhập');

      final response = await _apiService.getUserProfile();

      if (response.isSuccessful) {
        return User.fromJson(response.body);
      } else {
        throw Exception('Không thể tải thông tin người dùng');
      }
    } catch (e) {
      throw Exception('Lỗi mạng: $e');
    }
  }
}